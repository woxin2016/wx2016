//
//  HomeLimitBuyCell.h
//  RKWXT
//
//  Created by SHB on 16/1/18.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"
#import "WXMiltiViewCell.h"


@protocol HomeLimitBuyCellDelegate;
@interface HomeLimitBuyCell : WXMiltiViewCell
@property (nonatomic,assign)id<HomeLimitBuyCellDelegate>delegate;
@end

@protocol HomeLimitBuyCellDelegate <NSObject>
- (void)clickClassifyBtnAtIndex:(NSInteger)index;
-(void)homeLimitBuyCellbtnClicked:(id)sender;
@end
