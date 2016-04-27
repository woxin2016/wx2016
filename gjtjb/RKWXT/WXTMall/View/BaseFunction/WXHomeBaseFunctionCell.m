//
//  WXHomeBaseFunctionCell.m
//  RKWXT
//
//  Created by SHB on 16/1/7.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WXHomeBaseFunctionCell.h"
#import "NewHomePageCommonDef.h"

#define ImgBtnHeight (T_HomePageBaseFunctionHeight-8)
#define  margin (10)

@interface WXHomeBaseFunctionCell(){
    WXUIButton *bgImgBtn;
}
@end

@implementation WXHomeBaseFunctionCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        NSArray *textArr = @[@"签到有奖",@"商家红包",@"我要赚钱",@"我的奖励",@"商家联盟",@"我的云票"];
        NSArray *imgArr = @[@"HomePageSignImg.png",@"HomePageWallet.png",@"HomePageShareImg.png",@"HomePageCutImg.png",@"HomePageUnion.png",@"HomevirtualXNB.png"];
        NSInteger rowCount = 3;
        CGFloat width = self.frame.size.width  / rowCount;
        CGFloat baseHeight = ImgBtnHeight/2;
        
        
        for (int i  = 0; i < textArr.count; i++) {
           
            int row = i / rowCount;
            int col = i % rowCount;
            CGFloat  baseX = col * width;
            CGFloat baseY = row * (baseHeight);
            WXUIButton *commonBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
            [commonBtn setBackgroundColor:[UIColor whiteColor]];
            commonBtn.frame = CGRectMake(baseX,baseY, width, baseHeight);
            [commonBtn setBorderRadian:0 width:1 color:[UIColor clearColor]];
            commonBtn.tag = i + 1;
            [commonBtn setImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateNormal];
            [commonBtn setTitle:textArr[i] forState:UIControlStateNormal];
            [commonBtn setTitleColor:WXColorWithInteger(0x414141) forState:UIControlStateNormal];
            [commonBtn.titleLabel setFont:WXFont(11.0)];
            [commonBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:commonBtn];
            
            CGPoint buttonBoundsCenter = CGPointMake(CGRectGetMidX(commonBtn.bounds), CGRectGetMidY(commonBtn.bounds));
            CGPoint endImageViewCenter = CGPointMake(buttonBoundsCenter.x, CGRectGetMidY(commonBtn.imageView.bounds));
            CGPoint endTitleLabelCenter = CGPointMake(buttonBoundsCenter.x, CGRectGetHeight(commonBtn.bounds)-CGRectGetMidY(commonBtn.titleLabel.bounds));
            CGPoint startImageViewCenter = commonBtn.imageView.center;
            CGPoint startTitleLabelCenter = commonBtn.titleLabel.center;
            CGFloat imageEdgeInsetsLeft = endImageViewCenter.x - startImageViewCenter.x;
            CGFloat imageEdgeInsetsRight = -imageEdgeInsetsLeft;
            commonBtn.imageEdgeInsets = UIEdgeInsetsMake(0, imageEdgeInsetsLeft, 12, imageEdgeInsetsRight);
            CGFloat titleEdgeInsetsLeft = endTitleLabelCenter.x - startTitleLabelCenter.x;
            CGFloat titleEdgeInsetsRight = -titleEdgeInsetsLeft;
            commonBtn.titleEdgeInsets = UIEdgeInsetsMake(ImgBtnHeight/2-12, titleEdgeInsetsLeft, 0, titleEdgeInsetsRight);
            
        }
    }
    return self;
}

-(void)buttonClicked:(id)sender{
    WXUIButton *btn = (WXUIButton*)sender;
    NSInteger tag = btn.tag;
    T_BaseFunction t_baseFunction = T_BaseFunction_Init;
    switch (tag) {
        case 1:
            t_baseFunction = T_BaseFunction_Sign;
            break;
        case 2:
            t_baseFunction = T_BaseFunction_Wallet;
            break;
        case 3:
            t_baseFunction = T_BaseFunction_Invate;
            break;
        case 4:
            t_baseFunction = T_BaseFunction_Cut;
            break;
        case 5:
            t_baseFunction = T_BaseFunction_Union;
            break;
        case 6:
            t_baseFunction = T_BaseFunction_yunP;
            break;
        default:
            break;
    }
    if(_delegate && [_delegate respondsToSelector:@selector(wxHomeBaseFunctionBtnClickedAtIndex:with:)]){
        [_delegate wxHomeBaseFunctionBtnClickedAtIndex:t_baseFunction with:self];
    }
}



@end
