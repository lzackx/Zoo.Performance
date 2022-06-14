//
//  ZooNetFlowDetailSegment.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooNetFlowDetailSegment.h"
#import <Zoo/ZooDefine.h>

@interface ZooNetFlowDetailSegment()

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIView *selectLine;

@end

@implementation ZooNetFlowDetailSegment

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.zoo_width/2, self.zoo_height)];
        _leftLabel.textColor = [UIColor zoo_colorWithHexString:@"337CC4"];
        _leftLabel.font = [UIFont systemFontOfSize:kZooSizeFrom750_Landscape(32)];
        _leftLabel.text = ZooLocalizedString(@"请求");
        _leftLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_leftLabel];
        
        UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftTap)];
        _leftLabel.userInteractionEnabled = YES;
        [_leftLabel addGestureRecognizer:leftTap];
        
        _rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.zoo_width/2, 0, self.zoo_width/2, self.zoo_height)];
        _rightLabel.textColor = [UIColor zoo_colorWithHexString:@"333333"];
        _rightLabel.font = [UIFont systemFontOfSize:kZooSizeFrom750_Landscape(32)];
        _rightLabel.text = ZooLocalizedString(@"响应");
        _rightLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_rightLabel];
        
        UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightTap)];
        _rightLabel.userInteractionEnabled = YES;
        [_rightLabel addGestureRecognizer:rightTap];
        
        _selectLine = [[UIView alloc] initWithFrame:CGRectMake(self.zoo_width/4-kZooSizeFrom750_Landscape(128)/2, self.zoo_height-kZooSizeFrom750_Landscape(4), kZooSizeFrom750_Landscape(128), kZooSizeFrom750_Landscape(4))];
        _selectLine.backgroundColor = [UIColor zoo_colorWithHexString:@"337CC4"];
        [self addSubview:_selectLine];
        
    }
    return self;
}

- (void)leftTap{
    if (_delegate && [_delegate respondsToSelector:@selector(segmentClick:)]) {
        [_delegate segmentClick:0];
    }
    _leftLabel.textColor = [UIColor zoo_colorWithHexString:@"337CC4"];
    _rightLabel.textColor = [UIColor zoo_colorWithHexString:@"333333"];
    _selectLine.frame = CGRectMake(self.zoo_width/4-kZooSizeFrom750_Landscape(128)/2, self.zoo_height-kZooSizeFrom750_Landscape(4), kZooSizeFrom750_Landscape(128), kZooSizeFrom750_Landscape(4));
}

- (void)rightTap{
    if (_delegate && [_delegate respondsToSelector:@selector(segmentClick:)]) {
        [_delegate segmentClick:1];
    }
    _leftLabel.textColor = [UIColor zoo_colorWithHexString:@"333333"];
    _rightLabel.textColor = [UIColor zoo_colorWithHexString:@"337CC4"];
    _selectLine.frame = CGRectMake(self.zoo_width*3/4-kZooSizeFrom750_Landscape(128)/2, self.zoo_height-kZooSizeFrom750_Landscape(4), kZooSizeFrom750_Landscape(128), kZooSizeFrom750_Landscape(4));
}


@end
