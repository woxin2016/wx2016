//
//  BalancePhoneCell.h
//  RKWXT
//
//  Created by app on 16/5/4.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BalancePhoneCellDelegate;
@interface BalancePhoneCell : WXUITableViewCell
@property (nonatomic,weak)id<BalancePhoneCellDelegate> delegate;

@end


@protocol BalancePhoneCellDelegate <NSObject>
- (void)textFiledPhoneValueDidChanged:(NSString*)text;
@end