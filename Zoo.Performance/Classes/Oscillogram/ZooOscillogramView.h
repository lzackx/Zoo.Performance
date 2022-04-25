//
//  ZooOscillogramView.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <UIKit/UIKit.h>

@class ZooPerformanceInfoModel;

@interface ZooPoint : NSObject

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

@end

@interface ZooOscillogramView : UIScrollView

@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, assign) NSInteger numberOfPoints;

- (void)addHeightValue:(CGFloat)showHeight andTipValue:(NSString *)tipValue;

- (void)setLowValue:(NSString *)value;

- (void)setHightValue:(NSString *)value;

- (void)clear;

@end
