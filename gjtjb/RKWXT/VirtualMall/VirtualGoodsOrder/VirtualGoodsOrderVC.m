//
//  VirtualGoodsOrderVC.m
//  RKWXT
//
//  Created by app on 16/4/7.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "VirtualGoodsOrderVC.h"
#import "VirtualGoodsOrderModel.h"

#import "VirtualOrderNumberCell.h"
#import "VirtualUserInfoCell.h"
#import "VirtualCompanyCell.h"
#import "VirtualGoodsListCell.h"
#import "VirtualPayStatusCell.h"
#import "VirtualAllMoneyCell.h"
#import "VirtualForDateCell.h"


#import "ManagerAddressVC.h"

enum{
    VirtualOrder_Section_Number = 0,
    VirtualOrder_Section_UserInfo,
    VirtualOrder_Section_Company,
    VirtualOrder_Section_GoodsList,
    VirtualOrder_Section_PayWay,
    VirtualOrder_Section_PayMoney,
    VirtualOrder_Section_ForDate,
    
    VirtualOrder_Section_Invalid,
};

#define Size self.bounds.size
#define DownViewHeight 55

@interface VirtualGoodsOrderVC () <UITableViewDataSource,UITableViewDelegate,VirtualGoodsOrderModelDelegate>
{
    UITableView *_tableView;
    VirtualGoodsOrderModel *_model;
}
@end

@implementation VirtualGoodsOrderVC

- (instancetype)init{
    if (self = [super init]) {
        _model = [[VirtualGoodsOrderModel alloc]init];
        _model.delegate  = self;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_tableView) {
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:VirtualOrder_Section_UserInfo] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setCSTTitle:@"下单"];
    
    [self initTableView];
    
    [self addSubview:[self tableViewForFootView]];
}

- (void)initTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Size.width, Size.height - DownViewHeight) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self addSubview:_tableView];
}

-(UIView*)tableViewForFootView{
    UIView *footView = [[UIView alloc] init];
    CGFloat xOffset = 10;
    CGFloat btnWidth = 75;
    CGFloat btnHeight = 35;
    WXUIButton *payBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    payBtn.frame = CGRectMake(Size.width-xOffset-btnWidth, (DownViewHeight-btnHeight)/2, btnWidth, btnHeight);
    [payBtn setBorderRadian:2.0 width:0.5 color:WXColorWithInteger(0xdd2726)];
    [payBtn setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [payBtn setTitle:@"去支付" forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payBtn addTarget:self action:@selector(gotoPayVC) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:payBtn];
    
    footView.frame = CGRectMake(0, Size.height-DownViewHeight, Size.width, DownViewHeight);
    return footView;
}

#pragma mark   --   Tableview
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return VirtualOrder_Section_Invalid;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row;
    switch (section) {
        case VirtualOrder_Section_Number:
        case VirtualOrder_Section_UserInfo:
        case VirtualOrder_Section_Company:
        case VirtualOrder_Section_GoodsList:
        case VirtualOrder_Section_PayWay:
        case VirtualOrder_Section_PayMoney:
        case VirtualOrder_Section_ForDate:
            row = 1;
            break;
            
        default:
            break;
    }
    return row;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0;
    NSInteger section = indexPath.section;
    switch (section) {
        case VirtualOrder_Section_Number:
            height = 44;
            break;
        case VirtualOrder_Section_UserInfo:
            height = [VirtualUserInfoCell cellHeightOfInfo:nil];
            break;
        case VirtualOrder_Section_Company:
            height = [VirtualCompanyCell cellHeightOfInfo:nil];
            break;
        case VirtualOrder_Section_GoodsList:
            height = [VirtualGoodsListCell cellHeightOfInfo:nil];
            break;
        case VirtualOrder_Section_PayWay:
            height = [VirtualPayStatusCell cellHeightOfInfo:nil];
            break;
        case VirtualOrder_Section_PayMoney:
        case VirtualOrder_Section_ForDate:
            height = 44;
            break;
            
        default:
            break;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0.0;
    switch (section) {
        case VirtualOrder_Section_UserInfo:
            height = 10;
            break;
        case VirtualOrder_Section_Company:
            height = 10;
            break;
        case VirtualOrder_Section_PayWay:
            height = 20;
            break;
        case VirtualOrder_Section_GoodsList:
        case VirtualOrder_Section_PayMoney:
        case VirtualOrder_Section_ForDate:
            height = 0.0;
            break;
            
        default:
            break;
    }
    return height;
}

//订单号
- (WXUITableViewCell*)virtualTableViewVirtualOrderNumberCell{
    VirtualOrderNumberCell *cell = [VirtualOrderNumberCell VirtualOrderNumberCellWithTabelView:_tableView];
    [cell load];
    return cell;
}


//个人信息
- (WXUITableViewCell*)virtualTableViewUsetInfoCell{
    VirtualUserInfoCell *cell = [VirtualUserInfoCell VirtualUserInfoCellWithTabelView:_tableView];
    [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_HasNext];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell load];
    return cell;
}


