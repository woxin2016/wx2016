//
//  CloudTicketListVC.h
//  RKWXT
//
//  Created by SHB on 16/4/6.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WXUIViewController.h"

typedef enum{
    CloudTicket_Type_Account = 0,   //我的云票
    CloudTicket_Type_Info,          //账目明细
}CloudTicket_Type;

@interface CloudTicketListVC : WXUIViewController
@property (nonatomic,assign) NSInteger selectedNum;
@property (nonatomic,assign) CloudTicket_Type ctType;

@end
