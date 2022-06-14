//
//  ZooNetFlowSummaryTotalDataView.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooNetFlowSummaryTotalDataView.h"
#import "ZooNetFlowDataSource.h"
#import "ZooNetFlowManager.h"
#import <Zoo/ZooUtil.h>
#import <Zoo/ZooDefine.h>

@interface ZooNetFlowSummaryTotalDataItemView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *valueLabel;

@end

@implementation ZooNetFlowSummaryTotalDataItemView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.zoo_width, kZooSizeFrom750_Landscape(44))];
        _valueLabel.font = [UIFont systemFontOfSize:kZooSizeFrom750_Landscape(44)];
        _valueLabel.textColor = [UIColor zoo_black_1];
        _valueLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_valueLabel];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _valueLabel.zoo_bottom+kZooSizeFrom750_Landscape(16), self.zoo_width, kZooSizeFrom750_Landscape(24))];
        _titleLabel.font = [UIFont systemFontOfSize:kZooSizeFrom750_Landscape(20)];
        _titleLabel.textColor = [UIColor zoo_black_2];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        

    }
    return self;
}

- (void)renderUIWithTitle:(NSString *)title value:(NSString *)value{
    _titleLabel.text = title;
    _valueLabel.text = value;
}

@end

@interface ZooNetFlowSummaryTotalDataView()

@property (nonatomic, strong) ZooNetFlowSummaryTotalDataItemView *timeView;//抓包时间
@property (nonatomic, strong) ZooNetFlowSummaryTotalDataItemView *numView;//抓包数量
@property (nonatomic, strong) ZooNetFlowSummaryTotalDataItemView *upLoadView;//数据上传
@property (nonatomic, strong) ZooNetFlowSummaryTotalDataItemView *downLoadView;//数据下载

@end

@implementation ZooNetFlowSummaryTotalDataView

- (instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.layer.cornerRadius = 5.f;

#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
    if (@available(iOS 13.0, *)) {
        self.backgroundColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return [UIColor secondarySystemBackgroundColor];
            } else {
                return [UIColor whiteColor];
            }
        }];
    } else {
#endif
       self.backgroundColor = [UIColor whiteColor];
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
    }
#endif
     
    //抓包时间
    NSString *time;
    NSDate *startInterceptDate = [ZooNetFlowManager shareInstance].startInterceptDate;
    if (startInterceptDate) {
        NSDate *nowDate = [NSDate date];
        NSTimeInterval cha = [nowDate timeIntervalSinceDate:startInterceptDate];
        time = [NSString stringWithFormat:@"%.2f%@",cha,ZooLocalizedString(@"秒")];
    }else{
        time = ZooLocalizedString(@"暂未开启网络监控");
    }
    
    //抓包数量
    NSArray *httpModelArray = [ZooNetFlowDataSource shareInstance].httpModelArray;
    NSString *num = [NSString stringWithFormat:@"%zi",httpModelArray.count];
    
    CGFloat totalUploadFlow = 0.;
    CGFloat totalDownFlow = 0.;
    for (int i=0; i<httpModelArray.count; i++) {
        ZooNetFlowHttpModel *httpModel = httpModelArray[i];
        CGFloat uploadFlow =  [httpModel.uploadFlow floatValue];
        CGFloat downFlow = [httpModel.downFlow floatValue];
        totalUploadFlow += uploadFlow;
        totalDownFlow += downFlow;
    }
    //数据上传
    NSString *upLoad = [ZooUtil formatByte:totalUploadFlow];
    
    //数据下载
    NSString *downLoad = [ZooUtil formatByte:totalDownFlow];
    
    _timeView = [[ZooNetFlowSummaryTotalDataItemView alloc] initWithFrame:CGRectMake(0, 20, self.zoo_width, 40)];
    [_timeView renderUIWithTitle:ZooLocalizedString(@"总计已为您抓包") value:time];
    [self addSubview:_timeView];
    
    CGFloat offsetY = 20+40+40;
    CGFloat itemWidth = self.zoo_width/3;
    CGFloat offsetX = 0;
    
    _numView = [[ZooNetFlowSummaryTotalDataItemView alloc] initWithFrame:CGRectMake(0, offsetY, itemWidth, 40)];
    [_numView renderUIWithTitle:ZooLocalizedString(@"抓包数量") value:num];
    [self addSubview:_numView];
    
    offsetX += _numView.zoo_width;
    
    _upLoadView = [[ZooNetFlowSummaryTotalDataItemView alloc] initWithFrame:CGRectMake(offsetX, offsetY, itemWidth, 40)];
    [_upLoadView renderUIWithTitle:ZooLocalizedString(@"数据上传") value:upLoad];
    [self addSubview:_upLoadView];
    
    offsetX += _upLoadView.zoo_width;
    
    _downLoadView = [[ZooNetFlowSummaryTotalDataItemView alloc] initWithFrame:CGRectMake(offsetX, offsetY, itemWidth, 40)];
    [_downLoadView renderUIWithTitle:ZooLocalizedString(@"数据下载") value:downLoad];
    [self addSubview:_downLoadView];
    
}

@end
