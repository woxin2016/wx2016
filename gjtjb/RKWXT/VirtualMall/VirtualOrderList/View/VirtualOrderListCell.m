//
//  VirtualOrderListCell.m
//  RKWXT
//
//  Created by app on 16/4/11.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "VirtualOrderListCell.h"
#import "WXRemotionImgBtn.h"
#import "ViteualGoodsEntity.h"
#import "virtualOrderListEntity.h"

@interface VirtualOrderListCell ()
{
        WXRemotionImgBtn *_imgView;
        UILabel *nameL;
        UILabel *orderID;
        UILabel *timeL;
        UILabel *stautsL;
}
@end

@implementation VirtualOrderListCell

+ (instancetype)VirtualOrderListCellWithTabelView:(UITableView*)tableView{
    NSString *identifier = @"VirtualOrderListCell";
    VirtualOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[VirtualOrderListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.width = IPHONE_SCREEN_WIDTH;
        CGFloat xOffset = 10;
        CGFloat yOffset = 10;
        CGFloat imageH = 60;
        CGFloat imageW = imageH;
        _imgView = [[WXRemotionImgBtn alloc]initWithFrame:CGRectMake(xOffset, yOffset, imageW, imageH)];
        [self.contentView addSubview:_imgView];
        
        
        CGFloat timeW = 80;
        CGFloat timeX = self.width - xOffset - timeW;
        timeL = [[UILabel alloc]initWithFrame:CGRectMake(timeX, yOffset, timeW , 15)];
        timeL.font = WXFont(13.0);
        timeL.textAlignment = NSTextAlignmentRight;
        timeL.textColor = [UIColor grayColor];
        [self.contentView addSubview:timeL];
        
        stautsL = [[UILabel alloc]initWithFrame:CGRectMake(timeX, yOffset + 25, timeW , 15)];
        stautsL.font = WXFont(14.0);
        stautsL.textAlignment = NSTextAlignmentRight;
        stautsL.textColor = [UIColor redColor];
        [self.contentView addSubview:stautsL];
        
        
        xOffset += imageW + 10;
        yOffset += 5;
        CGFloat nameLH = 25;
        CGFloat nameLW = (self.width - 30) - imageW - timeW;
        nameL = [[UILabel alloc]initWithFrame:CGRectMake(xOffset, yOffset, nameLW, nameLH)];
        nameL.font = WXFont(14.0);
        nameL.textAlignment = NSTextAlignmentLeft;
        nameL.textColor = [UIColor blackColor];
        nameL.numberOfLines = 2;
        [self.contentView addSubview:nameL];
        
        yOffset += nameLH + 10;
        CGFloat pricelH = 12;
//        CGFloat priceW = 120;
        orderID = [[UILabel alloc]initWithFrame:CGRectMake(xOffset, yOffset, nameLW, pricelH)];
        orderID.font = WXFont(14.0);
        orderID.textAlignment = NSTextAlignmentLeft;
        orderID.textColor = [UIColor redColor];
        [self.contentView addSubview:orderID];
        
        
    }
    return self;
}

- (void)load{
    virtualOrderListEntity *entity = self.cellInfo;
    
    [_imgView setCpxViewInfo:[NSString stringWithFormat:@"%@",entity.goods_img]];
    [_imgView load];
    
    timeL.text = [self orderTime:entity.makeOrderTime];
    stautsL.text = [self orderStants:entity];
    nameL.text = entity.goods_name;
    orderID.text = [NSString stringWithFormat:@"订单号:%d",entity.order_id];
    
}


- (NSString*)orderStants:(virtualOrderListEntity*)entity{
    NSString *str = nil;
    if (entity.order_status == VirtualOrder_Status_Done) { //已完成
        str = @"已兑换";
    }else{
        if (entity.pay_status == VirtualOrder_Pay_Done) { //已付款
            
            if (entity.send_status == VirtualOrder_Send_Done) { //已发货
                str = @"已发货";
            }else{
                str = @"未发货";
            }
            
        }else{
            str = @"待兑换";
        }
    }
    return str;
}


- (NSString*)orderTime:(NSTimeInterval)timeVal{
    NSDate *Date = [NSDate dateWithTimeIntervalSince1970:timeVal];
    
    NSDateFormatter *matter = [[NSDateFormatter alloc]init];
    [matter setDateFormat:@"yyyy-MM-dd"];
    return [matter stringFromDate:Date];
}

@end
