//
//  ZooSubThreadUICheckPlugin.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooSubThreadUICheckPlugin.h"
#import "ZooSubThreadUICheckViewController.h"
#import <Zoo/ZooHomeWindow.h>

@implementation ZooSubThreadUICheckPlugin

- (void)pluginDidLoad{
    ZooSubThreadUICheckViewController *vc = [[ZooSubThreadUICheckViewController alloc] init];
    [ZooHomeWindow openPlugin:vc];
}

@end
