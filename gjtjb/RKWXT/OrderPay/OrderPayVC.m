//
//  OrderPayVC.m
//  RKWXT
//
//  Created by SHB on 15/6/27.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "OrderPayVC.h"
#import "OrderAlipayCell.h"
#import "OrderWechatCell.h"
#import "OrderPayMoneyCell.h"
#import "AliPayControl.h"
#import "PaySucceedModel.h"
#import "WechatPayObj.h"
#import "WechatPayModel.h"
#import "WechatEntity.h"

#define size self.bounds.size

enum{
    OrderPay_Section_Money = 0,
    OrderPay_Section_Alipay,
    OrderPay_Section_Wechat,
    
    OrderPay_Section_Invalid
};

@interface OrderPayVC()<UITableViewDataSource,UITableViewDelegate,WechatPayModelDelegate>{
    UITableView *_tableView;
    WechatPayModel *_model;
    
    BOOL paySucceed;
}
@end

@implementation OrderPayVC

-(id)init{
    self = [super init];
    if(self){
        _model = [[WechatPayModel alloc] init];
        [_model setDelegate:self];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"收银台"];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, size.width, size.height);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [self addOBS];
}

-(void)addOBS{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(alipaySucceed) name:D_Notification_Name_AliPaySucceed object:nil];
    [notificationCenter addObserver:self selector:@selector(wechatPaySucceed) name:D_Notification_Name_WechatPaySucceed object:nil];
    [notificationCenter addObserver:self selector:@selector(wechatPayCancel) name:D_Notification_Name_WechatPayCancel object:nil];
    [notificationCenter addObserver:self selector:@selector(wechatPayFailed) name:D_Notification_Name_WechatPayFailed object:nil];
}

