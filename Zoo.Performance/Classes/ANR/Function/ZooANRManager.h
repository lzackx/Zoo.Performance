//
//  ZooANRManager.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef void (^ZooANRManagerBlock)(NSDictionary *anrInfo);

@interface ZooANRManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, assign) BOOL anrTrackOn; 

/*
 卡顿时长阈值，单位为秒，
 */
@property (nonatomic, assign) CGFloat timeOut;

- (void)addANRBlock:(ZooANRManagerBlock)block;

- (void)start;
- (void)stop;

@end
