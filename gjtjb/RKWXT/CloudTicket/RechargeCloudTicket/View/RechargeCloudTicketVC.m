//
//  RechargeCloudTicketVC.m
//  RKWXT
//
//  Created by SHB on 16/4/6.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "RechargeCloudTicketVC.h"
#import "RechargeModel.h"

#define EveryCellHeight (40)
#define Size self.bounds.size

@interface RechargeCloudTicketVC()<RechargeDelegate>{
    UITextField *_numTextfield;
    UITextField *_pwdTextfield;
    
    RechargeModel *_model;
}

@end

@implementation RechargeCloudTicketVC

-(id)init{
    self = [super init];
    if(self){
        _model = [[RechargeModel alloc] init];
        [_model setDelegate:self];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"充值"];
    [self setBackgroundColor:WXColorWithInteger(0xcccccc)];
    
    [self createUpImgView];
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
    CGFloat yOffset = 60;
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
    [cartLabel setFont:WXTFont(14.0)];
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
    [_numTextfield setTextColor:WXColorWithInteger(0x323232)];
    [_numTextfield setFont:WXTFont(14.0)];
    [_numTextfield addTarget:self action:@selector(textfieldReturn:) forControlEvents:UIControlEventTouchDragExit];
    [backLabel addSubview:_numTextfield];
    
    xOffset -= numWidth;
    yOffset = EveryCellHeight;
    UILabel *downLine = [[UILabel alloc] init];
    downLine.frame = CGRectMake(0, yOffset, Size.width, 0.5);
    [downLine setBackgroundColor:WXColorWithInteger(0x969696)];
    [backLabel addSubview:downLine];
    
    yOffset += (EveryCellHeight-numHeight)/2;
    UILabel *pwdLabel = [[UILabel alloc] init];
    pwdLabel.frame = CGRectMake(xOffset-10, yOffset, numWidth, numHeight);
    [pwdLabel setBackgroundColor:[UIColor clearColor]];
    [pwdLabel setTextAlignment:NSTextAlignmentCenter];
    [pwdLabel setFont:WXTFont(14.0)];
    [pwdLabel setText:@"密码"];
    [cartLabel setTextColor:WXColorWithInteger(0x000000)];
    [backLabel addSubview:pwdLabel];
    
    xOffset += numWidth;
    _pwdTextfield = [[UITextField alloc] init];
    _pwdTextfield.frame = CGRectMake(xOffset, yOffset, textfieldWidth, textfieldHeight);
    [_pwdTextfield setKeyboardType:UIKeyboardTypePhonePad];
    [_pwdTextfield setPlaceholder:@"请输入密码"];
    [_pwdTextfield setTextColor:WXColorWithInteger(0x323232)];
    [_pwdTextfield setFont:WXTFont(14.0)];
    [_pwdTextfield addTarget:self action:@selector(textfieldReturn:) forControlEvents:UIControlEventTouchDragExit];
    [backLabel addSubview:_pwdTextfield];
    
    yOffset = 2*EveryCellHeight+50;
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(13, yOffset, Size.width-2*13, EveryCellHeight);
    [okBtn setBorderRadian:6.0 width:1.0 color:[UIColor clearColor]];
    [okBtn setBackgroundColor:WXColorWithInteger(AllBaseColor)];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn setTitleColor:WXColorWithInteger(0xffffff) forState:UIControlStateNormal];
    [okBtn setTitleColor:WXColorWithInteger(0xffffff) forState:UIControlStateSelected];
    [okBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [backLabel addSubview:okBtn];
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
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    [_model rechargeWithCardNum:numberStr andPwd:pwdStr phone:userObj.user];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

-(void)rechargeSucceed{
    [self unShowWaitView];
    [_numTextfield setText:nil];
    [_pwdTextfield setText:nil];
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
