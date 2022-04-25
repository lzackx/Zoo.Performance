//
//  ZooURLSessionDemux.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <Foundation/Foundation.h>

@interface ZooURLSessionDemux : NSObject

- (instancetype)initWithConfiguration:(NSURLSessionConfiguration *)configuration;

@property (atomic, copy,   readonly ) NSURLSessionConfiguration *   configuration;

@property (atomic, strong, readonly ) NSURLSession *                session;

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request delegate:(id<NSURLSessionDataDelegate>)delegate modes:(NSArray *)modes;

@end

