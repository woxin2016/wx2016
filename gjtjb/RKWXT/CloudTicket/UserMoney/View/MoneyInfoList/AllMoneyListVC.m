//
//  AllMoneyListVC.m
//  RKWXT
//
//  Created by SHB on 16/4/9.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "AllMoneyListVC.h"
#import "UserMoneyInfoListCell.h"
#import "UserMoneyInfoModel.h"
#import "MJRefresh.h"

#define EveryTimeLoad (10)
#define LoadDaysType (0)

@interface AllMoneyListVC()<UITableViewDataSource,UITableViewDelegate,UserMoneyInfoModelDelegate>{
    UITableView *_tableView;
    NSArray *allMoneyInfoArr;
    UserMoneyInfoModel *_model;
    BOOL isRefresh;
}

@end

@implementation AllMoneyListVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _model = [[UserMoneyInfoModel alloc] init];
    [_model setDelegate:self];
    
    [self setupRefresh];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    CGSize size = self.bounds.size;
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 1, size.width, size.height);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

//集成刷新控件
-(void)setupRefresh{
    //1.下拉刷新(进入刷新状态会调用self的headerRefreshing)
    [_tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [_tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    
    //设置文字
    _tableView.headerPullToRefreshText = @"下拉刷新";
    _tableView.headerReleaseToRefreshText = @"松开刷新";
    _tableView.headerRefreshingText = @"刷新中";
    
    _tableView.footerPullToRefreshText = @"上拉加载";
    _tableView.footerReleaseToRefreshText = @"松开加载";
    _tableView.footerRefreshingText = @"加载中";
}

//改变cell分割线置顶
-(void)viewDidLayoutSubviews{
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [allMoneyInfoArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UserMoneyInfoListCellHeight;
}

-(WXUITableViewCell *)tableViewUserWeekCTCell:(NSInteger)row{
    static NSString *identifier = @"Cell";
    UserMoneyInfoListCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[UserMoneyInfoListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setCellInfo:[allMoneyInfoArr objectAtIndex:row]];
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    cell = [self tableViewUserWeekCTCell:row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark mjRefresh
-(void)headerRefreshing{
    isRefresh = YES;
    if([allMoneyInfoArr count] == 0){
        [_model loadUserMoneyInfoData:0 length:EveryTimeLoad days:LoadDaysType];
    }else{
        [_model loadUserMoneyInfoData:0 length:[allMoneyInfoArr count] days:LoadDaysType];
    }
}

-(void)footerRefreshing{
    isRefresh = NO;
    [_model loadUserMoneyInfoData:[allMoneyInfoArr count] length:EveryTimeLoad days:LoadDaysType];
}

-(void)loadUserCloudTicketDataSucceed{
    allMoneyInfoArr = _model.userMoneyInfoArr;
    
    if(isRefresh){
        [_tableView headerEndRefreshing];
    }else{
        [_tableView footerEndRefreshing];
    }
    [_tableView reloadData];
}

-(void)loadUserCloudTicketDataFailed:(NSString *)errorMsg{
    if(!errorMsg){
        errorMsg = @"获取数据失败";
    }
    [UtilTool showAlertView:errorMsg];
    
    if(isRefresh){
        [_tableView headerEndRefreshing];
    }
    if(!isRefresh){
        [_tableView footerEndRefreshing];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_model setDelegate:nil];
}

@end
