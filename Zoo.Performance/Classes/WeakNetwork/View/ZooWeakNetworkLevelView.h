//
//  ZooWeakNetworkLevelView.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZooWeakNetworkLevelViewDelegate<NSObject>

- (void)segmentSelected:(NSInteger)index;

@end

@interface ZooWeakNetworkLevelView : UIView

@property (nonatomic, weak) id<ZooWeakNetworkLevelViewDelegate> delegate;

-(void)renderUIWithItemArray:(NSArray *)itemArray selecte:(NSUInteger)selected;

@end

NS_ASSUME_NONNULL_END
