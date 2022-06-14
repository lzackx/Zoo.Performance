//
//  ZooSubThreadUICheckDetailViewController.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooSubThreadUICheckDetailViewController.h"
#import <Zoo/Zooi18NUtil.h>
#import <Zoo/ZooDefine.h>

@interface ZooSubThreadUICheckDetailViewController ()

@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation ZooSubThreadUICheckDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = ZooLocalizedString(@"检测详情");
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.textColor = [UIColor zoo_black_2];
    _contentLabel.font = [UIFont systemFontOfSize:kZooSizeFrom750_Landscape(16)];
    _contentLabel.numberOfLines = 0;
    _contentLabel.text = _checkInfo[@"content"];
    
    CGSize fontSize = [_contentLabel sizeThatFits:CGSizeMake(self.view.frame.size.width-40, MAXFLOAT)];
    _contentLabel.frame = CGRectMake(20, IPHONE_NAVIGATIONBAR_HEIGHT, fontSize.width, fontSize.height);
    [self.view addSubview:_contentLabel];
}


@end
