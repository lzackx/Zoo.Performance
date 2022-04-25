//
//  ZooWeakNetworkManager.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZooWeakNetworkManager : NSObject

@property (nonatomic, assign) BOOL shouldWeak;
@property (nonatomic, assign) NSUInteger selecte;
@property (nonatomic, assign) NSUInteger upFlowSpeed;
@property (nonatomic, assign) NSUInteger downFlowSpeed;
@property (nonatomic, assign) NSUInteger delayTime;


+ (ZooWeakNetworkManager *)shareInstance;

- (void)canInterceptNetFlow:(BOOL)enable;
- (void)startRecord;
- (void)endRecord;

@end

NS_ASSUME_NONNULL_END
