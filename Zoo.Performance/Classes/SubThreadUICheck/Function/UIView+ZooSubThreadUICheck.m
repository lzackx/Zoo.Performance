//
//  UIView+Zoo.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <Zoo/UIView+Zoo.h>
#import <Zoo/NSObject+Zoo.h>
#import "ZooCacheManager+Performance.h"
#import "ZooSubThreadUICheckManager.h"
#import <Zoo/ZooUtil.h>
#import <Zoo/ZooBacktraceLogger.h>

@implementation UIView (ZooSubThreadUICheck)

+ (void)load{
    if ([NSStringFromClass([self class]) isEqualToString:@"UIView"]) {
        [[self  class] zoo_swizzleInstanceMethodWithOriginSel:@selector(setNeedsLayout) swizzledSel:@selector(zoo_setNeedsLayout)];
        [[self class] zoo_swizzleInstanceMethodWithOriginSel:@selector(setNeedsDisplay) swizzledSel:@selector(zoo_setNeedsDisplay)];
        [[self class] zoo_swizzleInstanceMethodWithOriginSel:@selector(setNeedsDisplayInRect:) swizzledSel:@selector(zoo_setNeedsDisplayInRect:)];
    }
}

- (void)zoo_setNeedsLayout{
    [self zoo_setNeedsLayout];
    [self uiCheck];
}

- (void)zoo_setNeedsDisplay{
    [self zoo_setNeedsDisplay];
    [self uiCheck];
}

- (void)zoo_setNeedsDisplayInRect:(CGRect)rect{
    [self zoo_setNeedsDisplayInRect:rect];
    [self uiCheck];
}

- (void)uiCheck{
    if(![NSThread isMainThread]){
        if ([[ZooCacheManager sharedInstance] subThreadUICheckSwitch]) {
            NSString *report = [ZooBacktraceLogger zoo_backtraceOfCurrentThread];
            NSDictionary *dic = @{
                                  @"title":[ZooUtil dateFormatNow],
                                  @"content":report
                                  };
            [[ZooSubThreadUICheckManager sharedInstance].checkArray addObject:dic];
        }
    }
}

@end
