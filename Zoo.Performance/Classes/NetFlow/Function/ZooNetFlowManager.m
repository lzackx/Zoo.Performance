//
//  ZooNetFlowManager.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooNetFlowManager.h"
#import "ZooNSURLProtocol.h"
#import "ZooNetFlowDataSource.h"
#import <Zoo/NSObject+Zoo.h>
#import "ZooNetworkInterceptor.h"
#import <Zoo/UIViewController+Zoo.h>


@interface ZooNetFlowManager() <ZooNetworkInterceptorDelegate, NSStreamDelegate>

@property (nonatomic, copy) HttpBodyCallBack bodyCallBack;
@property (nonatomic, strong) NSMutableData *bodyData;

@end

@implementation ZooNetFlowManager

+ (ZooNetFlowManager *)shareInstance{
    static dispatch_once_t once;
    static ZooNetFlowManager *instance;
    dispatch_once(&once, ^{
        instance = [[ZooNetFlowManager alloc] init];
    });
    return instance;
}

- (void)canInterceptNetFlow:(BOOL)enable{
    _canIntercept = enable;
    if (enable) {
        [[ZooNetworkInterceptor shareInstance] addDelegate:self];
        _startInterceptDate = [NSDate date];
    }else{
        [ZooNetworkInterceptor.shareInstance removeDelegate:self];
        _startInterceptDate = nil;
        [[ZooNetFlowDataSource shareInstance] clear];
    }
}

- (void)httpBodyFromRequest:(NSURLRequest *)request bodyCallBack:(HttpBodyCallBack)complete {
    NSData *httpBody = nil;
    if (request.HTTPBody) {
        httpBody = request.HTTPBody;
        complete(httpBody);
        return;
    }
    if ([request.HTTPMethod isEqualToString:@"POST"]) {
        NSInputStream *stream = request.HTTPBodyStream;
        [stream setDelegate:self];
        self.bodyCallBack = complete;
        [stream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [stream open];
    } else {
        complete(httpBody);
    }
}

#pragma mark -- NSStreamDelegate

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    switch (eventCode) {
        case NSStreamEventHasBytesAvailable:
        {
            if (!self.bodyData) {
                self.bodyData = [NSMutableData data];
            }
            uint8_t buf[1024];
            NSInteger len = 0;
            len = [(NSInputStream *)aStream read:buf maxLength:1024];
            if (len) {
                [self.bodyData appendBytes:(const void *)buf length:len];
            }
        }
            break;
        case NSStreamEventErrorOccurred:
        {
            NSError * error = [aStream streamError];
            NSString * errorInfo = [NSString stringWithFormat:@"Failed while reading stream; error '%@' (code %ld)", error.localizedDescription, error.code];
            NSLog(@"%@",errorInfo);
        }
            break;
        case NSStreamEventEndEncountered:
        {
            [aStream close];
            [aStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            aStream = nil;
            if (self.bodyCallBack) {
                self.bodyCallBack([self.bodyData copy]);
            }
            self.bodyData = nil;
        }
            break;
        default:
            break;
    }
}

#pragma mark -- ZooNetworkInterceptorDelegate
- (void)zooNetworkInterceptorDidReceiveData:(NSData *)data response:(NSURLResponse *)response request:(NSURLRequest *)request error:(NSError *)error startTime:(NSTimeInterval)startTime {
    [ZooNetFlowHttpModel dealWithResponseData:data response:response request:request complete:^(ZooNetFlowHttpModel *httpModel) {
        if (!response) {
            httpModel.statusCode = error.localizedDescription;
        }
        httpModel.startTime = startTime;
        httpModel.endTime = [[NSDate date] timeIntervalSince1970];
        
        httpModel.totalDuration = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] - startTime];
        httpModel.topVc = NSStringFromClass([[UIViewController topViewControllerForKeyWindow] class]);
        
        [[ZooNetFlowDataSource shareInstance] addHttpModel:httpModel];
    }];
}

- (BOOL)shouldIntercept {
    return _canIntercept;
}

@end
