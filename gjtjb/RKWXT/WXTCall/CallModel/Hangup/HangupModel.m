//
//  HangupModel.m
//  RKWXT
//
//  Created by SHB on 15/4/21.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "HangupModel.h"
#import "WXTURLFeedOBJ.h"
#import "WXTURLFeedOBJ+NewData.h"

@implementation HangupModel

-(id)init{
    self = [super init];
    if(self){
    }
    return self;
}

-(void)hangupWithCallID:(NSString *)callID{
    if(!callID){
        return;
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"hangup", @"cmd", callID, @"call_id", nil];
    [[WXTURLFeedOBJ sharedURLFeedOBJ] fetchNewDataFromFeedType:WXT_UrlFeed_Type_HungUp httpMethod:WXT_HttpMethod_Post timeoutIntervcal:-1 feed:dic completion:^(URLFeedData *retData){
        if (retData.code != 0){
            if (_hangupDelegate && [_hangupDelegate respondsToSelector:@selector(hangupFailed:)]){
                [_hangupDelegate hangupFailed:retData.errorDesc];
            }
        }else{
            if (_hangupDelegate && [_hangupDelegate respondsToSelector:@selector(hangupSucceed)]){
                [_hangupDelegate hangupSucceed];
            }
        }
    }];
}

@end

