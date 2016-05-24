//
//  LoginVC.m
//  RKWXT
//
//  Created by SHB on 15/3/12.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "LoginVC.h"
#import "UIView+Render.h"
#import "WXTUITextField.h"
#import "LoginModel.h"
#import "WXTUITabBarController.h"
#import "FetchPwdModel.h"
#import "RegistVC.h"
#import "WXTDatabase.h"
#import "WXTUITabbarVC.h"
#import "NewWXTLiDB.h"
#import "NewForgetPwdVC.h"
#import "APService.h"
#import "AllAreaDataModel.h"
#import "ShoppingCartView.h"
#import "FindCommonVC.h"

#define Size self.bounds.size
#define kLoginBigImgViewheight (190)
#define kLoginDownViewHeight (40)
#define kUserExactLength (11)
#define kFetchPasswordDur (60)

@interface LoginVC ()<FetchPwdDelegate>{
    WXTUITextField *_userTextField;
    WXTUITextField *_pwdTextField;
    UIView *_iconShell;
    UIView *_optShell;
    
    WXTUIButton *_fetchPwdBtn;
    WXTUIButton *_submitBtn;
    WXTUIButton *_toRegisterBtn;
    
    
    NSInteger _fetchPasswordTime;
    NSTimer *_fetchPWDTimer;
    
    FetchPwdModel *_pwdModel;
}
@end

@implementation LoginVC

-(id)init{
    self = [super init];
    if(self){
        _pwdModel = [[FetchPwdModel alloc] init];
        [_pwdModel setDelegate:self];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCSTNavigationViewHidden:YES animated:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyBoardDur:) name:UIKeyboardDidHideNotification object:nil];
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    if(userObj.user && _userTextField){
        [_userTextField setText:userObj.user];
    }
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setBackgroundColor:WXColorWithInteger(0xf74f35)];
    [self setDexterity:E_Slide_Dexterity_None];
    
    _iconShell = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Size.width, kLoginBigImgViewheight)];
    [_iconShell setClipsToBounds:YES];
    [self addSubview:_iconShell];
    
    CGFloat bgImgWidth = 180;
    CGFloat bgImgHeight = 150;
    UIImage *bigImg = [UIImage imageNamed:@"LoginUpBgImg.png"];
    UIImageView *loginBigImgView = [[UIImageView alloc] initWithFrame:CGRectMake(IPHONE_SCREEN_WIDTH-210, 70, bgImgWidth, bgImgHeight)];
    [loginBigImgView setImage:bigImg];
    [_iconShell addSubview:loginBigImgView];
    
    CGFloat yOffset = 36.0;
    _optShell = [[UIView alloc] initWithFrame:CGRectMake(0, kLoginBigImgViewheight, Size.width, Size.height - kLoginBigImgViewheight-kLoginDownViewHeight+25)];
    [_optShell setBackgroundColor:WXColorWithInteger(0xf74f35)];
    [self addSubview:_optShell];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [_optShell addGestureRecognizer:tap];
    
    UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swip)];
    [swip setDirection:UISwipeGestureRecognizerDirectionRight|UISwipeGestureRecognizerDirectionLeft|UISwipeGestureRecognizerDirectionUp|UISwipeGestureRecognizerDirectionDown];
    [_optShell addGestureRecognizer:swip];
    
    
    CGFloat yGap = 112;
    CGRect tableRect = CGRectMake(0, 0, Size.width, yGap);
    [self createUserAndPwdTable:tableRect];

    yOffset = tableRect.size.height+14;
    CGFloat btnHeight1 = 42.0;
    CGFloat xgap = 20;
    CGFloat btnWidth1 = Size.width-2*xgap;
//    CGFloat radian = 5.0;
    CGFloat titleSize = 18.0;
    _submitBtn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    [_submitBtn setFrame:CGRectMake(xgap, yOffset, btnWidth1, btnHeight1)];
    [_submitBtn setTitle:@"登 录" forState:UIControlStateNormal];
    [_submitBtn.titleLabel setFont:WXTFont(titleSize)];
    [_submitBtn setBackgroundImageOfColor:[UIColor whiteColor] controlState:UIControlStateNormal];
    [_submitBtn setTitleColor:WXColorWithInteger(0xf74f35) forState:UIControlStateNormal];
