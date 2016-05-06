//
//  NewUserBalanceVC.m
//  RKWXT
//
//  Created by app on 16/5/4.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "NewUserBalanceVC.h"
#import "BalanceModel.h"
#import "BalanceEntity.h"

#define Size self.view.bounds.size
#define HeadViewHeight (80)

typedef enum{
    UserBalance_XNB,
    UserBalance_Card,
    UserBalance_Invalid,
}UserBalance;

typedef enum{
    BalanceSection_According,
    BalanceSection_TopType,
    BalanceSection_Invalid,
}BalanceSection;

@interface NewUserBalanceVC ()<UITableViewDataSource,UITableViewDelegate,LoadUserBalanceDelegate>
{
    UITableView *_tableView;
    BalanceModel *_model;
}
@end

@implementation NewUserBalanceVC

- (instancetype)init{
    if (self = [super init]) {
        _model = [[BalanceModel alloc]init];
        _model.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     [self setCSTTitle:@"余额/充值"];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setScrollEnabled:NO];
    _tableView.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [_model loadUserBalance];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return BalanceSection_Invalid;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 0;
    switch (section ) {
        case BalanceSection_According:
            row = 2;
            break;
        case BalanceSection_TopType:
            row = 2;
            break;
    }
    return row;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0.0;
    switch (section) {
        case BalanceSection_According:
            height = 10;
            break;
        case BalanceSection_TopType:
            height = 10;
            break;
            
        default:
            break;
    }
    return height;
}


- (WXUITableViewCell*)tableViewFormAccordingCellWithRow:(NSInteger)row{
    WXUITableViewCell *cell = nil;
    WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
    NSString *money = nil;
    if([_model.dataList count] > 0){
        BalanceEntity *entity = [_model.dataList objectAtIndex:0];
        money = [NSString stringWithFormat:@"%.2f元",entity.money];
    }
    if (row == 0) {
        cell = [WXUITableViewCell tableViewCellInitializeWithTableView:_tableView andType:C_CellIsIdentifier_None andIsIdtifier:@"accountCell"];
        cell.textLabel.text = @"账号";
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.imageView.image = [UIImage imageNamed:@"balanceAccount.png"];
        cell.detailTextLabel.text = userDefault.user;
    }else{
        cell = [WXUITableViewCell tableViewCellInitializeWithTableView:_tableView andType:C_CellIsIdentifier_None andIsIdtifier:@"userBalance"];
        cell.textLabel.text = @"余额";
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.imageView.image = [UIImage imageNamed:@"balanceMonery.png"];
        cell.detailTextLabel.text = money;
        cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"f74f35"];
    }
     [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}


- (WXUITableViewCell*)tableViewFormCellWithRow:(NSInteger)row{
    WXUITableViewCell *cell = nil;
    switch (row) {
        case UserBalance_Card:
            cell = [WXUITableViewCell tableViewCellInitializeWithTableView:_tableView andType:C_CellIsIdentifier_None andIsIdtifier:@"Card"];
            cell.textLabel.text = @"话费卡充值";
            cell.textLabel.font = [UIFont systemFontOfSize:15];
             [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_HasNext];
            cell.imageView.image = [UIImage imageNamed:@"balanceCart.png"];
            break;
        case UserBalance_XNB:
            cell = [WXUITableViewCell tableViewCellInitializeWithTableView:_tableView andType:C_CellIsIdentifier_None andIsIdtifier:@"XNB"];
             [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_HasNext];
            cell.textLabel.text = @"云票兑换话费";
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.detailTextLabel.text = @"Hot";
            cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"f74f35"];
            cell.imageView.image = [UIImage imageNamed:@"balancexnb.png"];
            break;
            
        default:
            break;
    }
 
    return cell;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    UITableViewCell *cell = nil;
    
    switch (section) {
        case BalanceSection_According:
            cell = [self tableViewFormAccordingCellWithRow:indexPath.row];
            break;
        case BalanceSection_TopType:
            cell = [self tableViewFormCellWithRow:indexPath.row];
            break;
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == BalanceSection_TopType) {
            switch (row) {
                case UserBalance_Card:
                    [self gotoRecharge];
                    break;
                case UserBalance_XNB:
                    [self gotoXNBRecharge];
                    break;
            }
    }
}

-(void)gotoRecharge{
    [[CoordinateController sharedCoordinateController] toRechargeVC:self animated:YES];
}

- (void)gotoXNBRecharge{
    [[CoordinateController sharedCoordinateController] toXNBRechargeVC:self  animated:YES];
}

- (void)loadUserBalanceSucceed{
    [self unShowWaitView];
    
    [_tableView reloadData];
}

-(void)loadUserBalanceFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    if(!errorMsg){
        errorMsg = @"获取余额失败";
    }
    [UtilTool showAlertView:errorMsg];
}



@end
