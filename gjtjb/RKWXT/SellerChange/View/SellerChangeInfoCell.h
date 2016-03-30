//
//  SellerChangeInfoCell.h
//  RKWXT
//
//  Created by SHB on 16/3/29.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

#define SellerChangeInfoCellHeight (90)

@protocol SellerChangeInfoCellDelegate;
@interface SellerChangeInfoCell : WXUITableViewCell
@property (nonatomic,weak) id<SellerChangeInfoCellDelegate>delegate;
@property (nonatomic,assign) NSInteger sellerID;
@end

@protocol SellerChangeInfoCellDelegate <NSObject>
-(void)sellerChangeBtnClicked:(NSInteger)sellerID;

@end
