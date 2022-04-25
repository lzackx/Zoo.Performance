//
//  NSURLRequest+Zoo.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <Foundation/Foundation.h>

@interface NSURLRequest (Zoo)

- (NSString *)requestId;
- (void)setRequestId:(NSString *)requestId;


- (NSNumber*)startTime;
- (void)setStartTime:(NSNumber*)startTime;

@end
