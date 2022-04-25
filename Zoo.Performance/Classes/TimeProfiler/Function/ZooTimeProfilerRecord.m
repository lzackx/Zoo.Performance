//
//  ZooTimeProfilerRecord.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooTimeProfilerRecord.h"

@implementation ZooTimeProfilerRecord

- (NSString *)descriptionWithDepth {
    NSMutableString *str = [NSMutableString new];
    [str appendFormat:@"%2d| ",(int)_callDepth];
    [str appendFormat:@"%6.2f| ",_timeCost * 1000.0];
    for (NSUInteger i = 0; i < _callDepth; i++) {
        [str appendString:@"  "];
    }
    [str appendFormat:@"%s[%@ %@]",(_isClassMethod ? "+" : "-"),_className,_methodName];
    return str;
}

- (NSString *)description {
    NSMutableString *str = [NSMutableString new];
    [str appendFormat:@"%2d| ",(int)_callDepth];
    [str appendFormat:@"%6.2f|",_timeCost * 1000.0];
    [str appendFormat:@"%s[%@ %@]", (_isClassMethod ? "+" : "-"), _className, _methodName];
    return str;
}

@end
