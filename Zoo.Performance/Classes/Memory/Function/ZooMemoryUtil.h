//
//  ZooMemoryUtil.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <Foundation/Foundation.h>

@interface ZooMemoryUtil : NSObject

//当前app内存使用量
+ (NSInteger)useMemoryForApp;

//设备总的内存
+ (NSInteger)totalMemoryForDevice;

@end
