//
//  BaseInfoDef.h
//  RKWXT
//
//  Created by SHB on 15/5/30.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#ifndef RKWXT_BaseInfoDef_h
#define RKWXT_BaseInfoDef_h

#define BaseInfoForUserHeadHeight        (81)
#define BaseInfoForCommonCellHeight      (44)

enum{
    T_Base_UserInfo = 0,
    
    T_Base_Invalid,
};

enum{
    BaseInfo_Userhead = 0,
    BaseInfo_Nickname,
    BaseInfo_Usersex,
    BaseInfo_Userdate,

    BaseInfo_Invalid,
};

enum{
    ManagerAddress = 0,
    
    Manager_Invalid,
};

#import "BaseInfoCommonCell.h"
#import "BaseInfoHeadCell.h"
#import "WXTResetPwdVC.h"
#import "PersonDatePickerVC.h"
#import "PersonalNickNameCell.h"
#import "PersonalSexCell.h"

#endif
