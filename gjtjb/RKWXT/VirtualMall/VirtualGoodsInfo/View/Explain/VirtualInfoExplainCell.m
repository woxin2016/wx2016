//
//  VirtualInfoExplainCell.m
//  RKWXT
//
//  Created by app on 16/4/6.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "VirtualInfoExplainCell.h"
#import "WXRemotionImgBtn.h"
#import "VirtualGoods.h"

@interface VirtualInfoExplainCell ()
{
    UIImageView *imgBtn;
    UILabel *label;
}
@end

@implementation VirtualInfoExplainCell

+ (instancetype)VirtualInfoExplainCellWithTabelView:(UITableView*)tableView{
    NSString *identifier = @"VirtualInfoExplainCell";
    VirtualInfoExplainCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[VirtualInfoExplainCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.height = ExplainCellHeight;
        CGFloat xOffset = 10;
        CGFloat yOffset = 10;
        CGFloat imgW = 60;
        CGFloat imgH = imgW;
        UIView *bView = [[UIView alloc]initWithFrame:CGRectMake(xOffset, yOffset, imgW, imgH)];
        bView.backgroundColor = RGB_COLOR(208, 208, 208);
        [self.contentView addSubview:bView];
        
        imgBtn = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
        [bView addSubview:imgBtn];
        
        
        xOffset += imgW + 10;
        label = [[UILabel alloc]initWithFrame:CGRectMake(xOffset, 10, self.width - 30 - imgW, self.height - yOffset * 2)];
        label.font = WXFont(10.0);
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor blackColor];
        label.numberOfLines = 0;
        [self.contentView addSubview:label];
        
    }
    return self;
}

- (void)load{
    VirtualGoodsInfoEntity *entity = self.cellInfo;
    label.text = [NSString stringWithFormat:@"本商品只支持平台邮寄兑换(所需邮费%.2f)\n不支持商家现场兑换,每个用户每次只能兑换一个\n返现金额在订单完成的1-3个工作日内返还到您的现金余额中",entity.postageVirtual];;
    imgBtn.image = [UIImage imageNamed:@"virtualWarning.png"];
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
}


@end
