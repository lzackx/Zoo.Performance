//
//  ZooOscillogramViewController.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooOscillogramViewController.h"
#import "ZooOscillogramWindowManager.h"
#import <Zoo/ZooDefine.h>


@interface ZooOscillogramViewController ()

//每秒运行一次
@property (nonatomic, strong) NSTimer *secondTimer;

@end

@implementation ZooOscillogramViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = [self title];
    titleLabel.font = [UIFont systemFontOfSize:kZooSizeFrom750_Landscape(20)];
    titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:titleLabel];
    [titleLabel sizeToFit];
    titleLabel.frame = CGRectMake(kZooSizeFrom750_Landscape(20), kZooSizeFrom750_Landscape(10), titleLabel.zoo_width, titleLabel.zoo_height);
    
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn setImage:[UIImage zoo_xcassetImageNamed:@"zoo_close_white"] forState:UIControlStateNormal];
    closeBtn.frame = CGRectMake((kInterfaceOrientationPortrait ? ZooScreenWidth : ZooScreenHeight)-kZooSizeFrom750_Landscape(80), 0, kZooSizeFrom750_Landscape(80), kZooSizeFrom750_Landscape(80));
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    _closeBtn = closeBtn;
    
    _oscillogramView = [[ZooOscillogramView alloc] initWithFrame:CGRectMake(0, titleLabel.zoo_bottom+kZooSizeFrom750_Landscape(12), (kInterfaceOrientationPortrait ? ZooScreenWidth : ZooScreenHeight), kZooSizeFrom750_Landscape(184))];
    _oscillogramView.backgroundColor = [UIColor clearColor];
    [_oscillogramView setLowValue:[self lowValue]];
    [_oscillogramView setHightValue:[self highValue]];
    [self.view addSubview:_oscillogramView];
}

- (NSString *)title{
    return @"";
}

- (NSString *)lowValue{
    return @"0";
}

- (NSString *)highValue{
    return @"100";
}

- (void)closeBtnClick{
}

- (void)startRecord{
    if(!_secondTimer){
        _secondTimer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(doSecondFunction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_secondTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)doSecondFunction{
    
}

- (void)endRecord{
    if(_secondTimer){
        [_secondTimer invalidate];
        _secondTimer = nil;
        [self.oscillogramView clear];
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[ZooOscillogramWindowManager shareInstance] resetLayout];
    });
}
@end
