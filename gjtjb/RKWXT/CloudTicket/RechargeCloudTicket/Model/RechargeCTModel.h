//
//  RechargeCTModel.h
//  RKWXT
//
//  Created by SHB on 16/4/7.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RechargeCTModel : NSObject
-(void)rechargeUserCloudTicketWith:(NSString*)cartID andPwd:(NSString*)pwd completion:(void(^)(NSInteger code, NSString *errorMsg))completion;

@end
