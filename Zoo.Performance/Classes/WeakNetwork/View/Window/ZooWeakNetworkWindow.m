//
//  ZooWeakNetworkWindow.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooWeakNetworkWindow.h"
#import <Zoo/ZooDefine.h>
#import <Zoo/UIView+Zoo.h>
#import <Zoo/ZooStatusBarViewController.h>
#import "ZooWeakNetworkManager.h"
#import "ZooNetworkInterceptor.h"

@interface ZooWeakNetworkWindow()

@property (nonatomic, assign) CGFloat showViewSize;
@property (nonatomic, strong) UILabel *flowtitle;
@property (nonatomic, strong) UILabel *upFlowValue;
@property (nonatomic, strong) UILabel *downFlowValue;
@property (nonatomic, strong) UIButton *closeBtn;

@property(nonatomic, assign) int height;
@property(nonatomic, assign) int width;
@property(nonatomic, assign) int fontSize;
@property(nonatomic, strong) UIColor *fontColor;

@end

@implementation ZooWeakNetworkWindow

+ (ZooWeakNetworkWindow *)shareInstance{
    static dispatch_once_t once;
    static ZooWeakNetworkWindow *instance;
    dispatch_once(&once, ^{
        instance = [[ZooWeakNetworkWindow alloc] init];
        [instance _initialization];
    });
    return instance;
}

- (instancetype)init{
    _showViewSize = kZooSizeFrom750_Landscape(148);
    CGFloat x = self.startingPosition.x;
    CGFloat y = self.startingPosition.y;
    CGPoint defaultPosition = ZooStartingPosition;
    if (x < 0 || x > (ZooScreenWidth - _showViewSize*2.5)) {
        x = defaultPosition.x;
    }
    if (y <= 0 || y > (ZooScreenHeight - _showViewSize)) {
        y = _showViewSize/2;
    }
    
    self = [super initWithFrame:CGRectMake(x, y, _showViewSize*2.5, _showViewSize)];
    if (self) {
        self.backgroundColor = [UIColor zoo_colorWithHex:0x000000 andAlpha:0.33];
        self.windowLevel = UIWindowLevelStatusBar + 50;
        self.layer.cornerRadius = kZooSizeFrom750_Landscape(8);
        self.layer.masksToBounds = YES;//保证显示
        NSString *version= [UIDevice currentDevice].systemVersion;
        if(version.doubleValue >=10.0) {
            if (!self.rootViewController) {
                self.rootViewController = [[UIViewController alloc] init];
            }
        }else{
            //iOS9.0的系统中，新建的window设置的rootViewController默认没有显示状态栏
            if (!self.rootViewController) {
                self.rootViewController = [[ZooStatusBarViewController alloc] init];
            }
        }
        UIPanGestureRecognizer *move = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_move:)];
        [self addGestureRecognizer:move];
    }
    return self;
}

- (void)_initialization{
    _height = kZooSizeFrom750_Landscape(26);
    _width = self.zoo_width/5;
    _fontSize = kZooSizeFrom750_Landscape(26);
    _fontColor = [UIColor whiteColor];
    _width = self.zoo_width - _width;
    [self.rootViewController.view addSubview:self.flowtitle];
    [self.rootViewController.view addSubview:self.upFlowValue];
    [self.rootViewController.view addSubview:self.downFlowValue];
    [self.rootViewController.view addSubview:self.closeBtn];
}

- (void)closeBtnClick{
    [self hide];
}

- (void)hide{
    self.hidden = YES;
    [[ZooWeakNetworkManager shareInstance] endRecord];
    if(self.delegate) {
        [_delegate zooWeakNetworkWindowClosed];
    }
}


