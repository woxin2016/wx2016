//
//  UserDefaultSiteCell.h
//  RKWXT
//
//  Created by app on 16/3/17.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserDefaultSiteCellDelegate <NSObject>
-(void)keyPadToneSetting:(WXUISwitch*)s;
@end

@interface UserDefaultSiteCell : WXUITableViewCell
@property (nonatomic,weak)id<UserDefaultSiteCellDelegate> delegate;
@end
