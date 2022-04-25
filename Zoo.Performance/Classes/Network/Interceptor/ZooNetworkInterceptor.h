//
//  ZooNetworkInterceptor.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZooNetworkInterceptorDelegate <NSObject>
- (BOOL)shouldIntercept;

- (void)zooNetworkInterceptorDidReceiveData: (NSData *)data
                                              response: (NSURLResponse *)response
                                              request: (NSURLRequest *)request
                                              error: (NSError *)error
                                              startTime: (NSTimeInterval)startTime;
@end

@protocol ZooNetworkWeakDelegate <NSObject>

typedef NS_ENUM(NSUInteger, ZooWeakNetType) {
    #pragma mark - 弱网选项对应
    // 断网
    ZooWeakNetwork_Break,
    // 超时
    ZooWeakNetwork_OutTime,
    // 限网
    ZooWeakNetwork_WeakSpeed,
    //延时
    ZooWeakNetwork_Delay
};

- (NSInteger)weakNetSelecte;

- (NSUInteger)delayTime;

- (void)handleWeak:(NSData *)data isDown:(BOOL)is;
//- (NSData *)zooNSURLProtocolWeak:(NSData *)data count:(NSInteger)times;

@end

@interface ZooNetworkInterceptor : NSObject
@property (nonatomic, assign) BOOL shouldIntercept;

@property (nonatomic, weak) id<ZooNetworkWeakDelegate> weakDelegate;

+ (instancetype)shareInstance;

- (void)addDelegate:(id<ZooNetworkInterceptorDelegate>) delegate;
- (void)removeDelegate:(id<ZooNetworkInterceptorDelegate>)delegate;
- (void)updateInterceptStatusForSessionConfiguration: (NSURLSessionConfiguration *)sessionConfiguration;
- (void)handleResultWithData: (NSData *)data
                    response: (NSURLResponse *)response
                     request: (NSURLRequest *)request
                       error: (NSError *)error
                   startTime: (NSTimeInterval)startTime;
@end

NS_ASSUME_NONNULL_END
