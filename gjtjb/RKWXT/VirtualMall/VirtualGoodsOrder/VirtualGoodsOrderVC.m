//
//  VirtualGoodsOrderVC.m
//  RKWXT
//
//  Created by app on 16/4/7.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "VirtualGoodsOrderVC.h"
#import "VirtualGoodsOrderModel.h"
#import "VirtualOrderInfoEntity.h"
#import "MoreMoneyInfoModel.h"
#import "NewUserAddressModel.h"

#import "VirtualOrderNumberCell.h"
#import "VirtualUserInfoCell.h"
#import "VirtualCompanyCell.h"
#import "VirtualGoodsListCell.h"
#import "VirtualPayStatusCell.h"
#import "VirtualPayMoneryCell.h"
#import "VirtualPayXNBCell.h"
#import "VirtualForDateCell.h"
#import "VirtualUserMessageCell.h"
#import "VirtualExchangeListCell.h"
#import "VirtualAllMoneyCell.h"

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

@interface VirtualGoodsOrderVC () <UITableViewDataSource,UITableViewDelegate,VirtualGoodsOrderModelDelegate,VirtualUserMessageCellDelegate,UIAlertViewDelegate>
{
    UITableView *_tableView;
    VirtualGoodsOrderModel *_model;
    
}
@property (nonatomic,strong)NSString *userMessage;
@end

@implementation VirtualGoodsOrderVC

- (instancetype)init{
    if (self = [super init]) {
        _model = [[VirtualGoodsOrderModel alloc]init];
        _model.delegate  = self;
        if (![[MoreMoneyInfoModel shareUserMoreMoneyInfo] isLoaded]) {
             [[MoreMoneyInfoModel shareUserMoreMoneyInfo] loadUserMoreMoneyInfo];
        }
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (_tableView) {
        if ([[NewUserAddressModel shareUserAddress].userAddressArr count] != 0) {
             [_tableView reloadSections:[NSIndexSet indexSetWithIndex:VirtualOrder_Section_UserInfo] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    
    [self addOBS];
}

- (void)addOBS{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadUserMoreMoneyInfo) name:K_Notification_Name_LoadUserMoreMoneyInfoSucceed object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setCSTTitle:@"确认订单"];
    
    [self initTableView];
    
    if (self.orderType == VirtualOrderType_LookOrderStatus) {
       
    }else{
        [self addSubview:[self payTableViewForFootView]];
    }
    
    [self lookUserInfoSite];
}

- (void)lookUserInfoSite{
    if ([[NewUserAddressModel shareUserAddress].userAddressArr count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请添加地址" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
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

- (UIView*)payTableViewForFootView{
    UIView *footView = [[UIView alloc] init];
    CGFloat xOffset = 10;
    CGFloat btnWidth = 75;
    CGFloat btnHeight = 35;
    WXUIButton *payBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    payBtn.frame = CGRectMake(Size.width-xOffset-btnWidth, (DownViewHeight-btnHeight)/2, btnWidth, btnHeight);
    [payBtn setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [payBtn setTitle:@"立即下单" forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payBtn addTarget:self action:@selector(gotoPayVC) forControlEvents:UIControlEventTouchUpInside];
     payBtn.titleLabel.font = WXFont(14.0);
    [footView addSubview:payBtn];

    
    CGFloat labelX = Size.width - 2 *xOffset - btnWidth - 120;
    UILabel *allMonery = [[UILabel alloc]initWithFrame:CGRectMake(labelX, (DownViewHeight-btnHeight)/2, 120, btnHeight)];
    allMonery.textColor = [UIColor redColor];
    allMonery.font = WXFont(14.0);
    [footView addSubview:allMonery];
    
    if (self.type == virtualParOrderType_Store) {
        allMonery.text = [NSString stringWithFormat:@"合计:￥%.2f",self.virtualOrder.postage];
    }else{
        allMonery.text = [NSString stringWithFormat:@"合计:￥%.2f",(self.virtualOrder.postage + self.virtualOrder.goodsPrice)];
    }
    
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
        {
            if (self.orderType == VirtualOrderType_LookOrderStatus) {
                row = 1;
            }else{
                row = 0;
            }
        }
            break;
        case VirtualOrder_Section_ForDate:
        {
            if (self.orderType == VirtualOrderType_LookOrderStatus) {
                row = 1;
            }else{
                row = 0;
            }
        }
            break;
        case VirtualOrder_Section_UserInfo:
        case VirtualOrder_Section_Company:
        case VirtualOrder_Section_GoodsList:
        case VirtualOrder_Section_PayWay:
        case VirtualOrder_Section_UserMessage:
        case VirtualOrder_Section_PayMoney:
        case VirtualOrder_Section_AllMoneyInfo:
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
        case VirtualOrder_Section_AllMoneyInfo:
            height = [VirtualAllMoneyCell cellHeightOfInfo:nil];
            break;
        case VirtualOrder_Section_ForDate:
            height = [VirtualForDateCell cellHeightOfInfo:nil];
            break;
        case VirtualOrder_Section_PayMoney:
        case VirtualOrder_Section_UserMessage:
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
            if (self.orderType == VirtualOrderType_LookOrderStatus) {
                height = 10;
            }else{
                height = 0.0;
            }
            break;
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
    [cell load];
    return cell;
}


//个人信息
- (WXUITableViewCell*)virtualTableViewUsetInfoCell{
    VirtualUserInfoCell *cell = [VirtualUserInfoCell VirtualUserInfoCellWithTabelView:_tableView];
    [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_HasNext];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell load];
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

//商品列表
- (WXUITableViewCell*)virtualTableViewVirtualGoodsListCell{
    VirtualGoodsListCell *cell = [VirtualGoodsListCell VirtualGoodsListCellWithTabelView:_tableView];
    [cell setCellInfo:self.virtualOrder];
    [cell load];
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width - 20);
    return cell;
}

// 商城商品列表
- (WXUITableViewCell*)virtualTableViewVirtualExchangeListCell{
    VirtualExchangeListCell *cell = [VirtualExchangeListCell VirtualExchangeListCellWithTabelView:_tableView];
    [cell setCellInfo:self.virtualOrder];
    [cell load];
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width - 20);
    return cell;
}

//支付方式
- (WXUITableViewCell*)virtualTableViewVirtualPayStatusCell{
    VirtualPayStatusCell *cell = [VirtualPayStatusCell VirtualPayStatusCellWithTabelView:_tableView];
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width - 20);
    return cell;
}

//现金支付
- (WXUITableViewCell*)virtualTableViewVirtualPayMoneryCell{
    VirtualPayMoneryCell *cell = [VirtualPayMoneryCell VirtualPayMoneryCellWithTabelView:_tableView];
    [cell userCanMonery:[MoreMoneyInfoModel shareUserMoreMoneyInfo].userMoneyBalance];
    return cell;
}

//云票支付
- (WXUITableViewCell*)virtualTableViewVirtualPayXNBCell{
    VirtualPayXNBCell *cell = [VirtualPayXNBCell VirtualPayXNBCellWithTabelView:_tableView];
    [cell userCanXNB:[MoreMoneyInfoModel shareUserMoreMoneyInfo].userCloudBalance];
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width - 20);
    return cell;
}

//买家留言
- (WXUITableViewCell*)virtualTableViewVirtualUserMessageCell{
    VirtualUserMessageCell *cell = [VirtualUserMessageCell VirtualUserMessageCellWithTabelView:_tableView];
    cell.delegate = self;
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width - 20);
    return cell;
}

//总价详情
- (WXUITableViewCell*)virtualTableViewVirtualAllMoneyCell{
    VirtualAllMoneyCell *cell = [VirtualAllMoneyCell VirtualAllMoneyCellWithTabelView:_tableView];
    [cell setCellInfo:self.virtualOrder];
    [cell load];
    if (self.type == virtualParOrderType_Store) {
        [cell hidePrice];
    }else{
        [cell hidePriceAddPostage];
    }
    return cell;
}

//下单时间
- (WXUITableViewCell*)virtualTableViewVirtualForDateCell{
    VirtualForDateCell *cell = [VirtualForDateCell VirtualForDateCellWithTabelView:_tableView];
    [cell setCellInfo:self.virtualOrder];
    [cell load];
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
            if (self.type == virtualParOrderType_Store) {
                cell = [self virtualTableViewVirtualGoodsListCell];
            }else{
                cell = [self virtualTableViewVirtualExchangeListCell];
            }
             break;
        case VirtualOrder_Section_PayWay:
             cell = [self virtualTableViewVirtualPayStatusCell];
             break;
        case VirtualOrder_Section_PayMoney:
               cell = [self virtualTableViewVirtualPayXNBCell];
            break;
        case VirtualOrder_Section_UserMessage:
            cell = [self virtualTableViewVirtualUserMessageCell];
            break;
        case VirtualOrder_Section_ForDate:
            cell = [self virtualTableViewVirtualForDateCell];
            break;
        case VirtualOrder_Section_AllMoneyInfo:
            cell = [self virtualTableViewVirtualAllMoneyCell];
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
        default:
            break;
    }
    
}

