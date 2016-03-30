//
//  SellerChangeModel.h
//  RKWXT
//
//  Created by SHB on 16/3/29.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SellerChangeModelDelegate;
@interface SellerChangeModel : NSObject
@property (nonatomic,weak) id<SellerChangeModelDelegate>delegate;
@property (nonatomic,strong) NSArray *sellerArr;

-(void)loadSellerListArr:(NSInteger)startItem length:(NSInteger)length withText:(NSString*)text;
-(void)setUserChangeSeller;
@end

@protocol SellerChangeModelDelegate <NSObject>
-(void)loadSellerListArrSucceed;
-(void)loadSellerListArrFailed:(NSString*)errorMsg;

@end
