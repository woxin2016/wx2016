//
//  WXContacterModel.h
//  Woxin2.0
//
//  Created by le ting on 7/22/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kFirstKey @"*"

typedef struct {
    __unsafe_unretained NSString *name;
    __unsafe_unretained NSString *iconStr;
}S_OptContactInfo;

typedef enum {
    E_ContactDataType_OPT = 0,
    E_ContactDataType_Contacter,
}E_ContactDataType;

static S_OptContactInfo pOptInfo[] = {
    //    {kMerchantName,@"merchantIcon.png"},
    //    {@"我信团队",@"wxInsister.png"},
    //    {@"新的好友",@"newFriend.png"},
    //    {@"群聊",@"multiChat.png"},
    //    {@"所有我信好友",@"wxInsister.png"},
};


typedef enum {
//    E_ContactOPTType_Merchant = 0,//商家
//    E_ContactOPTType_WXTeam,//我信团队
//    E_ContactOPTType_NewWXFriend,//新的好友
//    E_ContactOPTType_MultiChat,//群聊
    E_ContactOPTType_WXContacter,//我信联系人
    
    E_ContactOPTType_Invalid
}E_ContactOPTType_Row;

@protocol WXContacterModelDelegate;
@interface WXContacterModel : NSObject
@property (nonatomic,assign)id<WXContacterModelDelegate>delegate;
@property (nonatomic,readonly)NSArray *contactOptArray;
@property (nonatomic,readonly)NSDictionary *sysContacterDic;
@property (nonatomic,readonly)NSArray *filterArray;

- (NSArray*)allKeys;
- (void)loadSystemContacters;
- (NSIndexPath*)indexPathFor:(ContacterEntity*)entity;


#pragma mark 搜索
//匹配~
- (void)matchSearchStringList:(NSString*)string;
- (void)removeMatchingContact;
@end

@protocol WXContacterModelDelegate <NSObject>

@end
