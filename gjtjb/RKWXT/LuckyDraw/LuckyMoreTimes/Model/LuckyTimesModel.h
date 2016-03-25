//
//  LuckyTimesModel.h
//  RKWXT
//
//  Created by SHB on 16/3/19.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

#define D_Notification_Name_LuckyTimesModel_Failed  @"D_Notification_Name_LuckyTimesModel_Failed"

typedef enum{
    LuckyTimes_ReaquestType_Number = 1,
    LuckyTimes_ReaquestType_Exchage,
}LuckyTimes_ReaquestType;

@interface LuckyTimesModel : NSObject
@property (nonatomic,assign)LuckyTimes_ReaquestType type;
-(void)luckyTimesChangeWithNumber:(NSInteger)num type:(LuckyTimes_ReaquestType)type completion:(void(^)(NSDictionary* retDic))completion;

@end
