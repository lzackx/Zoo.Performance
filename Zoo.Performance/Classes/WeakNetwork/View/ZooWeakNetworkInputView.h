//
//  ZooWeakNetworkInputView.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ZooNetWeakInputBlock)(void);

@interface ZooWeakNetworkInputView : UIView

- (void)renderUIWithTitle:(NSString *)title end:(NSString *)epilog;
- (void)renderUIWithSpeed:(long)speed define:(NSInteger)value;
- (long)getInputValue;

- (void)addBlock:(ZooNetWeakInputBlock)block;

@end

NS_ASSUME_NONNULL_END
