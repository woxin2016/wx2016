//
//  GoodsBuyNumberCell.m
//  RKWXT
//
//  Created by app on 16/3/19.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "GoodsBuyNumberCell.h"

@interface GoodsBuyNumberCell ()
{
    WXUIButton *removeBtn;
    WXUIButton *addBtn;
    WXUILabel *numberL;
}
@end

@implementation GoodsBuyNumberCell

+ (instancetype)GoodsBuyNumberCellWithTableView:(UITableView*)tableView{
    static NSString *identifier = @"GoodsBuyNumberCell";
    GoodsBuyNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[GoodsBuyNumberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat offsetX = 10;
        CGFloat labelW =  80;
        CGFloat height = self.frame.size.height;
        UILabel *titleL = [[UILabel alloc]initWithFrame:CGRectMake(offsetX, 0, labelW, height)];
        titleL.text = @"购买数量:";
        titleL.textColor = [UIColor colorWithHexString:@"969696"];
        titleL.font = WXFont(14.0);
        titleL.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:titleL];
        
        offsetX += labelW + 5;
        CGFloat removeW = 20;
        removeBtn = [[WXUIButton alloc]initWithFrame:CGRectMake(0, 0, removeW, removeW)];
        removeBtn.center = CGPointMake(offsetX, height / 2);
        [removeBtn setTitle:@"-" forState:UIControlStateNormal];
        [removeBtn setTitleColor:[UIColor colorWithHexString:@"969696"] forState:UIControlStateNormal];
        [removeBtn setBorderRadian:0.1 width:1 color:[UIColor colorWithHexString:@"969696"]];
        removeBtn.titleLabel.font = WXFont(13.0);
        [removeBtn addTarget:self action:@selector(clickRemoveBtn) forControlEvents:UIControlEventTouchDown];
        [self.contentView addSubview:removeBtn];
        
        CGFloat numberW = 20;
        offsetX += removeW + 5;
        numberL = [[WXUILabel alloc]initWithFrame:CGRectMake(0, 0, numberW, numberW)];
        numberL.center = CGPointMake(offsetX, height / 2);
        numberL.textColor = [UIColor colorWithHexString:@"969696"];
        numberL.text = @"1";
        numberL.font = WXFont(13.0);
        numberL.textAlignment = NSTextAlignmentCenter;
        [numberL setBorderRadian:0.1 width:1 color:[UIColor colorWithHexString:@"969696"]];
        [self.contentView addSubview:numberL];
        
        offsetX += numberW + 5;
        addBtn = [[WXUIButton alloc]initWithFrame:CGRectMake(0, 0, removeW, removeW)];
        addBtn.center = CGPointMake(offsetX, height / 2);
        [addBtn setTitle:@"+" forState:UIControlStateNormal];
        [addBtn setTitleColor:[UIColor colorWithHexString:@"969696"] forState:UIControlStateNormal];
        [addBtn setBorderRadian:0.1 width:1 color:[UIColor colorWithHexString:@"969696"]];
        addBtn.titleLabel.font = WXFont(13.0);
        [addBtn addTarget:self action:@selector(clickAddBtn) forControlEvents:UIControlEventTouchDown];
        [self.contentView addSubview:addBtn];
        
    }
    return self;
}

- (void)clickRemoveBtn{
    if (_delegate && [_delegate respondsToSelector:@selector(goodsBuyRemoveNumber)]) {
        [_delegate goodsBuyRemoveNumber];
    }
}

- (void)clickAddBtn{
    if (_delegate && [_delegate respondsToSelector:@selector(goodsBuyAddNumber)]) {
        [_delegate goodsBuyAddNumber];
    }
}

- (void)lookGoodsStockNumber:(NSUInteger)number{
    NSString *str = [NSString stringWithFormat:@"%d",number];
    [numberL setText:str];
}


-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
}

@end
