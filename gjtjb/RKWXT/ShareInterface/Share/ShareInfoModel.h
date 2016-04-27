//
//  ShareInfoModel.h
//  RKWXT
//
//  Created by SHB on 16/3/1.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareInfoModel : NSObject

+(ShareInfoModel*)shareInfoModel;
-(void)loadUserShareInfo;
-(void)loadUserShareCutInfo;

@end
