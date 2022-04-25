//
//  ZooOscillogramWindowManager.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface ZooOscillogramWindowManager : NSObject

+ (ZooOscillogramWindowManager *)shareInstance;

- (void)resetLayout;

@end

NS_ASSUME_NONNULL_END
