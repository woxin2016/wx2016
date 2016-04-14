//
//  VirtualOrderNumberCell.m
//  RKWXT
//
//  Created by app on 16/4/9.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "VirtualOrderNumberCell.h"
#import "virtualOrderListEntity.h"

@interface VirtualOrderNumberCell ()
{
    UILabel *orderNumber;
    UILabel *orderStauts;
}
@end

@implementation VirtualOrderNumberCell

+ (instancetype)VirtualOrderNumberCellWithTabelView:(UITableView*)tableView{
    NSString *identifier = @"VirtualOrderNumberCell";
    VirtualOrderNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[VirtualOrderNumberCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat xOffset = 10;
        CGFloat labelW = 50;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(xOffset, 0, labelW, self.height)];
        label.font = WXFont(14.0);
        label.textColor = [UIColor blackColor];
        label.text = @"订单号:";
        label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label];
        
        orderNumber = [[UILabel alloc]initWithFrame:CGRectMake(label.right + 10, 0, 120, self.height)];
        orderNumber.font = WXFont(14.0);
        orderNumber.textColor = [UIColor blackColor];
        [self.contentView addSubview:orderNumber];
        
        xOffset = self.width - 10 - 140;
        orderStauts = [[UILabel alloc]initWithFrame:CGRectMake(xOffset, 0, 140, self.height)];
        orderStauts.font = WXFont(14.0);
        orderStauts.textColor = [UIColor colorWithHexString:@"f74f35"];
        orderStauts.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:orderStauts];
    }
    return self;
}

- (void)load{
    virtualOrderListEntity *entity = self.cellInfo;
    orderNumber.text = [NSString stringWithFormat:@"%d",entity.order_id];
    orderStauts.text = [NSString stringWithFormat:@"%@",[self orderStants:entity]];
}

- (NSString*)orderStants:(virtualOrderListEntity*)entity{
    NSString *str = nil;
    if (entity.order_status == VirtualOrder_Status_Done) { //已完成
        str = @"已完成";
    }else if (entity.order_status == VirtualOrder_Status_Close){
        str = @"已关闭";
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


@end
