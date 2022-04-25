//
//  ZooLargeImageDetectionManager.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <Foundation/Foundation.h>
@class ZooResponseImageModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZooLargeImageDetectionManager : NSObject
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, assign) BOOL detecting;
@property (nonatomic, assign) int64_t minimumDetectionSize;

+ (instancetype) shareInstance;
- (void)updateInterceptStatus;
@end

NS_ASSUME_NONNULL_END
