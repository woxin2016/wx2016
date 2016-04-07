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
        nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, (UserMoneyDrawShowCellHeight-nameHeight)/2, IPHONE_SCREEN_WIDTH/2, nameHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setTextColor:WXColorWithInteger(0xcccccc)];
        [nameLabel setFont:WXFont(14.0)];
        [self.contentView addSubview:nameLabel];
    }
    return self;
}

-(void)load{
    NSString *userMoney = self.cellInfo;
    [nameLabel setText:[NSString stringWithFormat:@"可提现金额:￥%@",userMoney]];
}

@end
