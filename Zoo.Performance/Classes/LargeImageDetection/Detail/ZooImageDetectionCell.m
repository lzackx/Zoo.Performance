//
//  ZooImageDetectionCell.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooImageDetectionCell.h"
#import "ZooResponseImageModel.h"
#import <Zoo/ZooDefine.h>

@interface ZooImageDetectionCell()
@property (nonatomic, strong) UIImageView *previewImageView;
@property (nonatomic, strong) UILabel *urlLabel;
@property (nonatomic, strong) UILabel *sizeLabel;
@property (nonatomic, strong) UIButton *button;

@end

@implementation ZooImageDetectionCell

+ (CGFloat)cellHeight {
    return 116;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self initUI];
    return self;
}

- (void)setupWithModel:(ZooResponseImageModel *)model {
    self.urlLabel.text = [model.url absoluteString];
    self.previewImageView.image = [UIImage imageWithData: model.data];
    self.sizeLabel.text = [NSString stringWithFormat: @"size: %@", model.size];
}

- (void) initUI {
    CGFloat space = 8;
    
    self.previewImageView = [[UIImageView alloc] initWithFrame: CGRectMake(space, space, 100, 100)];
    self.previewImageView.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue:0 alpha: 0.3];
    self.previewImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview: self.previewImageView];
    
    UIView *imageInfoView = [[UIView alloc] initWithFrame: CGRectMake(self.previewImageView.zoo_width + (space * 2), self.previewImageView.zoo_y, ZooScreenWidth - self.previewImageView.zoo_right - (space * 2), self.previewImageView.zoo_height)];
    [self addSubview: imageInfoView];
    
    self.sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, imageInfoView.zoo_width, 15)];
    self.sizeLabel.textColor = [UIColor zoo_black_1];
    self.sizeLabel.font = [UIFont systemFontOfSize: 11];
    [imageInfoView addSubview: self.sizeLabel];
    
    self.urlLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.sizeLabel.zoo_bottom, imageInfoView.zoo_width, 80)];
    [imageInfoView addSubview: self.urlLabel];
    self.urlLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.sizeLabel.textColor = [UIColor zoo_black_1];
    self.urlLabel.numberOfLines = 5;
    self.urlLabel.font = [UIFont systemFontOfSize: 11];

}

@end
