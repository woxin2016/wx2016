//
//  WXTUserOBJ.h
//  RKWXT
//
//  Created by SHB on 15/3/13.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KeychainItemWrapper;
@interface WXTUserOBJ : NSObject
@property (nonatomic, strong) KeychainItemWrapper * passwdKeyChainItem;
@property (nonatomic, strong) KeychainItemWrapper * userKeyChainItem;
+(WXTUserOBJ*)sharedUserOBJ;

-(void)setWxtID:(NSString*)wxtID;  //设置我信通ID
-(void)setUser:(NSString*)user;    //设置帐号
-(void)setPwd:(NSString*)pwd;      //设置密码
-(void)setToken:(NSString*)token;  //设置令牌
-(void)setSmsID:(int)smsID;        //验证码ID
-(void)setNickname:(NSString*)nickname; //昵称
//商家信息
-(void)setSellerID:(NSString*)sellerID; //商家ID
-(void)setSellerName:(NSString*)sellerName;//商家name
-(void)setShopID:(NSString*)shopID; //店铺ID
-(void)setShopName:(NSString*)shopName; //店铺name
-(void)setShareInfo:(NSString*)shareInfo; //分享内容
-(void)setShareUserCutInfo:(NSString*)cutInfo;  //分享提成文字
-(void)setUserIdentity:(NSString*)identity; //为1说明是特殊号码，可以切换商家

-(NSString*)wxtID;
-(NSString*)user;
-(NSString*)pwd;
-(NSString*)token;
-(int)smsID;
-(NSString*)nickname;
//商家信息
-(NSString*)sellerID;
-(NSString*)sellerName;
-(NSString*)shopID;
-(NSString*)shopName;
-(NSString*)shareInfo;
-(NSString*)userCutInfo;
-(NSString*)userIentifier;

-(void)removeAllUserInfo;

@end
