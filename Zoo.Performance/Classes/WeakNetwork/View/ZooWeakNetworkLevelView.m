//
//  ZooWeakNetworkLevelView.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooWeakNetworkLevelView.h"
#import <Zoo/ZooDefine.h>

@interface ZooWeakNetworkLevelView()

@property (nonatomic, strong) UISegmentedControl *segment;

@end

@implementation ZooWeakNetworkLevelView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //NSArray *dataArray = @[@"Verbose",@"Debug",@"Info"];
        _segment = [[UISegmentedControl alloc] init];
        _segment.frame = CGRectMake(kZooSizeFrom750_Landscape(68), self.zoo_height/2-kZooSizeFrom750_Landscape(68)/2, self.zoo_width-kZooSizeFrom750_Landscape(68)*2, kZooSizeFrom750_Landscape(68));
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
        if (@available(iOS 13, *)) {
           _segment.selectedSegmentTintColor = [UIColor zoo_colorWithString:@"#337CC4"];
        } else {
#endif
            _segment.tintColor = [UIColor zoo_colorWithString:@"#337CC4"];
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
        }
#endif
        [_segment addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
        UIFont *font = [UIFont systemFontOfSize:kZooSizeFrom750_Landscape(28)];   // 设置字体大小
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        [_segment setTitleTextAttributes:attributes forState:UIControlStateNormal];
        [self addSubview:_segment];
    }
    return self;
}

-(void)renderUIWithItemArray:(NSArray *)itemArray selecte:(NSUInteger)selected{
    for (int i = 0; i<itemArray.count; i++) {
        [_segment insertSegmentWithTitle:ZooLocalizedString(itemArray[i]) atIndex:i animated:NO];
    }
    [_segment setSelectedSegmentIndex:selected];
}

-(void)segmentChange:(UISegmentedControl *)sender{
    NSInteger index = sender.selectedSegmentIndex;
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentSelected:)]) {
        [self.delegate segmentSelected:index];
    }
}


@end
