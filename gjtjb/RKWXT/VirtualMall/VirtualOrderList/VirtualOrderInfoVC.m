//
//  VirtualOrderInfoVC.m
//  RKWXT
//
//  Created by app on 16/4/11.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "VirtualOrderInfoVC.h"
#import "VirtualOrderListModel.h"
#import "virtualOrderListEntity.h"
#import "MoreMoneyInfoModel.h"

#import "VirtualOrderNumberCell.h"
#import "VirtualUserInfoCell.h"
#import "VirtualCompanyCell.h"
#import "VirtualGoodsListCell.h"
#import "VirtualPayStatusCell.h"
#import "VirtualPayMoneryCell.h"
#import "VirtualPayXNBCell.h"
#import "VirtualOrderDateCell.h"
#import "VirtualOrderUserMessageCell.h"
#import "VirtualOrderGoodsCell.h"
#import "VirtualOrderAllMoneyCell.h"

#import "ManagerAddressVC.h"
#import "OrderPayVC.h"


enum{
    VirtualOrder_Section_Number = 0,
    VirtualOrder_Section_UserInfo,
    VirtualOrder_Section_Company,
    VirtualOrder_Section_GoodsList,
    VirtualOrder_Section_PayWay,
    VirtualOrder_Section_PayMoney,
    VirtualOrder_Section_UserMessage,
    VirtualOrder_Section_AllMoneyInfo,
    VirtualOrder_Section_ForDate,
    
    VirtualOrder_Section_Invalid,
};

#define Size self.bounds.size
#define DownViewHeight 55

@interface VirtualOrderInfoVC () <UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    VirtualOrderListModel *_model;
    MoreMoneyInfoModel *_xnbModel;
    
}
@end

@implementation VirtualOrderInfoVC

- (instancetype)init{
    if (self = [super init]) {
        _model = [[VirtualOrderListModel alloc]init];
        if ([[MoreMoneyInfoModel shareUserMoreMoneyInfo] isLoaded]) {
            _xnbModel = [MoreMoneyInfoModel shareUserMoreMoneyInfo];
        }
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_tableView) {
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:VirtualOrder_Section_UserInfo] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)addOBS{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelOrderFailure) name:V_Notification_Name_CancelVirtualOrderFailure object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelOrderSuccend) name:V_Notification_Name_CancelVirtualOrderSuccend object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setCSTTitle:@"订单详情"];
    
    [self initTableView];
    
    [self addSubview: self.isAppearPay  ? [self tableViewForFootView] : [[UIView alloc] initWithFrame:CGRectZero]];

    [self addOBS];
}

- (void)dealloc{
     [self removeaddOBS];
}

- (void)removeaddOBS{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
    [payBtn setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [payBtn setTitle:@"去支付" forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    payBtn.titleLabel.font = WXFont(14.0);
    [payBtn addTarget:self action:@selector(gotoPayVC) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:payBtn];
    
    WXUIButton *cancelBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(Size.width-xOffset * 2-btnWidth * 2, (DownViewHeight-btnHeight)/2, btnWidth, btnHeight);
    [cancelBtn setBackgroundColor:RGB_COLOR(213, 213, 213)];
    [cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.titleLabel.font = WXFont(14.0);
    [footView addSubview:cancelBtn];
    
    UIView *marView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Size.width, 0.5)];
    marView.backgroundColor = RGB_COLOR(210, 210, 210);
    [footView addSubview:marView];
    
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
        case VirtualOrder_Section_ForDate:
        case VirtualOrder_Section_UserInfo:
        case VirtualOrder_Section_Company:
        case VirtualOrder_Section_GoodsList:
        case VirtualOrder_Section_PayWay:
        case VirtualOrder_Section_PayMoney:
        case VirtualOrder_Section_AllMoneyInfo:
            row = 1;
            break;
        case VirtualOrder_Section_UserMessage:
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
        case VirtualOrder_Section_PayMoney:
        case VirtualOrder_Section_UserMessage:
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
        case VirtualOrder_Section_AllMoneyInfo:
            height = [VirtualOrderAllMoneyCell cellHeightOfInfo:nil];
            break;
        case VirtualOrder_Section_ForDate:
            height = [VirtualOrderDateCell cellHeightOfInfo:nil];
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
        case VirtualOrder_Section_Company:
        case VirtualOrder_Section_PayWay:
        case VirtualOrder_Section_PayMoney:
        case VirtualOrder_Section_UserMessage:
            height = 7;
            break;
        case VirtualOrder_Section_GoodsList:
        case VirtualOrder_Section_ForDate:
        case VirtualOrder_Section_AllMoneyInfo:
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
    [cell setCellInfo:self.entity];
    [cell load];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width - 20);

    return cell;
}


