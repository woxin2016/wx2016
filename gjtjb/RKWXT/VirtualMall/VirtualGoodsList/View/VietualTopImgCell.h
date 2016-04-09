//
//  VietualTopImgCell.h
//  RKWXT
//
//  Created by app on 16/4/5.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@protocol VietualTopImgCellDelegate ;
@interface VietualTopImgCell : WXUITableViewCell
@property (nonatomic,weak)id<VietualTopImgCellDelegate> delegate;
+ (instancetype)viteualTopImgCellWithTabelView:(UITableView*)tableView;
@end


@protocol VietualTopImgCellDelegate <NSObject>
- (void)clickTopGoodAtIndex:(NSInteger)index;
@end