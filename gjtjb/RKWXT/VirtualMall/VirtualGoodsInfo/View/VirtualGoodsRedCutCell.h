//
//  VirtualGoodsRedCutCell.h
//  RKWXT
//
//  Created by app on 16/4/7.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VirtualGoodsRedCutCellDelegate <NSObject>

- (void)VirtualGoodsInfoDesCutBtnClicked;
- (void)VirtualGoodsInfoDesCarriageBtnClicked;
- (void)VirtualGoodsInfoDesredPacketBtnClicked;

@end

@interface VirtualGoodsRedCutCell : WXUITableViewCell
@property (nonatomic,weak)id <VirtualGoodsRedCutCellDelegate> delegate;
- (void)isAppearRed:(NSInteger)red cut:(NSInteger)cut posgate:(NSInteger)posgate;
+ (instancetype)VirtualGoodsRedCutCellWithTabelView:(UITableView*)tableView;

@end
