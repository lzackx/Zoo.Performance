//
//  ZooLargeImageDetectionListViewController.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <UIKit/UIKit.h>
#import <Zoo/ZooBaseViewController.h>
@class ZooResponseImageModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZooLargeImageDetectionListViewController : ZooBaseViewController
- (instancetype)initWithImages:(NSArray <ZooResponseImageModel *> *) images;
@end

NS_ASSUME_NONNULL_END
