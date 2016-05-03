//
//  MakeOrderModel.m
//  RKWXT
//
//  Created by SHB on 15/6/26.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "MakeOrderModel.h"
#import "WXTURLFeedOBJ.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "GoodsInfoEntity.h"
#import "NewUserAddressModel.h"
#import "AreaEntity.h"
#import "NSObject+SBJson.h"

@interface MakeOrderModel(){
    NSMutableArray *_dataList;
}
@end

@implementation MakeOrderModel
@synthesize data = _dataList;

-(void)toInit{
    [super toInit];
    [_dataList removeAllObjects];
}

-(id)init{
    self = [super init];
    if(self){
        _dataList = [[NSMutableArray alloc] init];
    }
    return self;
}

-(BOOL)shouldDataReload{
    return self.status == E_ModelDataStatus_Init || self.status == E_ModelDataStatus_LoadFailed;
}

-(void)submitOrderDataWithTotalMoney:(CGFloat)totalMoney factPay:(CGFloat)fectPay redPac:(CGFloat)redPacket carriage:(CGFloat)carriage remark:(NSString *)remark goodsInfo:(NSString *)goodsInfo{
    [self setStatus:E_ModelDataStatus_Loading];
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    AreaEntity *entity = [self addressEntity];
    
    if(!entity){
        [UtilTool showRoundView:@"请设置收货信息"];
    }
    
    NSString *address = [NSString stringWithFormat:@"%@%@%@%@",entity.proName,entity.cityName,entity.disName,entity.address];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"iOS", @"pid",
                         [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts",
                         userObj.wxtID, @"woxin_id",
                         userObj.user, @"phone",
                         [NSNumber numberWithInt:entity.proID], @"provincial_id",
                         entity.userName, @"consignee",
                         entity.userPhone, @"telephone",
                         address, @"address",
                         [NSNumber numberWithFloat:totalMoney], @"order_total_money",
                         [NSNumber numberWithFloat:fectPay], @"total_fee",
                         [NSNumber numberWithFloat:redPacket], @"red_packet",
                         [NSNumber numberWithFloat:carriage], @"postage",
                         remark, @"remark",
                         goodsInfo, @"goods_info",
                         nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"iOS", @"pid",
                             [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts",
                             userObj.wxtID, @"woxin_id",
                             userObj.user, @"phone",
                             [NSNumber numberWithInt:entity.proID], @"provincial_id",
                             entity.userName, @"consignee",
                             entity.userPhone, @"telephone",
                             address, @"address",
                             [NSNumber numberWithFloat:totalMoney], @"order_total_money",
                             [NSNumber numberWithFloat:fectPay], @"total_fee",
                             [NSNumber numberWithFloat:redPacket], @"red_packet",
                             [NSNumber numberWithFloat:carriage], @"postage",
                             remark, @"remark",
                             goodsInfo, @"goods_info",
                             [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign",
                             nil];
    __block MakeOrderModel *blockSelf = nil;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_MakeOrder httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            [blockSelf setStatus:E_ModelDataStatus_LoadFailed];
            if (_delegate && [_delegate respondsToSelector:@selector(makeOrderFailed:)]){
                [_delegate makeOrderFailed:retData.errorDesc];
            }
        }else{
            [blockSelf setStatus:E_ModelDataStatus_LoadSucceed];
            _orderID = [[retData.data objectForKey:@"data"] objectForKey:@"order_id"];
            if (_delegate && [_delegate respondsToSelector:@selector(makeOrderSucceed)]){
                [_delegate makeOrderSucceed];
            }
        }
    }];
}

/*
 接口名称:下单
 接口地址:https://oldyun.67call.com/wx10api/V1/seckill_order.php
 请求方式:POST
 输入参数
 pid:平台类型(android,ios),
 ts:时间戳,
 woxin_id:我信ID
 phone: 登录的手机号
 provincial_id: 省份ID
 consignee：联系人姓名
 address: 联系人地址
 telephone：联系人电话
 order_total_money：订单总金额 = 商品的价格*数量
 total_fee：实际支付总金额 = 订单总金额+邮费-红包
 red_packet：红包
 postage : 邮费
 remark：备注
 sign: 签名
 goods_id:商品ID
 goods_info : 库存ID:数量 10931:1^23832:2
 */
