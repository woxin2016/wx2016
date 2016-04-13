//
//  UserCloudTicketCell.m
//  RKWXT
//
//  Created by SHB on 16/4/6.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "UserCloudTicketCell.h"
#import "UserCloudTicketEntity.h"

@interface UserCloudTicketCell(){
    WXUILabel *nameLabel;
    WXUILabel *timeLabel;
    WXUILabel *moneyLabel;
}

@end

@implementation UserCloudTicketCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat labelHeight = 20;
        CGFloat nameWidth = IPHONE_SCREEN_WIDTH/3-15;
        nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(0, (UserCloudTicketCellHeight-labelHeight)/2, nameWidth, labelHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentCenter];
        [nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [nameLabel setFont:WXFont(13.0)];
        [self.contentView addSubview:nameLabel];
        
        timeLabel = [[WXUILabel alloc] init];
        timeLabel.frame = CGRectMake(nameWidth, (UserCloudTicketCellHeight-labelHeight)/2, IPHONE_SCREEN_WIDTH-2*nameWidth, labelHeight);
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        [timeLabel setTextAlignment:NSTextAlignmentCenter];
        [timeLabel setTextColor:WXColorWithInteger(0x5c615d)];
        [timeLabel setFont:WXFont(13.0)];
        [self.contentView addSubview:timeLabel];
        
        moneyLabel = [[WXUILabel alloc] init];
        moneyLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-nameWidth, (UserCloudTicketCellHeight-labelHeight)/2, nameWidth, labelHeight);
        [moneyLabel setBackgroundColor:[UIColor clearColor]];
        [moneyLabel setTextAlignment:NSTextAlignmentCenter];
        [moneyLabel setTextColor:WXColorWithInteger(AllBaseColor)];
        [moneyLabel setFont:WXFont(18.0)];
        [self.contentView addSubview:moneyLabel];
    }
    return self;
}

-(void)load{
    UserCloudTicketEntity *entity = self.cellInfo;
    [nameLabel setText:entity.title];
    [timeLabel setText:[NSString stringWithFormat:@"%@",[UtilTool getDateTimeFor:entity.addTime type:4]]];
    [moneyLabel setText:entity.cloudTicket];
}

@end
