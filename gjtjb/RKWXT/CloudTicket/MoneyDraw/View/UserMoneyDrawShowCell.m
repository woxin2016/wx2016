//
//  UserMoneyDrawShowCell.m
//  RKWXT
//
//  Created by SHB on 16/4/6.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "UserMoneyDrawShowCell.h"

@interface UserMoneyDrawShowCell(){
    WXUILabel *nameLabel;
}

@end

@implementation UserMoneyDrawShowCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 8;
        CGFloat nameHeight = 20;
        CGFloat nameWidth = 80;
        WXUILabel *textLabel = [[WXUILabel alloc] init];
        textLabel.frame = CGRectMake(xOffset, (UserMoneyDrawShowCellHeight-nameHeight)/2, nameWidth, nameHeight);
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setTextAlignment:NSTextAlignmentLeft];
        [textLabel setTextColor:WXColorWithInteger(0x5c615d)];
        [textLabel setFont:WXFont(14.0)];
        [textLabel setText:@"可提现金额:"];
        [self.contentView addSubview:textLabel];
        
        xOffset += nameWidth;
        nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, (UserMoneyDrawShowCellHeight-nameHeight)/2, nameWidth, nameHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [nameLabel setFont:WXFont(14.0)];
        [self.contentView addSubview:nameLabel];
    }
    return self;
}

-(void)load{
    NSString *userMoney = self.cellInfo;
    [nameLabel setText:[NSString stringWithFormat:@"￥%@",userMoney]];
}

@end
