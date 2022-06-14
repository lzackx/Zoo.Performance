//
//  ZooANRPlugin.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooANRPlugin.h"
#import "ZooANRViewController.h"
#import <Zoo/ZooHomeWindow.h>

@implementation ZooANRPlugin

- (void)pluginDidLoad{
    ZooANRViewController *vc = [[ZooANRViewController alloc] init];
    [ZooHomeWindow openPlugin:vc];
}

@end
