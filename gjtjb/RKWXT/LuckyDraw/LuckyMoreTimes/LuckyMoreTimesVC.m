//
//  LuckyMoreTimesVC.m
//  RKWXT
//
//  Created by SHB on 16/3/19.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "LuckyMoreTimesVC.h"
#import "BalanceModel.h"
#import "BalanceEntity.h"
#import "LuckyTimesModel.h"

@interface LuckyMoreTimesVC()<LoadUserBalanceDelegate>{
    WXUIButton *rightMoneyBtn;
    
    WXUILabel *timesLabel;
    WXUILabel *minusLabel;
    NSInteger luckyTimes;
    int count;
    
    BalanceModel *_balanceModel;
    LuckyTimesModel *_model;
}

@end

@implementation LuckyMoreTimesVC

-(id)init{
    self = [super init];
    if(self){
        _balanceModel = [[BalanceModel alloc] init];
        [_balanceModel setDelegate:self];
        
        _model = [[LuckyTimesModel alloc] init];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self addOBS];
}

- (void)addOBS{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeNumberFailed:) name:D_Notification_Name_LuckyTimesModel_Failed object:nil];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"兑换抽奖"];
    [self setBackgroundColor:WXColorWithInteger(0xffffff)];
    
    [_balanceModel loadUserBalance];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
    
    [self createRightMoneyView];
    [self createTopBaseView];
    [self createDetailView];
    luckyTimes = 1;
    count = 0;
}

-(void)createRightMoneyView{
    CGFloat xOffset = 5;
    CGFloat yOffset = 2;
    CGFloat width = 100;
    CGFloat height = 18;
    rightMoneyBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    rightMoneyBtn.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-width, 64-yOffset-height, width, height);
    [rightMoneyBtn setBackgroundColor:[UIColor clearColor]];
    [rightMoneyBtn setTitle:@"话费余额:0" forState:UIControlStateNormal];
    [rightMoneyBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
    [rightMoneyBtn setTitleColor:WXColorWithInteger(0xffffff) forState:UIControlStateNormal];
    [rightMoneyBtn.titleLabel setFont:WXFont(12.0)];
    [rightMoneyBtn addTarget:self action:@selector(gainUserBalance) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightMoneyBtn];
}

-(void)createTopBaseView{
    CGFloat xOffset = 15;
    CGFloat yOffset = 10;
    CGFloat labelWidth = 70;
    CGFloat labelHeight = 20;
    minusLabel = [[WXUILabel alloc] init];
    minusLabel.frame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
    [minusLabel setBackgroundColor:[UIColor clearColor]];
    [minusLabel setText:@"¥ 2"];
    [minusLabel setTextAlignment:NSTextAlignmentLeft];
    [minusLabel setTextColor:WXColorWithInteger(0xf74f35)];
    [minusLabel setFont:WXFont(18.0)];
    [self addSubview:minusLabel];
    
    yOffset += labelHeight-2;
    WXUILabel *textLabel = [[WXUILabel alloc] init];
    textLabel.frame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setText:@"消耗话费余额"];
    [textLabel setTextAlignment:NSTextAlignmentLeft];
    [textLabel setTextColor:WXColorWithInteger(0x848484)];
    [textLabel setFont:WXFont(11.0)];
    [self addSubview:textLabel];
    
    CGFloat btnWidth = 20;
    CGFloat btnHeight = btnWidth;
    CGFloat minLabelWidth = 24;
    yOffset = 15;
    WXUIButton *plusBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    plusBtn.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-btnWidth, yOffset, btnWidth, btnHeight);
    [plusBtn setBorderRadian:1.0 width:1.0 color:WXColorWithInteger(0xbdbdbd)];
    [plusBtn setTitle:@"+" forState:UIControlStateNormal];
    [plusBtn setTitleColor:WXColorWithInteger(0xbdbdbd) forState:UIControlStateNormal];
    [plusBtn addTarget:self action:@selector(plusUserLuckyTimes) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:plusBtn];
    
    xOffset += btnWidth+5;
    timesLabel = [[WXUILabel alloc] init];
    timesLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-minLabelWidth, yOffset, minLabelWidth, btnHeight);
    [timesLabel setBackgroundColor:[UIColor clearColor]];
    [timesLabel setBorderRadian:1.0 width:1.0 color:WXColorWithInteger(0xf74f35)];
    [timesLabel setText:@"1"];
    [timesLabel setTextAlignment:NSTextAlignmentCenter];
    [timesLabel setTextColor:WXColorWithInteger(0xf74f35)];
    [timesLabel setFont:WXFont(12.0)];
    [self addSubview:timesLabel];
    
    xOffset += minLabelWidth+5;
    WXUIButton *minusBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    minusBtn.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-btnWidth, yOffset, btnWidth, btnHeight);
    [minusBtn setBorderRadian:1.0 width:1.0 color:WXColorWithInteger(0xbdbdbd)];
    [minusBtn setTitle:@"-" forState:UIControlStateNormal];
    [minusBtn setTitleColor:WXColorWithInteger(0xbdbdbd) forState:UIControlStateNormal];
    [minusBtn addTarget:self action:@selector(minusUserLuckyTimes) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:minusBtn];
    
    yOffset += btnHeight+20;
    CGFloat width = 100;
    CGFloat height = 30;
    WXUIButton *completeBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    completeBtn.frame = CGRectMake((IPHONE_SCREEN_WIDTH-width)/2, yOffset, width, height);
    [completeBtn setBackgroundColor:WXColorWithInteger(0xf74f35)];
    [completeBtn setBorderRadian:3.0 width:1.0 color:[UIColor clearColor]];
    [completeBtn setTitle:@"确认兑换" forState:UIControlStateNormal];
    [completeBtn setTitleColor:WXColorWithInteger(0xffffff) forState:UIControlStateNormal];
    [completeBtn addTarget:self action:@selector(luckyTimesChange) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:completeBtn];
}

