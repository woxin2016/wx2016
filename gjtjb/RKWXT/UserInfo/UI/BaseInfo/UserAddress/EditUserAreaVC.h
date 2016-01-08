//
//  EditUserAreaVC.h
//  RKWXT
//
//  Created by SHB on 16/1/8.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WXUIViewController.h"
#import "AreaEntity.h"

typedef enum{
    UserArea_Type_Insert = 0,
    UserArea_Type_Modify,
    
    UserArea_Type_Invalid
}UserArea_Type;

@interface EditUserAreaVC : WXUIViewController
@property (nonatomic,assign) UserArea_Type address_type;
@property (nonatomic,strong) AreaEntity *entity;

@end
