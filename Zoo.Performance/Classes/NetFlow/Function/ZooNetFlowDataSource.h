//
//  ZooNetFlowDataSource.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <Foundation/Foundation.h>
#import "ZooNetFlowHttpModel.h"

@interface ZooNetFlowDataSource : NSObject

@property (nonatomic, strong) NSMutableArray<ZooNetFlowHttpModel *> *httpModelArray;

+ (ZooNetFlowDataSource *)shareInstance;

- (void)addHttpModel:(ZooNetFlowHttpModel *)httpModel;

- (void)clear;

@end
