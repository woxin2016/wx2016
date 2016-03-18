//
//  NewAddressAreaCell.m
//  RKWXT
//
//  Created by SHB on 16/1/8.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "NewAddressAreaCell.h"

@interface NewAddressAreaCell(){
    WXUILabel *textLabel;
}
@end

@implementation NewAddressAreaCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat height = 20;
        CGFloat nameWidth = 70;
        WXUILabel *nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, (44-height)/2, nameWidth, 20);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setText:@"收货地址:"];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setTextColor:WXColorWithInteger(0x484848)];
        [nameLabel setFont:WXFont(14.0)];
        [self.contentView addSubview:nameLabel];
        
        xOffset += nameWidth;
        CGFloat labelHeight = 17;
        textLabel = [[WXUILabel alloc] init];
        textLabel.frame = CGRectMake(xOffset, (44-labelHeight)/2+1, 160, labelHeight);
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setText:@"请选择所在区域"];
        [textLabel setTextAlignment:NSTextAlignmentLeft];
        [textLabel setFont:WXFont(12.0)];
        [textLabel setTextColor:WXColorWithInteger(0x484848)];
        [self.contentView addSubview:textLabel];
        
        CGFloat btnWidth = 19;
        CGFloat btnHeight = 12;
        WXUIButton *btn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(IPHONE_SCREEN_WIDTH-10-btnWidth, (44-btnHeight)/2, btnWidth, btnHeight);
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setEnabled:NO];
        [btn setImage:[UIImage imageNamed:@"T_ArrowDown.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:btn];
    }
    return self;
}

-(void)load{
    NSString *text = self.cellInfo;
    if(_normalAddress.length > 0){
        [textLabel setText:_normalAddress];
    }
    if(text.length > 0){
        [textLabel setText:text];
    }
}

@end
