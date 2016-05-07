//
//  XNBBalancePhoneCell.h
//  RKWXT
//
//  Created by app on 16/5/4.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"
@protocol XNBBalancePhoneCellDelegate;
@interface XNBBalancePhoneCell : WXUITableViewCell
@property (nonatomic,weak)id<XNBBalancePhoneCellDelegate> delegate;
@end

@protocol XNBBalancePhoneCellDelegate <NSObject>
- (void)textFiledPhoneValueDidChanged:(NSString*)text;
@end