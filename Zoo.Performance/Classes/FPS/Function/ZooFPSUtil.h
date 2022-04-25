//
//  ZooFPSUtil.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ZooFPSBlock)(NSInteger fps);

@interface ZooFPSUtil : NSObject

- (void)start;
- (void)end;
- (void)addFPSBlock:(ZooFPSBlock)block;

@end

NS_ASSUME_NONNULL_END
