//
//  ZooImageDetectionCell.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <UIKit/UIKit.h>
@class ZooResponseImageModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZooImageDetectionCell : UITableViewCell
+ (CGFloat)cellHeight;

- (void)setupWithModel:(ZooResponseImageModel *)model;
@end

NS_ASSUME_NONNULL_END
