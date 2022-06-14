//
//  ZooNetFlowSummaryMethodDataView.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooNetFlowSummaryMethodDataView.h"
#import <Zoo/UIView+Zoo.h>
#import "ZooNetFlowDataSource.h"
#import <Zoo/Zooi18NUtil.h>
#import <Zoo/ZooBarChart.h>
#import <Zoo/ZooDefine.h>

@interface ZooNetFlowSummaryMethodDataView()
@property (nonatomic, strong) NSArray<ZooChartDataItem *> *chartItems;

@end

@implementation ZooNetFlowSummaryMethodDataView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 5.f;

        UILabel *tipLabel = [[UILabel alloc] init];
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
        if (@available(iOS 13.0, *)) {
            self.backgroundColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
                if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                    return [UIColor secondarySystemBackgroundColor];
                } else {
                    return [UIColor whiteColor];
                }
            }];
            
            tipLabel.textColor = [UIColor labelColor];
        } else {
#endif
            self.backgroundColor = [UIColor whiteColor];
            
            tipLabel.textColor = [UIColor blackColor];
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
        }
#endif
        tipLabel.text = ZooLocalizedString(@"HTTP方法");
        tipLabel.font = [UIFont systemFontOfSize:14];
        [tipLabel sizeToFit];
        tipLabel.frame = CGRectMake(10, 10, tipLabel.zoo_width, tipLabel.zoo_height);
        [self addSubview:tipLabel];
        
        [self getData];
        
        if (self.chartItems.count > 0) {
            ZooBarChart *chart = [[ZooBarChart alloc] initWithFrame:CGRectMake(0, tipLabel.zoo_bottom+10, self.zoo_width, self.zoo_height-tipLabel.zoo_bottom-10)];
            chart.items = _chartItems;
            chart.yAxis.labelCount = 5;
            chart.contentInset = UIEdgeInsetsMake(0, 50, 40, 20);
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.maximumFractionDigits = 2;
            chart.vauleFormatter = formatter;
            
            [self addSubview:chart];
            [chart display];
        }
    }
    return self;
}

- (void)getData{
    NSArray *dataArray = [ZooNetFlowDataSource shareInstance].httpModelArray;
    NSMutableArray<NSString *> *methodArray = [NSMutableArray array];
    for (ZooNetFlowHttpModel* httpModel in dataArray) {
        NSString *method = httpModel.method;
        if (!method || [methodArray containsObject:method]) {
            continue;
        }
        [methodArray addObject:method];
    }
    
    NSMutableArray *methodDataArray = [NSMutableArray array];
    for (NSString *methodA in methodArray) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:methodA forKey:@"method"];
        NSInteger num = 0;
        for (ZooNetFlowHttpModel* httpModel in dataArray) {
            NSString *methodB = httpModel.method;
            if ([methodA isEqualToString:methodB]) {
                num++;
            }
        }
        [dic setValue:@(num) forKey:@"num"];
        [methodDataArray addObject:dic];
    }

    NSMutableArray<ZooChartDataItem *> *items = [NSMutableArray array];
    for (NSDictionary *methodData in methodDataArray) {
        ZooChartDataItem *item = [[ZooChartDataItem alloc] initWithValue:[methodData[@"num"] doubleValue] name:methodData[@"method"] color: [UIColor zoo_randomColor]];
        [items addObject:item];
    }
    
    self.chartItems = [NSArray arrayWithArray:items];;
}


@end
