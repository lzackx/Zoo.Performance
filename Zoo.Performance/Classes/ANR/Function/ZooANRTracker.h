//
//  ZooANRTracker.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

// 参考ONEANRTracker

#import <Foundation/Foundation.h>
#import "ZooPingThread.h"

//ANR监控状态枚举
typedef NS_ENUM(NSUInteger, ZooANRTrackerStatus) {
    ZooANRTrackerStatusStart, //监控开启
    ZooANRTrackerStatusStop,  //监控停止
};

/**
 *  主线程卡顿监控类
 */
@interface ZooANRTracker : NSObject

/**
 *  开始监控
 *
 *  @param threshold 卡顿阈值
 *  @param handler   监控到卡顿回调(回调时会自动暂停卡顿监控)
 */
- (void)startWithThreshold:(double)threshold
                   handler:(ZooANRTrackerBlock)handler;

/**
 *  停止监控
 */
- (void)stop;

/**
 *  ANR监控状态
 */
- (ZooANRTrackerStatus)status;

@end
