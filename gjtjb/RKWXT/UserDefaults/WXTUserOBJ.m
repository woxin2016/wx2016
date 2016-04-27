//
//  WXTUserOBJ.m
//  RKWXT
//
//  Created by SHB on 15/3/13.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTUserOBJ.h"
#import "WXTUserDefault.h"
#import "KeychainItemWrapper.h"
@implementation WXTUserOBJ

-(id)init{
    if (self = [super init]) {
        _userKeyChainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"wxt_user" accessGroup:@"woxin"];
        _passwdKeyChainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"wxt_passwd" accessGroup:@"woxin"];
    }
    return self;
}

+(WXTUserOBJ*)sharedUserOBJ{
    static dispatch_once_t onceToken;
    static WXTUserOBJ *sharedUserOBJ = nil;
    dispatch_once(&onceToken,^{
        sharedUserOBJ = [[WXTUserOBJ alloc] init];
    });
    return sharedUserOBJ;
}

-(void)setWxtID:(NSString *)wxtID{
    WXTUserDefault *userDefault = [WXTUserDefault sharedWXUserDefault];
    [userDefault setObject:wxtID forKey:WXT_Userdefault_WxtID];
#if TARGET_IPHONE_SIMULATOR
    [_userKeyChainItem setObject:wxtID forKey:kV_Data];
#endif
}

-(void)setUser:(NSString *)user{
    WXTUserDefault *userDefault = [WXTUserDefault sharedWXUserDefault];
    [userDefault setObject:user forKey:WXT_Userdefault_User];
}

-(void)setNickname:(NSString *)nickname{
    WXTUserDefault *userDefault = [WXTUserDefault sharedWXUserDefault];
    [userDefault setObject:nickname forKey:WXT_Userdefault_Nickname];
}

-(void)setSellerID:(NSString*)sellerID{
    WXTUserDefault *userDefault = [WXTUserDefault sharedWXUserDefault];
    [userDefault setObject:sellerID forKey:WXT_Userdefault_SellerID];
}

-(void)setSellerName:(NSString *)sellerName{
    WXTUserDefault *userDefault = [WXTUserDefault sharedWXUserDefault];
    [userDefault setObject:sellerName forKey:WXT_Userdefault_SellerName];
}

-(void)setShopID:(NSString*)ShopID{
    WXTUserDefault *userDefault = [WXTUserDefault sharedWXUserDefault];
    [userDefault setObject:ShopID forKey:WXT_Userdefault_ShopID];
}

-(void)setShopName:(NSString *)shopName{
    WXTUserDefault *userDefault = [WXTUserDefault sharedWXUserDefault];
    [userDefault setObject:shopName forKey:WXT_Userdefault_ShopName];
}

-(void)setShareInfo:(NSString *)shareInfo{
    WXTUserDefault *userDefault = [WXTUserDefault sharedWXUserDefault];
    [userDefault setObject:shareInfo forKey:WXT_Userdefault_ShareInfo];
}

-(void)setShareUserCutInfo:(NSString *)cutInfo{
    WXTUserDefault *userDefault = [WXTUserDefault sharedWXUserDefault];
    [userDefault setObject:cutInfo forKey:WXT_Userdefault_UserCutInfo];
}

-(void)setUserIdentity:(NSString *)identity{
    WXTUserDefault *userDefault = [WXTUserDefault sharedWXUserDefault];
    [userDefault setObject:identity forKey:WXT_Userdefault_UserIdentity];
}

-(void)setPwd:(NSString *)pwd{
    WXTUserDefault *userDefault = [WXTUserDefault sharedWXUserDefault];
    [userDefault setObject:pwd forKey:WXT_Userdefault_Pwd];
#if TARGET_IPHONE_SIMULATOR
    [_passwdKeyChainItem setObject:pwd forKey:kV_Data];
#endif
}

-(void)setToken:(NSString *)token{
    WXTUserDefault *userDefault = [WXTUserDefault sharedWXUserDefault];
    [userDefault setObject:token forKey:WXT_Userdefault_Token];
}

