//
//  SellerChangeModel.m
//  RKWXT
//
//  Created by SHB on 16/3/29.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "SellerChangeModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "SellerListEntity.h"

@interface SellerChangeModel(){
    NSMutableArray *_sellerArr;
    NSInteger start;
}

@end

@implementation SellerChangeModel
@synthesize sellerArr = _sellerArr;

-(id)init{
    self = [super init];
    if(self){
        _sellerArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)parseSellerListData:(NSArray*)data{
    if(start == 0){
        [_sellerArr removeAllObjects];
    }
    if([data count] == 0){
        return;
    }
    for(NSDictionary *dic in data){
        SellerListEntity *entity = [SellerListEntity initSellerListEntityWithDic:dic];
        entity.logoImg = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.logoImg];
        [_sellerArr addObject:entity];
    }
}

-(void)loadSellerListArr:(NSInteger)startItem length:(NSInteger)length withText:(NSString *)text{
    start = startItem;
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [NSNumber numberWithInteger:startItem], @"start_item", [NSNumber numberWithInteger:length], @"length", [NSNumber numberWithInt:1], @"type", text, @"seek_txt", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", [NSNumber numberWithInteger:startItem], @"start_item", [NSNumber numberWithInteger:length], @"length", [NSNumber numberWithInt:1], @"type", text, @"seek_txt", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
    __block SellerChangeModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_ChangeSeller httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            if([text isEqualToString:@""]){
                if(_delegate && [_delegate respondsToSelector:@selector(loadSellerListArrFailed:)]){
                    [_delegate loadSellerListArrFailed:retData.errorDesc];
                }
            }
        }else{
            [blockSelf parseSellerListData:[retData.data objectForKey:@"data"]];
            if(_delegate && [_delegate respondsToSelector:@selector(loadSellerListArrSucceed)]){
                [_delegate loadSellerListArrSucceed];
            }
        }
    }];
}

//切换商家后通知后台
-(void)setUserChangeSeller{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSString *pwd = [UtilTool md5:userObj.pwd];
    NSDictionary *baseDic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.user, @"phone", pwd, @"pwd", [NSNumber numberWithInt:2], @"type", userObj.sellerID, @"seller_id", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS", @"pid", [NSNumber numberWithInt:(int)[UtilTool timeChange]], @"ts", userObj.user, @"phone", pwd, @"pwd", [NSNumber numberWithInt:2], @"type", userObj.sellerID, @"seller_id", [UtilTool md5:[UtilTool allPostStringMd5:baseDic]], @"sign", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_ChangeSeller httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
    }];
}

@end
