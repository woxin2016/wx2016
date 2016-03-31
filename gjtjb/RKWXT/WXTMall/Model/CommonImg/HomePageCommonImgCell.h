//
//  HomePageCommonImgCell.h
//  RKWXT
//
//  Created by SHB on 16/3/31.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@protocol HomePageCommonImgCellDelegate;

@interface HomePageCommonImgCell : WXUITableViewCell
@property (nonatomic,weak) id<HomePageCommonImgCellDelegate>delegate;
@end

@protocol HomePageCommonImgCellDelegate <NSObject>
-(void)homepageCommonImgCellClicked:(id)sender;

@end
