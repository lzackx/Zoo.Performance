//
//  ZooNetFlowPlugin.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooNetFlowPlugin.h"
#import <Zoo/ZooHomeWindow.h>
#import "ZooNetFlowViewController.h"

@implementation ZooNetFlowPlugin

- (void)pluginDidLoad{
    ZooNetFlowViewController *vc = [[ZooNetFlowViewController alloc] init];
    [ZooHomeWindow openPlugin:vc];
}

@end
