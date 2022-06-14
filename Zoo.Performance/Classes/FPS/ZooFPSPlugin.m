//
//  ZooFPSPlugin.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooFPSPlugin.h"
#import "ZooFPSViewController.h"
#import <Zoo/ZooHomeWindow.h>

@implementation ZooFPSPlugin

- (void)pluginDidLoad{
    ZooFPSViewController *vc = [[ZooFPSViewController alloc] init];
    [ZooHomeWindow openPlugin:vc];
}

@end
