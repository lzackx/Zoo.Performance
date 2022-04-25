//
//  ZooOscillogramViewController.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <UIKit/UIKit.h>
#import "ZooOscillogramView.h"

@interface ZooOscillogramViewController : UIViewController

@property (nonatomic, strong) ZooOscillogramView *oscillogramView;
@property (nonatomic, strong) UIButton *closeBtn;

- (NSString *)title;
- (NSString *)lowValue;
- (NSString *)highValue;
- (void)closeBtnClick;
- (void)startRecord;
- (void)endRecord;
- (void)doSecondFunction;

@end