//个人信息
- (WXUITableViewCell*)virtualTableViewUsetInfoCell{
    VirtualUserInfoCell *cell = [VirtualUserInfoCell VirtualUserInfoCellWithTabelView:_tableView];
    [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_HasNext];
    [cell load];
     [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width - 20);

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

// 商城商品列表
- (WXUITableViewCell*)virtualTableViewVirtualOrderListCell{
    VirtualOrderGoodsCell *cell = [VirtualOrderGoodsCell VirtualOrderGoodsCellWithTabelView:_tableView];
    [cell setCellInfo:self.entity];
    [cell load];
     [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width - 20);
    return cell;
}

//支付方式
- (WXUITableViewCell*)virtualTableViewVirtualPayStatusCell{
    VirtualPayStatusCell *cell = [VirtualPayStatusCell VirtualPayStatusCellWithTabelView:_tableView];
     [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width - 20);
    return cell;
}

//现金支付
- (WXUITableViewCell*)virtualTableViewVirtualPayMoneryCell{
    VirtualPayMoneryCell *cell = [VirtualPayMoneryCell VirtualPayMoneryCellWithTabelView:_tableView];
    [cell userCanMonery:_xnbModel.userMoneyBalance];
     [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width - 20);
    return cell;
}

//云票支付
- (WXUITableViewCell*)virtualTableViewVirtualPayXNBCell{
    VirtualPayXNBCell *cell = [VirtualPayXNBCell VirtualPayXNBCellWithTabelView:_tableView];
    [cell userCanXNB:_xnbModel.userCloudBalance];
     [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width - 20);
    return cell;
}

//买家留言
- (WXUITableViewCell*)virtualTableViewVirtualOrderUserMessageCell{
    VirtualOrderUserMessageCell *cell = [VirtualOrderUserMessageCell VirtualOrderUserMessageCellWithTabelView:_tableView];
    [cell setCellInfo:self.entity.userMessage];
    [cell load];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width - 20);
    return cell;
}

//总价详情
- (WXUITableViewCell*)virtualTableViewVirtualOrderAllMoneyCell{
    VirtualOrderAllMoneyCell *cell = [VirtualOrderAllMoneyCell VirtualOrderAllMoneyCellWithTabelView:_tableView];
    [cell setCellInfo:self.entity];
    [cell load];
     [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

//下单时间
- (WXUITableViewCell*)virtualTableViewVirtualOrderDateCell{
    VirtualOrderDateCell *cell = [VirtualOrderDateCell VirtualOrderDateCellWithTabelView:_tableView];
    [cell setCellInfo:self.entity];
    [cell load];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
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
            cell = [self virtualTableViewVirtualOrderListCell];
            break;
        case VirtualOrder_Section_PayWay:
            cell = [self virtualTableViewVirtualPayStatusCell];
            break;
        case VirtualOrder_Section_PayMoney:
            cell = [self virtualTableViewVirtualPayXNBCell];
            break;
        case VirtualOrder_Section_UserMessage:
            cell = [self virtualTableViewVirtualOrderUserMessageCell];
            break;
        case VirtualOrder_Section_ForDate:
            cell = [self virtualTableViewVirtualOrderDateCell];
            break;
        case VirtualOrder_Section_AllMoneyInfo:
            cell = [self virtualTableViewVirtualOrderAllMoneyCell];
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
}

#pragma mark -- pay
- (void)cancelOrder{
    [_model cancelOrderIDWith:self.entity.order_id];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

#pragma mark --- model deleagte

- (void)gotoPayVC{
    // 跳转支付页面
    OrderPayVC *payVC = [[OrderPayVC alloc]init];
    payVC.orderID = [NSString stringWithFormat:@"%@%d",self.entity.orderPrefix,self.entity.order_id];
    payVC.payMoney = self.entity.monery;
    payVC.orderpay_type = OrderPay_Type_Virtual;
    [self.wxNavigationController pushViewController:payVC];
}

#pragma mark -- 通知
- (void)cancelOrderFailure{
    [self unShowWaitView];
    [UtilTool showAlertView:@"订单取消失败"];
}

- (void)cancelOrderSuccend{
    [self unShowWaitView];
    [UtilTool showAlertView:@"订单取消成功"];
    [self.wxNavigationController popViewControllerAnimated:YES completion:^{
    }];
    
    [MoreMoneyInfoModel shareUserMoreMoneyInfo].userCloudBalance += self.entity.xnb;
    [MoreMoneyInfoModel shareUserMoreMoneyInfo].isChanged = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_Name_UserCloudTicketChanged object:nil];
}

#pragma mark -- userMessage
















@end
