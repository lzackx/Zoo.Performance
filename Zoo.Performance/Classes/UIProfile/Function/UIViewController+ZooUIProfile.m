//
//  UIViewController+Zoo.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <Zoo/UIViewController+Zoo.h>
#import "ZooUIProfileManager.h"
#import <Zoo/NSObject+Zoo.h>
#import <Zoo/ZooDefine.h>
#import <objc/runtime.h>
#import "ZooUIProfileWindow.h"


@interface UIViewController ()

@property (nonatomic, strong) NSNumber *zoo_depth;
@property (nonatomic, strong) UIView *zoo_depthView;

@end

@implementation UIViewController (ZooUIProfile)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self class] zoo_swizzleInstanceMethodWithOriginSel:@selector(viewDidAppear:) swizzledSel:@selector(zoo_viewDidAppear:)];
        [[self class] zoo_swizzleInstanceMethodWithOriginSel:@selector(viewWillDisappear:) swizzledSel:@selector(zoo_viewWillDisappear:)];
    });
}

- (void)zoo_viewDidAppear:(BOOL)animated{
    [self zoo_viewDidAppear:animated];
    [self profileViewDepth];
}

- (void)zoo_viewWillDisappear:(BOOL)animated
{
    [self profileViewDepth];
    [self zoo_viewWillDisappear:animated];
    [self resetProfileData];
}

- (void)profileViewDepth
{
    if (![ZooUIProfileManager sharedInstance].enable) {
        return;
    }
    [self travelView:self.view depth:0];
    [self showUIProfile];
}

- (void)showUIProfile
{
    NSString *text = [NSString stringWithFormat:@"[%d][%@]",self.zoo_depth.intValue,NSStringFromClass([self.zoo_depthView class])];
    
    NSMutableArray *tmp = [NSMutableArray new];
    if (self.zoo_depthView) {
        [tmp addObject:NSStringFromClass([self.zoo_depthView class])];
    }

    UIView *tmpSuperView = self.zoo_depthView.superview;
    
    while (tmpSuperView && tmpSuperView != self.view) {
        [tmp addObject:NSStringFromClass([tmpSuperView class])];
        tmpSuperView = tmpSuperView.superview;
    }
    
    [tmp addObject:NSStringFromClass([self.view class])];


    NSArray *result = [[tmp reverseObjectEnumerator] allObjects];
    NSString *detail = [result componentsJoinedByString:@"\r\n"];
    
    [[ZooUIProfileWindow sharedInstance] showWithDepthText:text detailInfo:detail];
    
    self.zoo_depthView.layer.borderWidth = 1;
    self.zoo_depthView.layer.borderColor = [UIColor redColor].CGColor;

}

- (void)travelView:(UIView *)view depth:(int)depth
{
    depth++;
    if (depth > self.zoo_depth.intValue) {
        self.zoo_depth = @(depth);
        self.zoo_depthView = view;
    }
    
    if (view.subviews.count == 0) {
        return;
    }
    
    for (int i = 0; i < view.subviews.count; i++) {
        UIView *subView = view.subviews[i];
        [self travelView:subView depth:depth];
    }
}

- (void)resetProfileData
{
    self.zoo_depth = @(0);
    self.zoo_depthView.layer.borderWidth = 0;
    self.zoo_depthView.layer.borderColor = nil;
}

- (void)setZoo_depth:(NSNumber *)zoo_depth
{
    objc_setAssociatedObject(self, @selector(zoo_depth), zoo_depth, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)zoo_depth
{
    return objc_getAssociatedObject(self, @selector(zoo_depth));
}

- (void)setZoo_depthView:(UIView *)zoo_depthView
{
    objc_setAssociatedObject(self, @selector(zoo_depthView), zoo_depthView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)zoo_depthView
{
    return objc_getAssociatedObject(self, @selector(zoo_depthView));
}

@end
