//
//  ZooUrlUtil.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <Foundation/Foundation.h>

@interface ZooUrlUtil : NSObject

+ (NSString *)convertJsonFromData:(NSData *)data;

+ (NSDictionary *)convertDicFromData:(NSData *)data;

+ (NSUInteger)getHeadersLengthWithRequest:(NSURLRequest *)request;

+ (void)requestLength:(NSURLRequest *)request callBack:(void (^)(NSUInteger))callBack;

+ (NSUInteger)getHeadersLength:(NSDictionary *)headers ;

+ (NSDictionary<NSString *, NSString *> *)getCookies:(NSURLRequest *)request ;

+ (int64_t)getResponseLength:(NSHTTPURLResponse *)response data:(NSData *)responseData;

@end
