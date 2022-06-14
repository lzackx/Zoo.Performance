//
//  ZooNetFlowViewController.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooNetFlowViewController.h"
#import "ZooCacheManager+Performance.h"
#import "ZooNetFlowManager.h"
#import <Zoo/ZooDefine.h>
#import <Zoo/UIView+Zoo.h>
#import "ZooNetFlowListViewController.h"
#import <Zoo/ZooHomeWindow.h>
#import "ZooNetFlowSummaryViewController.h"
#import <Zoo/UIImage+Zoo.h>
#import <Zoo/UIColor+Zoo.h>
#import "ZooNetFlowOscillogramWindow.h"
#import <Zoo/Zooi18NUtil.h>
#import <Zoo/ZooCellSwitch.h>
#import <Zoo/ZooDefine.h>


@interface ZooNetFlowViewController ()<ZooSwitchViewDelegate, ZooOscillogramWindowDelegate>
@property (nonatomic, strong) UITabBarController *tabBar;

@property (nonatomic, strong) ZooCellSwitch *switchView;

@end

@implementation ZooNetFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [[ZooNetFlowOscillogramWindow shareInstance] addDelegate:self];
}

- (void)initUI{
    self.title = ZooLocalizedString(@"网络检测");
    
    _switchView = [[ZooCellSwitch alloc] initWithFrame:CGRectMake(0, self.bigTitleView.zoo_bottom, self.view.zoo_width, kZooSizeFrom750_Landscape(104))];
    [_switchView renderUIWithTitle:ZooLocalizedString(@"网络检测开关") switchOn:[[ZooCacheManager sharedInstance] netFlowSwitch]];
    [_switchView needTopLine];
    [_switchView needDownLine];
    _switchView.delegate = self;
    [self.view addSubview:_switchView];

    UIButton *showNetFlowDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    showNetFlowDetailBtn.frame = CGRectMake(kZooSizeFrom750_Landscape(32), _switchView.zoo_bottom+kZooSizeFrom750_Landscape(60), self.view.zoo_width-2*kZooSizeFrom750_Landscape(32), kZooSizeFrom750_Landscape(100));
    [showNetFlowDetailBtn setTitle:ZooLocalizedString(@"显示网络检测详情") forState:UIControlStateNormal];
    showNetFlowDetailBtn.backgroundColor = [UIColor zoo_colorWithHexString:@"#337CC4"];
    [showNetFlowDetailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [showNetFlowDetailBtn addTarget:self action:@selector(showNetFlowDetail) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showNetFlowDetailBtn];
}

- (BOOL)needBigTitleView{
    return YES;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    // trait发生了改变
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
    if (@available(iOS 13.0, *)) {
        if ([self.traitCollection hasDifferentColorAppearanceComparedToTraitCollection:previousTraitCollection]) {
            if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -0.5, CGRectGetWidth(self.tabBar.tabBar.frame), 0.5)];
                view.backgroundColor = [UIColor zoo_black_3];
                [self.tabBar.tabBar insertSubview:view atIndex:0];
            }
        }
    }
#endif
}

#pragma mark -- ZooSwitchViewDelegate
- (void)changeSwitchOn:(BOOL)on sender:(id)sender{
    if (sender == _switchView.switchView) {
        [[ZooCacheManager sharedInstance] saveNetFlowSwitch:on];
        if(on){
            [[ZooNetFlowManager shareInstance] canInterceptNetFlow:YES];
            [self showOscillogramView];
        }else{
            [[ZooNetFlowManager shareInstance] canInterceptNetFlow:NO];
            [self hiddenOscillogramView];
        }
    }
}

- (void)showOscillogramView{
    [[ZooNetFlowOscillogramWindow shareInstance] show];
}

- (void)hiddenOscillogramView{
    [[ZooNetFlowOscillogramWindow shareInstance] hide];
}


- (void)showNetFlowDetail {
    UITabBarController *tabBar = [[UITabBarController alloc] init];
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
    if (@available(iOS 13.0, *)) {
        tabBar.tabBar.backgroundColor = [UIColor systemBackgroundColor];
        if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -0.5, CGRectGetWidth(tabBar.tabBar.frame), 0.5)];
            view.backgroundColor = [UIColor zoo_black_3];
            [tabBar.tabBar insertSubview:view atIndex:0];
        }
    } else {
#endif
        tabBar.tabBar.backgroundColor = [UIColor whiteColor];
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
    }
#endif
    _tabBar = tabBar;
    
    UIViewController *vc1 = [[ZooNetFlowSummaryViewController alloc] init];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    nav1.tabBarItem = [[UITabBarItem alloc] initWithTitle:ZooLocalizedString(@"网络监控摘要") image:[[[UIImage zoo_xcassetImageNamed:@"zoo_netflow_summary_unselect"] zoo_scaledToSize:CGSizeMake(30,30)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[[UIImage zoo_xcassetImageNamed:@"zoo_netflow_summary_select"] zoo_scaledToSize:CGSizeMake(30,30)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [nav1.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor zoo_colorWithHex:0x333333],NSFontAttributeName:[UIFont systemFontOfSize:10]} forState:UIControlStateNormal];
    [nav1.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor zoo_colorWithHex:0x337CC4],NSFontAttributeName:[UIFont systemFontOfSize:10]} forState:UIControlStateSelected];
    
    
    UIViewController *vc2 = [[ZooNetFlowListViewController alloc] init];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    nav2.tabBarItem = [[UITabBarItem alloc] initWithTitle:ZooLocalizedString(@"网络监控列表") image:[[[UIImage zoo_xcassetImageNamed:@"zoo_netflow_list_unselect"] zoo_scaledToSize:CGSizeMake(30,30)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[[UIImage zoo_xcassetImageNamed:@"zoo_netflow_list_select"] zoo_scaledToSize:CGSizeMake(30,30)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [nav2.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor zoo_colorWithHex:0x333333],NSFontAttributeName:[UIFont systemFontOfSize:10]} forState:UIControlStateNormal];
    [nav2.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor zoo_colorWithHex:0x337CC4],NSFontAttributeName:[UIFont systemFontOfSize:10]} forState:UIControlStateSelected];
    
    tabBar.viewControllers = @[nav1,nav2];
    
    tabBar.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:tabBar animated:YES completion:nil];
}

#pragma mark -- ZooOscillogramWindowDelegate
- (void)zooOscillogramWindowClosed {
    [_switchView renderUIWithTitle:ZooLocalizedString(@"网络检测开关") switchOn:[[ZooCacheManager sharedInstance] netFlowSwitch]];
}

@end
