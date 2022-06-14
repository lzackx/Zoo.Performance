//
//  ZooNetFlowSummaryTypeDataView.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooNetFlowSummaryTypeDataView.h"
#import <Zoo/UIView+Zoo.h>
#import <Zoo/ZooPieChart.h>
#import "ZooNetFlowDataSource.h"
#import <Zoo/Zooi18NUtil.h>
#import <Zoo/ZooDefine.h>

@interface ZooNetFlowSummaryTypeDataView()
@property (nonatomic, strong) NSArray<ZooChartDataItem *> *chartItems;

@end

@implementation ZooNetFlowSummaryTypeDataView

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
        
        tipLabel.text = ZooLocalizedString(@"数据类型");
        tipLabel.font = [UIFont systemFontOfSize:14];
        [tipLabel sizeToFit];
        tipLabel.frame = CGRectMake(10, 10, tipLabel.zoo_width, tipLabel.zoo_height);
        [self addSubview:tipLabel];
        
        [self getData];
        
        if (self.chartItems.count > 0) {
            ZooPieChart *chart = [[ZooPieChart alloc] initWithFrame:CGRectMake(0, tipLabel.zoo_bottom+10, self.zoo_width, self.zoo_height-tipLabel.zoo_bottom-10)];
            chart.items = self.chartItems;
            [self addSubview:chart];
            [chart display];
        }
    }
    return self;
}

- (void)getData{
    NSArray *dataArray = [ZooNetFlowDataSource shareInstance].httpModelArray;
    NSMutableArray *mineTypeArray = [NSMutableArray array];
    for (ZooNetFlowHttpModel* httpModel in dataArray) {
        NSString *mineType = httpModel.mineType;
        if (!mineType || [mineTypeArray containsObject:mineType]) {
            continue;
        }
        [mineTypeArray addObject:mineType];
    }
    
    NSMutableArray *mineTypeDataArray = [NSMutableArray array];
    for (NSString *mineTypeA in mineTypeArray) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:mineTypeA forKey:@"mineType"];
        NSInteger num = 0;
        for (ZooNetFlowHttpModel* httpModel in dataArray) {
            NSString *mineTypeB = httpModel.mineType;
            if ([mineTypeA isEqualToString:mineTypeB]) {
                num++;
            }
        }
        [dic setValue:@(num) forKey:@"num"];
        [mineTypeDataArray addObject:dic];
    }

    NSMutableArray<ZooChartDataItem *> *items = [NSMutableArray array];
    for (NSDictionary *mineTypeData in mineTypeDataArray) {
        ZooChartDataItem *item = [[ZooChartDataItem alloc] initWithValue:[mineTypeData[@"num"] doubleValue] name:mineTypeData[@"mineType"] color:[UIColor zoo_randomColor]];
        [items addObject:item];
    }
    self.chartItems = [NSArray arrayWithArray:items];
}


@end
