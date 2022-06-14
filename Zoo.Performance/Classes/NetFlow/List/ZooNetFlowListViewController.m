//
//  ZooNetFlowListViewController.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooNetFlowListViewController.h"
#import "ZooNetFlowDataSource.h"
#import "ZooNetFlowListCell.h"
#import "ZooNetFlowHttpModel.h"
#import "ZooNetFlowDetailViewController.h"
#import <Zoo/ZooDefine.h>
#import <Zoo/ZooStringSearchView.h>

@interface ZooNetFlowListViewController ()<UITableViewDelegate,UITableViewDataSource,ZooStringSearchViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, copy) NSArray *allHttpModelArray;
@property (nonatomic, strong) ZooStringSearchView *searchView;

@end

@implementation ZooNetFlowListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = ZooLocalizedString(@"网络监控列表");
    
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return [UIColor systemBackgroundColor];
            } else {
                return [UIColor whiteColor];
            }
        }];
    } else {
#endif
        self.view.backgroundColor = [UIColor whiteColor];
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
    }
#endif
    
    NSArray *dataArray = [ZooNetFlowDataSource shareInstance].httpModelArray;
    _dataArray = [NSArray arrayWithArray:dataArray];
    _allHttpModelArray = [NSArray arrayWithArray:dataArray];

    _searchView = [[ZooStringSearchView alloc] initWithFrame:CGRectMake(kZooSizeFrom750_Landscape(32), IPHONE_NAVIGATIONBAR_HEIGHT+kZooSizeFrom750_Landscape(32), self.view.zoo_width-2*kZooSizeFrom750_Landscape(32), kZooSizeFrom750_Landscape(100))];
    _searchView.delegate = self;
    [self.view addSubview:_searchView];
    

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _searchView.zoo_bottom+kZooSizeFrom750_Landscape(30), self.view.zoo_width, self.view.zoo_height-_searchView.zoo_bottom-kZooSizeFrom750_Landscape(30)) style:UITableViewStylePlain];
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
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZooNetFlowHttpModel* model = [self.dataArray objectAtIndex:indexPath.row];
    return [ZooNetFlowListCell cellHeightWithModel:model];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"httpcell";
    ZooNetFlowListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[ZooNetFlowListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    ZooNetFlowHttpModel* model = [self.dataArray objectAtIndex:indexPath.row];
    [cell renderCellWithModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZooNetFlowHttpModel* model = [self.dataArray objectAtIndex:indexPath.row];
    ZooNetFlowDetailViewController *detailVc = [[ZooNetFlowDetailViewController alloc] init];
    detailVc.httpModel = model;
    
    [self.navigationController pushViewController:detailVc animated:YES];
}

- (void)leftNavBackClick:(id)clickView{
    [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ZooStringSearchViewDelegate
- (void)searchViewInputChange:(NSString *)text{
    NSArray *allHttpModelArray = _allHttpModelArray;
    if (text.length == 0) {
        _dataArray = allHttpModelArray;
        [self.tableView reloadData];
        return;
    }
    NSMutableArray *tempArray = [NSMutableArray array];
    for (ZooNetFlowHttpModel *httpModel in allHttpModelArray) {
        NSString *url = httpModel.url;
        if ([url containsString:text]) {
            [tempArray addObject:httpModel];
        }
    }
    
    _dataArray = [NSArray arrayWithArray:tempArray];
    [self.tableView reloadData];
}

@end
