//
//  RechargeVC.m
//  RKWXT
//
//  Created by SHB on 15/3/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "RechargeVC.h"
#import "RechargeCell.h"
#import "RechargeView.h"
#import "BalancePhoneCell.h"
#import "BalancePasWordCell.h"
#import "BalanceAccountCell.h"

#import "RechargeModel.h"

#define Size self.bounds.size
#define HeadViewHeight (80)
#define kAnimatedDur (0.7)

enum{
    WXT_Rechagre_Phone,
    WXT_Rechagre_Account,
    WXT_Rechagre_Invalid,
}WXT_Rechagre;

@interface RechargeVC()<UITableViewDataSource,UITableViewDelegate,BalancePhoneCellDelegate,BalanceAccountCellDelegate,BalancePasWordCellDelegate,RechargeDelegate>{
    UITableView *_tableView;
    RechargeView *_rechargeView;
    RechargeModel *_model;
    WXUITextField *_textField;
    
    NSString *_phone;
    NSString *_account;
    NSString *_pasWord;
}
@end

@implementation RechargeVC

- (instancetype)init{
    if (self = [super init]) {
        _phone = @"";
        _model = [[RechargeModel alloc]init];
        _model.delegate = self;
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setScrollEnabled:NO];
    _tableView.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[self tableFootView]];
    
//    _rechargeView = [[RechargeView alloc] init];
//    
//    WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
//    _rechargeView.rechargeUserphoneStr = userDefault.user;
//    [self addSubview:_rechargeView];
//    
//    [_rechargeView setFrame:CGRectMake(0, ViewNormalDistance, Size.width, RechargeViewHeight)];

}

- (UIView*)tableFootView{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Size.width, 100)];
    footView.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(13, 60, Size.width-2*13, 40);
    [okBtn setBorderRadian:6.0 width:1.0 color:[UIColor clearColor]];
    [okBtn setBackgroundColor:WXColorWithInteger(AllBaseColor)];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn setTitleColor:WXColorWithInteger(0xffffff) forState:UIControlStateNormal];
    [okBtn setTitleColor:WXColorWithInteger(0xffffff) forState:UIControlStateSelected];
    [okBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:okBtn];
    
    return footView;
}

-(void)textFieldDone:(id)sender{
    [_textField resignFirstResponder];
}

-(void)textFieldChange{
    _rechargeView.rechargeUserphoneStr = _textField.text;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return WXT_Rechagre_Invalid;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 0;
    switch (section) {
        case WXT_Rechagre_Phone:
            row = 1;
            break;
        case WXT_Rechagre_Account:
            row = 2;
            break;
        default:
            break;
    }
    return row;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (WXUITableViewCell*)tableViewFormPhoneCell{
    BalancePhoneCell *cell = [BalancePhoneCell tableViewCellInitializeWithTableView:_tableView andType:C_CellIsIdentifier_CreateCell andIsIdtifier:@"BalancePhoneCell"];
    cell.delegate = self;
    return cell;
}

- (WXUITableViewCell*)tableViewFormAccountCell{
    BalanceAccountCell *cell = [BalanceAccountCell tableViewCellInitializeWithTableView:_tableView andType:C_CellIsIdentifier_CreateCell andIsIdtifier:@"BalanceAccountCell"];
    cell.delegate = self;
    return cell;
}

- (WXUITableViewCell*)tableViewFormPassWordCell{
    BalancePasWordCell *cell = [BalancePasWordCell tableViewCellInitializeWithTableView:_tableView andType:C_CellIsIdentifier_CreateCell andIsIdtifier:@"BalancePasWordCell"];
    cell.delegate = self;
    return cell;
}


-(UITableViewCell*)tableForRechargeCell{
    static NSString *identifier = @"rechargeCell";
    RechargeCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[RechargeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell load];
    return cell;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    switch (section) {
        case WXT_Rechagre_Phone:
            cell = [self tableViewFormPhoneCell];
            break;
        case WXT_Rechagre_Account:
            if (indexPath.row == 0) {
                cell = [self tableViewFormAccountCell];
            }else{
                 cell = [self tableViewFormPassWordCell];
            }
            break;
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)textFiledPhoneValueDidChanged:(NSString *)text{
    _phone = text;
}

- (void)accountTextFiledPhoneValueDidChanged:(NSString *)text{
    _account = text;
}

- (void)passWordTextFiledPhoneValueDidChanged:(NSString *)text{
    _pasWord = text;
    
    [_tableView setContentOffset:CGPointMake(0, 64) animated:YES];
    
}


- (void)submit{
    [self.view endEditing:YES];
    _phone = [_phone isEqualToString:@""] ? [WXTUserOBJ sharedUserOBJ].user : _phone;
    if (![UtilTool isValidateMobile:_phone]) {
        [UtilTool showAlertView:@"请输入正确的手机号"];
        return;
    }
    if(_account.length < 1 || _pasWord.length < 1){
        [UtilTool showAlertView:@"帐号或密码格式错误"];
        return;
    }
    
    [_model rechargeWithCardNum:_account andPwd:_pasWord phone:_phone];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

-(void)rechargeSucceed{
    [self unShowWaitView];
    
    [UtilTool showAlertView:@"充值成功"];
}

-(void)rechargeFailed:(NSString*)errorMsg{
    [self unShowWaitView];
    if(!errorMsg){
        [UtilTool showAlertView:@"充值失败"];
        return;
    }
    [UtilTool showAlertView:errorMsg];
}

@end
