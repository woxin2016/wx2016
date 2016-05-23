//
//  WaitSendOrderVC.m
//  RKWXT
//
//  Created by SHB on 16/1/9.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WaitSendOrderVC.h"
#import "WaitSendOrderStateCell.h"
#import "WaitSendOrderGoodsCell.h"
#import "WaitSendOrderMoneyCell.h"
#import "WaitSendOrderHandleCell.h"
#import "MJRefresh.h"
#import "AliPayControl.h"

#import "AllOrderListEntity.h"
#import "AllOrderListModel.h"
#import "DealOrderModel.h"

#import "OrderListCommonDef.h"

#define EveryTimeLoad (10)

enum{
    Order_Show_State = 0,
    Order_Show_Goods,
    Order_Show_Money,
    Order_Shop_UserHandle,
    
    Order_Show_Invalid
};

@interface WaitSendOrderVC()<UITableViewDataSource,UITableViewDelegate,AllOrderListModelDelegate,WaitSendOrderHandleCellDelegate>{
    UITableView *_tableView;
    NSMutableArray *orderListArr;
    AllOrderListModel *_model;
    
    BOOL isRefresh;
    UIView *_shell;
}
@end

@implementation WaitSendOrderVC

-(id)init{
    self = [super init];
    if(self){
        _model = [[AllOrderListModel alloc] init];
        [_model setDelegate:self];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupRefresh];
    [self addOBS];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    CGSize size = self.bounds.size;
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, size.width, size.height);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

-(void)loadEmptyOrderListView{
    _shell = [[UIView alloc] init];
    [_shell setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat yOffset = 10;
    UIImage *img = [UIImage imageNamed:@"NoOrderImg.png"];
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.frame = CGRectMake((self.bounds.size.width-img.size.width)/2, yOffset, img.size.width, img.size.height);
    [imgView setImage:img];
    [_shell addSubview:imgView];
    
    yOffset += img.size.height+18;
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, yOffset, self.bounds.size.width, 20);
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:@"您还没有相关订单"];
    [label setTextColor:WXColorWithInteger(0x000000)];
    [label setFont:WXFont(15.0)];
    [_shell addSubview:label];
    
    yOffset += 30;
    [_shell setHidden:YES];
    [_shell setFrame:CGRectMake(0, 110, IPHONE_SCREEN_WIDTH, 100)];
    [self addSubview:_shell];
    
    if([orderListArr count] == 0){
        [_tableView setHidden:YES];
        [_shell setHidden:NO];
    }else{
        [_tableView setHidden:NO];
        [_shell setHidden:YES];
    }
}


-(void)addOBS{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(payOrderListSucceed) name:D_Notification_Name_AliPaySucceed object:nil];
    [notificationCenter addObserver:self selector:@selector(applyRefundSucceed) name:K_Notification_Name_RefundSucceed object:nil];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [orderListArr count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self numberOfRowInSection:section];
}

-(NSInteger)numberOfRowInSection:(NSInteger)section{
    AllOrderListEntity *entity = [orderListArr objectAtIndex:section];
    return Order_Show_Invalid+[entity.goodsListArr count]-1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(row == Order_Show_State){
        height = WaitSendOrderStateCellHeight;
    }
    if(row == [self numberOfRowInSection:section]-1){
        height = WaitSendOrderHandleCellHeight;
    }
    if(row == [self numberOfRowInSection:section]-2){
        height = WaitSendOrderMoneyCellHeight;
    }
    if(row > Order_Show_State && row < [self numberOfRowInSection:section]-2){
        height = WaitSendOrderGoodsCellHeight;
    }
    return height;
}

//订单状态
-(WXUITableViewCell*)orderStateCell:(NSInteger)section{
    static NSString *identifier = @"stateCell";
    WaitSendOrderStateCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WaitSendOrderStateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if([orderListArr count] > 0){
        [cell setCellInfo:[orderListArr objectAtIndex:section]];
    }
    [cell load];
    return cell;
}

