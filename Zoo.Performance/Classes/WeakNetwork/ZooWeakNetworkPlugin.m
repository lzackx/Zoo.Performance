//
//  ZooWeakNetworkPlugin.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooWeakNetworkPlugin.h"
#import "ZooWeakNetworkViewController.h"
#import <Zoo/ZooHomeWindow.h>

@implementation ZooWeakNetworkPlugin

- (void)pluginDidLoad{
    ZooWeakNetworkViewController *vc = [[ZooWeakNetworkViewController alloc] init];
    [ZooHomeWindow openPlugin:vc];
}

@end