- (UIButton *)closeBtn{
    _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.zoo_width-_height, 0, _height, _height)];
    [_closeBtn setImage:[UIImage zoo_xcassetImageNamed:@"zoo_close_white"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _closeBtn.backgroundColor = [UIColor clearColor];
    return _closeBtn;
}

- (UILabel *)flowtitle{
    if (!_flowtitle) {
        _flowtitle = [[UILabel alloc] initWithFrame:CGRectMake(0, self.zoo_height/8, _width*2, _height)];
        _flowtitle.textAlignment = NSTextAlignmentLeft;
        _flowtitle.font = [UIFont systemFontOfSize:_fontSize];
        _flowtitle.textColor = _fontColor;
        _flowtitle.text = ZooLocalizedString(@"弱网模式");
        _flowtitle.adjustsFontSizeToFitWidth = YES;
    }
    return _flowtitle;
}

- (UILabel *)upFlowValue {
    if (!_upFlowValue) {
        _upFlowValue = [[UILabel alloc] initWithFrame:CGRectMake(0, self.zoo_height/3 + _height/2, _width*2, _height)];
        _upFlowValue.textAlignment = NSTextAlignmentLeft;
        _upFlowValue.font = [UIFont systemFontOfSize:_fontSize];
        _upFlowValue.textColor = _fontColor;
        _upFlowValue.adjustsFontSizeToFitWidth = YES;
    }
    return _upFlowValue;
}

- (UILabel *)downFlowValue {
    if (!_downFlowValue) {
        _downFlowValue = [[UILabel alloc] initWithFrame:CGRectMake(0, _upFlowValue.zoo_bottom + _height/2, _width*2, _height)];
        _downFlowValue.textAlignment = NSTextAlignmentLeft;
        _downFlowValue.font = [UIFont systemFontOfSize:_fontSize];
        _downFlowValue.textColor = _fontColor;
        _downFlowValue.adjustsFontSizeToFitWidth = YES;
    }
    return _downFlowValue;
}

- (void)_move:(UIPanGestureRecognizer *)sender{
    //1、获得拖动位移
    CGPoint offsetPoint = [sender translationInView:sender.view];
    //2、清空拖动位移
    [sender setTranslation:CGPointZero inView:sender.view];
    //3、重新设置控件位置
    UIView *panView = sender.view;
    CGFloat newX = panView.zoo_centerX+offsetPoint.x;
    CGFloat newY = panView.zoo_centerY+offsetPoint.y;
    if (newX < _showViewSize) {
        newX = _showViewSize;
    }
    if (newX > ZooScreenWidth - _showViewSize) {
        newX = ZooScreenWidth - _showViewSize;
    }
    if (newY < _showViewSize/2) {
        newY = _showViewSize/2;
    }
    if (newY > ZooScreenHeight - _showViewSize/2) {
        newY = ZooScreenHeight - _showViewSize/2;
    }
    panView.center = CGPointMake(newX, newY);
}

-(void)updateFlowValue:(NSString *)upFlow downFlow:(NSString *)downFlow fromWeak:(BOOL)is{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self _updateFlowValue:upFlow downFlow:downFlow fromWeak:is];
    });
}

-(void)_updateFlowValue:(NSString *)upFlow downFlow:(NSString *)downFlow fromWeak:(BOOL)is{
    NSInteger selecte = [ZooWeakNetworkManager shareInstance].selecte;
    if(self.hidden){
        return ;
    }else if(!is){
        if(selecte == ZooWeakNetwork_Break ||selecte == ZooWeakNetwork_OutTime){
            downFlow = nil;
        }else if(selecte == ZooWeakNetwork_WeakSpeed){
            return ;
        }
    }
        
    if([upFlow floatValue]>=1000){
        upFlow = [NSString stringWithFormat:@"%.1fK",[upFlow floatValue]/1000];
        NSLog(@"the end === %@",upFlow);
    }
    
    if([downFlow floatValue]>=1000){
        downFlow = [NSString stringWithFormat:@"%.1fK",[downFlow floatValue]/1000];
    }
    _upFlowValue.text = upFlow ? [NSString stringWithFormat:@"%@ : %@ B/s",ZooLocalizedString(@"上行流量"),upFlow] : _upFlowValue.text;
    _downFlowValue.text = downFlow ? [NSString stringWithFormat:@"%@ : %@ B/s",ZooLocalizedString(@"下行流量"),downFlow] :_downFlowValue.text;
}
@end
