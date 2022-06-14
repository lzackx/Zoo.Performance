//
//  ZooNetFlowSummaryViewController.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooNetFlowSummaryViewController.h"
#import "ZooNetFlowSummaryTotalDataView.h"
#import "ZooNetFlowSummaryMethodDataView.h"
#import "ZooNetFlowSummaryTypeDataView.h"
#import <Zoo/UIView+Zoo.h>
#import <Zoo/UIColor+Zoo.h>
#import <Zoo/Zooi18NUtil.h>

@interface ZooNetFlowSummaryViewController ()

@property (nonatomic, strong) ZooNetFlowSummaryTotalDataView *totalView;//数据概要
@property (nonatomic, strong) ZooNetFlowSummaryMethodDataView *methodView;//Http 方法概要
@property (nonatomic, strong) ZooNetFlowSummaryTypeDataView *typeView;//数据类型 概要

@end

@implementation ZooNetFlowSummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = ZooLocalizedString(@"网络监控摘要");
    
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return [UIColor groupTableViewBackgroundColor];
            } else {
                return [UIColor zoo_colorWithHex:0xeff0f4];
            }
        }];
    } else {
#endif
        self.view.backgroundColor = [UIColor zoo_colorWithHex:0xeff0f4];
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
    }
#endif
    
    CGFloat tabBarHeight = self.tabBarController.tabBar.zoo_height;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.zoo_width, self.view.zoo_height-tabBarHeight)];
    scrollView.contentSize = CGSizeMake(self.view.zoo_width, 20+160+20+260+20+260);
    [self.view addSubview:scrollView];
    
    _totalView = [[ZooNetFlowSummaryTotalDataView alloc] initWithFrame:CGRectMake(10, 20, self.view.zoo_width-20, 160)];
    [scrollView addSubview:_totalView];
    
    _methodView = [[ZooNetFlowSummaryMethodDataView alloc] initWithFrame:CGRectMake(10, _totalView.zoo_bottom+20, self.view.zoo_width-20, 260)];
    [scrollView addSubview:_methodView];
    
    _typeView = [[ZooNetFlowSummaryTypeDataView alloc] initWithFrame:CGRectMake(10, _methodView.zoo_bottom+20, self.view.zoo_width-20, 260)];
    [scrollView addSubview:_typeView];
}

- (void)leftNavBackClick:(id)clickView{
    [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
}

@end
