//
//  CoverSearchView.h
//  RKWXT
//
//  Created by app on 16/2/29.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^MYBlock) (NSString *str);

@interface CoverSearchView : UIView
@property (nonatomic,copy)MYBlock block;
@property (nonatomic,strong)NSArray *array;
- (instancetype)initWithFrame:(CGRect)frame dropListFrame:(CGRect)dropListFrame;
- (void)clickCellBlock:(MYBlock)block;
@end
