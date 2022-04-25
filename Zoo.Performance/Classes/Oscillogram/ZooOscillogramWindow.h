//
//  ZooOscillogramWindow.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ZooOscillogramViewController.h"

@protocol ZooOscillogramWindowDelegate <NSObject>

- (void)zooOscillogramWindowClosed;

@end

@interface ZooOscillogramWindow : UIWindow

+ (ZooOscillogramWindow *)shareInstance;

@property (nonatomic, strong) ZooOscillogramViewController *vc;

//需要子类重写
- (void)addRootVc;

- (void)show;

- (void)hide;

- (void)addDelegate:(id<ZooOscillogramWindowDelegate>) delegate;

- (void)removeDelegate:(id<ZooOscillogramWindowDelegate>)delegate;

@end
