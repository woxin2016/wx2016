//
//  UserInfoDef.h
//  RKWXT
//
//  Created by SHB on 15/6/2.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#ifndef RKWXT_UserInfoDef_h
#define RKWXT_UserInfoDef_h

#import "PersonalInfoOrderListCell.h"
#import "PersonalOrderInfoCell.h"
#import "PersonalMoneyCell.h"
#import "PersonalCallCell.h"
#import "UserInfoCommonCell.h"
#import "UserCommonShowCell.h"

#import "UserBalanceVC.h"
#import "SignViewController.h"
#import "AboutWxtInfoVC.h"
#import "NewSystemSettingVC.h"
#import "BaseInfoVC.h"
#import "WXUserQuestionVC.h"
#import "WXHomeOrderListVC.h"
#import "ShoppingCartVC.h"
#import "ManagerAddressVC.h"
#import "CloudTicketListVC.h"
#import "UserMoneyShowVC.h"
#import "VirtualOrderListVC.h"

enum{
    PersonalInfo_Order = 0,
    PersonalInfo_SharkOrder,
    PersonalInfo_UserMoney,
    PersonalInfo_CutAndShare,
    PersonalInfo_System,
    
    PersonalInfo_Invalid
};

//订单
enum{
    Order_listAll = 0,
    Order_Category,
    
    Order_Invalid
};

//收获地址
enum{
   Address_userShopping = 0,
   Address_Invalid,
};

//我的云票
enum{
    userXNBOrder = 0,
    UserCloudTicket ,
    UserAccountMoney,
    
    UserMoneyInvalid,
};

//钱包
enum{
    Money_listAll = 0,
    Money_Category,
    
    Money_Invalid
};

enum{
    Call_Recharge,
    Call_Sign,
    
    Call_Invalid
};

//系统
enum{
    System_About = 0,
    System_Question,
    System_Setting,
    
    System_Invalid
};

//提成
enum{
    User_Cut = 0,
//    User_Share,
    
    User_Invalid
};

#endif