-(void)removeOBS{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return OrderPay_Section_Invalid;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row;
    switch (section) {
        case OrderPay_Section_Money:
            row = 1;
            break;
        case OrderPay_Section_Alipay:
            row = 1;
            break;
        case OrderPay_Section_Wechat:
                row = 1;
            break;
        default:
            break;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0;
    NSInteger section = indexPath.section;
    switch (section) {
        case OrderPay_Section_Money:
            height = OrderPayMoneyCellHeight;
            break;
        case OrderPay_Section_Alipay:
            height = OrderAlipayCellHeight;
            break;
        case OrderPay_Section_Wechat:
            height = OrderWechatCellHeight;
            break;
        default:
            break;
    }
    return height;
}

-(WXUITableViewCell*)tableViewForPayMoneyCell{
    static NSString *identifier = @"payMoneyCell";
    OrderPayMoneyCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[OrderPayMoneyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setCellInfo:[NSNumber numberWithFloat:_payMoney]];
    [cell load];
    return cell;
}

-(WXUITableViewCell*)tableViewForAlipayCell{
    static NSString *identifier = @"alipayCell";
    OrderAlipayCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[OrderAlipayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_HasNext];
    [cell load];
    return cell;
}

-(WXUITableViewCell*)tableViewForWechatCell{
    static NSString *identifier = @"wechatCell";
    OrderWechatCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[OrderWechatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_HasNext];
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    switch (section) {
        case OrderPay_Section_Money:
            cell = [self tableViewForPayMoneyCell];
            break;
        case OrderPay_Section_Alipay:
            cell = [self tableViewForAlipayCell];
            break;
        case OrderPay_Section_Wechat:
            cell = [self tableViewForWechatCell];
            break;
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case OrderPay_Section_Alipay:
            [self alipay];
            break;
        case OrderPay_Section_Wechat:
            [self wechatPay];
            break;
        default:
            break;
    }
}

#pragma mark wechat
-(void)wechatPay{
//    [_model wechatPayWithOrderID:_orderID type:(_orderpay_type==OrderPay_Type_Order ? @"N" : (_orderpay_type==OrderPay_Type_Lucky ? @"P" : @""))];
     [_model wechatPayWithOrderID:_orderID type:[self weixinType]];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

-(NSString*)weixinType{
    NSString *newStr = nil;
    switch (_orderpay_type) {
        case OrderPay_Type_Order:
            newStr = @"N";
            break;
        case OrderPay_Type_Recharge:
            newStr = @"R";
            break;
        case OrderPay_Type_Lucky:
            newStr = @"P";
            break;
        case OrderPay_Type_Virtual:
            newStr = @"E";
            break;
        default:
            break;
    }
    return newStr;
}

-(void)wechatPayLoadSucceed{
    [self unShowWaitView];
    if([_model.wechatArr count] <= 0){
        return;
    }
    WechatEntity *entity = [_model.wechatArr objectAtIndex:0];
    [[WechatPayObj sharedWxPayOBJ] wechatPayWith:entity];
}

-(void)wechatPayLoadFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    if(!errorMsg){
        errorMsg = @"调用微信支付失败";
    }
    [UtilTool showAlertView:errorMsg];
}

//微信支付状态
-(void)wechatPaySucceed{
    [self paySucceedWith:Pay_Type_Weixin];
}

-(void)wechatPayCancel{
    [UtilTool showAlertView:@"支付失败:中途取消"];
}

-(void)wechatPayFailed{
    [UtilTool showAlertView:@"支付失败"];
}

#pragma mark alipay
-(void)alipay{
    if(!_orderID){
        return;
    }
    
    [[AliPayControl sharedAliPayOBJ] alipayOrderID:[self newChangeOrderID] title:kMerchantName amount:_payMoney phpURL:@"" payTag:nil];
}

-(void)alipaySucceed{
    [self paySucceedWith:Pay_Type_AliPay];
}

-(void)paySucceedWith:(Pay_Type)type{
    paySucceed = YES;
    [[PaySucceedModel sharePaySucceed] updataPayOrder:type withOrderID:[self newChangeOrderID]];
    if(_orderpay_type == OrderPay_Type_Recharge){
        [self.wxNavigationController popViewControllerAnimated:YES completion:^{
        }];
        return;
    }
    if(_orderpay_type == OrderPay_Type_Lucky){
        [self toLuckyGoodsOrderList];
        return;
    }
    [self toOrderList];
}

-(void)back{
    if(_orderpay_type == OrderPay_Type_Recharge){
        [self.wxNavigationController popViewControllerAnimated:YES completion:^{
        }];
        return;
    }
    if(_orderpay_type == OrderPay_Type_Lucky){
        [self toLuckyGoodsOrderList];
        return;
    }
    
    if (_orderpay_type == OrderPay_Type_Virtual) {
        [self.wxNavigationController popViewControllerAnimated:YES completion:^{
        }];
        return;
    }
    [self toOrderList];
}

-(void)toLuckyGoodsOrderList{
    WXUINavigationController *navigationController = [CoordinateController sharedNavigationController];
    UIViewController *orderVC = [navigationController lastViewControllerOfClass:NSClassFromString(@"LuckyGoodsOrderList")];
    if(orderVC){
        [navigationController popToViewController:orderVC animated:YES Completion:^{
        }];
    }else{
        [navigationController popToRootViewControllerAnimated:NO Completion:^{
            [[CoordinateController sharedCoordinateController] toLuckyOrderList:navigationController.rootViewController animated:YES];
        }];
    }
}

//去商城订单列表
-(void)toOrderList{
    WXUINavigationController *navigationController = [CoordinateController sharedNavigationController];
    UIViewController *orderVC = [navigationController lastViewControllerOfClass:NSClassFromString(@"WXHomeOrderListVC")];
    if(orderVC){
        [navigationController popToViewController:orderVC animated:YES Completion:^{
        }];
    }else{
        [navigationController popToRootViewControllerAnimated:NO Completion:^{
            [[CoordinateController sharedCoordinateController] toOrderList:navigationController.rootViewController selectedShow:(paySucceed?2:0) animated:YES];
        }];
    }
}

-(NSString*)newChangeOrderID{
    NSString *newStr = nil;
    switch (_orderpay_type) {
        case OrderPay_Type_Order:
            newStr = [NSString stringWithFormat:@"N%@",_orderID];
            break;
        case OrderPay_Type_Recharge:
            newStr = [NSString stringWithFormat:@"%@",_orderID];
            break;
        case OrderPay_Type_Lucky:
            newStr = [NSString stringWithFormat:@"P%@",_orderID];
            break;
        case OrderPay_Type_Virtual:
            newStr = [NSString stringWithFormat:@"%@",_orderID];
            break;
        default:
            break;
    }
    return newStr;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeOBS];
}

@end
