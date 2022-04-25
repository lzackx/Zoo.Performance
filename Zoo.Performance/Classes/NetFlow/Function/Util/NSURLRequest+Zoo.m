//
//  NSURLRequest+Zoo.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "NSURLRequest+Zoo.h"
#import <objc/runtime.h>

@implementation NSURLRequest (Zoo)

- (NSString *)requestId {
    return objc_getAssociatedObject(self, @"requestId");
}

- (void)setRequestId:(NSString *)requestId {
    objc_setAssociatedObject(self, @"requestId", requestId, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSNumber*)startTime {
    return objc_getAssociatedObject(self, @"startTime");
}

- (void)setStartTime:(NSNumber*)startTime {
    objc_setAssociatedObject(self, @"startTime", startTime, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
