//
//  NSURLSessionConfiguration+Zoo.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "NSURLSessionConfiguration+Zoo.h"
#import "ZooNSURLProtocol.h"
//#import <Zoo/ZooMultiURLProtocol.h>
#import <Zoo/NSObject+Zoo.h>
#import "ZooNetFlowManager.h"
#import <Zoo/ZooCacheManager.h>


@implementation NSURLSessionConfiguration (Zoo)

+ (void)load{
    [[self class] zoo_swizzleClassMethodWithOriginSel:@selector(defaultSessionConfiguration) swizzledSel:@selector(zoo_defaultSessionConfiguration)];
    [[self class] zoo_swizzleClassMethodWithOriginSel:@selector(ephemeralSessionConfiguration) swizzledSel:@selector(zoo_ephemeralSessionConfiguration)];
}

+ (NSURLSessionConfiguration *)zoo_defaultSessionConfiguration{
    NSURLSessionConfiguration *configuration = [self zoo_defaultSessionConfiguration];
    [configuration addZooNSURLProtocol];
    return configuration;
}

+ (NSURLSessionConfiguration *)zoo_ephemeralSessionConfiguration{
    NSURLSessionConfiguration *configuration = [self zoo_ephemeralSessionConfiguration];
    [configuration addZooNSURLProtocol];
    return configuration;
}

- (void)addZooNSURLProtocol {
    if ([self respondsToSelector:@selector(protocolClasses)]
        && [self respondsToSelector:@selector(setProtocolClasses:)]) {
        NSMutableArray * urlProtocolClasses = [NSMutableArray arrayWithArray: self.protocolClasses];
        //ZooMultiURLProtocol
//        Class protoCls = ZooMultiURLProtocol.class;
        Class protoCls = ZooNSURLProtocol.class;
        if (![urlProtocolClasses containsObject:protoCls]) {
            [urlProtocolClasses insertObject:protoCls atIndex:0];
        }
        self.protocolClasses = urlProtocolClasses;
    }
}

@end
