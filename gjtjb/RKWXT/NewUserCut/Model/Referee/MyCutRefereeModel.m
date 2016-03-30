//
//  MyCutRefereeModel.m
//  RKWXT
//
//  Created by SHB on 15/9/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "MyCutRefereeModel.h"
#import "WXTURLFeedOBJ+NewData.h"
#import "MyRefereeEntity.h"

@interface MyCutRefereeModel(){
    NSMutableArray *_myCutInfoArr;
}
@end

@implementation MyCutRefereeModel
@synthesize myCutInfoArr = _myCutInfoArr;

-(id)init{
    self = [super init];
    if(self){
        _myCutInfoArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)loadMyCutRefereeInfo{
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
    
    __block MyCutRefereeModel *blockSelf = self;
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_New_LoadMyCutInfo httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData) {
        if(retData.code != 0){
            if(_delegate && [_delegate respondsToSelector:@selector(loadMyCutRefereeInfoFailed:)]){
                [_delegate loadMyCutRefereeInfoFailed:retData.errorDesc];
            }
        }else{
            [blockSelf parseMyCutInfoDataWithDic:[retData.data objectForKey:@"data"]];
            if([_delegate respondsToSelector:@selector(loadMyCutRefereeInfoSucceed)]){
                [_delegate loadMyCutRefereeInfoSucceed];
            }
        }
    }];
}

-(void)parseMyCutInfoDataWithDic:(NSDictionary*)dic{
    if(!dic){
        return;
    }
    [_myCutInfoArr removeAllObjects];
    MyRefereeEntity *entity = [MyRefereeEntity initRefereeEntityWithDic:dic];
    entity.userIconImg = [NSString stringWithFormat:@"%@%@",AllImgPrefixUrlString,entity.userIconImg];
    [_myCutInfoArr addObject:entity];
}

@end
