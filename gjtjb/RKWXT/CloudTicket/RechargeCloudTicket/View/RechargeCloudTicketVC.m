//
//  RechargeCloudTicketVC.m
//  RKWXT
//
//  Created by SHB on 16/4/6.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "RechargeCloudTicketVC.h"
#import "RechargeCTModel.h"

#define EveryCellHeight (40)
#define Size self.bounds.size

@interface RechargeCloudTicketVC(){
    UITextField *_numTextfield;
    UITextField *_pwdTextfield;
}

@end

@implementation RechargeCloudTicketVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"云票充值"];
    [self setBackgroundColor:WXColorWithInteger(0xf6f6f6)];
    
//    [self createUpImgView];
    [self createBaseView];
}

-(void)createUpImgView{
    CGFloat xOffset = 12;
    CGFloat imgWidth = 45;
    CGFloat imgHeight = 26;
    WXUIImageView *imgView = [[WXUIImageView alloc] init];
    [imgView setFrame:CGRectMake(xOffset, (60-imgHeight)/2, imgWidth, imgHeight)];
    [imgView setImage:[UIImage imageNamed:@"wxtRecharge.png"]];
    [self addSubview:imgView];
    
    xOffset += imgWidth+5;
    WXUILabel *nameLabel = [[WXUILabel alloc] init];
    nameLabel.frame = CGRectMake(xOffset, (60-imgHeight)/2, 150, imgHeight);
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setTextAlignment:NSTextAlignmentLeft];
    [nameLabel setTextColor:WXColorWithInteger(0x000000)];
    [nameLabel setFont:WXFont(14.0)];
    [nameLabel setText:@"我信充值卡"];
    [self addSubview:nameLabel];
}

-(void)createBaseView{
    CGFloat xOffset = 19;
    CGFloat yOffset = 7;
    CGFloat numWidth = 36;
    CGFloat numHeight = 17;
    WXUIView *backLabel = [[WXUIView alloc] init];
    backLabel.frame = CGRectMake(0, yOffset, IPHONE_SCREEN_WIDTH, 2*EveryCellHeight);
    [backLabel setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:backLabel];
    
    UILabel *cartLabel = [[UILabel alloc] init];
    cartLabel.frame = CGRectMake(xOffset, (EveryCellHeight-numHeight)/2+0.6, numWidth, numHeight);
    [cartLabel setBackgroundColor:[UIColor clearColor]];
    [cartLabel setTextAlignment:NSTextAlignmentCenter];
    [cartLabel setFont:WXTFont(15.0)];
    [cartLabel setText:@"卡号"];
    [cartLabel setTextColor:WXColorWithInteger(0x000000)];
    [backLabel addSubview:cartLabel];
    
    xOffset += numWidth+10;
    CGFloat textfieldWidth = 200;
    CGFloat textfieldHeight = numHeight;
    _numTextfield = [[UITextField alloc] init];
    _numTextfield.frame = CGRectMake(xOffset, (EveryCellHeight-numHeight)/2, textfieldWidth, textfieldHeight);
    [_numTextfield setKeyboardType:UIKeyboardTypePhonePad];
    [_numTextfield setPlaceholder:@"请输入卡号"];
    [_numTextfield setTextColor:WXColorWithInteger(0x9c9c9c)];
    [_numTextfield setFont:WXTFont(15.0)];
    [_numTextfield addTarget:self action:@selector(textfieldReturn:) forControlEvents:UIControlEventTouchDragExit];
    [backLabel addSubview:_numTextfield];
    
    xOffset -= numWidth;
    yOffset = EveryCellHeight;
    UILabel *downLine = [[UILabel alloc] init];
    downLine.frame = CGRectMake(0, yOffset, Size.width, 0.5);
    [downLine setBackgroundColor:WXColorWithInteger(0x9c9c9c)];
    [backLabel addSubview:downLine];
    
    yOffset += (EveryCellHeight-numHeight)/2;
    UILabel *pwdLabel = [[UILabel alloc] init];
    pwdLabel.frame = CGRectMake(xOffset-10, yOffset, numWidth, numHeight);
    [pwdLabel setBackgroundColor:[UIColor clearColor]];
    [pwdLabel setTextAlignment:NSTextAlignmentCenter];
    [pwdLabel setFont:WXTFont(15.0)];
    [pwdLabel setText:@"密码"];
    [cartLabel setTextColor:WXColorWithInteger(0x000000)];
    [backLabel addSubview:pwdLabel];
    
    xOffset += numWidth;
    _pwdTextfield = [[UITextField alloc] init];
    _pwdTextfield.frame = CGRectMake(xOffset, yOffset, textfieldWidth, textfieldHeight);
    [_pwdTextfield setKeyboardType:UIKeyboardTypePhonePad];
    [_pwdTextfield setPlaceholder:@"请输入密码"];
    [_pwdTextfield setTextColor:WXColorWithInteger(0x9c9c9c)];
    [_pwdTextfield setFont:WXTFont(15.0)];
    [_pwdTextfield addTarget:self action:@selector(textfieldReturn:) forControlEvents:UIControlEventTouchDragExit];
    [backLabel addSubview:_pwdTextfield];
    
    yOffset = backLabel.frame.origin.y+2*EveryCellHeight+50;
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(13, yOffset, Size.width-2*13, EveryCellHeight);
    [okBtn setBackgroundColor:WXColorWithInteger(AllBaseColor)];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn setTitleColor:WXColorWithInteger(0xffffff) forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:okBtn];
}

-(void)textfieldReturn:(id)sender{
    UITextField *textfield = sender;
    [textfield resignFirstResponder];
}

-(void)submit{
    if(_numTextfield.text.length < 1 || _pwdTextfield.text.length < 1){
        [UtilTool showAlertView:@"帐号或密码格式错误"];
        return;
    }
    NSString *numberStr = _numTextfield.text;
    NSString *pwdStr = _pwdTextfield.text;
    
    RechargeCTModel *_model = [[RechargeCTModel alloc] init];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
    [_model rechargeUserCloudTicketWith:numberStr andPwd:pwdStr completion:^(NSInteger code, NSString *errorMsg) {
        [self unShowWaitView];
        if(code == 0){
            [self rechargeSucceed];
        }else{
            [self rechargeFailed:errorMsg];
        }
    }];
}

-(void)rechargeSucceed{
    [_numTextfield setText:nil];
    [_pwdTextfield setText:nil];
    [UtilTool showAlertView:@"充值成功"];
}

-(void)rechargeFailed:(NSString*)errorMsg{
    if(!errorMsg){
        [UtilTool showAlertView:@"充值失败"];
        return;
    }
    [UtilTool showAlertView:errorMsg];
}

@end
