//
//  CLassifySearchListVC.h
//  RKWXT
//
//  Created by SHB on 15/10/29.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXUIViewController.h"

@protocol CLassifySearchListVCDelelgae <NSObject>
- (void)searchListVCWithGoodsName:(NSString*)goodsName;
@end

@interface CLassifySearchListVC : WXUIViewController
@property (nonatomic,strong) NSArray *searchList;
@property (nonatomic,weak)id <CLassifySearchListVCDelelgae> delegate;
- (void)searchText:(NSString *)text;
@end
