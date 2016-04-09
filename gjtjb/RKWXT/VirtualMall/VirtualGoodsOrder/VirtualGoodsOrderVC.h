//
//  VirtualGoodsOrderVC.h
//  RKWXT
//
//  Created by app on 16/4/7.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    virtualParOrderType_Default,
    virtualParOrderType_Store,
    virtualParOrderType_Exchange
}virtualParOrderType;

@interface VirtualGoodsOrderVC : WXUIViewController
@property (nonatomic,strong)id goodsList;
@property (nonatomic,assign)virtualParOrderType type;
@end
