//
//  ZooNetFlowDataSource.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooNetFlowDataSource.h"

@implementation ZooNetFlowDataSource{
    dispatch_semaphore_t semaphore;
}

+ (ZooNetFlowDataSource *)shareInstance{
    static dispatch_once_t once;
    static ZooNetFlowDataSource *instance;
    dispatch_once(&once, ^{
        instance = [[ZooNetFlowDataSource alloc] init];
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _httpModelArray = [NSMutableArray array];
        semaphore = dispatch_semaphore_create(1);
    }
    return self;
}

- (void)addHttpModel:(ZooNetFlowHttpModel *)httpModel{
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    [_httpModelArray insertObject:httpModel atIndex:0];
    dispatch_semaphore_signal(semaphore);
}

- (void)clear{
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    [_httpModelArray removeAllObjects];
    dispatch_semaphore_signal(semaphore);
}

@end
