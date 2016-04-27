//
//  T_SignViewController.m
//  Woxin3.0
//
//  Created by SHB on 15/1/21.
//  Copyright (c) 2015年 le ting. All rights reserved.
//

#import "SignViewController.h"
#import "T_SignGifView.h"
#import "SignModel.h"
#import "SignEntity.h"
#import "NSDate+Compare.h"

enum{
    Sign_Type_None = 0,
    Sign_Type_Phone,
    Sign_Type_Cloud,
    
    Sign_Type_Invalid,
};

#define kAnimatedDur (0.3)
#define kMaskMaxAlpha (1.0)
#define Size self.view.bounds.size

@interface SignViewController()<SignDelegate>{
    UIButton *_closeBtn;
    UIButton *_signBtn;
    SignModel *_model;
    UILabel *_textLabel;
}
@end

@implementation SignViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCSTNavigationViewHidden:YES animated:NO];
    
    _model = [[SignModel alloc] init];
    [_model setDelegate:self];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [imgView setImage:[UIImage imageNamed:@"signBg.png"]];
    [self.view addSubview:imgView];
    
    [self createRewardLabel];
    [self createSignBtn];
    [self createBackBtn];
    
    UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backToLastPage)];
    [swip setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swip];
}

-(void)createBackBtn{
    CGFloat xOffset = 20;
    CGFloat yOffset = 30;
    UIImage *img = [UIImage imageNamed:@"T_Back.png"];
    WXTUIButton *backBtn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(xOffset, yOffset, img.size.width, img.size.height);
    [backBtn setImage:[UIImage imageNamed:@"T_BackWhite.png"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"T_Back.png"] forState:UIControlStateSelected];
    [backBtn setBackgroundColor:[UIColor clearColor]];
    [backBtn addTarget:self action:@selector(backToLastPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}

-(void)createRewardLabel{
    CGSize size = self.view.bounds.size;
    CGFloat yOffset = 30;
    CGFloat height = 30;
    _textLabel = [[UILabel alloc] init];
    _textLabel.frame = CGRectMake(0, size.height-yOffset-30-30-30, Size.width, height);
    [_textLabel setBackgroundColor:[UIColor clearColor]];
    [_textLabel setTextAlignment:NSTextAlignmentCenter];
    [_textLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_textLabel setTextColor:[UIColor whiteColor]];
    [self.view addSubview:_textLabel];
}

-(void)createSignBtn{
    CGFloat xOffset = 30;
    CGFloat yOffset = 30;
    CGFloat height = 55;
    _signBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _signBtn.frame = CGRectMake(xOffset, Size.height-yOffset-height, Size.width-2*xOffset, height);
    [_signBtn setImage:[UIImage imageNamed:@"SignNow.png"] forState:UIControlStateNormal];
    [_signBtn addTarget:self action:@selector(signBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_signBtn];
    
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger time = [userDefaults integerForKey:userObj.wxtID];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *timeString = [date YMDHMString:E_YMD];
    if([timeString isEqualToString:@"今天"]){
        NSUserDefaults *userDefaults1 = [NSUserDefaults standardUserDefaults];
        NSString *message = [userDefaults1 objectForKey:userObj.user];
        [_signBtn setEnabled:NO];
        [_textLabel setText:message];
    }
}

-(void)signBtnClicked{
    [_model signGainMoney];
    [_signBtn setEnabled:NO];
    [_signBtn setImage:[UIImage imageNamed:@"SignSeleNow.png"] forState:UIControlStateNormal];
    
    T_SignGifView *gifView = [[T_SignGifView alloc] initWithFrame:CGRectMake(0, 0, Size.width, Size.height)];
    [self.view addSubview:gifView];
}

-(void)showAlert{
    [_signBtn setEnabled:YES];
}

-(void)signSucceed{
   [_signBtn setEnabled:NO];
   [_signBtn setImage:[UIImage imageNamed:@"SignSeleNow.png"] forState:UIControlStateNormal];
    
    if([_model.signArr count] > 0){
        SignEntity *signEntity = [_model.signArr objectAtIndex:0];
        [_textLabel setText:[NSString stringWithFormat:@"签到奖励:%.2f元",signEntity.money]];
        if(signEntity.type == Sign_Type_Cloud){
            [_textLabel setText:[NSString stringWithFormat:@"签到奖励:%d云票",(int)signEntity.money]];
        }
    }
}

-(void)signFailed:(NSString *)errorMsg{
    [_signBtn setEnabled:YES];
    if(!errorMsg){
        errorMsg = @"签到失败";
    }
    [UtilTool showAlertView:errorMsg];
}

-(void)backToLastPage{
    [self.wxNavigationController popViewControllerAnimated:YES completion:^{
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_model setDelegate:nil];
}

@end
