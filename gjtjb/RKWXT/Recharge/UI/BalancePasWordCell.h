//
//  BalancePasWordCell.h
//  RKWXT
//
//  Created by app on 16/5/5.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"
@protocol BalancePasWordCellDelegate;
@interface BalancePasWordCell : WXUITableViewCell
@property (nonatomic,weak)id<BalancePasWordCellDelegate> delegate;
@end

@protocol BalancePasWordCellDelegate <NSObject>
- (void)passWordTextFiledPhoneValueDidChanged:(NSString*)text;
@end