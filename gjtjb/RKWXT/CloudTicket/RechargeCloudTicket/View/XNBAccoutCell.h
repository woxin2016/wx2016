//
//  XNBAccoutCell.h
//  RKWXT
//
//  Created by app on 16/5/23.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@protocol XNBAccoutCellDelegate;
@interface XNBAccoutCell : WXUITableViewCell
@property (nonatomic,weak)id <XNBAccoutCellDelegate> delegate;

@end


@protocol XNBAccoutCellDelegate <NSObject>
@optional
- (void)textFiledValueDidChanged:(NSString*)text;

@end