//
//  ZooSubThreadUICheckListCell.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <UIKit/UIKit.h>

@interface ZooSubThreadUICheckListCell : UITableViewCell

- (void)renderCellWithData:(NSDictionary *)dic;

+ (CGFloat)cellHeight;

@end
