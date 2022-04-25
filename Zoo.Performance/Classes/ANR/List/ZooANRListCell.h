//
//  ZooANRListCell.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <UIKit/UIKit.h>

@class ZooSandboxModel;

@interface ZooANRListCell : UITableViewCell

- (void)renderCellWithData:(ZooSandboxModel *)model;

+ (CGFloat)cellHeight;

@end
