//
//  UserDefaultSiteCell.m
//  RKWXT
//
//  Created by app on 16/3/17.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "UserDefaultSiteCell.h"

@interface UserDefaultSiteCell ()
{
    WXUISwitch *_switch;
}
@end

@implementation UserDefaultSiteCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat xOffset = 32;
        CGFloat width = 30;
        CGFloat height = 12;
        _switch = [[WXUISwitch alloc] init];
        _switch.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-width, (44-height)/2-10, width, height);
        [_switch addTarget:self action:@selector(keyPadTone:) forControlEvents:UIControlEventValueChanged];
        [_switch setOnTintColor:WXColorWithInteger(AllBaseColor)];
        [self.contentView addSubview:_switch];
    }
    return self;
}

- (void)keyPadTone:(WXUISwitch*)s{
    if(_delegate && [_delegate respondsToSelector:@selector(keyPadToneSetting:)]){
        [_delegate keyPadToneSetting:_switch];
    }
}





@end
