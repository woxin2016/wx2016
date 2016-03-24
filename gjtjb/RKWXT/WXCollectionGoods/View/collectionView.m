//
//  collectionView.m
//  RKWXT
//
//  Created by app on 16/3/23.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "collectionView.h"
#import "WXRemotionImgBtn.h"
#import "CollectionGoodsEntity.h"

@interface collectionView ()
{
    WXRemotionImgBtn *_imgView;
    UILabel *_nameLabel;
    UILabel *_priceLabel;
    UIButton *deleBtn;
}
@end

@implementation collectionView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        CGFloat width = frame.size.width;
        _imgView = [[WXRemotionImgBtn alloc]initWithFrame:CGRectMake(0,0, width, 150)];
        [_imgView setUserInteractionEnabled:NO];
        [self addSubview:_imgView];
        
        CGFloat offsety = CGRectGetMaxY(_imgView.frame) + 5;
        CGFloat nameH = 20;
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, offsety, width, nameH)];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_nameLabel];
        
        offsety += nameH;
        _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, offsety, width, 25)];
        _priceLabel.textColor = [UIColor colorWithHexString:@"#f74f35"];
        _priceLabel.textAlignment = NSTextAlignmentLeft;
        _priceLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_priceLabel];
        
        CGFloat btnW = 25;
        UIImage *img = [UIImage imageNamed:@"AddressDel.png"];
        WXUIButton *deleteBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(width- btnW - 5, offsety, btnW , btnW);
        [deleteBtn setBackgroundColor:[UIColor clearColor]];
        [deleteBtn setImage:img forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteBtn];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickShop)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void)setEntity:(CollectionGoodsEntity *)entity{
    _entity = entity;
    [_imgView setCpxViewInfo:entity.homeImg];
    [_imgView load];
    _nameLabel.text = entity.goodsName;
    _priceLabel.text = [NSString stringWithFormat:@"￥ %.2f",entity.marketPrice];
}

- (void)deleteBtnClicked{
    if (_delegate && [_delegate respondsToSelector:@selector(colltionViewClickDeleteGoods:)] ) {
        [_delegate colltionViewClickDeleteGoods:self.entity.deleGoodsID];
    }
}

- (void)clickShop{
    if (_delegate && [_delegate respondsToSelector:@selector(colltionViewClickGoods:)]) {
        [_delegate colltionViewClickGoods:self.entity.goodsID];
    }
}

@end
