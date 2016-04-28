//
//  VirtualInfoIntegralCell.m
//  RKWXT
//
//  Created by app on 16/4/6.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "VirtualInfoIntegralCell.h"

@interface VirtualInfoIntegralCell ()
{
    UILabel *canL;
    UILabel *cantL;
    UILabel *label1;
}
@end

@implementation VirtualInfoIntegralCell

+ (instancetype)VirtualInfoIntegralCellWithTabelView:(UITableView*)tableView{
    NSString *identifier = @"VirtualInfoIntegralCell";
    VirtualInfoIntegralCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[VirtualInfoIntegralCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat xOffset = 10;
        CGFloat labelW = 50;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(xOffset, 0, labelW, self.height)];
        label.font = WXFont(13.0);
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor blackColor];
        label.text = @"可兑换:";
        [self.contentView addSubview:label];
        
        xOffset += labelW;
        canL = [[UILabel alloc]initWithFrame:CGRectMake(xOffset, 0, 60, self.height)];
        canL.font = WXFont(13.0);
        canL.textAlignment = NSTextAlignmentLeft;
        canL.textColor = [UIColor blackColor];
        [self.contentView addSubview:canL];
        
        
        label1 = [[UILabel alloc]initWithFrame:CGRectMake(xOffset, 0, labelW, self.height)];
        label1.font = WXFont(13.0);
        label1.textAlignment = NSTextAlignmentLeft;
        label1.textColor = [UIColor blackColor];
        label1.text = @"已兑换:";
        [self.contentView addSubview:label1];
        
        cantL = [[UILabel alloc]initWithFrame:CGRectMake(xOffset, 0, 60, self.height)];
        cantL.font = WXFont(13.0);
        cantL.textAlignment = NSTextAlignmentLeft;
        cantL.textColor = [UIColor blackColor];
        [self.contentView addSubview:cantL];
        
    }
    return self;
}

- (void)canuseInterral:(NSString*)canUse cantBe:(NSString*)cantBe{
    canL.text = canUse;
    if (cantBe.length == 0) {
        cantBe = @"0";
    }
    cantL.text = cantBe;
    CGSize size = [cantBe stringSize:cantL.font];
    cantL.frame = CGRectMake(self.width - size.width - 10, 0, size.width, self.height);
    label1.X = self.width - size.width - 50 - 10;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
}

@end
