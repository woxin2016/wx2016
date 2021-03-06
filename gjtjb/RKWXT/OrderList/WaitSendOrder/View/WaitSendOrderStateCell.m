//
//  WaitSendOrderStateCell.m
//  RKWXT
//
//  Created by SHB on 16/1/20.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WaitSendOrderStateCell.h"
#import "AllOrderListEntity.h"

@interface WaitSendOrderStateCell(){
    WXUILabel *orderIDLabel;
    WXUILabel *orderTimeLabel;
    WXUILabel *orderStateLabel;
}
@end

@implementation WaitSendOrderStateCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat labelWidth = 140;
        CGFloat labelHeight = 18;
        orderIDLabel = [[WXUILabel alloc] init];
        orderIDLabel.frame = CGRectMake(xOffset, (WaitSendOrderStateCellHeight-labelHeight)/2, labelWidth, labelHeight);
        [orderIDLabel setBackgroundColor:[UIColor clearColor]];
        [orderIDLabel setTextAlignment:NSTextAlignmentLeft];
        [orderIDLabel setTextColor:WXColorWithInteger(0x000000)];
        [orderIDLabel setFont:WXFont(14.0)];
        [self.contentView addSubview:orderIDLabel];
        
        CGFloat yOffset = 6;
        CGFloat height = 11;
        orderTimeLabel = [[WXUILabel alloc] init];
        orderTimeLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-labelWidth, yOffset, labelWidth, height);
        [orderTimeLabel setBackgroundColor:[UIColor clearColor]];
        [orderTimeLabel setTextAlignment:NSTextAlignmentRight];
        [orderTimeLabel setTextColor:WXColorWithInteger(0x000000)];
        [orderTimeLabel setFont:WXFont(10.0)];
        [self.contentView addSubview:orderTimeLabel];
        
        yOffset += height+8;
        orderStateLabel = [[WXUILabel alloc] init];
        orderStateLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-labelWidth, yOffset, labelWidth, height);
        [orderStateLabel setBackgroundColor:[UIColor clearColor]];
        [orderStateLabel setTextAlignment:NSTextAlignmentRight];
        [orderStateLabel setTextColor:WXColorWithInteger(0xf74f35)];
        [orderStateLabel setFont:WXFont(12.0)];
        [self.contentView addSubview:orderStateLabel];
    }
    return self;
}

-(void)load{
    AllOrderListEntity *entity = self.cellInfo;
    [orderIDLabel setText:[NSString stringWithFormat:@"订单号: %ld",(long)entity.orderId]];
    [orderTimeLabel setText:[UtilTool getDateTimeFor:entity.addTime type:1]];
    
    [orderStateLabel setText:@"待发货"];
}
@end