//公司名称
- (WXUITableViewCell*)virtualTableViewVirtualCompanyCell{
    VirtualCompanyCell *cell = [VirtualCompanyCell VirtualCompanyCellWithTabelView:_tableView];
    [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_HasNext];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell load];
    return cell;
}

//商品列表
- (WXUITableViewCell*)virtualTableViewVirtualGoodsListCell{
    VirtualGoodsListCell *cell = [VirtualGoodsListCell VirtualGoodsListCellWithTabelView:_tableView];
    [cell setCellInfo:self.goodsList];
    [cell load];
    return cell;
}
//支付方式
- (WXUITableViewCell*)virtualTableViewVirtualPayStatusCell{
    VirtualPayStatusCell *cell = [VirtualPayStatusCell VirtualPayStatusCellWithTabelView:_tableView];
    return cell;
}
//总价
- (WXUITableViewCell*)virtualTableViewVirtualAllMoneyCell{
    VirtualAllMoneyCell *cell = [VirtualAllMoneyCell VirtualAllMoneyCellWithTabelView:_tableView];
    return cell;
}
//下单时间
- (WXUITableViewCell*)virtualTableViewVirtualForDateCell{
    VirtualForDateCell *cell = [VirtualForDateCell VirtualForDateCellWithTabelView:_tableView];
    return cell;
}

- (WXUITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WXUITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    switch (section) {
        case VirtualOrder_Section_Number:
            cell = [self virtualTableViewVirtualOrderNumberCell];
            break;
        case VirtualOrder_Section_UserInfo:
            cell = [self virtualTableViewUsetInfoCell];
             break;
        case VirtualOrder_Section_Company:
             cell = [self virtualTableViewVirtualCompanyCell];
             break;
        case VirtualOrder_Section_GoodsList:
             cell = [self virtualTableViewVirtualGoodsListCell];
             break;
        case VirtualOrder_Section_PayWay:
             cell = [self virtualTableViewVirtualPayStatusCell];
             break;
        case VirtualOrder_Section_PayMoney:
             cell = [self virtualTableViewVirtualAllMoneyCell];
             break;
        case VirtualOrder_Section_ForDate:
            cell = [self virtualTableViewVirtualForDateCell];
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    switch (section) {
        case VirtualOrder_Section_UserInfo:
        {
            ManagerAddressVC *addressVC = [[ManagerAddressVC alloc] init];
            [self.wxNavigationController pushViewController:addressVC];
        }
            break;
//        case VirtualOrder_Section_Company:
//            cell = [self virtualTableViewVirtualCompanyCell];
//            break;
//        case VirtualOrder_Section_GoodsList:
//            cell = [self virtualTableViewVirtualGoodsListCell];
//            break;
//        case VirtualOrder_Section_PayWay:
//            cell = [self virtualTableViewVirtualPayStatusCell];
//            break;
//        case VirtualOrder_Section_PayMoney:
//            cell = [self virtualTableViewVirtualAllMoneyCell];
//            break;
//        case VirtualOrder_Section_ForDate:
//            cell = [self virtualTableViewVirtualForDateCell];
//            break;
        default:
            break;
    }
    
}

#pragma mark -- pay
- (void)gotoPayVC{
//    [_model submitOrdersVitrtualWithType:VirtualGoodsOrderType_Store goodsInfo:];
}


#pragma mark --- model deleagte
- (void)virtualGoodsOrderSuccend{
    [self unShowWaitView];
    
}

- (void)virtualGoodsOrderFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    if(!errorMsg){
        errorMsg = @"下单失败";
    }
    [UtilTool showAlertView:errorMsg];
}


@end
