//
//  HomeClassifyTitleCell.h
//  RKWXT
//
//  Created by SHB on 16/3/31.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@protocol HomeClassifyTitleCellDelegate;

@interface HomeClassifyTitleCell : WXUITableViewCell
@property (nonatomic,weak) id<HomeClassifyTitleCellDelegate>delegate;
@end

@protocol HomeClassifyTitleCellDelegate <NSObject>
-(void)homeClassifyMoreBtnClicked;

@end
