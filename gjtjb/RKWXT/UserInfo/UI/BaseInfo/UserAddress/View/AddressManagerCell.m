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
        _selBtn = [UIButton buttonWithType:UIButtonTypeCustom];
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
        
        xOffset = IPHONE_SCREEN_WIDTH-105;
        UIImage *editImg = [UIImage imageNamed:@"AddressEdit.png"];
        WXUIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        editBtn.frame = CGRectMake(xOffset, (AddressManagerCellHeight-editImg.size.height)/2, editImg.size.width+norAddWidth/2, editImg.size.height);
        [editBtn setBackgroundColor:[UIColor clearColor]];
        [editBtn setImage:editImg forState:UIControlStateNormal];
        [editBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [editBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
        [editBtn.titleLabel setFont:WXFont(12.0)];
        [editBtn setTitleColor:WXColorWithInteger(0x8a8a8a) forState:UIControlStateNormal];
        [editBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, editImg.size.width-10, 0, 0)];
        [editBtn addTarget:self action:@selector(editAddress) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:editBtn];
        
        CGFloat xGap = xOffset+editImg.size.width+6;
        CGFloat labelWidth = norAddWidth/2;
        UILabel *editLabel = [[[UILabel alloc] init] autorelease];
        editLabel.frame = CGRectMake(xGap, (AddressManagerCellHeight-norAddheight)/2, labelWidth, norAddheight);
        [editLabel setBackgroundColor:[UIColor clearColor]];
        [editLabel setTextAlignment:NSTextAlignmentLeft];
        [editLabel setText:@"编辑"];
        [editLabel setTextColor:WXColorWithInteger(0x8a8a8a)];
        [editLabel setFont:WXFont(12.0)];
//        [self.contentView addSubview:editLabel];
        
        
        UIImage *delImg = [UIImage imageNamed:@"AddressDel.png"];
        xGap += labelWidth-10;
        WXUIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        delBtn.frame = CGRectMake(xGap, (AddressManagerCellHeight-delImg.size.height)/2, delImg.size.width+labelWidth, delImg.size.height);
        [delBtn setBackgroundColor:[UIColor clearColor]];
        [delBtn setImage:delImg forState:UIControlStateNormal];
        [delBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [delBtn setTitle:@"删除" forState:UIControlStateNormal];
        [delBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
        [delBtn.titleLabel setFont:WXFont(12.0)];
        [delBtn setTitleColor:WXColorWithInteger(0x8a8a8a) forState:UIControlStateNormal];
        [delBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, delImg.size.width-10, 0, 0)];
        [delBtn addTarget:self action:@selector(delAdd) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:delBtn];
        
        xGap += delImg.size.width+11;
        UILabel *delLabel = [[[UILabel alloc] init] autorelease];
        delLabel.frame = CGRectMake(xGap, (AddressManagerCellHeight-norAddheight)/2, labelWidth, norAddheight);
        [delLabel setBackgroundColor:[UIColor clearColor]];
        [delLabel setTextAlignment:NSTextAlignmentLeft];
        [delLabel setText:@"删除"];
        [delLabel setTextColor:WXColorWithInteger(0x8a8a8a)];
        [delLabel setFont:WXFont(12.0)];
//        [self.contentView addSubview:delLabel];
    }
    return self;
}

-(void)load{
    AddressEntity *ent = self.cellInfo;
    [self setAddressNormal:(ent.normalID==1?YES:NO)];
}

-(void)setAddressNormal:(BOOL)load{
//    AddressEntity *ent = self.cellInfo;
    if(load){
        [_selBtn setImage:[UIImage imageNamed:@"AddressSelNormal.png"] forState:UIControlStateNormal];
    }else{
        [_selBtn setImage:[UIImage imageNamed:@"AddressCircle.png"] forState:UIControlStateNormal];
    }
//    if(!load){
//        if(_delegate && [_delegate respondsToSelector:@selector(setAddressNormal:)]){
//            [_delegate setAddressNormal:ent];
//        }
//    }
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
