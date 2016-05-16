//
//  XNBRechangeVC.m
//  RKWXT
//
//  Created by app on 16/5/4.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "XNBRechangeVC.h"
#import "XNBBalanceModel.h"
#import "XNBBalancePhoneCell.h"
#import "XNBCartInfoCell.h"
#import "XNBBalanceEntity.h"
#import "XNBOrderEntity.h"

#import "OrderPayVC.h"
#import "MoreMoneyInfoModel.h"

#define Size self.view.bounds.size
#define FootHeight (150)

typedef enum{
    XNBSection_XNB,
    XNBSection_Cart,
    XNBSection_Invalid,
}XNBSection;

@interface XNBRechangeVC ()<UITableViewDataSource,UITableViewDelegate,XNBBalancePhoneCellDelegate,XNBBalanceModelDlegatge,XNBCartInfoCellDelegate>
{
    UITableView *_tableView;
    NSString *_changePhone;
    XNBBalanceModel *_model;
    UIButton *_btn;
    NSInteger _key;
    int _xnb;
    UILabel *_customLabel;
    UIView *_didView;
    NSTimer *_timer;
}
@end

@implementation XNBRechangeVC

- (instancetype)init{
    if (self = [super init]) {
        _changePhone = @"";
        _model = [[XNBBalanceModel alloc]init];
        _model.delegate = self;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_model requestLoadCartInfo];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setScrollEnabled:NO];
    _tableView.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[self tabaleViewFootView]];
}