-(void)createDetailView{
    CGFloat yOffset = 100;
    WXUILabel *lineLabel = [[WXUILabel alloc] init];
    lineLabel.frame = CGRectMake(0, yOffset, IPHONE_SCREEN_WIDTH, 0.5);
    [lineLabel setBackgroundColor:[UIColor grayColor]];
    [self addSubview:lineLabel];
    
    yOffset += 9;
    CGFloat nameWidth = 120;
    CGFloat nameHeight = 20;
    CGFloat xOffset = 12;
    WXUILabel *nameLabel = [[WXUILabel alloc] init];
    nameLabel.frame = CGRectMake(xOffset, yOffset, nameWidth, nameHeight);
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setText:@"温馨提示:"];
    [nameLabel setTextAlignment:NSTextAlignmentLeft];
    [nameLabel setTextColor:WXColorWithInteger(0xf74f35)];
    [nameLabel setFont:WXFont(13.0)];
    [self addSubview:nameLabel];
    
    yOffset += nameHeight;
    CGFloat textHeight = 35;
    WXUILabel *upTextLabel = [[WXUILabel alloc] init];
    upTextLabel.frame = CGRectMake(xOffset, yOffset, IPHONE_SCREEN_WIDTH-2*xOffset, textHeight/2);
    [upTextLabel setBackgroundColor:[UIColor clearColor]];
    [upTextLabel setText:@"1.每个用户每天最多兑换5次抽奖机会，消耗我信话费2元／次。"];
    [upTextLabel setTextAlignment:NSTextAlignmentLeft];
    [upTextLabel setTextColor:WXColorWithInteger(0x000000)];
    [upTextLabel setNumberOfLines:0];
    [upTextLabel setFont:WXFont(10.0)];
    [self addSubview:upTextLabel];
    
    yOffset += textHeight/2-5;
    WXUILabel *downTextLabel = [[WXUILabel alloc] init];
    downTextLabel.frame = CGRectMake(xOffset, yOffset, IPHONE_SCREEN_WIDTH-2*xOffset, textHeight);
    [downTextLabel setBackgroundColor:[UIColor clearColor]];
    [downTextLabel setText:@"2.只能用我信话费余额进行抽奖兑换，不会以任何形式扣除您手机套餐的费用。"];
    [downTextLabel setTextAlignment:NSTextAlignmentLeft];
    [downTextLabel setTextColor:WXColorWithInteger(0x000000)];
    [downTextLabel setNumberOfLines:0];
    [downTextLabel setFont:WXFont(10.0)];
    [self addSubview:downTextLabel];
}

#pragma mark balanceDelegate
-(void)gainUserBalance{
    [_balanceModel loadUserBalance];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

-(void)loadUserBalanceSucceed{
    [self unShowWaitView];
    if([_balanceModel.dataList count] > 0){
        BalanceEntity *entity = [_balanceModel.dataList objectAtIndex:0];
        [rightMoneyBtn setTitle:[NSString stringWithFormat:@"话费余额:%.d",(int)entity.money] forState:UIControlStateNormal];
    }
}

-(void)loadUserBalanceFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    [rightMoneyBtn setTitle:@"点击获取话费余额" forState:UIControlStateNormal];
}

#pragma mark luckyTimes
-(void)luckyTimesChange{
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
    [_model luckyTimesChangeWithNumber:luckyTimes type:LuckyTimes_ReaquestType_Exchage  completion:^(NSDictionary *retDic) {
        [self unShowWaitView];
        if([[retDic objectForKey:@"error"] integerValue] == 0 && retDic){
            [UtilTool showTipView:@"兑换抽奖次数成功"];
        }
         [self lookUserMoney];
    }];

}

- (void)lookUserMoney{
    count += luckyTimes;
    
    if(count > 5){
        [UtilTool showTipView:@"每天最多兑换5次抽奖机会"];
        return;
    }
    
    if([_balanceModel.dataList count] > 0){
        BalanceEntity *entity = [_balanceModel.dataList objectAtIndex:0];
         int  money = (int)entity.money -  (count * 2);
        [rightMoneyBtn setTitle:[NSString stringWithFormat:@"话费余额:%.d",money] forState:UIControlStateNormal];
    }
}

- (void)changeNumberFailed:(NSNotification*)tion{
    [self unShowWaitView];
      NSString *errorMsg = tion.object;
     [UtilTool showAlertView:errorMsg];
}

//增加兑换次数
-(void)plusUserLuckyTimes{
    if(luckyTimes >= 5){
        [UtilTool showTipView:@"每天最多兑换5次抽奖机会"];
        return;
    }
    luckyTimes += 1;
    [timesLabel setText:[NSString stringWithFormat:@"%ld",(long)luckyTimes]];
    [minusLabel setText:[NSString stringWithFormat:@"¥ %ld",(long)luckyTimes*2]];
}

//减少兑换次数
-(void)minusUserLuckyTimes{
    if(luckyTimes == 1){
        [UtilTool showTipView:@"至少兑换一次抽奖机会"];
        return;
    }
    luckyTimes -= 1;
    [timesLabel setText:[NSString stringWithFormat:@"%ld",(long)luckyTimes]];
    [minusLabel setText:[NSString stringWithFormat:@"¥ %ld",(long)luckyTimes*2]];
}

-(void)viewDidDisappear:(BOOL)animated{
    [_balanceModel setDelegate:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
