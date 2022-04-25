//
//  ZooNetFlowListCell.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <UIKit/UIKit.h>
#import "ZooNetFlowHttpModel.h"

@interface ZooNetFlowListCell : UITableViewCell

- (void)renderCellWithModel:(ZooNetFlowHttpModel *)httpModel;

+ (CGFloat)cellHeightWithModel:(ZooNetFlowHttpModel *)httpModel;

@end
