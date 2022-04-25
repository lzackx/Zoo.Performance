//
//  ZooCacheManager.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooCacheManager+Performance.h"
#import <Zoo/ZooManager.h>
#import <Zoo/ZooDefine.h>


static NSString * const kZooFpsKey = @"zoo_fps_key";
static NSString * const kZooCpuKey = @"zoo_cpu_key";
static NSString * const kZooMemoryKey = @"zoo_memory_key";
static NSString * const kZooNetFlowKey = @"zoo_netflow_key";
static NSString * const kZooSubThreadUICheckKey = @"zoo_sub_thread_ui_check_key";
static NSString * const kZooMethodUseTimeKey = @"zoo_method_use_time_key";
static NSString * const kZooLargeImageDetectionKey = @"zoo_large_image_detection_key";
static NSString * const kZooStartTimeKey = @"zoo_start_time_key";
static NSString * const kZooStartClassKey = @"zoo_start_class_key";
static NSString * const kZooANRTrackKey = @"zoo_anr_track_key";
static NSString * const kZooBigImageDetectionSizeKey = @"zoo_big_image_detection_key";

@implementation ZooCacheManager (Performance)

- (void)saveFpsSwitch:(BOOL)on{
    [[NSUserDefaults standardUserDefaults] setBool:on forKey:kZooFpsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)fpsSwitch{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kZooFpsKey];
}

- (void)saveCpuSwitch:(BOOL)on{
    [[NSUserDefaults standardUserDefaults] setBool:on forKey:kZooCpuKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)cpuSwitch{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kZooCpuKey];
}

- (void)saveMemorySwitch:(BOOL)on{
    [[NSUserDefaults standardUserDefaults] setBool:on forKey:kZooMemoryKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)memorySwitch{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kZooMemoryKey];
}

- (void)saveNetFlowSwitch:(BOOL)on{
    [[NSUserDefaults standardUserDefaults] setBool:on forKey:kZooNetFlowKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)netFlowSwitch{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kZooNetFlowKey];
}

- (void)saveLargeImageDetectionSwitch:(BOOL)on{
    [[NSUserDefaults standardUserDefaults] setBool:on forKey:kZooLargeImageDetectionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)largeImageDetectionSwitch{
    return [[NSUserDefaults standardUserDefaults] boolForKey: kZooLargeImageDetectionKey];
}

- (void)saveSubThreadUICheckSwitch:(BOOL)on{
    [[NSUserDefaults standardUserDefaults] setBool:on forKey:kZooSubThreadUICheckKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)subThreadUICheckSwitch{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kZooSubThreadUICheckKey];
}

- (void)saveMethodUseTimeSwitch:(BOOL)on{
    [[NSUserDefaults standardUserDefaults] setBool:on forKey:kZooMethodUseTimeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)methodUseTimeSwitch{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kZooMethodUseTimeKey];
}

- (void)saveStartTimeSwitch:(BOOL)on {
    [[NSUserDefaults standardUserDefaults] setBool:on forKey:kZooStartTimeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)startTimeSwitch{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kZooStartTimeKey];
}

- (void)saveANRTrackSwitch:(BOOL)on {
    [[NSUserDefaults standardUserDefaults] setBool:on forKey:kZooANRTrackKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)anrTrackSwitch {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kZooANRTrackKey];
}

- (void)saveStartClass:(NSString *)startClass {
    [[NSUserDefaults standardUserDefaults] setObject:startClass forKey:kZooStartClassKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)startClass {
    NSString *startClass = [[NSUserDefaults standardUserDefaults] objectForKey:kZooStartClassKey];
    return startClass;
}

- (int64_t)bigImageDetectionSize {
    NSString *sizeString = [[NSUserDefaults standardUserDefaults] stringForKey:kZooBigImageDetectionSizeKey];
    int64_t size = [sizeString longLongValue];
    return size;
}

- (void)saveBigImageDetectionSize:(int64_t)bigImageDetectionSize {
    NSString *sizeString = [NSString stringWithFormat:@"%lld", bigImageDetectionSize];
    [[NSUserDefaults standardUserDefaults] setObject:sizeString forKey:kZooBigImageDetectionSizeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
