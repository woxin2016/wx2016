//
//  GoodsStockStyleCell.m
//  RKWXT
//
//  Created by app on 16/3/18.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "GoodsStockStyleCell.h"
#import "GoodsInfoEntity.h"

@interface GoodsStockStyleCell ()
{
    WXUILabel *nameLabel;
    WXUILabel *stockBtn;
}
@end

#define nameW  (40)

@implementation GoodsStockStyleCell

+ (instancetype)GoodsStockStyleCellWithTableView:(UITableView*)tableView{
    static NSString *identifier = @"GoodsStockStyleCell";
    GoodsStockStyleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[GoodsStockStyleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGRect rect = self.frame;
        rect.size.height = 30;
        self.frame = rect;
        
        nameLabel = [[WXUILabel alloc]initWithFrame:CGRectMake(10, 0, nameW, self.frame.size.height)];
        nameLabel.font = WXFont(14.0);
        nameLabel.textColor = [UIColor colorWithHexString:@"#969696"];
        nameLabel.text = @"规格:";
        [self.contentView addSubview:nameLabel];
        
        stockBtn = [[WXUILabel alloc]initWithFrame:CGRectZero];
        stockBtn.font = WXFont(13.0);
        stockBtn.textColor = [UIColor colorWithHexString:@"#969696"];
        [stockBtn setBorderRadian:0 width:0.5 color:RGB_COLOR(210, 210, 210)];
        stockBtn.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:stockBtn];
    }
    return self;
}

-(void)load{
    GoodsInfoEntity *entity = self.cellInfo;
    CGFloat MAXW = self.frame.size.width - (10 * 2) - nameW - 20;
    CGFloat offsetX = 10 * 2 + nameW;
    CGFloat offsetW = [self sizeWithString:entity.stockName font:WXFont(13.0) maxW:MAXW];
    if (offsetW < MAXW / 2) {
        offsetW = MAXW / 2;
    }
    CGFloat offsetY = (self.frame.size.height - 20) / 2;
    stockBtn.frame = CGRectMake(offsetX , offsetY, offsetW, 20);
    stockBtn.text = entity.stockName;
    
    
}

- (void)setLabelHid:(BOOL)hid{
    nameLabel.hidden = hid;
}

- (CGFloat)sizeWithString:(NSString*)string font:(UIFont*)font maxW:(CGFloat)maxW{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = font;
    CGSize size = CGSizeMake(maxW, self.frame.size.height);
    return [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size.width + 8;
    
}

- (void)setLabelBackGroundColor:(BOOL)hid{
    if (hid) {
        stockBtn.textColor = [UIColor colorWithHexString:@"#f74f35"];
        [stockBtn setBorderRadian:0 width:1.0 color:[UIColor colorWithHexString:@"#f74f35"]];
    }else{
        stockBtn.textColor = [UIColor colorWithHexString:@"#969696"];
        [stockBtn setBorderRadian:0 width:1.0 color:RGB_COLOR(210, 210, 210)];
    }
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
}

@end
