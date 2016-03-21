//
//  DropdownView.h
//  RKWXT
//
//  Created by app on 16/3/21.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DropdownViewDeleate <NSObject>
- (void)dropdownViewSwitchTitle:(NSString*)title;
@end

@interface DropdownView : UIView
@property (nonatomic,weak)id<DropdownViewDeleate> delegate;
-(instancetype)initWithFrame:(CGRect)frame sourceData:(NSArray*)data imgArray:(NSArray*)imgArr;

@end
