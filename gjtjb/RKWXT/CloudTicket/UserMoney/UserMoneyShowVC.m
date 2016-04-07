//
//  UserMoneyShowVC.m
//  RKWXT
//
//  Created by SHB on 16/4/6.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "UserMoneyShowVC.h"
#import "CloudTicketListVC.h"
#import "UserMoneyInfoCell.h"
#import "UserMoneyShowCell.h"

#import "ConfirmUserAliPayVC.h"
#import "UserMoneyDrawVC.h"

#import "SearchUserAliAccountModel.h"
#import "UserAliEntity.h"

#define Size self.bounds.size

@interface UserMoneyShowVC()<UITableViewDataSource,UITableViewDelegate,SearchUserAliAccountModelDelegate>{
    UITableView *_tableView;
    SearchUserAliAccountModel *_model;
    UserAliEntity *entity;
}

@end

@implementation UserMoneyShowVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self changeUserWithdrawalsInfoSucceed];
}

-(id)init{
    self = [super init];
    if(self){
        _model = [[SearchUserAliAccountModel alloc] init];
        [_model setDelegate:self];
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
    [_tableView setTableFooterView:[self createFooterView]];
    
    [_model searchUserAliPayAccount];
}

-(WXUIButton*)rightBtn{
    CGFloat xgap = 8;
    CGFloat btnWidth = 70;
    CGFloat btnHeight = 16;
    WXUIButton *rightBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(self.bounds.size.width-xgap-btnWidth, 35, btnWidth, btnHeight);
    [rightBtn setBackgroundColor:[UIColor clearColor]];
    [rightBtn setTitle:@"账目明细" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:WXFont(13.0)];
    [rightBtn addTarget:self action:@selector(gotoAccountInfoVC) forControlEvents:UIControlEventTouchUpInside];
    
    return rightBtn;
}

-(UIView*)createFooterView{
    CGFloat footHeight = 240;
    UIView *footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, footHeight);
    [footerView setBackgroundColor:WXColorWithInteger(0xf6f6f6)];
    
    CGFloat btnWidth = IPHONE_SCREEN_WIDTH-2*20;
    CGFloat btnHeight = 40;
    WXUIButton *submitBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake((IPHONE_SCREEN_WIDTH-btnWidth)/2, footHeight-btnHeight-10, btnWidth, btnHeight);
    [submitBtn setBackgroundColor:WXColorWithInteger(0xf74f35)];
    [submitBtn setTitle:@"绑定提现账户" forState:UIControlStateNormal];
    [submitBtn setTitleColor:WXColorWithInteger(0xffffff) forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:submitBtn];
    
    if([_model.userAliAcountArr count] > 0){
        entity = [_model.userAliAcountArr objectAtIndex:0];
    }
    
    CGFloat imgWidth = 60;
    CGFloat imgHeight = imgWidth;
    CGFloat commonLabelWidth = 140;
    CGFloat commonLabelHeight = 22;
    if(entity.userali_type == UserAliCount_Type_Submit && entity){
        CGFloat yOffset = 35;
        WXUIImageView *imgView = [[WXUIImageView alloc] init];
        imgView.frame = CGRectMake((IPHONE_SCREEN_WIDTH-imgWidth)/2, yOffset, imgWidth, imgHeight);
        [imgView setImage:[UIImage imageNamed:@"UserWithdrawals.png"]];
        [footerView addSubview:imgView];
        
        yOffset += imgHeight+18;
        WXUILabel *nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake((IPHONE_SCREEN_WIDTH-commonLabelWidth)/2, yOffset, commonLabelWidth, commonLabelHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setText:@"正在审核中..."];
        [nameLabel setTextAlignment:NSTextAlignmentCenter];
        [nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [nameLabel setFont:WXFont(17.0)];
        [footerView addSubview:nameLabel];
        
        [submitBtn setEnabled:NO];
    }
    
    if(entity.userali_type == UserAliCount_Type_Failed){
        CGFloat yOffset = 35;
        WXUIImageView *imgView = [[WXUIImageView alloc] init];
        imgView.frame = CGRectMake((IPHONE_SCREEN_WIDTH-imgWidth)/2, yOffset, imgWidth, imgHeight);
        [imgView setImage:[UIImage imageNamed:@"UserAliAccountFailed.png"]];
        [footerView addSubview:imgView];
        
        yOffset += imgHeight+18;
        WXUILabel *nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake((IPHONE_SCREEN_WIDTH-commonLabelWidth)/2, yOffset, commonLabelWidth, commonLabelHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setText:@"审核失败..."];
        [nameLabel setTextAlignment:NSTextAlignmentCenter];
        [nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [nameLabel setFont:WXFont(17.0)];
        [footerView addSubview:nameLabel];
        
        [submitBtn setEnabled:YES];
    }
    
    if(entity.userali_type == UserAliCount_Type_Succeed && entity){
        CGFloat yOffset = 25;
        CGFloat xOffset = 8;
        CGFloat labelWidth = IPHONE_SCREEN_WIDTH-2*xOffset;
        CGFloat labelHeight = commonLabelHeight;
        WXUILabel *accountName = [[WXUILabel alloc] init];
        accountName.frame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
        [accountName setBackgroundColor:[UIColor clearColor]];
        [accountName setText:[NSString stringWithFormat:@"账户名:%@",entity.aliName]];
        [accountName setTextAlignment:NSTextAlignmentLeft];
        [accountName setTextColor:WXColorWithInteger(0x5c615d)];
        [accountName setFont:WXFont(14.0)];
        [footerView addSubview:accountName];
        
        yOffset += labelHeight+10;
        WXUILabel *accountType = [[WXUILabel alloc] init];
        accountType.frame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
        [accountType setBackgroundColor:[UIColor clearColor]];
        [accountType setText:@"账户类型:支付宝"];
        [accountType setTextAlignment:NSTextAlignmentLeft];
        [accountType setTextColor:WXColorWithInteger(0x5c615d)];
        [accountType setFont:WXFont(14.0)];
        [footerView addSubview:accountType];
        
        yOffset += labelHeight+10;
        WXUILabel *accountInfo = [[WXUILabel alloc] init];
        accountInfo.frame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
        [accountInfo setBackgroundColor:[UIColor clearColor]];
        [accountInfo setText:[NSString stringWithFormat:@"收款账户:%@",entity.aliCount]];
        [accountInfo setTextAlignment:NSTextAlignmentLeft];
        [accountInfo setTextColor:WXColorWithInteger(0x5c615d)];
        [accountInfo setFont:WXFont(14.0)];
        [footerView addSubview:accountInfo];
        
        [submitBtn setEnabled:YES];
        [submitBtn setTitle:@"重新绑定账户" forState:UIControlStateNormal];
    }
    
    return footerView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = UserMoneyShowCellHeight;
    if(indexPath.row == 1){
        height = UserMoneyInfoCellHeight;
    }
    return height;
}

-(WXUITableViewCell*)tableViewForUserMoneyShowCell{
    static NSString *identfier = @"userMoneyShowCell";
    UserMoneyShowCell *cell = [_tableView dequeueReusableCellWithIdentifier:identfier];
    if(!cell){
        cell = [[UserMoneyShowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfier];
    }
    [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_HasNext];
    [cell load];
    return cell;
}

-(WXUITableViewCell*)tableViewForUserMoneyInfoCell{
    static NSString *identfier = @"userMoneyInfoCell";
    UserMoneyInfoCell *cell = [_tableView dequeueReusableCellWithIdentifier:identfier];
    if(!cell){
        cell = [[UserMoneyInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfier];
    }
    [cell setUserInteractionEnabled:NO];
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    switch (row) {
        case 0:
            cell = [self tableViewForUserMoneyShowCell];
            break;
        case 1:
            cell = [self tableViewForUserMoneyInfoCell];
            break;
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserMoneyDrawVC *moneyVC = [[UserMoneyDrawVC alloc] init];
    [self.wxNavigationController pushViewController:moneyVC];
}

#pragma mark aliaccount
-(void)searchUserAliPayAccountSucceed{
    [self unShowWaitView];
    [_tableView reloadData];
}

-(void)searchUserAliPayAccountFailed:(NSString *)errorMsg{
    [self unShowWaitView];
}

#pragma mark 添加或修改支付宝成功
-(void)changeUserWithdrawalsInfoSucceed{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults boolForKey:ConfirmSign]){
        entity.userali_type = UserAliCount_Type_Submit;
        [_tableView reloadData];
    }
}

#pragma mark nextPage
-(void)gotoAccountInfoVC{
    CloudTicketListVC *cloudVC = [[CloudTicketListVC alloc] init];
    cloudVC.ctType = CloudTicket_Type_Info;
    [self.wxNavigationController pushViewController:cloudVC];
}

-(void)submitBtnClicked{
    ConfirmUserAliPayVC *comfirmVC = [[ConfirmUserAliPayVC alloc] init];
    comfirmVC.titleString = @"验证信息";
    [self.wxNavigationController pushViewController:comfirmVC];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:NO forKey:ConfirmSign];
}

@end
