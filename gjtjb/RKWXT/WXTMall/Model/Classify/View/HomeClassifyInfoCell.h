//
//  HomeClassifyInfoCell.h
//  RKWXT
//
//  Created by SHB on 16/4/1.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WXMiltiViewCell.h"

@protocol HomeClassifyInfoCellDelegate;

@interface HomeClassifyInfoCell : WXMiltiViewCell
@property (nonatomic,weak) id<HomeClassifyInfoCellDelegate>delegate;
@end

@protocol HomeClassifyInfoCellDelegate <NSObject>
-(void)homeClassifyInfoBtnClicked:(id)sender;

@end
