//
//  ZooManager+Performance.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooManager+Performance.h"
#import "ZooCacheManager+Performance.h"

#import <objc/runtime.h>
#import <Zoo/Zooi18NUtil.h>

#import "ZooANRManager.h"
#import "ZooLargeImageDetectionManager.h"
#import "ZooNetFlowOscillogramWindow.h"
#import "ZooNetFlowManager.h"



@implementation ZooManager (Performance)

#pragma mark - Performance
- (void)addPerformancePlugins {
    [self addPluginWithModel: [self appFPSPluginModel]];
    [self addPluginWithModel: [self appCPUPluginModel]];
    [self addPluginWithModel: [self appMemoryPluginModel]];
    [self addPluginWithModel: [self appNetFlowPluginModel]];
    [self addPluginWithModel: [self appSubThreadUIPluginModel]];
    [self addPluginWithModel: [self appANRPluginModel]];
    [self addPluginWithModel: [self appLargeImagePluginModel]];
    [self addPluginWithModel: [self appLaunchTimePluginModel]];
    [self addPluginWithModel: [self appUIProfilePluginModel]];
    [self addPluginWithModel: [self appTimeProfilePluginModel]];
    [self addPluginWithModel: [self appWeakNetworkPluginModel]];
}

- (void)setupPerformancePlugins {
    
    if ([[ZooCacheManager sharedInstance] netFlowSwitch]) {
        [[ZooNetFlowManager shareInstance] canInterceptNetFlow:YES];
        //[[ZooNetFlowOscillogramWindow shareInstance] show];
    }
    
    [[ZooCacheManager sharedInstance] saveFpsSwitch:NO];
    [[ZooCacheManager sharedInstance] saveCpuSwitch:NO];
    [[ZooCacheManager sharedInstance] saveMemorySwitch:NO];
    
    [[ZooANRManager sharedInstance] addANRBlock:^(NSDictionary *anrInfo) {
        if (self.anrBlock) {
            self.anrBlock(anrInfo);
        }
    }];
    
    if (self.bigImageDetectionSize > 0){
        [ZooLargeImageDetectionManager shareInstance].minimumDetectionSize = self.bigImageDetectionSize;
    }
}
#pragma mark - Variables
- (NSString *)startClass{
    return [[ZooCacheManager sharedInstance] startClass];
}

- (void)setStartClass:(NSString *)startClass {
    [[ZooCacheManager sharedInstance] saveStartClass:startClass];
}

