//
//  JPushMsgEntity.h
//  RKWXT
//
//  Created by SHB on 15/7/2.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPushMsgEntity : NSObject
@property (nonatomic,strong) NSString *content;  //消息头
@property (nonatomic,strong) NSString *abstract;  //摘要
@property (nonatomic,strong) NSString *msgURL;
@property (nonatomic,assign) NSInteger push_id;
@property (nonatomic,strong) NSString *pushTime;
@property (nonatomic,strong) NSString  *toView; // 是否已读 0 为未读 1为已读

+(JPushMsgEntity*)initWithJPushMessageWithDic:(NSDictionary*)dic;
+(JPushMsgEntity*)initWithJPushCloseMessageWithDic:(NSDictionary*)dic;

@end