#pragma mark -- pay
- (void)gotoPayVC{
    if (self.type == virtualParOrderType_Store) {
        [_model submitOrdersVitrtualWithType:VirtualGoodsOrderType_Store orderInfo:self.virtualOrder remark:(self.userMessage.length==0?@"无":self.userMessage)];
    }else{
        [_model submitOrdersVitrtualWithType:VirtualGoodsOrderType_Exchange orderInfo:self.virtualOrder remark:(self.userMessage.length==0?@"无":self.userMessage)];
    }
    [self showWaitViewMode:E_WaiteView_Mode_FullScreenBlock title:@""];
}

- (void)cancelOrder{
    [self.wxNavigationController popViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark --- model deleagte
- (void)virtualGoodsOrderSuccend{
    [self unShowWaitView];
    
    
    //发出通知
    [MoreMoneyInfoModel shareUserMoreMoneyInfo].userCloudBalance -= [VirtualOrderInfoEntity shareVirtualOrderAlloc].xnbPrice;
//    [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_Name_UserCloudTicketChanged object:nil];
    [MoreMoneyInfoModel shareUserMoreMoneyInfo].isChanged = YES;
    
    // 跳转支付页面
    OrderPayVC *payVC = [[OrderPayVC alloc]init];
    payVC.orderID = _model.order.orderID;
    payVC.payMoney = _model.order.payMoney;
    payVC.orderpay_type = OrderPay_Type_Virtual;
    [self.wxNavigationController pushViewController:payVC];
}

- (void)virtualGoodsOrderFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    if(!errorMsg){
        errorMsg = @"下单失败";
    }
    [UtilTool showAlertView:errorMsg];
}

#pragma mark  -
- (void)uploadUserMoreMoneyInfo{
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:VirtualOrder_Section_PayMoney] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark --- cell delegate
- (void)userMessageTextFieldChanged:(NSString *)message{
    self.userMessage = message;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    ManagerAddressVC *addressVC = [[ManagerAddressVC alloc] init];
    [self.wxNavigationController pushViewController:addressVC];
}

@end
