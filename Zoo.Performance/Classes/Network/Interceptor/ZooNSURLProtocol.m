//
//  ZooNSURLProtocol.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooNSURLProtocol.h"
#import "ZooNetFlowHttpModel.h"
#import "ZooNetFlowDataSource.h"
#import "ZooNetFlowManager.h"
#import "ZooURLSessionDemux.h"
#import "ZooNetworkInterceptor.h"
#import <Zoo/ZooManager.h>
#import <Zoo/ZooDefine.h>
#import "ZooUrlUtil.h"
#import <Zoo/UIViewController+Zoo.h>

static NSString * const kZooProtocolKey = @"zoo_protocol_key";

@interface ZooNSURLProtocol()<NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession *urlSession;
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSError *error;

@property (atomic, strong, readwrite) NSThread *clientThread;
@property (atomic, copy,   readwrite) NSArray *modes;
@property (atomic, strong, readwrite) NSURLSessionDataTask *task;

@end

@implementation ZooNSURLProtocol

+ (ZooURLSessionDemux *)sharedDemux{
    static dispatch_once_t      sOnceToken;
    static ZooURLSessionDemux *sDemux;
    dispatch_once(&sOnceToken, ^{
        NSURLSessionConfiguration *config;
        config = [NSURLSessionConfiguration defaultSessionConfiguration];
        sDemux = [[ZooURLSessionDemux alloc] initWithConfiguration:config];
    });
    return sDemux;
}

+ (BOOL)canInitWithTask:(NSURLSessionTask *)task {
    NSURLRequest *request = task.currentRequest;
    return request == nil ? NO : [self canInitWithRequest:request];
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request{
    if ([NSURLProtocol propertyForKey:kZooProtocolKey inRequest:request]) {
        return NO;
    }
    if (![ZooNetworkInterceptor shareInstance].shouldIntercept) {
        return NO;
    }
    if (![request.URL.scheme isEqualToString:@"http"] &&
        ![request.URL.scheme isEqualToString:@"https"]) {
        return NO;
    }
    //文件类型不作处理
    NSString *contentType = [request valueForHTTPHeaderField:@"Content-Type"];
    if (contentType && [contentType containsString:@"multipart/form-data"]) {
        return NO;
    }
    
//    if ([self ignoreRequest:request]) {
//        return NO;
//    }
    
    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request{
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    [NSURLProtocol setProperty:@YES forKey:kZooProtocolKey inRequest:mutableReqeust];
    return [mutableReqeust copy];
}

- (void)handleFromSelect{
    if(ZooWeakNetwork_Delay == [[ZooNetworkInterceptor shareInstance].weakDelegate weakNetSelecte]){
        ZooLog(@"Delay Net");//此处有dispatch_get_main_queue，无法使用switch
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([[ZooNetworkInterceptor shareInstance].weakDelegate delayTime] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.task resume];
        });
    }else if(ZooWeakNetwork_WeakSpeed == [[ZooNetworkInterceptor shareInstance].weakDelegate weakNetSelecte]){
        ZooLog(@"WeakUpFlow Net");
        [[ZooNetFlowManager shareInstance] httpBodyFromRequest:self.request bodyCallBack:^(NSData *body) {
            [[ZooNetworkInterceptor shareInstance].weakDelegate handleWeak:body isDown:NO];
            [self.task resume];
        }];
    }else{
        [self.task resume];
    }
}

- (BOOL)needLoading{
    BOOL result = YES;
    if ([ZooNetworkInterceptor shareInstance].weakDelegate){
        if(ZooWeakNetwork_OutTime == [[ZooNetworkInterceptor shareInstance].weakDelegate weakNetSelecte]){
            ZooLog(@"Outtime Net");
            [self.client URLProtocol:self didFailWithError:[[NSError alloc] initWithDomain:NSCocoaErrorDomain code:NSURLErrorTimedOut userInfo:nil]];
            result = NO;
        }else if(ZooWeakNetwork_Break == [[ZooNetworkInterceptor shareInstance].weakDelegate weakNetSelecte]){
            ZooLog(@"Break Net");
            [self.client URLProtocol:self didFailWithError:[[NSError alloc] initWithDomain:NSCocoaErrorDomain code:NSURLErrorNotConnectedToInternet userInfo:nil]];
            result = NO;
        }
    }
    return result;
}

- (void)startLoading{
    NSMutableURLRequest *   recursiveRequest;
    NSMutableArray *        calculatedModes;
    NSString *              currentMode;
    
    assert(self.clientThread == nil);
    assert(self.task == nil);
    assert(self.modes == nil);
    
    calculatedModes = [NSMutableArray array];
    [calculatedModes addObject:NSDefaultRunLoopMode];
    currentMode = [[NSRunLoop currentRunLoop] currentMode];
    if ( (currentMode != nil) && ! [currentMode isEqual:NSDefaultRunLoopMode] ) {
        [calculatedModes addObject:currentMode];
    }
    self.modes = calculatedModes;
    assert([self.modes count] > 0);
    
    recursiveRequest = [[self request] mutableCopy];
    assert(recursiveRequest != nil);
    
    self.clientThread = [NSThread currentThread];
    self.data = [NSMutableData data];
    self.startTime = [[NSDate date] timeIntervalSince1970];
    self.task = [[[self class] sharedDemux] dataTaskWithRequest:recursiveRequest delegate:self modes:self.modes];
    assert(self.task != nil);
    if([ZooNetworkInterceptor shareInstance].weakDelegate){
        [self handleFromSelect];
    }else{
        [self.task resume];
    }
}

- (void)stopLoading{
    assert(self.clientThread != nil);
    assert([NSThread currentThread] == self.clientThread);
    [[ZooNetworkInterceptor shareInstance] handleResultWithData: self.data
                                                            response: self.response
                                                             request:self.request
                                                               error:self.error
                                                           startTime:self.startTime];
    
    if (self.task != nil) {
        [self.task cancel];
        self.task = nil;
    }
}

#pragma mark - NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    assert([NSThread currentThread] == self.clientThread);
    self.response = response;
    if([self needLoading]){
        [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        completionHandler(NSURLSessionResponseAllow);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    assert([NSThread currentThread] == self.clientThread);
    if ([ZooNetworkInterceptor shareInstance].weakDelegate) {
        if(ZooWeakNetwork_WeakSpeed == [[ZooNetworkInterceptor shareInstance].weakDelegate weakNetSelecte]){
            ZooLog(@"WeakDownFlow Net");
            [[ZooNetworkInterceptor shareInstance].weakDelegate handleWeak:data isDown:YES];
        }
    }
    [self.data appendData:data];
    [self.client URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    assert([NSThread currentThread] == self.clientThread);
    if (error) {
        self.error = error;
        [self.client URLProtocol:self didFailWithError:error];
    }else if([self needLoading]){
        [self.client URLProtocolDidFinishLoading:self];
    }
}

//- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
//    assert([NSThread currentThread] == self.clientThread);
//    //判断服务器返回的证书类型, 是否是服务器信任
//    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
//        //强制信任
//        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
//        completionHandler(NSURLSessionAuthChallengeUseCredential, card);
//    }
//}

// 去掉一些我们不关心的链接, 与UIWebView的兼容还是要好好考略一下
+ (BOOL)ignoreRequest:(NSURLRequest *)request{
    NSString *pathExtension = [request.URL.absoluteString pathExtension];
    //NSArray *blackList = @[@"",@"",@""];
    if (pathExtension.length > 0) {
        return YES;
    }
    return NO;
}

@end
