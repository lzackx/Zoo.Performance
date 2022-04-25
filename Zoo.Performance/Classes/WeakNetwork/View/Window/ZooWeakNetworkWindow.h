//
//  ZooWeakNetworkWindow.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZooWeakNetworkWindowDelegate <NSObject>

- (void)zooWeakNetworkWindowClosed;

@end


@interface ZooWeakNetworkWindow : UIWindow

+ (ZooWeakNetworkWindow *)shareInstance;

- (void)hide;

-(void)updateFlowValue:(NSString *)upFlow downFlow:(NSString *)downFlow fromWeak:(BOOL)is;

// start位置
@property (nonatomic) CGPoint startingPosition;
@property (nonatomic, assign) BOOL upFlowChanged;
@property (nonatomic, assign) BOOL downFlowChanged;
@property (nonatomic, weak) id<ZooWeakNetworkWindowDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
