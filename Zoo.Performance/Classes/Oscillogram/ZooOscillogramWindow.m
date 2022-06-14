//
//  ZooOscillogramWindow.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooOscillogramWindow.h"
#import "ZooOscillogramViewController.h"
#import <Zoo/UIColor+Zoo.h>
#import <Zoo/ZooDefine.h>
#import "ZooOscillogramWindowManager.h"

@interface ZooOscillogramWindow()

@property (nonatomic, strong) NSHashTable *delegates;

@end

@implementation ZooOscillogramWindow

- (NSHashTable *)delegates {
    if (_delegates == nil) {
        self.delegates = [NSHashTable weakObjectsHashTable];
    }
    return _delegates;
}

- (void)addDelegate:(id<ZooOscillogramWindowDelegate>) delegate {
    [self.delegates addObject:delegate];
}

- (void)removeDelegate:(id<ZooOscillogramWindowDelegate>)delegate {
    [self.delegates removeObject:delegate];
}

+ (ZooOscillogramWindow *)shareInstance{
    static dispatch_once_t once;
    static ZooOscillogramWindow *instance;
    dispatch_once(&once, ^{
        instance = [[ZooOscillogramWindow alloc] initWithFrame:CGRectZero];
    });
    return instance;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelStatusBar + 2.f;
        self.backgroundColor = [UIColor zoo_colorWithHex:0x000000 andAlpha:0.33];
        self.layer.masksToBounds = YES;
        #if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
            if (@available(iOS 13.0, *)) {
                for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes){
                    if (windowScene.activationState == UISceneActivationStateForegroundActive){
                        self.windowScene = windowScene;
                        break;
                    }
                }
            }
        #endif
        [self addRootVc];
    }
    return self;
}

- (void)addRootVc{
   //需要子类重写
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    // 默认曲线图不拦截触摸事件，只有在关闭按钮z之类才响应
    if (CGRectContainsPoint(self.vc.closeBtn.frame, point)) {
        return [super pointInside:point withEvent:event];
    }
    return NO;
}

- (void)show{
    self.hidden = NO;
    [_vc startRecord];
    [self resetLayout];
}

- (void)hide{
    [_vc endRecord];
    self.hidden = YES;
    [self resetLayout];
    
    for (id<ZooOscillogramWindowDelegate> delegate in self.delegates) {
        [delegate zooOscillogramWindowClosed];
    }
}

- (void)resetLayout{
    [[ZooOscillogramWindowManager shareInstance] resetLayout];
}

@end
