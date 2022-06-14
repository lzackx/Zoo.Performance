//
//  ZooNetFlowListCell.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooNetFlowListCell.h"
#import <Zoo/UIView+Zoo.h>
#import <Zoo/ZooDefine.h>
#import <Zoo/UIColor+Zoo.h>
#import <Zoo/ZooUtil.h>
#import <Zoo/Zooi18NUtil.h>

static CGFloat const kFontSize = 10;

@interface ZooNetFlowListCell()

@property (nonatomic, strong) UILabel *urlLabel;//url信息
@property (nonatomic, strong) UILabel *methodLabel;//请求方式
@property (nonatomic, strong) UILabel *statusLabel;//请求状态
@property (nonatomic, strong) UILabel *startTimeLabel;//请求开始时间
@property (nonatomic, strong) UILabel *timeLabel;//请求耗时
@property (nonatomic, strong) UILabel *flowLabel;//流量信息

@end

@implementation ZooNetFlowListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.urlLabel = [[UILabel alloc] init];
        self.urlLabel.font = [UIFont systemFontOfSize:kFontSize];
        
        self.urlLabel.numberOfLines = 0;
        [self.contentView addSubview:self.urlLabel];
        
        self.methodLabel = [[UILabel alloc] init];
        self.methodLabel.font = [UIFont systemFontOfSize:kFontSize];
        self.methodLabel.textColor = [UIColor whiteColor];
        self.methodLabel.backgroundColor = [UIColor zoo_colorWithHex:0XD26282];
        self.methodLabel.layer.cornerRadius = 2;
        self.methodLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:self.methodLabel];
        
        self.statusLabel = [[UILabel alloc] init];
        self.statusLabel.font = [UIFont systemFontOfSize:kFontSize];
        
        [self.contentView addSubview:self.statusLabel];
        
        self.startTimeLabel = [[UILabel alloc] init];
        self.startTimeLabel.font = [UIFont systemFontOfSize:kFontSize];
        
        [self.contentView addSubview:self.startTimeLabel];
        
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.font = [UIFont systemFontOfSize:kFontSize];
        
        [self.contentView addSubview:self.timeLabel];
        
        self.flowLabel = [[UILabel alloc] init];
        self.flowLabel.font = [UIFont systemFontOfSize:kFontSize];
        [self.contentView addSubview:self.flowLabel];
        
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
        if (@available(iOS 13.0, *)) {
            self.urlLabel.textColor = [UIColor labelColor];
            self.statusLabel.textColor = [UIColor labelColor];
            self.startTimeLabel.textColor = [UIColor labelColor];
            self.timeLabel.textColor = [UIColor labelColor];
            self.flowLabel.textColor = [UIColor labelColor];
        } else {
#endif
            self.urlLabel.textColor = [UIColor blackColor];
            self.statusLabel.textColor = [UIColor blackColor];
            self.startTimeLabel.textColor = [UIColor blackColor];
            self.timeLabel.textColor = [UIColor blackColor];
            self.flowLabel.textColor = [UIColor blackColor];
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
        }
#endif
    }
    return self;
}

