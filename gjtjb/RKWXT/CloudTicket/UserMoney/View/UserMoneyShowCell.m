//
//  UserMoneyShowCell.m
//  RKWXT
//
//  Created by SHB on 16/4/6.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "UserMoneyShowCell.h"
#import "UserMoneyFormEntity.h"

@interface UserMoneyShowCell(){
    WXUILabel *nameLabel;
}

@end

@implementation UserMoneyShowCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat nameHeight = 30;
        nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, (UserMoneyShowCellHeight-nameHeight)/2, IPHONE_SCREEN_WIDTH/2, nameHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setTextColor:WXColorWithInteger(0x5c615d)];
        [nameLabel setFont:WXFont(14.0)];
        [nameLabel setText:@"可提现 (￥100)"];
        [self.contentView addSubview:nameLabel];
        
        CGFloat labelWidth = 35;
        WXUILabel *label = [[WXUILabel alloc] init];
        label.frame = CGRectMake(IPHONE_SCREEN_WIDTH-25-labelWidth, (UserMoneyShowCellHeight-nameHeight)/2, labelWidth, nameHeight);
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:@"提现"];
        [label setTextAlignment:NSTextAlignmentRight];
        [label setTextColor:WXColorWithInteger(0x9c9c9c)];
        [label setFont:WXFont(12.0)];
        [self.contentView addSubview:label];
        
        WXUILabel *lineLable = [[WXUILabel alloc] init];
        lineLable.frame = CGRectMake(0, UserMoneyShowCellHeight-0.5, IPHONE_SCREEN_WIDTH, 0.5);
        [lineLable setBackgroundColor:WXColorWithInteger(0xf6f6f6)];
        [self.contentView addSubview:lineLable];
    }
    return self;
}

-(void)load{
    UserMoneyFormEntity *entity = self.cellInfo;
    [nameLabel setText:[NSString stringWithFormat:@"可提现 (￥%.2f)",entity.balance]];
}

@end
