//
//  ZooSubThreadUICheckListViewController.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooSubThreadUICheckListViewController.h"
#import <Zoo/UIView+Zoo.h>
#import "ZooSubThreadUICheckListCell.h"
#import "ZooSubThreadUICheckManager.h"
#import "ZooSubThreadUICheckDetailViewController.h"
#import <Zoo/Zooi18NUtil.h>

@interface ZooSubThreadUICheckListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *checkArray;

@end

@implementation ZooSubThreadUICheckListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = ZooLocalizedString(@"检测列表");
    
    self.checkArray = [ZooSubThreadUICheckManager sharedInstance].checkArray;
    
    CGFloat navBarHeight = self.navigationController.navigationBar.zoo_height+[[UIApplication sharedApplication] statusBarFrame].size.height;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.zoo_width, self.view.zoo_height-navBarHeight) style:UITableViewStylePlain];
//    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.checkArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ZooSubThreadUICheckListCell cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"httpcell";
    ZooSubThreadUICheckListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[ZooSubThreadUICheckListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    NSDictionary* dic = [self.checkArray objectAtIndex:indexPath.row];
    [cell renderCellWithData:dic];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary* dic = [self.checkArray objectAtIndex:indexPath.row];
    
    ZooSubThreadUICheckDetailViewController *vc = [[ZooSubThreadUICheckDetailViewController alloc] init];
    vc.checkInfo = dic;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
