//
//  UserMoneyShowVC.m
//  RKWXT
//
//  Created by SHB on 16/4/6.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "UserMoneyShowVC.h"
#import "UserMoneyInfoListVC.h"
#import "UserMoneyInfoCell.h"
#import "UserMoneyShowCell.h"
#import "UserAliAccountStateCell.h"

#import "ConfirmUserAliPayVC.h"
#import "UserMoneyDrawVC.h"

#import "SearchUserAliAccountModel.h"
#import "UserAliEntity.h"

#import "UserMoneyFormModel.h"
#import "UserMoneyFormEntity.h"

#define Size self.bounds.size
enum{
    Row_UserMoneyShow = 0,
    Row_UserMoneyHistory,
    Row_UserAliAccountState,
    
    Row_UserMoneyInvalid,
};

@interface UserMoneyShowVC()<UITableViewDataSource,UITableViewDelegate,SearchUserAliAccountModelDelegate,UserAliAccountStateCellDelegate,UserMoneyFormModelDelegate>{
    UITableView *_tableView;
    SearchUserAliAccountModel *_model;
    UserAliEntity *entity;
    
    UserMoneyFormModel *_moneyModel;
    UserMoneyFormEntity *_moneyEntity;
}

@end

@implementation UserMoneyShowVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self changeUserWithdrawalsInfoSucceed];
    [self applyAliSucceed];
}

-(id)init{
    self = [super init];
    if(self){
        _model = [[SearchUserAliAccountModel alloc] init];
        [_model setDelegate:self];
        
        _moneyModel = [[UserMoneyFormModel alloc] init];
        [_moneyModel setDelegate:self];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"我的现金"];
    
    [self.view addSubview:[self rightBtn]];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setBackgroundColor:WXColorWithInteger(0xf6f6f6)];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [_model searchUserAliPayAccount];
    [_moneyModel loadUserMoneyFormData];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

-(WXUIButton*)rightBtn{
    CGFloat xgap = 8;
    CGFloat btnWidth = 60;
    CGFloat btnHeight = 16;
    WXUIButton *rightBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(self.bounds.size.width-xgap-btnWidth, 40, btnWidth, btnHeight);
    [rightBtn setBackgroundColor:[UIColor clearColor]];
    [rightBtn setTitle:@"账目明细" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:WXFont(13.0)];
    [rightBtn addTarget:self action:@selector(gotoAccountInfoVC) forControlEvents:UIControlEventTouchUpInside];
    
    return rightBtn;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return Row_UserMoneyInvalid;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = UserMoneyShowCellHeight;
    if(indexPath.row == Row_UserMoneyHistory){
        height = UserMoneyInfoCellHeight;
    }
    if(indexPath.row == Row_UserAliAccountState){
        height = UserAliAccountStateCellHeight;
    }
    return height;
}