-(void)limitSubmitOrderDataWithTotalMoney:(CGFloat)totalMoney factPay:(CGFloat)fectPay redPac:(CGFloat)redPacket carriage:(CGFloat)carriage remark:(NSString *)remark goodsInfo:(NSString *)goodsInfo inventory:(NSString*)inventory goodsID:(NSString*)goodsID{
    [self setStatus:E_ModelDataStatus_Loading];
    
    
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    AreaEntity *entity = [self addressEntity];
    
    if(!entity){
        [UtilTool showRoundView:@"请设置收货信息"];
    }
    
    NSString *address = [NSString stringWithFormat:@"%@%@%@%@",entity.proName,entity.cityName,entity.disName,entity.address];
    NSMutableDictionary *baseDic = [NSMutableDictionary dictionary];
    baseDic[@"pid"]= @"ios";
    baseDic[@"ts"]= [NSNumber numberWithInt:(int)[UtilTool timeChange]];
    baseDic[@"woxin_id"]= userObj.wxtID;
    baseDic[@"phone"]= userObj.user;
    baseDic[@"provincial_id"]= [NSNumber numberWithInt:entity.proID];
    baseDic[@"consignee"]= entity.userName;
    baseDic[@"address"]= address;
    baseDic[@"telephone"]= entity.userPhone;
    baseDic[@"order_total_money"]= [NSNumber numberWithFloat:totalMoney];
    baseDic[@"total_fee"]= [NSNumber numberWithFloat:fectPay];
    baseDic[@"red_packet"]= [NSNumber numberWithFloat:redPacket];
    baseDic[@"postage"]= [NSNumber numberWithFloat:carriage];
    baseDic[@"remark"]= remark;
    baseDic[@"goods_info"] = goodsInfo;
    baseDic[@"goods_id"] = goodsID;
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"pid"]= @"ios";
    dic[@"ts"]= [NSNumber numberWithInt:(int)[UtilTool timeChange]];
    dic[@"woxin_id"]= userObj.wxtID;
    dic[@"phone"]= userObj.user;
    dic[@"provincial_id"]= [NSNumber numberWithInt:entity.proID];
    dic[@"consignee"]= entity.userName;
    dic[@"address"]= address;
    dic[@"telephone"]= entity.userPhone;
    dic[@"order_total_money"]= [NSNumber numberWithFloat:totalMoney];
    dic[@"total_fee"]= [NSNumber numberWithFloat:fectPay];
    dic[@"red_packet"]= [NSNumber numberWithFloat:redPacket];
    dic[@"postage"]= [NSNumber numberWithFloat:carriage];
    dic[@"remark"]= remark;
    dic[@"goods_info"] = goodsInfo;
    dic[@"goods_id"] = goodsID;
    dic[@"sign"]= [UtilTool md5:[UtilTool allPostStringMd5:baseDic]];
    
    NSLog(@"%@",dic);
    
    __block MakeOrderModel *blockSelf = nil;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_MakeLimitOrder httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if (retData.code != 0){
            [blockSelf setStatus:E_ModelDataStatus_LoadFailed];
            if (_delegate && [_delegate respondsToSelector:@selector(makeOrderFailed:)]){
                [_delegate makeOrderFailed:retData.errorDesc];
            }
        }else{
            [blockSelf setStatus:E_ModelDataStatus_LoadSucceed];
            _orderID = [[retData.data objectForKey:@"data"] objectForKey:@"order_id"];
            if (_delegate && [_delegate respondsToSelector:@selector(makeOrderSucceed)]){
                [_delegate makeOrderSucceed];
            }
        }
    }];
    
    
}

//暂时不用
-(NSArray*)changeTypeWithOldArr:(NSArray*)oldArr{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for(NSDictionary *dic in oldArr){
        NSString *str = [dic JSONRepresentation];
        [arr addObject:str];
    }
    return arr;
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
