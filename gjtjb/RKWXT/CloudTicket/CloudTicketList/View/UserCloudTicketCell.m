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
        CGFloat labelWidth = IPHONE_SCREEN_WIDTH/3;
        CGFloat labelHeight = 20;
        nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(0, (UserCloudTicketCellHeight-labelHeight)/2, labelWidth, labelHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentCenter];
        [nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [nameLabel setFont:WXFont(14.0)];
        [self.contentView addSubview:nameLabel];
        
        timeLabel = [[WXUILabel alloc] init];
        timeLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH/3, (UserCloudTicketCellHeight-labelHeight)/2, labelWidth, labelHeight);
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        [timeLabel setTextAlignment:NSTextAlignmentCenter];
        [timeLabel setTextColor:WXColorWithInteger(0x000000)];
        [timeLabel setFont:WXFont(12.0)];
        [self.contentView addSubview:timeLabel];
        
        moneyLabel = [[WXUILabel alloc] init];
        moneyLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH*2/3, (UserCloudTicketCellHeight-labelHeight)/2, labelWidth, labelHeight);
        [moneyLabel setBackgroundColor:[UIColor clearColor]];
        [moneyLabel setTextAlignment:NSTextAlignmentCenter];
        [moneyLabel setTextColor:WXColorWithInteger(0x000000)];
        [moneyLabel setFont:WXFont(15.0)];
        [self.contentView addSubview:moneyLabel];
    }
    return self;
}

-(void)load{
    
}

@end
