//
//  ZooUIProfileManager.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZooUIProfileManager : NSObject

@property (nonatomic, assign) BOOL enable;              //default NO

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
