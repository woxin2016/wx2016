//
//  PersonalSexCell.h
//  RKWXT
//
//  Created by SHB on 16/3/17.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

@protocol PersonalSexCellDelegate;

@interface PersonalSexCell : WXUITableViewCell
@property (nonatomic,weak) id<PersonalSexCellDelegate>delegate;
@end

@protocol PersonalSexCellDelegate <NSObject>
-(void)personalSexButtonClicked:(NSInteger)index;

@end
