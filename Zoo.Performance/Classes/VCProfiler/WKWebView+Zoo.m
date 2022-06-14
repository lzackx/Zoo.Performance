//
//  WKWebView+Zoo.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "WKWebView+Zoo.h"
#import <objc/runtime.h>
#import <Zoo/NSObject+Zoo.h>


@implementation WKWebView (Zoo)

+ (void)load{
    [self zoo_swizzleInstanceMethodWithOriginSel:@selector(loadRequest:) swizzledSel:@selector(zoo_loadRequest:)];
}

- (WKNavigation *)zoo_loadRequest:(NSURLRequest *)request{
    WKNavigation *navigation = [self zoo_loadRequest:request];
    return navigation;
}

@end
