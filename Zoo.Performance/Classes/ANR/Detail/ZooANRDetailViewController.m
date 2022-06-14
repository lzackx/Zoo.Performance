//
//  ZooANRDetailViewController.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooANRDetailViewController.h"
#import <Zoo/ZooDefine.h>
#import <Zoo/ZooUtil.h>

@interface ZooANRDetailViewController ()

@property (nonatomic, strong) UILabel *anrTimeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) NSDictionary *anrInfo;

@end

@implementation ZooANRDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = ZooLocalizedString(@"卡顿详情");
    [self setRightNavTitle:ZooLocalizedString(@"导出")];
    
    self.anrInfo = [NSDictionary dictionaryWithContentsOfFile:self.filePath];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.textColor = [UIColor zoo_black_2];
    _contentLabel.font = [UIFont systemFontOfSize:kZooSizeFrom750_Landscape(16)];
    _contentLabel.numberOfLines = 0;
    _contentLabel.text = _anrInfo[@"content"];
    
    CGSize fontSize = [_contentLabel sizeThatFits:CGSizeMake(self.view.zoo_width-40, MAXFLOAT)];
    _contentLabel.frame = CGRectMake(20, IPHONE_NAVIGATIONBAR_HEIGHT, fontSize.width, fontSize.height);
    [self.view addSubview:_contentLabel];
    
    _anrTimeLabel = [[UILabel alloc] init];
    _anrTimeLabel.textColor = [UIColor zoo_black_1];
    _anrTimeLabel.font = [UIFont systemFontOfSize:kZooSizeFrom750_Landscape(16)];
    _anrTimeLabel.text = [NSString stringWithFormat:@"anr time : %@ms",_anrInfo[@"duration"]];
    [_anrTimeLabel sizeToFit];
    _anrTimeLabel.frame = CGRectMake(20, _contentLabel.zoo_bottom+20, _anrTimeLabel.zoo_width, _anrTimeLabel.zoo_height);
    [self.view addSubview:_anrTimeLabel];
    
    
}

- (void)rightNavTitleClick:(id)clickView{
    [ZooUtil shareURL:[NSURL fileURLWithPath:self.filePath] formVC:self];
}




@end