//    [_submitBtn setBorderRadian:radian width:0.5 color:WXColorWithInteger(0xf74f35)];
    [_submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [_optShell addSubview:_submitBtn];
    
    yOffset += btnHeight1;
    CGFloat fetchPwdBtnWidth = 100;
    
    CGFloat xGap1 = Size.width - fetchPwdBtnWidth - xgap;
    _fetchPwdBtn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    _fetchPwdBtn.frame = CGRectMake(xGap1, yOffset, fetchPwdBtnWidth, 30);
    [_fetchPwdBtn.titleLabel setFont:WXTFont(14.0)];
    [_fetchPwdBtn setTitle:@"找回密码" forState:UIControlStateNormal];
    _fetchPwdBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_fetchPwdBtn setTitleColor:WXColorWithInteger(0xffffff) forState:UIControlStateNormal];
    [_fetchPwdBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [_fetchPwdBtn addTarget:self action:@selector(fetchPassWord) forControlEvents:UIControlEventTouchUpInside];
    [_optShell addSubview:_fetchPwdBtn];
    
    WXUIButton *registBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    registBtn.frame = CGRectMake(0, yOffset, fetchPwdBtnWidth, 30);
    [registBtn.titleLabel setFont:WXFont(14.0)];
    [registBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    [registBtn setTitleColor:WXColorWithInteger(0xffffff) forState:UIControlStateNormal];
    [registBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [registBtn addTarget:self action:@selector(toRegister) forControlEvents:UIControlEventTouchUpInside];
    [_optShell addSubview:registBtn];
}

- (void)createUserAndPwdTable:(CGRect)rect{
    CGSize size = rect.size;
    CGFloat xGap = 18.0;
    CGFloat height = 35.0;
    CGFloat width = size.width - xGap*2.0;
    CGFloat yOffset = 4;
    CGFloat smImgHeight = 42;
    
    WXUIImageView *upImgView = [[WXUIImageView alloc] init];
    upImgView.frame = CGRectMake(xGap, yOffset, Size.width-2*xGap, smImgHeight);
    [upImgView setBackgroundColor:WXColorWithInteger(0xf9725d)];
    [_optShell addSubview:upImgView];
    
    CGFloat fontSize = 14.0;
    CGFloat leftViewGap = 13.0;
    CGFloat textGap = 10.0;
    _userTextField = [[WXTUITextField alloc] initWithFrame:CGRectMake(xGap, yOffset+(smImgHeight-height)/2, width, height)];
    [_userTextField setReturnKeyType:UIReturnKeyDone];
    [_userTextField setKeyboardType:UIKeyboardTypePhonePad];
//    [_userTextField addTarget:self action:@selector(textFieldDone:)  forControlEvents:UIControlEventEditingDidEndOnExit];
    [_userTextField addTarget:self action:@selector(showKeyBoardDur:)  forControlEvents:UIControlEventEditingDidBegin];
    [_userTextField setBorderRadian:5.0 width:1.0 color:[UIColor clearColor]];
    [_userTextField setTextColor:WXColorWithInteger(0xffffff)];
    [_userTextField setTintColor:WXColorWithInteger(0xffffff)];
    [_userTextField setPlaceHolder:@"请输入注册的手机号码" color:WXColorWithInteger(0xffffff)];
    [_userTextField setLeftViewMode:UITextFieldViewModeAlways];
    [_userTextField setFont:WXTFont(fontSize)];
    UIImage *leftImg = [UIImage imageNamed:@"LoginUserImg.png"];
    UIImageView *leftView = [[UIImageView alloc] initWithImage:leftImg];
    [_userTextField setLeftView:leftView leftGap:leftViewGap rightGap:textGap];
    [_optShell addSubview:_userTextField];
    
    
    yOffset += smImgHeight+10;
    WXUIImageView *downImgView = [[WXUIImageView alloc] init];
    downImgView.frame = CGRectMake(xGap, yOffset, Size.width-2*xGap, smImgHeight);
    [downImgView setBackgroundColor:WXColorWithInteger(0xf9725d)];
    [_optShell addSubview:downImgView];
    
    _pwdTextField = [[WXTUITextField alloc] initWithFrame:CGRectMake(xGap+7, yOffset+(smImgHeight-height)/2, width, height)];
    [_pwdTextField setReturnKeyType:UIReturnKeyDone];
    [_pwdTextField setSecureTextEntry:YES];
    [_pwdTextField addTarget:self action:@selector(textFieldDone:)  forControlEvents:UIControlEventEditingDidEndOnExit];
    [_pwdTextField addTarget:self action:@selector(showKeyBoardDur:)  forControlEvents:UIControlEventEditingDidBegin];
    [_pwdTextField setBorderRadian:5.0 width:1.0 color:[UIColor clearColor]];
    [_pwdTextField setTextColor:WXColorWithInteger(0xffffff)];
    [_pwdTextField setTintColor:WXColorWithInteger(0xffffff)];
    [_pwdTextField setLeftViewMode:UITextFieldViewModeAlways];
    [_pwdTextField setKeyboardType:UIKeyboardTypeASCIICapable];
    [_pwdTextField setSecureTextEntry:YES];
    [_pwdTextField setPlaceHolder:@"请输入密码" color:WXColorWithInteger(0xffffff)];
    UIImage *passwordIcon = [UIImage imageNamed:@"LoginUserPwd.png"];
    UIImageView *leftView1 = [[UIImageView alloc] initWithImage:passwordIcon];
    [_pwdTextField setLeftView:leftView1 leftGap:leftViewGap-5 rightGap:textGap];
    [_pwdTextField setFont:WXTFont(fontSize)];
    [_optShell addSubview:_pwdTextField];
}

#pragma mark KeyBoard
- (void)showKeyBoardDur:(CGFloat)dur{
    CGFloat yOffset = 0.0;
    if(isIOS7){
        yOffset = IPHONE_STATUS_BAR_HEIGHT;
    }
    CGRect optShellRect = [_optShell bounds];
    optShellRect.origin.y = yOffset+45;
    [UIView animateWithDuration:0.3 animations:^{
        [_optShell setFrame:optShellRect];
    }];
}

- (void)hideKeyBoardDur:(CGFloat)dur{
    CGRect optShellRect = [_optShell bounds];
    optShellRect.origin.y = kLoginBigImgViewheight + 25;
    
    [UIView animateWithDuration:0.3 animations:^{
        [_optShell setFrame:optShellRect];
    }];
}

#pragma mark textField resignFirstResponder
- (void)swip{
    [self textFieldResighFirstResponder];
}

- (void)tap{
    [self textFieldResighFirstResponder];
}

- (void)textFieldResighFirstResponder{
    [_userTextField resignFirstResponder];
    [_pwdTextField resignFirstResponder];
}

- (void)textFieldDone:(id)sender{
    WXTUITextField *textField = sender;
    [textField resignFirstResponder];
}

#pragma mark 数据是否有效~
- (BOOL)checkUserValide{
    NSString *user = _userTextField.text;
    NSInteger len = user.length;
    if(len == 0){
        [UtilTool showAlertView:@"请输入手机号"];
        return NO;
    }
    NSString *phoneStr = [UtilTool callPhoneNumberRemovePreWith:_userTextField.text];
    if(![UtilTool determineNumberTrue:phoneStr]){
        [UtilTool showAlertView:@"请输入正确的手机号码"];
        return NO;
    }
    return YES;
}

- (BOOL)checkPasswordValide{
    NSString *password = _pwdTextField.text;
    NSInteger len = password.length;
    if(len == 0){
        [UtilTool showAlertView:@"请输入密码"];
        return NO;
    }
    if(len < 6){
        [UtilTool showAlertView:@"密码长度不能小于6位"];
        return NO;
    }
    
    return YES;
}

#pragma mark
-(void)fetchPassWord{
//    if(![self checkUserValide]){
//        return;
//    }
    NewForgetPwdVC *forgetPwd = [[NewForgetPwdVC alloc] init];
    forgetPwd.userPhone = _userTextField.text;
    [self.wxNavigationController pushViewController:forgetPwd];
}

#pragma mark 获取密码
- (void)setFetchPasswordButtonTitle{
    [_fetchPwdBtn setEnabled:_fetchPasswordTime == 0];
    NSString *title = @"登录遇到问题?";
    if(_fetchPasswordTime > 0){
        title = [NSString stringWithFormat:@"(%d)密码获取中",kFetchPasswordDur - (int)_fetchPasswordTime];
    }
    [_fetchPwdBtn setTitle:title forState:UIControlStateNormal];
    [_fetchPwdBtn setTitle:title forState:UIControlStateHighlighted];
    [_fetchPwdBtn setTitle:title forState:UIControlStateDisabled];
}

- (void)startFetchPwdTiming{
    _fetchPWDTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countFetchPassword) userInfo:nil repeats:YES];
}

