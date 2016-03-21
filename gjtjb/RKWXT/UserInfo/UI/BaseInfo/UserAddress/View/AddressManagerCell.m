//
//  AddressManagerCell.m
//  RKWXT
//
//  Created by SHB on 15/6/2.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "AddressManagerCell.h"
#import "AddressEntity.h"

@interface AddressManagerCell(){
    WXUIButton *_selBtn;
}
@end

@implementation AddressManagerCell

-(void)dealloc{
    _delegate = nil;
    [super dealloc];
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        UIImage *img = [UIImage imageNamed:@"AddressCircle.png"];
        CGSize size = img.size;
        size.width += 3.0;
        size.height += 3.0;
        _selBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        _selBtn.frame = CGRectMake(xOffset, (AddressManagerCellHeight-size.height)/2, size.width, size.height);
        [_selBtn setBackgroundColor:[UIColor clearColor]];
        [_selBtn setImage:img forState:UIControlStateNormal];
        [_selBtn addTarget:self action:@selector(setAddressCircleNormal) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_selBtn];
        
        xOffset += size.width+10;
        CGFloat norAddWidth = 80;
        CGFloat norAddheight = 15;
        UILabel *norAddLabel = [[[UILabel alloc] init] autorelease];
        norAddLabel.frame = CGRectMake(xOffset, (AddressManagerCellHeight-norAddheight)/2, norAddWidth, norAddheight);
        [norAddLabel setBackgroundColor:[UIColor clearColor]];
        [norAddLabel setTextAlignment:NSTextAlignmentLeft];
        [norAddLabel setText:@"默认地址"];
        [norAddLabel setTextColor:WXColorWithInteger(0x8a8a8a)];
        [norAddLabel setFont:WXFont(12.0)];
        [self.contentView addSubview:norAddLabel];
        
        xOffset = IPHONE_SCREEN_WIDTH-115;
        CGFloat btnHeight = 18;
        CGFloat btnWidth = 50;
        WXUIButton *editBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        editBtn.frame = CGRectMake(xOffset, (AddressManagerCellHeight-btnHeight)/2, btnWidth, btnHeight);
        [editBtn setBackgroundColor:[UIColor clearColor]];
        [editBtn setBorderRadian:1.0 width:0.5 color:WXColorWithInteger(0xc8c8c8)];
        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [editBtn.titleLabel setFont:WXFont(10.0)];
        [editBtn setTitleColor:WXColorWithInteger(0xbababa) forState:UIControlStateNormal];
        [editBtn addTarget:self action:@selector(editAddress) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:editBtn];
        
        CGFloat xGap = xOffset+btnWidth+10;
        WXUIButton *delBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        delBtn.frame = CGRectMake(xGap, (AddressManagerCellHeight-btnHeight)/2, btnWidth, btnHeight);
        [delBtn setBackgroundColor:[UIColor clearColor]];
        [delBtn setBorderRadian:1.0 width:0.5 color:WXColorWithInteger(0xc8c8c8)];
        [delBtn setTitle:@"删除" forState:UIControlStateNormal];
        [delBtn.titleLabel setFont:WXFont(10.0)];
        [delBtn setTitleColor:WXColorWithInteger(0xbababa) forState:UIControlStateNormal];
        [delBtn addTarget:self action:@selector(delAdd) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:delBtn];
    }
    return self;
}

-(void)load{
    AddressEntity *ent = self.cellInfo;
    [self setAddressNormal:(ent.normalID==1?YES:NO)];
}

-(void)setAddressNormal:(BOOL)load{
    if(load){
        [_selBtn setImage:[UIImage imageNamed:@"AddressSelNormal.png"] forState:UIControlStateNormal];
    }else{
        [_selBtn setImage:[UIImage imageNamed:@"AddressCircle.png"] forState:UIControlStateNormal];
    }
}

-(void)setAddressCircleNormal{
    AddressEntity *ent = self.cellInfo;
    if(_delegate && [_delegate respondsToSelector:@selector(setAddressNormal:)]){
        [_delegate setAddressNormal:ent];
    }
}

-(void)editAddress{
    AddressEntity *entity = self.cellInfo;
    if(_delegate && [_delegate respondsToSelector:@selector(editAddressInfo:)]){
        [_delegate editAddressInfo:entity];
    }
}

-(void)delAdd{
    AddressEntity *entity = self.cellInfo;
    if(_delegate && [_delegate respondsToSelector:@selector(delAddress:)]){
        [_delegate delAddress:entity];
    }
}

@end
