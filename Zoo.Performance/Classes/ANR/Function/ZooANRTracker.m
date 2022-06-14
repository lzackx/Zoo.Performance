//
//  ZooANRTracker.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooANRTracker.h"
#import <sys/utsname.h>

/**
 *  主线程卡顿监控看门狗类
 */
@interface ZooANRTracker()

/**
 *  用于Ping主线程的线程实例
 */
@property (nonatomic, strong) ZooPingThread *pingThread;

@end

@implementation ZooANRTracker

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)startWithThreshold:(double)threshold
                   handler:(ZooANRTrackerBlock)handler {
    
    self.pingThread = [[ZooPingThread alloc] initWithThreshold:threshold
                                                            handler:^(NSDictionary *info) {
                                                                handler(info);
                                                            }];
    
    [self.pingThread start];
}

- (void)stop {
    if (self.pingThread != nil) {
        [self.pingThread cancel];
        self.pingThread = nil;
    }
}

- (ZooANRTrackerStatus)status {
    if (self.pingThread != nil && self.pingThread.isCancelled != YES) {
        return ZooANRTrackerStatusStart;
    }else {
        return ZooANRTrackerStatusStop;
    }
}

- (void)dealloc
{
    [self.pingThread cancel];
}

@end
