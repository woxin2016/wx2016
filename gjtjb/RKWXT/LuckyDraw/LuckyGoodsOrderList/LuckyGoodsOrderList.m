//
//  LuckyGoodsOrderList.m
//  RKWXT
//
//  Created by SHB on 15/8/17.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "LuckyGoodsOrderList.h"
#import "LuckyGoodsOrderListCell.h"
#import "LuckyOrderListModel.h"
#import "LuckyGoodsOrderInfoVC.h"
#import "AliPayControl.h"
#import "LuckyOrderEntity.h"
#import "MJRefresh.h"

#define Size self.bounds.size
#define EveryTimeLoadDataNumber 5

@interface LuckyGoodsOrderList ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    NSArray *orderListArr;
    
    NSInteger orderID;
    
    BOOL isRefresh;
}
@end

@implementation LuckyGoodsOrderList

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addOBS];
    [self setupRefresh];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCSTTitle:@"奖品订单"];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
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

-(void)addOBS{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(loadLuckyOrderListSucceed) name:D_Notification_Name_LuckyOrderList_LoadSucceed object:nil];
    [notificationCenter addObserver:self selector:@selector(loadLuckyOrderListFailed:) name:D_Notification_Name_LuckyOrderList_LoadFailed object:nil];
    [notificationCenter addObserver:self selector:@selector(paySucceed) name:D_Notification_Name_AliPaySucceed object:nil];
}

-(void)removeOBS{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:D_Notification_Name_LuckyOrderList_LoadSucceed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:D_Notification_Name_LuckyOrderList_LoadFailed object:nil];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return LuckyGoodsOrderListCellHeight;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [orderListArr count];
}

-(WXUITableViewCell *)tableViewForLuckyGoodsListCellAtRow:(NSInteger)row{
    static NSString *identifier = @"luckyOrderListCell";
    LuckyGoodsOrderListCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LuckyGoodsOrderListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setCellInfo:orderListArr[row]];
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    cell = [self tableViewForLuckyGoodsListCellAtRow:row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    LuckyOrderEntity *en = [orderListArr objectAtIndex:row];
    orderID = en.order_id;
    
    LuckyGoodsOrderInfoVC *vc = [[LuckyGoodsOrderInfoVC alloc] init];
    vc.luckyEntity = en;
    [self.wxNavigationController pushViewController:vc];
}

#pragma mark luckyModelDelegate
-(void)headerRefreshing{
    isRefresh = YES;
    if([orderListArr count] == 0){
        [[LuckyOrderListModel shareLuckyOrderList] loadLuckyOrderListWithStrat:0 withLength:EveryTimeLoadDataNumber];
    }else{
        [[LuckyOrderListModel shareLuckyOrderList] loadLuckyOrderListWithStrat:0 withLength:[orderListArr count]];
    }
}

-(void)footerRefreshing{
    isRefresh = NO;
    [[LuckyOrderListModel shareLuckyOrderList] loadLuckyOrderListWithStrat:[orderListArr count] withLength:EveryTimeLoadDataNumber];
}

-(void)loadLuckyOrderListSucceed{
    if(isRefresh){
        [_tableView headerEndRefreshing];
    }else{
        [_tableView footerEndRefreshing];
    }
    
    orderListArr = [LuckyOrderListModel shareLuckyOrderList].luckyOrderListArr;
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)loadLuckyOrderListFailed:(NSNotification*)notification{
    if(isRefresh){
        [_tableView headerEndRefreshing];
    }else{
        [_tableView footerEndRefreshing];
    }
    
    NSString *errorMsg = notification.object;
    if(!errorMsg){
        errorMsg = @"获取订单列表失败";
    }
    [UtilTool showAlertView:errorMsg];
}

#pragma mark pay
-(void)paySucceed{
    for(LuckyOrderEntity *enti in [LuckyOrderListModel shareLuckyOrderList].luckyOrderListArr){
        if(enti.order_id == orderID){
            enti.pay_status = LuckyOrder_Pay_Done;
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:[self indexPathWithLuckyOrderEntity:enti] inSection:0];
            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath ,nil] withRowAnimation:UITableViewRowAnimationFade];
            return;
        }
    }
}

-(NSInteger)indexPathWithLuckyOrderEntity:(LuckyOrderEntity*)luckyEnt{
    orderListArr = [LuckyOrderListModel shareLuckyOrderList].luckyOrderListArr;
    NSInteger index = 0;
    if (luckyEnt){
        index = [orderListArr indexOfObject:luckyEnt];
    }
    return index;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeOBS];
}

@end
