//
//  BalanceAccountCell.h
//  RKWXT
//
//  Created by app on 16/5/5.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@protocol BalanceAccountCellDelegate;
@interface BalanceAccountCell : WXUITableViewCell
@property (nonatomic,weak)id<BalanceAccountCellDelegate> delegate;
@end

@protocol BalanceAccountCellDelegate <NSObject>
- (void)accountTextFiledPhoneValueDidChanged:(NSString*)text;
@end