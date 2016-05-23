//
//  RechargeCloudTicketVC.m
//  RKWXT
//
//  Created by SHB on 16/4/6.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "RechargeCloudTicketVC.h"
#import "RechargeCTModel.h"
#import "XNBAccoutCell.h"
#import "XNBPassWordCell.h"
#import "MoreMoneyInfoModel.h"

#define EveryCellHeight (40)
#define Size self.bounds.size

enum{
    TableSection_XNBResidue = 0,
    TableSection_XNBRecharge,
    TableSection_Invalid,
}TableSection;

@interface RechargeCloudTicketVC()<UITableViewDataSource,UITableViewDelegate,XNBAccoutCellDelegate,XNBPassWordCellDelegate>
{
    UITableView *_tableView;
    NSString *_numberStr;
    NSString*_pwdStr;
}

@end

@implementation RechargeCloudTicketVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if([MoreMoneyInfoModel shareUserMoreMoneyInfo].isLoaded){
        [self uploadUserMoreMoneyInfo];
    }else{
        [[MoreMoneyInfoModel shareUserMoreMoneyInfo] loadUserMoreMoneyInfo];
    }
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"云票充值"];
    [self setBackgroundColor:WXColorWithInteger(0xf6f6f6)];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setBackgroundColor:WXColorWithInteger(0xf6f6f6)];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    _tableView.rowHeight = 44;
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[self tableViewFootView]];
}

- (UIView*)tableViewFootView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, 120)];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(13, 12, Size.width-2*13, EveryCellHeight);
    [okBtn setBackgroundColor:WXColorWithInteger(AllBaseColor)];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn setTitleColor:WXColorWithInteger(0xffffff) forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:okBtn];
    
    return view;
}

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
    return TableSection_Invalid;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 0;
    if (section == TableSection_XNBResidue) {
        row = 1;
    }else{
        row = 2;
    }
    return row;
}

- (WXUITableViewCell*)tableViewCellFormResidue{
    WXUITableViewCell *cell = [WXUITableViewCell tableViewCellInitializeWithTableView:_tableView andType:C_CellIsIdentifier_None andIsIdtifier:@"FormResidue"];
    NSString *text = [NSString stringWithFormat:@"云票余额: %d 云票",[MoreMoneyInfoModel shareUserMoreMoneyInfo].userCloudBalance];
    [cell.textLabel setTextColor:WXColorWithInteger(0x484848)];
    cell.textLabel.attributedText = [self changeFontAddColor:text sonStr:[NSString stringWithFormat:@"%d",[MoreMoneyInfoModel shareUserMoreMoneyInfo].userCloudBalance] fontColor:[UIColor redColor] font:[UIFont systemFontOfSize:14.0]];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

- (WXUITableViewCell*)tableViewCellFormRecharge:(NSInteger)row{
   
    if (row == 0) {
     XNBAccoutCell *cell = [XNBAccoutCell tableViewCellInitializeWithTableView:_tableView andType:C_CellIsIdentifier_CreateCell andIsIdtifier:@"XNBAccoutCell"];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
      XNBPassWordCell* Posscell = [XNBPassWordCell tableViewCellInitializeWithTableView:_tableView andType:C_CellIsIdentifier_CreateCell andIsIdtifier:@"XNBPassWordCell"];
        Posscell.delegate = self;
        Posscell.selectionStyle = UITableViewCellSelectionStyleNone;
         return Posscell;
    }
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    if (indexPath.section == TableSection_XNBResidue) {
        cell = [self tableViewCellFormResidue];
    }else{
        cell = [self tableViewCellFormRecharge:indexPath.row];
    }
    return cell;
}

-(void)textFiledPassWordValueDidChanged:(NSString *)text{
    _pwdStr = text;
}

-(void)textFiledValueDidChanged:(NSString *)text{
    _numberStr = text;
}

-(void)textfieldReturn:(id)sender{
    UITextField *textfield = sender;
    [textfield resignFirstResponder];
}

-(void)submit{
    if(_numberStr.length < 1 || _pwdStr.length < 1){
        [UtilTool showAlertView:@"帐号或密码格式错误"];
        return;
    }
    RechargeCTModel *_model = [[RechargeCTModel alloc] init];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
    [_model rechargeUserCloudTicketWith:_numberStr andPwd:_pwdStr completion:^(NSInteger code, NSString *errorMsg) {
        [self unShowWaitView];
        if(code == 0){
            [self rechargeSucceed];
        }else{
            [self rechargeFailed:errorMsg];
        }
    }];
}

-(void)rechargeSucceed{
    [_tableView  reloadData];
    [UtilTool showAlertView:@"充值成功"];
}

-(void)rechargeFailed:(NSString*)errorMsg{
    if(!errorMsg){
        [UtilTool showAlertView:@"充值失败"];
        return;
    }
    [UtilTool showAlertView:errorMsg];
}

-(void)uploadUserMoreMoneyInfo{
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:TableSection_XNBResidue] withRowAnimation:UITableViewRowAnimationFade];
}

- (NSMutableAttributedString*)changeFontAddColor:(NSString*)rootStr  sonStr:(NSString*)sonStr fontColor:(UIColor*)fontColor font:(UIFont*)font {
    //设置带属性的字体
    NSMutableAttributedString *atter = [[NSMutableAttributedString alloc]initWithString:rootStr];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = font;
    dict[NSForegroundColorAttributeName] = fontColor;
    
    [atter addAttributes:dict range:[rootStr rangeOfString:sonStr]];
    
    return atter;
}

@end
