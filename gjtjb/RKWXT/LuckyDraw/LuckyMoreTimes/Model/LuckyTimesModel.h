//
//  LuckyTimesModel.h
//  RKWXT
//
//  Created by SHB on 16/3/19.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LuckyTimesModel : NSObject
-(void)luckyTimesChangeWithNumber:(NSInteger)num completion:(void(^)(NSDictionary* retDic))completion;

@end
