//
//  ZooANRTool.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZooANRTool : NSObject

/**
 保存卡顿记录到沙盒中的Library/Caches/ANR目录下
 
 @param info 卡顿信息的内容
 */
+ (void)saveANRInfo:(NSDictionary *)info;

/**
 获取卡顿记录的目录

 @return 卡顿记录的目录
 */
+ (NSString *)anrDirectory;

@end

NS_ASSUME_NONNULL_END
