//
//  UserMoneyInfoCell.m
//  RKWXT
//
//  Created by SHB on 16/4/6.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "UserMoneyInfoCell.h"
#import "UserMoneyFormEntity.h"

@interface UserMoneyInfoCell(){
    WXUILabel *leftMoney;
    WXUILabel *rightMoney;
}

@end

@implementation UserMoneyInfoCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat labelWidth = IPHONE_SCREEN_WIDTH/3;
        CGFloat labelHeight = 20;
        CGFloat yOffset = 8;
        WXUILabel *leftName = [[WXUILabel alloc] init];
        leftName.frame = CGRectMake(0, yOffset, labelWidth, labelHeight);
        [leftName setBackgroundColor:[UIColor clearColor]];
        [leftName setText:@"已提现"];
        [leftName setTextAlignment:NSTextAlignmentCenter];
        [leftName setTextColor:WXColorWithInteger(0x5c615d)];
        [leftName setFont:WXFont(13.0)];
        [self.contentView addSubview:leftName];
        
        WXUILabel *rightName = [[WXUILabel alloc] init];
        rightName.frame = CGRectMake(IPHONE_SCREEN_WIDTH*2/3, yOffset, labelWidth, labelHeight);
        [rightName setBackgroundColor:[UIColor clearColor]];
        [rightName setText:@"提现中"];
        [rightName setTextAlignment:NSTextAlignmentCenter];
        [rightName setTextColor:WXColorWithInteger(0x5c615d)];
        [rightName setFont:WXFont(12.0)];
        [self.contentView addSubview:rightName];
        
        yOffset += labelHeight;
        leftMoney = [[WXUILabel alloc] init];
        leftMoney.frame = CGRectMake(0, yOffset, labelWidth, labelHeight);
        [leftMoney setBackgroundColor:[UIColor clearColor]];
        [leftMoney setTextAlignment:NSTextAlignmentCenter];
        [leftMoney setTextColor:WXColorWithInteger(0x000000)];
        [leftMoney setFont:WXFont(14.0)];
        [leftMoney setText:@"￥0"];
        [self.contentView addSubview:leftMoney];
        
        rightMoney = [[WXUILabel alloc] init];
        rightMoney.frame = CGRectMake(IPHONE_SCREEN_WIDTH*2/3, yOffset, labelWidth, labelHeight);
        [rightMoney setBackgroundColor:[UIColor clearColor]];
        [rightMoney setTextAlignment:NSTextAlignmentCenter];
        [rightMoney setTextColor:WXColorWithInteger(0x000000)];
        [rightMoney setFont:WXFont(14.0)];
        [rightMoney setText:@"￥0"];
        [self.contentView addSubview:rightMoney];
    }
    return self;
}

-(void)load{
    UserMoneyFormEntity *entity = self.cellInfo;
    [leftMoney setText:[NSString stringWithFormat:@"￥%.2f",entity.completeMoney]];
    [rightMoney setText:[NSString stringWithFormat:@"￥%.2f",entity.onGoingMoney]];
}

@end