- (void)stopFetchPwdTiming{
    if(_fetchPWDTimer){
        if([_fetchPWDTimer isValid]){
            [_fetchPWDTimer invalidate];
        }
    }
    _fetchPasswordTime = 0;
}

- (void)countFetchPassword{
    _fetchPasswordTime ++;
    if(_fetchPasswordTime == kFetchPasswordDur){
        _fetchPasswordTime = 0;
        [self stopFetchPwdTiming];
    }
    [self setFetchPasswordButtonTitle];
}

#pragma mark loginSucceed
- (void)loginSucceed{
    WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
    WXTUITabbarVC *tabbar = [[WXTUITabbarVC alloc] init];
    WXUINavigationController *nav = [[WXUINavigationController alloc] initWithRootViewController:tabbar];
    [self presentViewController:nav animated:YES completion:^{
        WXTDatabase * database = [WXTDatabase shareDatabase];
        [database createDatabase:userDefault.wxtID];
        [[NewWXTLiDB sharedWXLibDB] loadData];
        [self checkAreaVersion];
        NSSet *set1 = [NSSet setWithObjects:[NSString stringWithFormat:@"%@",userDefault.user], [NSString stringWithFormat:@"seller_%@",userDefault.sellerID], nil];
        [APService setTags:set1 alias:nil callbackSelector:nil object:nil];
    }];
    
    //第一次登陆直接调用发送消息
    LoginModel *_model = [[LoginModel alloc]init];
    [_model sendUserMessage];
    
    //登陆成功之后查看购物车数量
    [[[ShoppingCartView alloc]initWithFrame:CGRectZero] searchShoppingCartNumber];
}

