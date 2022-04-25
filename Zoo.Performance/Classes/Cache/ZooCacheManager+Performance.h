//
//  ZooCacheManager.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <Foundation/Foundation.h>
#import <Zoo/ZooCacheManager.h>


@interface ZooCacheManager (Performance)

- (void)saveFpsSwitch:(BOOL)on;

- (BOOL)fpsSwitch;

- (void)saveCpuSwitch:(BOOL)on;

- (BOOL)cpuSwitch;

- (void)saveMemorySwitch:(BOOL)on;

- (BOOL)memorySwitch;

- (void)saveNetFlowSwitch:(BOOL)on;

- (BOOL)netFlowSwitch;

- (void)saveLargeImageDetectionSwitch:(BOOL)on;

- (BOOL)largeImageDetectionSwitch;

- (void)saveSubThreadUICheckSwitch:(BOOL)on;

- (BOOL)subThreadUICheckSwitch;

- (void)saveMethodUseTimeSwitch:(BOOL)on;

- (BOOL)methodUseTimeSwitch;

- (void)saveStartTimeSwitch:(BOOL)on;

- (BOOL)startTimeSwitch;

- (void)saveANRTrackSwitch:(BOOL)on;

- (BOOL)anrTrackSwitch;

- (NSString *)startClass;

- (void)saveStartClass : (NSString *)startClass;

- (int64_t)bigImageDetectionSize;

- (void)saveBigImageDetectionSize:(int64_t)bigImageDetectionSize;


@end
