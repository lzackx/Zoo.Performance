//
//  ZooLaunchTimePlugin.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooLaunchTimePlugin.h"
#import <Zoo/ZooHomeWindow.h>
#import "ZooLaunchTimeViewController.h"

@implementation ZooLaunchTimePlugin

- (void)pluginDidLoad{
    ZooLaunchTimeViewController *vc = [[ZooLaunchTimeViewController alloc] init];
    [ZooHomeWindow openPlugin:vc];
}

@end
