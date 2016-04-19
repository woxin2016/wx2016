//
//  LoginModel.h
//  RKWXT
//
//  Created by SHB on 15/3/12.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginModel : NSObject
-(void)loginWithUser:(NSString*)userStr pwd:(NSString*)pwdStr completion:(void(^)(NSInteger code, NSString *errorMsg))completion;
- (void)sendUserMessage;
@end
