//
//  VirtualGoodsOrderModel.m
//  RKWXT
//
//  Created by app on 16/4/7.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "VirtualGoodsOrderModel.h"
#import "VirtualGoodsInfoEntity.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "NewUserAddressModel.h"
#import "AreaEntity.h"
#import "VirtualOrderInfoEntity.h"

@implementation VirtualGoodsOrderModel

/*
 接口名称：兑换商城订单写入,只能买一个商品
 接口地址：https://oldyun.67call.com/wx10api/V1/insert_exchange_order.php
 请求方式：POST
 输入参数：
 pid:平台类型(android,ios,web),
 ver:版本号,
 ts:时间戳,
 sid : 商家ID
 woxin_id : 我信ID
 phone:登录的手机号
 consignee:收件人姓名
 telephone:收件人电话
 address:地址
 sign: 签名

 
 goods_stock_id:库存ID
 total_fee: 应支付金额 , 品牌商城 : total_fee = goods_price+postage , 兑换商城: total = postage
 goods_price : 商品价格
 xnb_1: 云票
 back_money : 返现
 postage : 邮费
 
 */

- (void)submitOrdersVitrtualWithType:(VirtualGoodsOrderType)type orderInfo:(VirtualOrderInfoEntity*)orderInfo remark:(NSString *)remark{
    NSNumber * money= nil;
    if (type == VirtualGoodsOrderType_Store) {
        money = [NSNumber numberWithFloat:orderInfo.postage];
        orderInfo.goodsPrice = 0.0;
    }else{
        CGFloat price = orderInfo.postage + orderInfo.goodsPrice * orderInfo.buyNumber;
        money = [NSNumber numberWithFloat:price];
    }
    
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    AreaEntity *entity = [self addressEntity];
    if(!entity){
        [UtilTool showRoundView:@"请设置收货信息"];
    }
    NSString *address = [NSString stringWithFormat:@"%@%@%@%@",entity.proName,entity.cityName,entity.disName,entity.address];
    NSMutableDictionary *baseDic = [NSMutableDictionary dictionary];
    baseDic[@"pid"]= @"ios";
    baseDic[@"ver"]= [UtilTool currentVersion];
    baseDic[@"ts"]= [NSNumber numberWithInt:(int)[UtilTool timeChange]];
    baseDic[@"woxin_id"]= userObj.wxtID;
    baseDic[@"phone"]= userObj.user;
    baseDic[@"sid"]= [NSNumber numberWithInt:(int)kMerchantID];
    baseDic[@"address"]= address;
    baseDic[@"consignee"]= entity.userName;
    baseDic[@"telephone"]= entity.userPhone;
    baseDic[@"goods_stock_id"]= [NSNumber numberWithInteger:orderInfo.stockID];
    baseDic[@"total_fee"]= money;
    baseDic[@"goods_price"]= [NSNumber numberWithFloat:orderInfo.goodsPrice];
    baseDic[@"xnb_1"]= [NSNumber numberWithFloat:orderInfo.xnbPrice];
    baseDic[@"back_money"]= [NSNumber numberWithFloat:orderInfo.backMoney];
    baseDic[@"postage"]= [NSNumber numberWithFloat:orderInfo.postage];
    baseDic[@"remark"] =remark;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"pid"]= @"ios";
    dic[@"ver"]= [UtilTool currentVersion];
    dic[@"ts"]= [NSNumber numberWithInt:(int)[UtilTool timeChange]];
    dic[@"woxin_id"]= userObj.wxtID;
    dic[@"phone"]= userObj.user;
    dic[@"sid"]= [NSNumber numberWithInt:(int)kMerchantID];
    dic[@"sign"]= [UtilTool md5:[UtilTool allPostStringMd5:baseDic]];
    dic[@"address"]= address;
    dic[@"consignee"]= entity.userName;
    dic[@"telephone"]= entity.userPhone;
    dic[@"goods_stock_id"]= [NSNumber numberWithInteger:orderInfo.stockID];
    dic[@"total_fee"]= money;
    dic[@"goods_price"]= [NSNumber numberWithFloat:orderInfo.goodsPrice];
    dic[@"xnb_1"]= [NSNumber numberWithFloat:orderInfo.xnbPrice];
    dic[@"back_money"]= [NSNumber numberWithFloat:orderInfo.backMoney];
    dic[@"postage"]= [NSNumber numberWithFloat:orderInfo.postage];
    dic[@"remark"] =remark;
    
    __block typeof(self) blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_VirtualOrder httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            
          if (_delegate && [_delegate respondsToSelector:@selector(virtualGoodsOrderFailed:)]) {
                [_delegate virtualGoodsOrderFailed:retData.errorDesc];
            }
            
        }else{
             [blockSelf analyticalProcessingData:retData.data[@"data"]];
            if (_delegate && [_delegate respondsToSelector:@selector(virtualGoodsOrderSuccend)]) {
                [_delegate virtualGoodsOrderSuccend];
            }
            
        }
    }];
}

- (void)analyticalProcessingData:(NSDictionary*)dict{
    self.order = [VirtualOrderInfoEntity virtualOrderInfoEntityWithDict:dict];
}


-(AreaEntity *)addressEntity{
    if([[NewUserAddressModel shareUserAddress].userAddressArr count] == 0){
        return nil;
    }
    AreaEntity *entity = nil;
    for(AreaEntity *ent in [NewUserAddressModel shareUserAddress].userAddressArr){
        if(ent.normalID == 1){
            entity = ent;
        }
    }
    return entity;
}



@end
