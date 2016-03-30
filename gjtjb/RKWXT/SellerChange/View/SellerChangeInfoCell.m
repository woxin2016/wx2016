//
//  SellerChangeInfoCell.m
//  RKWXT
//
//  Created by SHB on 16/3/29.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "SellerChangeInfoCell.h"
#import "WXRemotionImgBtn.h"
#import "SellerListEntity.h"

@interface SellerChangeInfoCell(){
    WXUIButton *selBtn;
    WXRemotionImgBtn *imgView;
    WXUILabel *nameLabel;
    WXUILabel *addressLabel;
}

@end

@implementation SellerChangeInfoCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat btnWidth = 22;
        CGFloat btnHeight = btnWidth;
        selBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        selBtn.frame = CGRectMake(xOffset, (SellerChangeInfoCellHeight-btnHeight)/2, btnWidth, btnHeight);
        [selBtn setImage:[UIImage imageNamed:@"SellerChangeNor.png"] forState:UIControlStateNormal];
        [selBtn addTarget:self action:@selector(selectNormalSellerShow) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:selBtn];
        
        xOffset += btnWidth+13;
        CGFloat imgWidth = 70;
        CGFloat imgHeight = imgWidth;
        imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, (SellerChangeInfoCellHeight-imgHeight)/2, imgWidth, imgHeight)];
        [imgView setUserInteractionEnabled:NO];
        [self.contentView addSubview:imgView];
        
        xOffset += imgWidth+15;
        CGFloat yOffset = 22;
        CGFloat nameWidth = 150;
        CGFloat nameHeight = 18;
        nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, yOffset, nameWidth, nameHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [nameLabel setFont:WXFont(15.0)];
        [self.contentView addSubview:nameLabel];
        
        yOffset += nameHeight+10;
        addressLabel = [[WXUILabel alloc] init];
        addressLabel.frame = CGRectMake(xOffset, yOffset, IPHONE_SCREEN_WIDTH-xOffset-15, 25);
        [addressLabel setBackgroundColor:[UIColor clearColor]];
        [addressLabel setTextAlignment:NSTextAlignmentLeft];
        [addressLabel setTextColor:WXColorWithInteger(0x9b9b9b)];
        [addressLabel setNumberOfLines:0];
        [addressLabel setFont:WXFont(12.0)];
        [self.contentView addSubview:addressLabel];
    }
    return self;
}

-(void)load{
    SellerListEntity *entity = self.cellInfo;
    [imgView setCpxViewInfo:entity.logoImg];
    [imgView load];
    [nameLabel setText:entity.sellerName];
    [addressLabel setText:entity.address];
    
    if(_sellerID == entity.sellerID){
        [selBtn setImage:[UIImage imageNamed:@"SellerChangeSel.png"] forState:UIControlStateNormal];
    }else{
        [selBtn setImage:[UIImage imageNamed:@"SellerChangeNor.png"] forState:UIControlStateNormal];
    }
}

-(void)selectNormalSellerShow{
    SellerListEntity *entity = self.cellInfo;
    if(_delegate && [_delegate respondsToSelector:@selector(sellerChangeBtnClicked:)]){
        [_delegate sellerChangeBtnClicked:entity.sellerID];
    }
}

@end
