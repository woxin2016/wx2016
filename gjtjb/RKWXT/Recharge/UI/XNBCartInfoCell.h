//
//  XNBCartInfoCell.h
//  RKWXT
//
//  Created by app on 16/5/4.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"
@protocol XNBCartInfoCellDelegate;
@class XNBBalanceEntity;
@interface XNBCartInfoCell : WXUITableViewCell
@property (nonatomic,weak)id<XNBCartInfoCellDelegate> delegate;
@end

@protocol XNBCartInfoCellDelegate <NSObject>
- (void)clickBtnCartInfoWithIndex:(NSInteger)index;
@end
