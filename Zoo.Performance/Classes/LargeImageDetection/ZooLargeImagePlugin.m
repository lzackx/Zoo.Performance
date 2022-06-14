//
//  ZooLargeImagePlugin.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooLargeImagePlugin.h"
#import "ZooLargeImageViewController.h"
#import <Zoo/ZooHomeWindow.h>

@implementation ZooLargeImagePlugin
- (void)pluginDidLoad {
    ZooLargeImageViewController *vc = [[ZooLargeImageViewController alloc] init];
    [ZooHomeWindow openPlugin:vc];
}

@end
