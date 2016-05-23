//
//  XNBPassWordCell.h
//  RKWXT
//
//  Created by app on 16/5/23.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@protocol XNBPassWordCellDelegate;
@interface XNBPassWordCell : WXUITableViewCell
@property (nonatomic,weak)id <XNBPassWordCellDelegate> delegate;

@end

@protocol XNBPassWordCellDelegate <NSObject>
@optional
- (void)textFiledPassWordValueDidChanged:(NSString*)text;

@end