-(void)checkAreaVersion{
    AllAreaDataModel *model = [AllAreaDataModel shareAllAreaData];
    [model checkAllAreaVersion];
}

- (void)fetchPwdFailed:(NSString*)errorMsg{
    [self unShowWaitView];
    if(!errorMsg){
        errorMsg = @"密码获取失败";
    }
    [UtilTool showAlertView:errorMsg];
    [self stopFetchPwdTiming];
    [self setFetchPasswordButtonTitle];
}

- (void)fetchPwdSucceed{
    [self unShowWaitView];
    [UtilTool showAlertView:[NSString stringWithFormat:@"密码已经发送到你的号码为%@的手机上，请注意查收",_userTextField.text]];
}

#pragma mark 登录
- (void)submit{
    if([self checkUserValide] && [self checkPasswordValide]){
        [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
        
        LoginModel *_model = [[LoginModel alloc] init];
        [_model loginWithUser:_userTextField.text pwd:_pwdTextField.text completion:^(NSInteger code, NSString *errorMsg) {
            [self unShowWaitView];
            if(code == 0){
                [self loginSucceed];
            }else{
                [UtilTool showAlertView:errorMsg];
            }
        }];
    }
    [self textFieldResighFirstResponder];
}

- (void)toRegister{
    //注册页面
//    RegistVC *registVC = [[RegistVC alloc] init];
//    [self.wxNavigationController pushViewController:registVC];
    
    NSString *urlStr = @"http://api.woxinyun.com/wx_union/index.php/Register/index?sid=100000";
    FindCommonVC *webViewVC = [[FindCommonVC alloc]init];
    webViewVC.name = @"用户注册";
    webViewVC.webURl = urlStr;
    [self.wxNavigationController pushViewController:webViewVC];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end