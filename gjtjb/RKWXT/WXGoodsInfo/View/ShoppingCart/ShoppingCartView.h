//
//  ShoppingCartView.h
//  RKWXT
//
//  Created by app on 16/3/8.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShoppingCartViewDelegate;

@interface ShoppingCartView : UIView
@property (nonatomic,weak)id <ShoppingCartViewDelegate> delegate;
- (void)searchShoppingCartNumber;
- (void)replaceBtnImage:(NSString*)imageName;  //替换图片
@end

@protocol ShoppingCartViewDelegate <NSObject>
- (void)shoppingCartViewInShoppingVC;
@end