//账户提现
-(WXUITableViewCell*)tableViewForUserMoneyShowCell{
    static NSString *identfier = @"userMoneyShowCell";
    UserMoneyShowCell *cell = [_tableView dequeueReusableCellWithIdentifier:identfier];
    if(!cell){
        cell = [[UserMoneyShowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfier];
    }
    [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_HasNext];
    [cell setCellInfo:_moneyEntity];
    [cell load];
    return cell;
}
//提现记录
-(WXUITableViewCell*)tableViewForUserMoneyInfoCell{
    static NSString *identfier = @"userMoneyInfoCell";
    UserMoneyInfoCell *cell = [_tableView dequeueReusableCellWithIdentifier:identfier];
    if(!cell){
        cell = [[UserMoneyInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfier];
    }
    [cell setUserInteractionEnabled:NO];
    [cell setCellInfo:_moneyEntity];
    [cell load];
    return cell;
}
//支付宝状态
-(WXUITableViewCell*)tableViewForAliAccountStateCell{
    static NSString *identfier = @"aliAccountStateCell";
    UserAliAccountStateCell *cell = [_tableView dequeueReusableCellWithIdentifier:identfier];
    if(!cell){
        cell = [[UserAliAccountStateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setCellInfo:entity];
    [cell load];
    [cell setDelegate:self];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    switch (row) {
        case Row_UserMoneyShow:
            cell = [self tableViewForUserMoneyShowCell];
            break;
        case Row_UserMoneyHistory:
            cell = [self tableViewForUserMoneyInfoCell];
            break;
        case Row_UserAliAccountState:
            cell = [self tableViewForAliAccountStateCell];
            break;
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == Row_UserMoneyShow){
        if([_model.userAliAcountArr count] == 0){
            [UtilTool showTipView:@"请先绑定提现账户"];
            return;
        }
        if(_moneyEntity.balance == 0){
            [UtilTool showTipView:@"您没有现金可以提现"];
            return;
        }
        UserMoneyDrawVC *moneyVC = [[UserMoneyDrawVC alloc] init];
        moneyVC.userMoney = _moneyEntity.balance;
        [self.wxNavigationController pushViewController:moneyVC];
    }
}

#pragma mark aliaccount
-(void)searchUserAliPayAccountSucceed{
    [self unShowWaitView];
    if([_model.userAliAcountArr count] > 0){
        entity = [_model.userAliAcountArr objectAtIndex:0];
    }
    [_tableView reloadData];
}

-(void)searchUserAliPayAccountFailed:(NSString *)errorMsg{
    [self unShowWaitView];
}

#pragma mark userMoneyForm
-(void)loadUserMoneyFormDataSucceed{
    [self unShowWaitView];
    if([_moneyModel.moneyFormArr count] > 0){
        _moneyEntity = [_moneyModel.moneyFormArr objectAtIndex:0];
        [_tableView reloadData];
    }
}

-(void)loadUserMoneyFormDataFailed:(NSString *)errorMsg{
    [self unShowWaitView];
}

#pragma mark 提现成功后的通知
-(void)applyAliSucceed{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    CGFloat moneyValue = [userDefaults floatForKey:UserApplyMoneySucceed];
    
    if(moneyValue > 0){
        [UtilTool showAlertView:@"申请提现成功，系统将自动转到您的支付宝账户，请注意查收"];
        _moneyEntity.balance -= moneyValue;
        _moneyEntity.onGoingMoney += moneyValue;
        [_tableView reloadData];
    }
}

#pragma mark 添加或修改支付宝成功
-(void)changeUserWithdrawalsInfoSucceed{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults boolForKey:ConfirmSign]){
        entity = [[UserAliEntity alloc] init];
        entity.userali_type = UserAliCount_Type_Submit;
        [_tableView reloadData];
    }
}

#pragma mark nextPage
-(void)gotoAccountInfoVC{
    UserMoneyInfoListVC *moneyVC = [[UserMoneyInfoListVC alloc] init];
    [self.wxNavigationController pushViewController:moneyVC];
}

-(void)userSubmitAliAccountBtnClicked:(id)sender{
    UserAliEntity *ent = sender;
    if(ent && ent.userali_type == UserAliCount_Type_Failed){
        ConfirmUserAliPayVC *comfirmVC = [[ConfirmUserAliPayVC alloc] init];
        comfirmVC.titleString = @"验证信息";
        comfirmVC.aliAcount = ent.aliCount;
        comfirmVC.userName = ent.aliName;
        comfirmVC.confirmType = Confirm_Type_Change;
        [self.wxNavigationController pushViewController:comfirmVC];
    }
    if(!ent){
        ConfirmUserAliPayVC *comfirmVC = [[ConfirmUserAliPayVC alloc] init];
        comfirmVC.titleString = @"验证信息";
        [self.wxNavigationController pushViewController:comfirmVC];
    }
    if(ent && ent.userali_type == UserAliCount_Type_Succeed){
        ConfirmUserAliPayVC *comfirmVC = [[ConfirmUserAliPayVC alloc] init];
        comfirmVC.titleString = @"修改账户信息";
        comfirmVC.aliAcount = ent.aliCount;
        comfirmVC.userName = ent.aliName;
        [self.wxNavigationController pushViewController:comfirmVC];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:NO forKey:ConfirmSign];
    [userDefaults setFloat:0 forKey:UserApplyMoneySucceed];
}

@end
