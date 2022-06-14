//
//  ZooLargeImageDetectionManager.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooLargeImageDetectionManager.h"
#import <Zoo/ZooCacheManager.h>
#import "ZooResponseImageModel.h"
#import "ZooNetworkInterceptor.h"
#import "ZooUrlUtil.h"

static ZooLargeImageDetectionManager *instance = nil;

@interface ZooLargeImageDetectionManager() <ZooNetworkInterceptorDelegate>
@end

@implementation ZooLargeImageDetectionManager {
    dispatch_semaphore_t semaphore;
    BOOL _isDetecting;
}

+ (instancetype)shareInstance {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[ZooLargeImageDetectionManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _images = [NSMutableArray array];
        semaphore = dispatch_semaphore_create(1);
        _isDetecting = NO;
        _minimumDetectionSize = 500 * 1024;
    }
    return self;
}

- (void)setDetecting:(BOOL)detecting {
    _isDetecting = detecting;
    [self updateInterceptStatus];
}

- (BOOL)detecting {
    return _isDetecting;
}

- (void)updateInterceptStatus {
    if (_isDetecting) {
        [[ZooNetworkInterceptor shareInstance] addDelegate: self];
    } else {
        [[ZooNetworkInterceptor shareInstance] removeDelegate: self];
    }
}

#pragma mark -- ZooNetworkInterceptorDelegate
- (void)zooNetworkInterceptorDidReceiveData:(NSData *)data response:(NSURLResponse *)response request:(NSURLRequest *)request error:(NSError *)error startTime:(NSTimeInterval)startTime {
    if (![response.MIMEType hasPrefix:@"image/"]) {
        return;
    }
    if ([ZooUrlUtil getResponseLength:(NSHTTPURLResponse *)response data:data] < self.minimumDetectionSize) {
        return;
    }
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    ZooResponseImageModel *model = [[ZooResponseImageModel alloc] initWithResponse: response data: data];
    [self.images addObject: model];
    dispatch_semaphore_signal(semaphore);
}


- (BOOL)shouldIntercept {
    return _isDetecting;
}
    
@end
