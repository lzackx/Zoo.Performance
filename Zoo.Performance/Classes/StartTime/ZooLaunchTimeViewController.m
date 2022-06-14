//
//  ZooLaunchTimeViewController.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooLaunchTimeViewController.h"
#import <Zoo/ZooCellSwitch.h>
#import <Zoo/ZooCellButton.h>
#import <Zoo/ZooDefine.h>
#import "ZooCacheManager+Performance.h"
#import <Zoo/NSObject+Zoo.h>
#import "ZooManager+Performance.h"
#import <objc/runtime.h>
#import "ZooTimeProfiler.h"
#import "ZooStartTimeProfilerViewController.h"

static NSTimeInterval startTime;
static NSTimeInterval endTime;

@interface ZooLaunchTimeViewController ()<ZooSwitchViewDelegate,ZooCellButtonDelegate>

@property (nonatomic, strong) ZooCellSwitch *switchView;
@property (nonatomic, strong) ZooCellButton *cellBtn;

@end

@implementation ZooLaunchTimeViewController

+ (void)load{
    startTime = [[NSDate date] timeIntervalSince1970];
    if ([[ZooCacheManager sharedInstance] startTimeSwitch]) {
        NSString *startClass = [ZooManager shareInstance].startClass;
        if (!startClass) {
            startClass = @"AppDelegate";
        }
        Class class = NSClassFromString(startClass);
        Method originMethod = class_getInstanceMethod(class, @selector(application:didFinishLaunchingWithOptions:));
        Method swizzledMethod = class_getInstanceMethod([self class], @selector(zoo_application:didFinishLaunchingWithOptions:));
        class_addMethod(class, method_getName(swizzledMethod), method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        Method swizzledMethod2 = class_getInstanceMethod(class, @selector(zoo_application:didFinishLaunchingWithOptions:));
        method_exchangeImplementations(originMethod, swizzledMethod2);
    }
}

- (BOOL)zoo_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [ZooTimeProfiler startRecord];
    BOOL ret = [self zoo_application:application didFinishLaunchingWithOptions:launchOptions];
    [ZooTimeProfiler stopRecord];
    endTime = [[NSDate date] timeIntervalSince1970];
    return ret;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = ZooLocalizedString(@"启动耗时");
    
    _switchView = [[ZooCellSwitch alloc] initWithFrame:CGRectMake(0, self.bigTitleView.zoo_bottom, self.view.zoo_width, kZooSizeFrom750(104))];
    [_switchView renderUIWithTitle:ZooLocalizedString(@"开关") switchOn:[[ZooCacheManager sharedInstance] startTimeSwitch]];
    [_switchView needTopLine];
    [_switchView needDownLine];
    _switchView.delegate = self;
    [self.view addSubview:_switchView];
    
    _cellBtn = [[ZooCellButton alloc] initWithFrame:CGRectMake(0, _switchView.zoo_bottom, self.view.zoo_width, kZooSizeFrom750(104))];
    if ([[ZooCacheManager sharedInstance] startTimeSwitch]){
        [_cellBtn renderUIWithTitle:[NSString stringWithFormat:@"%@%fs",ZooLocalizedString(@"本次启动时间为"),endTime-startTime]];
    }
    _cellBtn.delegate = self;
    [_cellBtn needDownLine];
    [self.view addSubview:_cellBtn];
    
}

- (BOOL)needBigTitleView{
    return YES;
}

#pragma mark -- ZooSwitchViewDelegate
- (void)changeSwitchOn:(BOOL)on sender:(id)sender{
    __weak typeof(self) weakSelf = self;
    [ZooAlertUtil handleAlertActionWithVC:self okBlock:^{
        [[ZooCacheManager sharedInstance] saveStartTimeSwitch:on];
        exit(0);
    } cancleBlock:^{
        weakSelf.switchView.switchView.on = !on;
    }];
}

#pragma mark -- ZooCellButtonDelegate
- (void)cellBtnClick:(id)sender{
    ZooStartTimeProfilerViewController *vc = [[ZooStartTimeProfilerViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}



@end
