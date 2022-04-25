//
//  ZooSubThreadUICheckManager.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <Foundation/Foundation.h>

@interface ZooSubThreadUICheckManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) NSMutableArray *checkArray;

@end
