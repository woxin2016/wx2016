//
//  EvaluteGoodsCell.m
//  RKWXT
//
//  Created by SHB on 16/3/1.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "EvaluteGoodsCell.h"
#import "WXRemotionImgBtn.h"
#import "AllOrderListEntity.h"

@interface EvaluteGoodsCell()<WXUITextViewDelegate>{
    WXRemotionImgBtn *imgView;
}
@end

@implementation EvaluteGoodsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat xOffset = 10;
        CGFloat imgWidth = 62;
        CGFloat imgHeight = imgWidth;
        imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, (EvaluteGoodsCellHeight-imgHeight)/2, imgWidth, imgHeight)];
        [imgView setUserInteractionEnabled:NO];
        [self.contentView addSubview:imgView];
        
        xOffset += imgWidth+10;
        CGFloat textHeight = 60;
        _textField = [[WXUITextView alloc] init];
        _textField.frame = CGRectMake(xOffset, 15, IPHONE_SCREEN_WIDTH-xOffset-10, textHeight);
        [_textField setTextAlignment:NSTextAlignmentLeft];
        [_textField setReturnKeyType:UIReturnKeyDone];
        [_textField setPlaceholder:@"请写下对商品的感受吧，对他人帮助很大哦!"];
        [_textField setTextColor:WXColorWithInteger(0x646464)];
        [_textField setWxDelegate:self];
        [self.contentView addSubview:_textField];
    }
    return self;
}

-(void)wxTextViewDidChange:(WXUITextView *)textView{
    AllOrderListEntity *entity = self.cellInfo;
    if(_delegate && [_delegate respondsToSelector:@selector(userEvaluteTextFieldChanged:goodsID:)]){
        [_delegate userEvaluteTextFieldChanged:self goodsID:entity.goodsID];
    }
}

-(void)load{
    AllOrderListEntity *entity = self.cellInfo;
    [imgView setCpxViewInfo:entity.goodsImg];
    [imgView load];
}

@end