- (UIView*)tabaleViewFootView{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Size.width, FootHeight)];
    footView.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    
    CGFloat btnY = 55;
    CGFloat btnX = 25;
    CGFloat btnH = 40;
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.frame = CGRectMake(btnX, btnY,Size.width - btnX *2 , btnH);
    [_btn setTitle:@"去支付" forState:UIControlStateNormal];
    [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btn.backgroundColor = [UIColor colorWithHexString:@"f74f35"];
    [_btn setBorderRadian:5 width:0 color:[UIColor clearColor]];
    [_btn addTarget:self action:@selector(gotoParOrder) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:_btn];
    
    CGFloat labelX = 40;
    btnY += btnH + 25;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(labelX, btnY,58,60)];
    label.text = @"温馨提示:\n   ";
    label.font = [UIFont systemFontOfSize:12];
    label.numberOfLines = 2;
    [footView  addSubview:label];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(label.right, btnY, Size.width - labelX * 2 - 58, 60)];
    label1.numberOfLines = 2;
    label1.text =@"充值卡以及云票充值话费只限充值\n到“我信云商”话费余额";
    label1.textAlignment = NSTextAlignmentLeft;
    label1.font = [UIFont systemFontOfSize:12];
    [footView  addSubview:label1];
    
    return footView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return XNBSection_Invalid;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 0;
    switch (section) {
        case XNBSection_XNB:
            row = 2;
            break;
        case XNBSection_Cart:
            row = 1;
            break;
    }
    return row;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == XNBSection_Cart) {
        return [XNBCartInfoCell cellHeightOfInfo:_model.cartArray];
    }else{
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (WXUITableViewCell*)tableViewXNBBalanceCell{
   WXUITableViewCell *cell = [WXUITableViewCell tableViewCellInitializeWithTableView:_tableView andType:C_CellIsIdentifier_None andIsIdtifier:@"accountCell"];
    if (_model.cartArray.count != 0) {
         XNBBalanceEntity *entity = _model.cartArray[0];
        cell.textLabel.text = [NSString stringWithFormat:@"云票余额:  %d云票", entity.xnbBalnce];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.imageView.image = [UIImage imageNamed:@"xnbRemaining.png"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (WXUITableViewCell*)tableViewUserPhoneBalanceCell{
    XNBBalancePhoneCell *cell = [XNBBalancePhoneCell tableViewCellInitializeWithTableView:_tableView andType:C_CellIsIdentifier_CreateCell andIsIdtifier:@"XNBBalancePhoneCell"];
    cell.delegate = self;
    cell.imageView.image = [UIImage imageNamed:@"balanceAccount.png"];
    cell.textLabel.text = @"充值账号:";
    cell.textLabel.font = WXFont(15.0);
    return cell;
}

- (WXUITableViewCell*)tableViewCartInfoCell{
    XNBCartInfoCell *infoCell = [XNBCartInfoCell tableViewCellInitializeWithTableView:_tableView andType:C_CellIsIdentifier_CreateCell andIsIdtifier:@"XNBCartInfoCell"];
    if (_model.cartArray.count != 0) {
        infoCell.height = [XNBCartInfoCell cellHeightOfInfo:_model.cartArray];
       [infoCell setCellInfo:_model.cartArray];
    }
    infoCell.delegate = self;
    return infoCell;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (section) {
        case XNBSection_XNB:
            if (row == 0) {
                cell = [self tableViewXNBBalanceCell];
            }else{
                cell = [self tableViewUserPhoneBalanceCell];
            }
            break;
          case XNBSection_Cart:
            cell = [self tableViewCartInfoCell];
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    
}

- (void)textFiledPhoneValueDidChanged:(NSString *)text{
    _changePhone = text;
}

- (void)clickBtnCartInfoWithIndex:(NSInteger)index{
    [self.view  endEditing:YES];
    _key = index;
    XNBBalanceEntity *entity = _model.cartArray[index];
    _xnb = entity.xnb;
    [_btn setTitle:[NSString stringWithFormat:@"去支付（￥%d.00）",entity.rmb] forState:UIControlStateNormal];
}

- (void)loadXNBUserBalanceFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    
    [UtilTool showRoundView:errorMsg];
}

- (void)loadXNBUserBalanceSucceed{
    [self unShowWaitView];
    
    [_tableView reloadData];
}

- (void)gotoParOrder{
    WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
    NSString *phone = [_changePhone isEqualToString:@""] ? userDefault.user : _changePhone;
    if ([UtilTool isValidateMobile:phone]) {
        [_model balanceSubmitOrdersWithKey:_key phone:phone];
        [self showWaitViewMode:E_WaiteView_Mode_FullScreenBlock title:@"正在提交订单"];
    }else{
        [UtilTool showAlertView:@"请输入正确的手机号"];
    }
}

- (void)balanceSubmitOrderSucceed{
    [self unShowWaitView];
    
    //发出通知
    [MoreMoneyInfoModel shareUserMoreMoneyInfo].userCloudBalance -= _xnb;
    [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_Name_UserCloudTicketChanged object:nil];
    [MoreMoneyInfoModel shareUserMoreMoneyInfo].isChanged = YES;
    
    // 跳转支付页面
    OrderPayVC *payVC = [[OrderPayVC alloc]init];
    payVC.orderID = _model.order.orderID;
    payVC.payMoney = _model.order.price;
    payVC.orderpay_type = OrderPay_Type_Recharge;
    [self.wxNavigationController pushViewController:payVC];
}

- (void)balanceSubmitOrderFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    
    [self customView:errorMsg];
}

- (void)customView:(NSString*)error{
    CGFloat width = 12;
    CGSize size = [NSString sizeWithString:error font:[UIFont systemFontOfSize:14]];
    CGFloat X = (self.view.frame.size.width - size.width - 20) / 2;
    CGFloat Y = (_btn.top - size.height - width) / 2;
    _customLabel = [[UILabel alloc]initWithFrame:CGRectMake(X, Y, size.width + 20, size.height + width)];
    _customLabel.text = error;
    _customLabel.textAlignment =NSTextAlignmentCenter;
    _customLabel.backgroundColor = [UIColor grayColor];
    _customLabel.textColor = [UIColor whiteColor];
    _customLabel.font = WXFont(14);
    [_customLabel setBorderRadian:5 width:0 color:[UIColor clearColor]];
    [_tableView.tableFooterView addSubview:_customLabel];
    
    
    _didView = [[UIView alloc]initWithFrame:self.view.bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:_didView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickScreen:)];
    [_didView addGestureRecognizer:tap];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)timer:(NSTimer*)time{
    [_customLabel removeFromSuperview];
    [_didView removeFromSuperview];
    [time invalidate];
}

- (void)clickScreen:(UITapGestureRecognizer*)tap{
    [tap.view removeFromSuperview];
    [_timer invalidate];
    [_customLabel removeFromSuperview];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_timer invalidate];
}

@end
