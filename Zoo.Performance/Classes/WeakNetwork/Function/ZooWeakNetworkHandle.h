//
//  ZooWeakNetworkHandle.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZooWeakNetworkHandle : NSObject

- (NSData *)weakFlow:(NSData *)data count:(NSInteger)times size:(NSInteger)weakSize;

@end

NS_ASSUME_NONNULL_END
