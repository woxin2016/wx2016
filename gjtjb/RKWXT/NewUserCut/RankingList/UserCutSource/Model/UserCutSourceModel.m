//
//  UserCutSourceModel.m
//  RKWXT
//
//  Created by SHB on 15/12/8.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "UserCutSourceModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "UserCutSourceEntity.h"

@interface UserCutSourceModel(){
    NSMutableArray *_sourceArr;
}
@end

@implementation UserCutSourceModel
@synthesize sourceArr = _sourceArr;

-(id)init{
    self = [super init];
    if(self){
        _sourceArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)parseUserCutSourceData:(NSArray*)data{
//    if(!dic){
//        return;
//    }
    
    [_sourceArr removeAllObjects];
    
    for (NSDictionary *dict in data) {
        UserCutSourceEntity *entity = [UserCutSourceEntity initUserCutSourceEntityWith:dict];
        [_sourceArr addObject:entity];
    }
    
//    NSInteger count = 0;
//    NSArray *keys = [dic allKeys];
//    for(NSString *name in keys){
//        for(NSDictionary *dic1 in [dic objectForKey:name]){
//            UserCutSourceEntity *entity = [UserCutSourceEntity initUserCutSourceEntityWith:dic1];
//            if(![entity.imgUrl isEqualToString:@""]){
//                entity.imgUrl = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.imgUrl];
//            }
//            NSString *key = [keys objectAtIndex:count];
//            if([key isEqualToString:@"p1"]){
//                entity.grade = @"一级";
//            }
//            if([key isEqualToString:@"p2"]){
//                entity.grade = @"二级";
//            }
//            if([key isEqualToString:@"p3"]){
//                entity.grade = @"三级";
//            }
//            [_sourceArr addObject:entity];
//        }
//        count ++;
//    }
    
    
}

/*：
 pid:平台类型(android,ios,web),
 ver:版本号,
 ts:时间戳,
 sid : 商家ID
 woxin_id : 我信ID
 phone:登录的手机号
 sign: 签名
 */

-(void)loadUserCutSource{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSMutableDictionary *baseDic = [NSMutableDictionary dictionary];
    baseDic[@"pid"]= @"ios";
    baseDic[@"ver"]= [UtilTool currentVersion];
    baseDic[@"ts"]= [NSNumber numberWithInt:(int)[UtilTool timeChange]];
    baseDic[@"woxin_id"]= userObj.wxtID;
    baseDic[@"phone"]= userObj.user;
    baseDic[@"sid"]= userObj.sellerID;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"pid"]= @"ios";
    dic[@"ver"]= [UtilTool currentVersion];
    dic[@"ts"]= [NSNumber numberWithInt:(int)[UtilTool timeChange]];
    dic[@"woxin_id"]= userObj.wxtID;
    dic[@"phone"]= userObj.user;
    dic[@"sid"]= userObj.sellerID;
    dic[@"sign"]= [UtilTool md5:[UtilTool allPostStringMd5:baseDic]];
    
    __block UserCutSourceModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_UserCutSource httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(loadUserCutSourceFailed:)]){
                [_delegate loadUserCutSourceFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseUserCutSourceData:[retData.data objectForKey:@"data"]];
            if(_delegate && [_delegate respondsToSelector:@selector(loadUserCutSourceSucceed)]){
                [_delegate loadUserCutSourceSucceed];
            }
        }
    }];
}

@end
