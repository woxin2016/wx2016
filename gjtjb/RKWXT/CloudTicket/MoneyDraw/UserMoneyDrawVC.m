//
//  UserMoneyDrawVC.m
//  RKWXT
//
//  Created by SHB on 16/4/6.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "UserMoneyDrawVC.h"
#import "UserMoneyDrawCell.h"
#import "UserMoneyDrawShowCell.h"
#import "ApplyAliModel.h"
#import "MoreMoneyInfoModel.h"

#define Size self.bounds.size

@interface UserMoneyDrawVC()<UITableViewDataSource,UITableViewDelegate,UserMoneyDrawCellDelegate,ApplyAliModelDelegate>{
    UITableView *_tableView;
    CGFloat drawMoney;
    ApplyAliModel *_model;
}

@end

@implementation UserMoneyDrawVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"提现"];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setBackgroundColor:WXColorWithInteger(0xf6f6f6)];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[self tableFooterView]];
    
    _model = [[ApplyAliModel alloc] init];
    [_model setDelegate:self];
}

-(UIView*)tableFooterView{
    CGFloat height = 240;
    UIView *footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, height);
    [footerView setBackgroundColor:WXColorWithInteger(0xf6f6f6)];
    
    CGFloat yOffset = 10;
    CGFloat xOffset = 12;
    CGFloat nameHeight = 25;
    WXUILabel *nameLabel = [[WXUILabel alloc] init];
    nameLabel.frame = CGRectMake(xOffset, yOffset, 120, nameHeight);
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setText:@"温馨提示:"];
    [nameLabel setTextAlignment:NSTextAlignmentLeft];
    [nameLabel setTextColor:WXColorWithInteger(0xf74f35)];
    [nameLabel setFont:WXFont(14.0)];
    [footerView addSubview:nameLabel];
    
    yOffset += nameHeight+7;
    CGFloat infoHeight = 100;
    NSString *infoString = @"1.每次提现金额需≥20元,否则不能提现。\n2.在收到您的提现申请后，我们会在1-3个工作日内将您的提现金额转到您的提现账户，如遇节假日，则顺延。\n3.如果您在提现过程中出现任何问题，请致电我们的客服: 0755-61665888";
    WXUILabel *infoLabel = [[WXUILabel alloc] init];
    infoLabel.frame = CGRectMake(xOffset, yOffset, IPHONE_SCREEN_WIDTH-2*xOffset, infoHeight);
    [infoLabel setBackgroundColor:[UIColor clearColor]];
    [infoLabel setText:infoString];
    [infoLabel setTextAlignment: NSTextAlignmentLeft];
    [infoLabel setTextColor:WXColorWithInteger(0x000000)];
    [infoLabel setFont:WXFont(12.0)];
    [infoLabel setNumberOfLines:0];
    [footerView addSubview:infoLabel];
    //行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:infoString];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [infoString length])];
    infoLabel.attributedText = attributedString;
    [infoLabel sizeToFit];
    
    yOffset += infoHeight+35;
    CGFloat btnWidth = IPHONE_SCREEN_WIDTH-2*20;
    CGFloat btnHeight = 40;
    WXUIButton *submitBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake((IPHONE_SCREEN_WIDTH-btnWidth)/2, yOffset, btnWidth, btnHeight);
    [submitBtn setBackgroundColor:WXColorWithInteger(AllBaseColor)];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:WXColorWithInteger(0xffffff) forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitUserDrawMoney) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:submitBtn];
    
    return footerView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = UserMoneyDrawShowCellHeight;
    if(indexPath.row == 1){
        height = UserMoneyDrawCellHeight;
    }
    return height;
}

-(WXUITableViewCell*)tableViewForUserMoneyDrawShowCell{
    static NSString *identifier = @"moneyShowCell";
    UserMoneyDrawShowCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[UserMoneyDrawShowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setUserInteractionEnabled:NO];
    [cell setCellInfo:[NSString stringWithFormat:@"%.2f",_userMoney]];
    [cell load];
    return cell;
}

-(WXUITableViewCell*)tableViewForUserMoneyDrawInfoCell{
    static NSString *identifier = @"moneyInfoCell";
    UserMoneyDrawCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[UserMoneyDrawCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setDelegate:self];
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    switch (row) {
        case 0:
            cell = [self tableViewForUserMoneyDrawShowCell];
            break;
        case 1:
            cell = [self tableViewForUserMoneyDrawInfoCell];
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark delegate
-(void)textFiledValueDidChanged:(NSString *)text{
    drawMoney = [text floatValue];
}

-(void)submitUserDrawMoney{
    if(drawMoney==0){
        [UtilTool showTipView:@"请输入提现金额"];
        return;
    }
    if(drawMoney < 20){
        [UtilTool showTipView:@"提现金额需大于20元"];
        return;
    }
    if(drawMoney > _userMoney){
        [UtilTool showTipView:@"对不起，账户余额不足"];
        return;
    }
    [_model applyAliMoney:drawMoney];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

-(void)applyAliMoneySucceed{
    [self unShowWaitView];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setFloat:drawMoney forKey:UserApplyMoneySucceed];
    
    //提现成功修改个人中心现金的显示
    [MoreMoneyInfoModel shareUserMoreMoneyInfo].userMoneyBalance -= drawMoney;
    [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_Name_UserMoneyBalanceChanged object:nil];
    
    [self.wxNavigationController popViewControllerAnimated:YES completion:^{
    }];
}

-(void)applyAliMoneyFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    if(!errorMsg){
        errorMsg = @"申请提现失败";
    }
    [UtilTool showAlertView:errorMsg];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_model setDelegate:nil];
}

@end