//商品列表
-(WXUITableViewCell*)orderGoodsListCell:(NSInteger)section atRow:(NSInteger)row{
    static NSString *identfier = @"goodsListCell";
    WaitSendOrderGoodsCell *cell = [_tableView dequeueReusableCellWithIdentifier:identfier];
    if(!cell){
        cell = [[WaitSendOrderGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfier];
    }
    if([orderListArr count] > 0){
        AllOrderListEntity *entity = [orderListArr objectAtIndex:section];
        [cell setCellInfo:[entity.goodsListArr objectAtIndex:row-1]];
    }
    [cell load];
    return cell;
}

//订单金额
-(WXUITableViewCell*)orderMoneyCell:(NSInteger)section{
    static NSString *identfier = @"moneyCell";
    WaitSendOrderMoneyCell *cell = [_tableView dequeueReusableCellWithIdentifier:identfier];
    if(!cell){
        cell = [[WaitSendOrderMoneyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if([orderListArr count] > 0){
        [cell setCellInfo:[orderListArr objectAtIndex:section]];
    }
    [cell load];
    return cell;
}

//用户操作
-(WXUITableViewCell*)userHandleCell:(NSInteger)section{
    static NSString *identifier = @"handleCell";
    WaitSendOrderHandleCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WaitSendOrderHandleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if([orderListArr count] > 0){
        [cell setCellInfo:[orderListArr objectAtIndex:section]];
    }
    [cell setDelegate:self];
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(row == Order_Show_State){
        cell = [self orderStateCell:section];
    }
    if(row == [self numberOfRowInSection:section]-1){
        cell = [self userHandleCell:section];
    }
    if(row == [self numberOfRowInSection:section]-2){
        cell = [self orderMoneyCell:section];
    }
    if(row > Order_Show_State && row < [self numberOfRowInSection:section]-2){
        cell = [self orderGoodsListCell:section atRow:row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    AllOrderListEntity *entity = [orderListArr objectAtIndex:section];
    if(row == Order_Show_State || row == [self numberOfRowInSection:section]-1 || row == [self numberOfRowInSection:section]-2){
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_Name_JumpToOrderInfo object:entity];
}

-(NSInteger)indexPathOfOptCellWithOrder:(AllOrderListEntity*)orderEntity{
    [orderListArr removeAllObjects];
    for(AllOrderListEntity *entity in _model.orderList){
        if(entity.payType == Order_PayType_HasPay && entity.sendType == Order_SendType_WaitSend){
            [orderListArr addObject:entity];
        }
    }
    NSInteger index = 100000;
    if (orderEntity && [orderListArr count] > 0){
        index = [orderListArr indexOfObject:orderEntity];
    }
    return index;
}

#pragma mark mjRefresh
-(void)headerRefreshing{
    isRefresh = YES;
    if([orderListArr count] == 0){
        [_model loadOrderList:0 andLength:EveryTimeLoad type:OrderList_Type_WaitSend];
    }else{
        [_model loadOrderList:0 andLength:[orderListArr count] type:OrderList_Type_WaitSend];
    }
}

-(void)footerRefreshing{
    isRefresh = NO;
    [_model loadOrderList:[orderListArr count] andLength:EveryTimeLoad type:OrderList_Type_WaitSend];
}

-(void)loadAllOrderlistSucceed{
    orderListArr = [NSMutableArray arrayWithArray:_model.orderList];;
    
    if(isRefresh){
        [_tableView headerEndRefreshing];
    }else{
        [_tableView footerEndRefreshing];
    }
    [_tableView reloadData];
    [_shell setHidden:YES];
}

-(void)loadAllOrderlistFailed:(NSString *)errorMsg{
    if(!errorMsg){
        errorMsg = @"获取数据失败";
    }
    [UtilTool showAlertView:errorMsg];
    
//    [orderListArr removeAllObjects];
//    [_tableView reloadData];
    
    if(isRefresh){
        [_tableView headerEndRefreshing];
    }
    if(!isRefresh){
        [_tableView footerEndRefreshing];
    }
    
    if ([errorMsg isEqualToString:@"没有您要查询的订单"]) {
        [self loadEmptyOrderListView];
    }
}

#pragma mark notification
-(void)userRefundOrder:(id)sender{
}

//申请退款成功
-(void)applyRefundSucceed{
    [self setupRefresh];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

@end
