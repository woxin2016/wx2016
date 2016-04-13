//
//  VirtualOrderInfoVC.h
//  RKWXT
//
//  Created by app on 16/4/11.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "WXUIViewController.h"
@class virtualOrderListEntity;
@interface VirtualOrderInfoVC : WXUIViewController
@property (nonatomic,strong)virtualOrderListEntity *entity;
@property (nonatomic,assign)BOOL isAppearPay;
@end
