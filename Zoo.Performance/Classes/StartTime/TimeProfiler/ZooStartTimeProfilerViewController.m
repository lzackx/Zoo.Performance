//
//  ZooStartTimeProfilerViewController.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooStartTimeProfilerViewController.h"
#import <Zoo/ZooDefine.h>
#import "ZooTimeProfiler.h"

@interface ZooStartTimeProfilerViewController ()

@property (nonatomic, strong) UITextView *contentLabel;

@end

@implementation ZooStartTimeProfilerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = ZooLocalizedString(@"启动耗时");
    [self setRightNavTitle:ZooLocalizedString(@"导出")];
    
    NSString *costDetail = [ZooTimeProfiler getRecordsResult];
    
    _contentLabel = [[UITextView alloc] initWithFrame:self.view.bounds];
    _contentLabel.textColor = [UIColor zoo_black_2];
    _contentLabel.font = [UIFont systemFontOfSize:kZooSizeFrom750_Landscape(16)];
    _contentLabel.text = costDetail;
    
    [self.view addSubview:_contentLabel];
}

- (void)rightNavTitleClick:(id)clickView{
    [self export:_contentLabel.text];
}

- (void)export:(NSString *)text {
    [ZooUtil shareText:text formVC:self];
}

@end
