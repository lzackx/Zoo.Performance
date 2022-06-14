//
//  ZooTimeProfilerViewController.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooTimeProfilerViewController.h"
#import <Zoo/ZooDefine.h>

@interface ZooTimeProfilerViewController()

@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation ZooTimeProfilerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = ZooLocalizedString(@"函数耗时");
    
    NSString *contet = ZooLocalizedString(@"函数耗时描述");
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.textColor = [UIColor zoo_black_2];
    _contentLabel.font = [UIFont systemFontOfSize:kZooSizeFrom750_Landscape(24)];
    _contentLabel.numberOfLines = 0;
    [self.view addSubview:_contentLabel];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:contet];
    NSRange range = [contet rangeOfString:@"[ZooTimeProfiler startRecord];"];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    range = [contet rangeOfString:@"[ZooTimeProfiler stopRecord];"];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    range = [contet rangeOfString:@"分析完毕之后，记得删掉startRecord和stopRecord的函数调用。"];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    _contentLabel.attributedText = attrStr;
    
    CGSize fontSize = [_contentLabel sizeThatFits:CGSizeMake(self.view.zoo_width-40, MAXFLOAT)];
    _contentLabel.frame = CGRectMake(20, self.bigTitleView.zoo_bottom, fontSize.width, fontSize.height);
}

- (BOOL)needBigTitleView{
    return YES;
}

@end
