//
//  ZooWeakNetworkDetailView.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooWeakNetworkDetailView.h"
#import "ZooWeakNetworkManager.h"
#import "ZooWeakNetworkLevelView.h"
#import "ZooWeakNetworkInputView.h"
#import <Zoo/ZooDefine.h>

@interface ZooWeakNetworkDetailView()<ZooWeakNetworkLevelViewDelegate>

@property (nonatomic, strong) ZooWeakNetworkLevelView *levelView;
@property (nonatomic, strong) ZooWeakNetworkInputView *delayInputView;
@property (nonatomic, strong) ZooWeakNetworkInputView *upInputView;
@property (nonatomic, strong) ZooWeakNetworkInputView *downInputView;
@property (nonatomic, strong) NSArray *weakItemArray;
@property (nonatomic, strong) NSDictionary *inputItemArray;
@property (nonatomic, assign) NSInteger weakSize;
@property (nonatomic, strong) NSString *delayTitle;
@property (nonatomic, strong) NSString *upFlowTitle;
@property (nonatomic, strong) NSString *downFlowTitle;
@property (nonatomic, strong) NSString *flowEpilog;
@property (nonatomic, strong) NSString *timeEpilog;


@end


@implementation ZooWeakNetworkDetailView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        CGFloat padding = kZooSizeFrom750_Landscape(68);
        _levelView = [[ZooWeakNetworkLevelView alloc] initWithFrame:CGRectMake(0, padding, self.zoo_width, padding)];
        _levelView.delegate = self;
        [self initWeakItem];
        [_levelView renderUIWithItemArray:_weakItemArray selecte:[ZooWeakNetworkManager shareInstance].selecte ? :0];
        [self addSubview:_levelView];
        
        _delayInputView = [[ZooWeakNetworkInputView alloc] initWithFrame:CGRectMake(padding * 2, _levelView.zoo_bottom + padding/2, self.zoo_width - padding, padding)];
        _upInputView = [[ZooWeakNetworkInputView alloc] initWithFrame:CGRectMake(padding * 2, _levelView.zoo_bottom + padding/2, self.zoo_width - padding, padding)];
        _downInputView = [[ZooWeakNetworkInputView alloc] initWithFrame:CGRectMake(padding * 2, _upInputView.zoo_bottom , self.zoo_width - padding, padding)];
        [self renderInputView:[ZooWeakNetworkManager shareInstance].selecte];
        
        __weak typeof(self) weakSelf = self;
         [_delayInputView addBlock:^{
             [ZooWeakNetworkManager shareInstance].delayTime = [weakSelf.delayInputView getInputValue];
         }];
         [_upInputView addBlock:^{
             [ZooWeakNetworkManager shareInstance].upFlowSpeed = [weakSelf.upInputView getInputValue];
         }];
         [_downInputView addBlock:^{
             [ZooWeakNetworkManager shareInstance].downFlowSpeed = [weakSelf.downInputView getInputValue];
         }];
        
        [self addSubview:_delayInputView];
        [self addSubview:_upInputView];
        [self addSubview:_downInputView];
        
    }
    return self;
}

- (void)initWeakItem{
    _weakItemArray = @[
        @"断网",
        @"超时",
        @"限速",
        @"延时"
    ];
    
    _delayTitle = [NSString stringWithFormat:@"%@:",ZooLocalizedString(@"延时时间")];
    _upFlowTitle = [NSString stringWithFormat:@"%@:",ZooLocalizedString(@"请求限速")];
    _downFlowTitle = [NSString stringWithFormat:@"%@:",ZooLocalizedString(@"响应限速")];
    _flowEpilog = @"Kb/s";
    _timeEpilog = @"S";
}

- (void)_renderInputHidden:(BOOL)hidden{
    _delayInputView.hidden = !hidden;
    _upInputView.hidden = hidden;
    _downInputView.hidden = hidden;
}

- (void)_renderInputValue{
    [ZooWeakNetworkManager shareInstance].delayTime = [_delayInputView getInputValue];
    [ZooWeakNetworkManager shareInstance].upFlowSpeed = [_upInputView getInputValue];
    [ZooWeakNetworkManager shareInstance].downFlowSpeed = [_downInputView getInputValue];
}

- (void)renderInputView:(NSInteger)select{
    
    switch (select) {
        case 0:
        case 1:
            _delayInputView.hidden = YES;
            _upInputView.hidden = YES;
            _downInputView.hidden = YES;
            break;
        case 2:
            [_upInputView renderUIWithTitle:_upFlowTitle end:_flowEpilog];
            [_upInputView renderUIWithSpeed:[ZooWeakNetworkManager shareInstance].upFlowSpeed define:2000];
            [_downInputView renderUIWithTitle:_downFlowTitle end:_flowEpilog];
            [_downInputView renderUIWithSpeed:[ZooWeakNetworkManager shareInstance].downFlowSpeed define:2000];
           [self _renderInputHidden:NO];
            break;
        case 3:
            [_delayInputView renderUIWithTitle:_delayTitle end:_timeEpilog];
            [_delayInputView renderUIWithSpeed:[ZooWeakNetworkManager shareInstance].delayTime define:10];
            [self _renderInputHidden:YES];
            break;
                
        default:
            break;
    }
}

#pragma mark - ZooWeakNetworkLevelViewDelegate
- (void)segmentSelected:(NSInteger)index{

    [ZooWeakNetworkManager shareInstance].selecte = index;
    [self renderInputView:index];
    [self _renderInputValue];
}

@end