- (ZooANRBlock)anrBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setAnrBlock:(void(^)(NSDictionary *info))anrBlock {
    objc_setAssociatedObject(self, @selector(anrBlock), anrBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (ZooPerformanceBlock)performanceBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setPerformanceBlock:(void(^)(NSDictionary *info))performanceBlock {
    objc_setAssociatedObject(self, @selector(performanceBlock), performanceBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (int64_t)bigImageDetectionSize {
    return [[ZooCacheManager sharedInstance] bigImageDetectionSize];
}

- (void)setBigImageDetectionSize:(int64_t)bigImageDetectionSize {
    [[ZooCacheManager sharedInstance] saveBigImageDetectionSize:bigImageDetectionSize];
}

- (NSArray<NSString *> *)vcProfilerBlackList {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setVcProfilerBlackList:(NSArray<NSString *> *)vcProfilerBlackList {
    objc_setAssociatedObject(self, @selector(vcProfilerBlackList), vcProfilerBlackList, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - Model

- (ZooManagerPluginTypeModel *)appFPSPluginModel {
    ZooManagerPluginTypeModel *model = [ZooManagerPluginTypeModel new];
    model.title = ZooLocalizedString(@"FPS");
    model.desc = ZooLocalizedString(@"FPS");
    model.icon = @"zoo_fps";
    model.pluginName = @"ZooFPSPlugin";
    model.atModule = ZooLocalizedString(@"Performance");
    return model;
}

- (ZooManagerPluginTypeModel *)appCPUPluginModel {
    ZooManagerPluginTypeModel *model = [ZooManagerPluginTypeModel new];
    model.title = ZooLocalizedString(@"CPU");
    model.desc = ZooLocalizedString(@"CPU");
    model.icon = @"zoo_cpu";
    model.pluginName = @"ZooCPUPlugin";
    model.atModule = ZooLocalizedString(@"Performance");
    return model;
}

- (ZooManagerPluginTypeModel *)appMemoryPluginModel {
    ZooManagerPluginTypeModel *model = [ZooManagerPluginTypeModel new];
    model.title = ZooLocalizedString(@"Memory");
    model.desc = ZooLocalizedString(@"Memory");
    model.icon = @"zoo_memory";
    model.pluginName = @"ZooMemoryPlugin";
    model.atModule = ZooLocalizedString(@"Performance");
    return model;
}

- (ZooManagerPluginTypeModel *)appNetFlowPluginModel {
    ZooManagerPluginTypeModel *model = [ZooManagerPluginTypeModel new];
    model.title = ZooLocalizedString(@"Net Flow");
    model.desc = ZooLocalizedString(@"Net Flow");
    model.icon = @"zoo_net";
    model.pluginName = @"ZooNetFlowPlugin";
    model.atModule = ZooLocalizedString(@"Performance");
    return model;
}

- (ZooManagerPluginTypeModel *)appSubThreadUIPluginModel {
    ZooManagerPluginTypeModel *model = [ZooManagerPluginTypeModel new];
    model.title = ZooLocalizedString(@"SubThreadUI");
    model.desc = ZooLocalizedString(@"SubThreadUI");
    model.icon = @"zoo_ui";
    model.pluginName = @"ZooSubThreadUICheckPlugin";
    model.atModule = ZooLocalizedString(@"Performance");
    return model;
}

- (ZooManagerPluginTypeModel *)appANRPluginModel {
    ZooManagerPluginTypeModel *model = [ZooManagerPluginTypeModel new];
    model.title = ZooLocalizedString(@"AppNotResponse");
    model.desc = ZooLocalizedString(@"AppNotResponse");
    model.icon = @"zoo_anr";
    model.pluginName = @"ZooANRPlugin";
    model.atModule = ZooLocalizedString(@"Performance");
    return model;
}

- (ZooManagerPluginTypeModel *)appLargeImagePluginModel {
    ZooManagerPluginTypeModel *model = [ZooManagerPluginTypeModel new];
    model.title = ZooLocalizedString(@"大图检测");
    model.desc = ZooLocalizedString(@"大图检测");
    model.icon = @"zoo_net";
    model.pluginName = @"ZooLargeImagePlugin";
    model.atModule = ZooLocalizedString(@"Performance");
    return model;
}

- (ZooManagerPluginTypeModel *)appLaunchTimePluginModel {
    ZooManagerPluginTypeModel *model = [ZooManagerPluginTypeModel new];
    model.title = ZooLocalizedString(@"启动耗时");
    model.desc = ZooLocalizedString(@"启动耗时");
    model.icon = @"zoo_app_launch_time";
    model.pluginName = @"ZooLaunchTimePlugin";
    model.atModule = ZooLocalizedString(@"Performance");
    return model;
}

- (ZooManagerPluginTypeModel *)appUIProfilePluginModel {
    ZooManagerPluginTypeModel *model = [ZooManagerPluginTypeModel new];
    model.title = ZooLocalizedString(@"UI层级");
    model.desc = ZooLocalizedString(@"UI层级");
    model.icon = @"zoo_view_level";
    model.pluginName = @"ZooUIProfilePlugin";
    model.atModule = ZooLocalizedString(@"Performance");
    return model;
}

- (ZooManagerPluginTypeModel *)appTimeProfilePluginModel {
    ZooManagerPluginTypeModel *model = [ZooManagerPluginTypeModel new];
    model.title = ZooLocalizedString(@"函数耗时");
    model.desc = ZooLocalizedString(@"函数耗时");
    model.icon = @"zoo_time_profiler";
    model.pluginName = @"ZooTimeProfilerPlugin";
    model.atModule = ZooLocalizedString(@"Performance");
    return model;
}

- (ZooManagerPluginTypeModel *)appWeakNetworkPluginModel {
    ZooManagerPluginTypeModel *model = [ZooManagerPluginTypeModel new];
    model.title = ZooLocalizedString(@"模拟弱网");
    model.desc = ZooLocalizedString(@"模拟弱网测试");
    model.icon = @"zoo_weaknet";
    model.pluginName = @"ZooWeakNetworkPlugin";
    model.atModule = ZooLocalizedString(@"Performance");
    return model;
}

@end