- (void)renderCellWithModel:(ZooNetFlowHttpModel *)httpModel{
    CGFloat startY = 5,startX=10;
    NSString *urlString = httpModel.url;
    if (urlString.length>0){
        self.urlLabel.text = urlString;
        CGSize size = [self.urlLabel sizeThatFits:CGSizeMake(ZooScreenWidth-50, CGFLOAT_MAX)];
        self.urlLabel.frame = CGRectMake(startX, startY, ZooScreenWidth-40, size.height);
        startY += self.urlLabel.zoo_height+2;
    }
    
    CGFloat height = 0;
    NSString *method = httpModel.method;
    NSString *status = httpModel.statusCode;
    if (method.length>0) {
        NSString *mineType = httpModel.mineType;
        if (mineType.length>0) {
            self.methodLabel.text = [NSString stringWithFormat:@" %@ > %@ ",method,mineType];
        }else{
            self.methodLabel.text = [NSString stringWithFormat:@" %@ ",method];
        }
        [self.methodLabel sizeToFit];
        self.methodLabel.frame = CGRectMake(10, startY, self.methodLabel.zoo_width, self.methodLabel.zoo_height);
        startX = self.methodLabel.zoo_right+5;
        height = self.methodLabel.zoo_height;
    }
    if (status.length>0) {
        self.statusLabel.text =[NSString stringWithFormat:@"[%@]",status];
        [self.statusLabel sizeToFit];
        self.statusLabel.frame = CGRectMake(startX, self.urlLabel.zoo_bottom+2, self.statusLabel.zoo_width, self.statusLabel.zoo_height);
        height = self.statusLabel.zoo_height;
    }
    if (method.length>0 || status.length>0) {
        startY += height + 2;
    }
    
    startX = 10;
    
    NSString *startTime = [ZooUtil dateFormatTimeInterval:httpModel.startTime];
    NSString *time = httpModel.totalDuration;
    if (startTime.length>0) {
        self.startTimeLabel.text = startTime;
        [self.startTimeLabel sizeToFit];
        self.startTimeLabel.frame = CGRectMake(startX, startY, self.startTimeLabel.zoo_width, self.startTimeLabel.zoo_height);
        startX = self.startTimeLabel.zoo_right + 5;
        height = self.startTimeLabel.zoo_height;
    }
    if (time.length>0) {
        self.timeLabel.text = [NSString stringWithFormat:@"%@:%@s",ZooLocalizedString(@"耗时"),time];
        [self.timeLabel sizeToFit];
        self.timeLabel.frame = CGRectMake(startX, startY, self.timeLabel.zoo_width, self.timeLabel.zoo_height);
        height = self.startTimeLabel.zoo_height;
    }
    
    if (startTime.length>0 || time.length>0) {
        startY += height+2;
    }
    startX = 10;
    
    NSString *uploadFlow = [ZooUtil formatByte:[httpModel.uploadFlow floatValue]];
    NSString *downFlow = [ZooUtil formatByte:[httpModel.downFlow floatValue]];
    if(uploadFlow.length>0 || downFlow.length>0){
        NSMutableString *netflow = [NSMutableString string];
        if (uploadFlow.length>0) {
            [netflow appendString:[NSString stringWithFormat:@"↑ %@",uploadFlow]];
        }
        if (downFlow.length>0) {
            [netflow appendString:[NSString stringWithFormat:@"↓ %@",downFlow]];
        }
        
        self.flowLabel.text = netflow;
        [self.flowLabel sizeToFit];
        self.flowLabel.frame = CGRectMake(startX, startY, self.flowLabel.zoo_width, self.flowLabel.zoo_height);
    }
}

+ (CGFloat)cellHeightWithModel:(ZooNetFlowHttpModel *)httpModel{
    CGFloat height = 5;

    UILabel *tempLabel = [[UILabel alloc] init];
    tempLabel.font = [UIFont systemFontOfSize:10];
    NSString *urlString = httpModel.url;
    if (urlString.length>0) {
        tempLabel.numberOfLines = 0;
        tempLabel.text = urlString;
        CGSize size = [tempLabel sizeThatFits:CGSizeMake(ZooScreenWidth-50, CGFLOAT_MAX)];
        height += size.height;
        height += 2.;
    }
    
    NSString *method = httpModel.method;
    NSString *status = httpModel.statusCode;
    if (method.length>0 || status.length>0) {
        tempLabel.numberOfLines = 1;
        tempLabel.text = ZooLocalizedString(@"你好");
        [tempLabel sizeToFit];
        height += tempLabel.zoo_height;
        height += 2;
    }
    
    NSString *startTime = [ZooUtil dateFormatTimeInterval:httpModel.startTime];
    NSString *time = httpModel.totalDuration;
    if (startTime.length>0 || time.length>0) {
        tempLabel.numberOfLines = 1;
        tempLabel.text = ZooLocalizedString(@"你好");
        [tempLabel sizeToFit];
        height += tempLabel.zoo_height;
        height += 2;
    }
    
    NSString *uploadFlow = httpModel.uploadFlow;
    NSString *downFlow = httpModel.downFlow;
    if (uploadFlow.length>0 || downFlow.length>0) {
        tempLabel.numberOfLines = 1;
        tempLabel.text = ZooLocalizedString(@"你好");
        [tempLabel sizeToFit];
        height += tempLabel.zoo_height;
        height += 2;
    }
    
    height += 3;

    return height;
}


@end
