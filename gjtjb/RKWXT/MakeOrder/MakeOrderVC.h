//
//  MakeOrderVC.h
//  RKWXT
//
//  Created by SHB on 16/1/8.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WXUIViewController.h"

typedef enum{
    MakePayType_Normal = 0,
    MakePayType_Limit,
}MakePayType;

@interface MakeOrderVC : WXUIViewController
@property (nonatomic,strong)id  goodsList;
@property (nonatomic,assign)MakePayType payType;
@end
