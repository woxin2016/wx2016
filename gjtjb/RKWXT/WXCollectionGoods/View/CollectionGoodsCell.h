//
//  CollectionGoodsCell.h
//  RKWXT
//
//  Created by app on 16/3/23.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CollectionGoodsCellDelegate;
@interface CollectionGoodsCell : UITableViewCell
@property (nonatomic,strong)NSArray *entityArr;
@property (nonatomic,weak)id <CollectionGoodsCellDelegate> delegate;
+ (instancetype)collectionGoodsCellWith:(UITableView*)tableView;
@end

@protocol CollectionGoodsCellDelegate <NSObject>
- (void)colltionGoodsCellClickGoods:(NSInteger)goodsID;
- (void)colltionGoodsCellClickDeleteGoods:(NSInteger)goodsID;

@end