-(void)setSmsID:(int)smsID{
    WXTUserDefault *userDefault = [WXTUserDefault sharedWXUserDefault];
    [userDefault setInteger:smsID forKey:WXT_Userdefault_SmsID];
}

-(NSString*)wxtID{
    WXTUserDefault *userDefault = [WXTUserDefault sharedWXUserDefault];
    return [userDefault textValueForKey:WXT_Userdefault_WxtID];
#if TARGET_IPHONE_SIMULATOR
    return [_userKeyChainItem objectForKey:kV_Data];
#endif
}

-(NSString*)user{
    WXTUserDefault *userDefault = [WXTUserDefault sharedWXUserDefault];
    return [userDefault textValueForKey:WXT_Userdefault_User];
}

-(NSString*)nickname{
    WXTUserDefault *userDefault = [WXTUserDefault sharedWXUserDefault];
    return [userDefault textValueForKey:WXT_Userdefault_Nickname];
}

-(NSString*)pwd{
    WXTUserDefault *userDefault = [WXTUserDefault sharedWXUserDefault];
    return [userDefault textValueForKey:WXT_Userdefault_Pwd];
#if TARGET_IPHONE_SIMULATOR
    return [_passwdKeyChainItem objectForKey:kV_Data];
#endif
}

-(NSString*)token{
    WXTUserDefault *userDefault = [WXTUserDefault sharedWXUserDefault];
    return [userDefault textValueForKey:WXT_Userdefault_Token];
}

-(int)smsID{
    WXTUserDefault *userDefault = [WXTUserDefault sharedWXUserDefault];
    return (int)[userDefault integerValueForKey:WXT_Userdefault_SmsID];
}

-(NSString*)sellerID{
    WXTUserDefault *userDefault = [WXTUserDefault sharedWXUserDefault];
    return [userDefault textValueForKey:WXT_Userdefault_SellerID];
}

-(NSString*)sellerName{
    WXTUserDefault *userDefault = [WXTUserDefault sharedWXUserDefault];
    return [userDefault textValueForKey:WXT_Userdefault_SellerName];
}

-(NSString*)shopID{
    WXTUserDefault *userDefault = [WXTUserDefault sharedWXUserDefault];
    return [userDefault textValueForKey:WXT_Userdefault_ShopID];
}

-(NSString*)shopName{
    WXTUserDefault *userDefault = [WXTUserDefault sharedWXUserDefault];
    return [userDefault textValueForKey:WXT_Userdefault_ShopName];
}

-(NSString*)shareInfo{
    WXTUserDefault *userDefault = [WXTUserDefault sharedWXUserDefault];
    return [userDefault textValueForKey:WXT_Userdefault_ShareInfo];
}

-(NSString*)userCutInfo{
    WXTUserDefault *userDefault = [WXTUserDefault sharedWXUserDefault];
    return [userDefault textValueForKey:WXT_Userdefault_UserCutInfo];
}

-(NSString*)userIentifier{
    WXTUserDefault *userDefault = [WXTUserDefault sharedWXUserDefault];
    return [userDefault textValueForKey:WXT_Userdefault_UserIdentity];
}

- (void)removeAllUserInfo{
    WXTUserDefault *userDefault = [WXTUserDefault sharedWXUserDefault];
    [userDefault removeObjectForKey:WXT_Userdefault_WxtID];
    [userDefault removeObjectForKey:WXT_Userdefault_Token];
    [userDefault removeObjectForKey:WXT_Userdefault_User];
    [userDefault removeObjectForKey:WXT_Userdefault_Pwd];
    [userDefault removeObjectForKey:WXT_Userdefault_SmsID];
    [userDefault removeObjectForKey:WXT_Userdefault_Nickname];
    [userDefault removeObjectForKey:WXT_Userdefault_SellerID];
    [userDefault removeObjectForKey:WXT_Userdefault_ShopID];
    [userDefault removeObjectForKey:WXT_Userdefault_ShopName];
    [userDefault removeObjectForKey:WXT_Userdefault_ShareInfo];
    [userDefault removeObjectForKey:WXT_Userdefault_UserCutInfo];
}

@end
