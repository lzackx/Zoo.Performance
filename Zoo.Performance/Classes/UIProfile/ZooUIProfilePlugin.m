//
//  ZooUIProfilePlugin.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooUIProfilePlugin.h"
#import "ZooUIProfileViewController.h"
#import <Zoo/ZooHomeWindow.h>

@implementation ZooUIProfilePlugin

- (void)pluginDidLoad{
    ZooUIProfileViewController *vc = [[ZooUIProfileViewController alloc] init];
    [ZooHomeWindow openPlugin:vc];
}

@end
