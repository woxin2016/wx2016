//
//  VirtualTopImgCell.h
//  RKWXT
//
//  Created by app on 16/4/6.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@protocol VirtualTopImgCellDelegate <NSObject>
- (void)virtualClickTopGoodAtIndex:(NSInteger)index;
@end

@interface VirtualTopImgCell : WXUITableViewCell
@property (nonatomic,weak)id<VirtualTopImgCellDelegate> delegate;
+ (instancetype)VirtualTopImgCellWithTabelView:(UITableView*)tableView;
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier imageArray:(NSArray *)imageArray;
@end
