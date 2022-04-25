//
//  ZooManager+Performance.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <Zoo/ZooManager.h>


NS_ASSUME_NONNULL_BEGIN

typedef void (^ZooANRBlock)(NSDictionary *);
typedef void (^ZooPerformanceBlock)(NSDictionary *);

@interface ZooManager (Performance)

@property (nonatomic, copy) NSString *startClass;
@property (nonatomic, copy) ZooANRBlock anrBlock;
@property (nonatomic, copy) ZooPerformanceBlock performanceBlock;
@property (nonatomic, assign) int64_t bigImageDetectionSize;
@property (nonatomic, copy) NSArray<NSString *> *vcProfilerBlackList;

// MARK: - Performance
- (void)addPerformancePlugins;

- (void)setupPerformancePlugins;

@end

NS_ASSUME_NONNULL_END
