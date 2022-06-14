//
//  ZooLargeImageDetectionListViewController.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooLargeImageDetectionListViewController.h"
#import "ZooLargeImageDetectionManager.h"
#import "ZooImageDetectionCell.h"
#import <Zoo/ZooDefine.h>

@interface ZooLargeImageDetectionListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *filterButton;
@property (nonatomic, strong) NSArray <ZooResponseImageModel *> *images;
@end

@implementation ZooLargeImageDetectionListViewController

- (instancetype)initWithImages:(NSArray <ZooResponseImageModel *> *) images {
    if (self = [super init]) {
        self.images = images;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI {
    
    CGRect tableViewFrame = CGRectMake(0, CGRectGetMaxY(self.textField.frame), ZooScreenWidth, ZooScreenHeight);
    self.tableView = [[UITableView alloc] initWithFrame: tableViewFrame];
    self.tableView.translatesAutoresizingMaskIntoConstraints = false;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsSelection = false;
    [self.tableView registerClass: [ZooImageDetectionCell class] forCellReuseIdentifier: NSStringFromClass([ZooImageDetectionCell class])];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
    
}

- (void)setting {
    
}
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [ZooLargeImageDetectionManager shareInstance].images.count;
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZooImageDetectionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZooImageDetectionCell class]) forIndexPath:indexPath];
    [cell setupWithModel: self.images[indexPath.item]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ZooImageDetectionCell cellHeight];
}

@end
