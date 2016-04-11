//
//  UserAliAccountStateCell.h
//  RKWXT
//
//  Created by SHB on 16/4/7.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

#define UserAliAccountStateCellHeight (200)

@protocol UserAliAccountStateCellDelegate;

@interface UserAliAccountStateCell : WXUITableViewCell
@property (nonatomic,weak) id<UserAliAccountStateCellDelegate>delegate;
@property (nonatomic,assign) BOOL isAdded;
@end

@protocol UserAliAccountStateCellDelegate <NSObject>
-(void)userSubmitAliAccountBtnClicked:(id)sender;

@end
