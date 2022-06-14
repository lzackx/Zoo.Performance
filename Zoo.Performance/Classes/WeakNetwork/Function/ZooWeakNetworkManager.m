//
//  ZooWeakNetworkManager.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooWeakNetworkManager.h"
#import "ZooNetworkInterceptor.h"
#import "ZooWeakNetworkHandle.h"
#import <Zoo/ZooDefine.h>
#import "ZooWeakNetworkWindow.h"
#import "ZooNetFlowManager.h"
#import "ZooUrlUtil.h"

@interface ZooWeakNetworkManager()<ZooNetworkInterceptorDelegate,ZooNetworkWeakDelegate>

@property (nonatomic, assign) CGFloat sleepTime;
@property (nonatomic, strong) ZooWeakNetworkHandle *weakHandle;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSTimer *secondTimer;


@end

@implementation ZooWeakNetworkManager

+ (ZooWeakNetworkManager *)shareInstance{
    static dispatch_once_t once;
    static ZooWeakNetworkManager *instance;
    dispatch_once(&once, ^{
        instance = [[ZooWeakNetworkManager alloc] init];
        instance.shouldWeak = NO;
        instance.sleepTime = 500000;
    });
    return instance;
}

- (void)startRecord{
    [ZooWeakNetworkManager shareInstance].startTime = [NSDate date];
    if(!_secondTimer){
        _secondTimer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(doSecondFunction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_secondTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)doSecondFunction{
    NSString *str = nil;
    if(![ZooWeakNetworkWindow shareInstance].upFlowChanged){
        [[ZooWeakNetworkWindow shareInstance] updateFlowValue:@"0" downFlow:str fromWeak:YES];
    }
    if(![ZooWeakNetworkWindow shareInstance].downFlowChanged){
        [[ZooWeakNetworkWindow shareInstance] updateFlowValue:str downFlow:@"0" fromWeak:YES];
    }
}

- (void)endRecord{
    if(_secondTimer){
        [_secondTimer invalidate];
        _secondTimer = nil;
    }
    [self canInterceptNetFlow:NO];
}

- (void)canInterceptNetFlow:(BOOL)enable{
    _shouldWeak = enable;
    if (enable) {
        [[ZooNetworkInterceptor shareInstance] addDelegate:self];
        [ZooNetworkInterceptor shareInstance].weakDelegate = self;
        _weakHandle = [[ZooWeakNetworkHandle alloc] init];
    }else{
        [ZooNetworkInterceptor.shareInstance removeDelegate:self];
        [ZooNetworkInterceptor shareInstance].weakDelegate = nil;
    }
}

- (BOOL)shouldWeak{
    return _shouldWeak;
}

- (BOOL)limitSpeed:(NSData *)data isDown:(BOOL)is{
    BOOL result = NO;
    CGFloat speed = is ? _downFlowSpeed : _upFlowSpeed ;
    if(0 == data.length || data.length < (ZooKbChange(speed) ? : ZooKbChange(2000))){
        [self showWeakNetworkWindow:is speed:speed];
        result = YES;
    }
    else{
        [self showWeakNetworkWindow:is speed:speed];
        usleep(_sleepTime);
        [self showWeakNetworkWindow:is speed:speed];
        usleep(_sleepTime);
    }
    [self flowChange:is change:NO];
    return result;
}

- (void)flowChange:(BOOL)isDownFlow change:(BOOL)change{
    if(isDownFlow){
        [ZooWeakNetworkWindow shareInstance].downFlowChanged = change;
    }else{
        [ZooWeakNetworkWindow shareInstance].upFlowChanged = change;
    }
}

- (void)showWeakNetworkWindow:(BOOL) is speed:(CGFloat)speed{
    NSString *str = nil;
    [self flowChange:is change:YES];
    if(is){
        [[ZooWeakNetworkWindow shareInstance] updateFlowValue:str downFlow:[NSString stringWithFormat: @"%f", (ZooKbChange(speed) ? : ZooKbChange(2000))] fromWeak:YES];
    }else{
        [[ZooWeakNetworkWindow shareInstance] updateFlowValue:[NSString stringWithFormat: @"%f", (ZooKbChange(speed) ? : ZooKbChange(2000))] downFlow:str fromWeak:YES];
    }
}

#pragma mark -- ZooNetworkInterceptorDelegate
- (void)zooNetworkInterceptorDidReceiveData:(NSData *)data response:(NSURLResponse *)response request:(NSURLRequest *)request error:(NSError *)error startTime:(NSTimeInterval)startTime {
    [ZooUrlUtil requestLength:request callBack:^(NSUInteger length) {
        [[ZooWeakNetworkWindow shareInstance] updateFlowValue:[NSString stringWithFormat:@"%zi",length] downFlow:[NSString stringWithFormat:@"%lli",[ZooUrlUtil getResponseLength:(NSHTTPURLResponse *)response data:data]] fromWeak:NO];
    }];
}

- (BOOL)shouldIntercept {
    return _shouldWeak;
}


#pragma mark - zooNSURLProtocolWeakNetDelegate
- (void)handleWeak:(NSData *)data isDown:(BOOL)is{
    NSUInteger count = 0;
    NSData *limitedData = nil;
    NSInteger speed = 0;
    speed = is ? _downFlowSpeed : _upFlowSpeed;
    while (true) {
        limitedData = [_weakHandle weakFlow:data count:count size:ZooKbChange(speed) ? : ZooKbChange(2000)];
        if([self limitSpeed:limitedData isDown:is]){
            return ;
        }
        ZooLog(@"count == %ld",count);
        [self flowChange:is change:YES];
        count++;
    }
}

- (NSUInteger)delayTime{
    return _delayTime;
}

- (NSInteger)weakNetSelecte{
    return _selecte;
}

@end

