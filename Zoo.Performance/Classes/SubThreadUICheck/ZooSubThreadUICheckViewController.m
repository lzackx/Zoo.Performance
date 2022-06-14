//
//  ZooSubThreadUICheckViewController.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooSubThreadUICheckViewController.h"
#import <Zoo/ZooCellSwitch.h>
#import <Zoo/ZooCellButton.h>
#import "ZooCacheManager+Performance.h"
#import "ZooSubThreadUICheckListViewController.h"
#import <Zoo/Zooi18NUtil.h>
#import <Zoo/ZooDefine.h>

@interface ZooSubThreadUICheckViewController ()<ZooSwitchViewDelegate,ZooCellButtonDelegate>

@property (nonatomic, strong) ZooCellSwitch *switchView;
@property (nonatomic, strong) ZooCellButton *cellBtn;

@end

@implementation ZooSubThreadUICheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = ZooLocalizedString(@"子线程UI");
    
    _switchView = [[ZooCellSwitch alloc] initWithFrame:CGRectMake(0, self.bigTitleView.zoo_bottom, self.view.zoo_width, kZooSizeFrom750_Landscape(104))];
    [_switchView renderUIWithTitle:ZooLocalizedString(@"子线程UI渲染检测开关") switchOn:[[ZooCacheManager sharedInstance] subThreadUICheckSwitch]];
    [_switchView needTopLine];
    [_switchView needDownLine];
    _switchView.delegate = self;
    [self.view addSubview:_switchView];
    
    _cellBtn = [[ZooCellButton alloc] initWithFrame:CGRectMake(0, _switchView.zoo_bottom, self.view.zoo_width, kZooSizeFrom750_Landscape(104))];
    [_cellBtn renderUIWithTitle:ZooLocalizedString(@"查看检测记录")];
    _cellBtn.delegate = self;
    [_cellBtn needDownLine];
    [self.view addSubview:_cellBtn];

}

- (BOOL)needBigTitleView{
    return YES;
}

#pragma mark -- ZooSwitchViewDelegate
- (void)changeSwitchOn:(BOOL)on sender:(id)sender{
    [[ZooCacheManager sharedInstance] saveSubThreadUICheckSwitch:on];
}

#pragma mark -- ZooCellButtonDelegate
- (void)cellBtnClick:(id)sender{
    if (sender == _cellBtn) {
        ZooSubThreadUICheckListViewController *vc = [[ZooSubThreadUICheckListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
