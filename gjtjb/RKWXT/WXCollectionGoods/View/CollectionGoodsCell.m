//
//  CollectionGoodsCell.m
//  RKWXT
//
//  Created by app on 16/3/23.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "CollectionGoodsCell.h"
#import "collectionView.h"
#import "CollectionGoodsEntity.h"

@interface CollectionGoodsCell ()<collectionViewDelegate>
{
    UIView *bottonView;
}
@end

@implementation CollectionGoodsCell

+ (instancetype)collectionGoodsCellWith:(WXUITableView*)tableView{
    static NSString *cellName = @"CollectionGoodsCell";
    CollectionGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[CollectionGoodsCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
    }
    
    return cell;
}


- (void)setEntityArr:(NSArray *)entityArr{
    _entityArr = entityArr;
    
    [bottonView removeFromSuperview];
    bottonView = [[UIView alloc]initWithFrame:self.bounds];
    [self.contentView addSubview:bottonView];
    
    CGFloat margin = 10;
    CGFloat width = (self.frame.size.width - ( 3 * margin) ) / 2;
    CGFloat height = 202;
    for (int i = 0; i < entityArr.count; i++) {
        CGFloat offsetX = margin + (width + margin)* i;
        CollectionGoodsEntity *entity = entityArr[i];
        collectionView *goodsView = [[collectionView alloc]initWithFrame:CGRectMake(offsetX, 10, width, height)];
        goodsView.entity = entity;
        [goodsView setBorderRadian:0.0 width:1.0 color:[UIColor colorWithCGColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0].CGColor]];
        goodsView.delegate = self;
        [bottonView addSubview:goodsView];
    }
    
}

-(void)colltionViewClickGoods:(NSInteger)goodsID{
    if (_delegate && [_delegate respondsToSelector:@selector(colltionGoodsCellClickGoods:)]) {
        [_delegate colltionGoodsCellClickGoods:goodsID];
    }
}

- (void)colltionViewClickDeleteGoods:(NSInteger)goodsID{
    if (_delegate && [_delegate respondsToSelector:@selector(colltionGoodsCellClickDeleteGoods:)]) {
        [_delegate colltionGoodsCellClickDeleteGoods:goodsID];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
}



@end
