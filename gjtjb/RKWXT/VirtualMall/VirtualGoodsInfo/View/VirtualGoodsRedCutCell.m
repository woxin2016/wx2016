//
//  VirtualGoodsRedCutCell.m
//  RKWXT
//
//  Created by app on 16/4/7.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "VirtualGoodsRedCutCell.h"

@interface VirtualGoodsRedCutCell ()
{
    WXUIButton *usercutBtn;
    WXUIButton *carriageBtn;
    WXUIButton *redPacketBtn;
    CGRect redRect;
    CGRect cutRect;
    CGRect carRect;
}
@end

@implementation VirtualGoodsRedCutCell

+ (instancetype)VirtualGoodsRedCutCellWithTabelView:(UITableView*)tableView{
    NSString *identifier = @"VirtualGoodsRedCutCell";
    VirtualGoodsRedCutCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[VirtualGoodsRedCutCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat yOffset = 10;
        CGFloat xOffset = 10;
        CGFloat btnWidth = 70;
        CGFloat btnHieght = 24;
        usercutBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        usercutBtn.frame = CGRectMake(xOffset, yOffset, btnWidth, btnHieght);
        [usercutBtn setBackgroundColor:[UIColor whiteColor]];
        [usercutBtn setBorderRadian:2.0 width:0.5 color:WXColorWithInteger(0xdbdbdb)];
        [usercutBtn setImage:[UIImage imageNamed:@"LMUserCutImg.png"] forState:UIControlStateNormal];
        [usercutBtn setTitle:@" 提成" forState:UIControlStateNormal];
        [usercutBtn.titleLabel setFont:WXFont(9.0)];
        [usercutBtn setTitleColor:WXColorWithInteger(0x000000) forState:UIControlStateNormal];
        [usercutBtn setHidden:YES];
        [usercutBtn addTarget:self action:@selector(userCutBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:usercutBtn];
        cutRect = usercutBtn.frame;
        
        xOffset += btnWidth+10;
        carriageBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        carriageBtn.frame = CGRectMake(xOffset, yOffset, btnWidth, btnHieght);
        [carriageBtn setBackgroundColor:[UIColor whiteColor]];
        [carriageBtn setBorderRadian:0.5 width:0.5 color:WXColorWithInteger(0xdbdbdb)];
        [carriageBtn setImage:[UIImage imageNamed:@"LMCarriageImg.png"] forState:UIControlStateNormal];
        [carriageBtn setTitle:@" 包邮" forState:UIControlStateNormal];
        [carriageBtn.titleLabel setFont:WXFont(9.0)];
        [carriageBtn setHidden:YES];
        [carriageBtn setTitleColor:WXColorWithInteger(0x000000) forState:UIControlStateNormal];
        [carriageBtn addTarget:self action:@selector(carriageBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:carriageBtn];
        carRect = carriageBtn.frame;
        
        xOffset += btnWidth+10;
        redPacketBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        redPacketBtn.frame = CGRectMake(xOffset, yOffset, btnWidth, btnHieght);
        [redPacketBtn setBackgroundColor:[UIColor whiteColor]];
        [redPacketBtn setBorderRadian:0.5 width:0.5 color:WXColorWithInteger(0xdbdbdb)];
        [redPacketBtn setImage:[UIImage imageNamed:@"LMResPackingImg.png"] forState:UIControlStateNormal];
        [redPacketBtn setTitle:@" 红包" forState:UIControlStateNormal];
        [redPacketBtn.titleLabel setFont:WXFont(9.0)];
        [redPacketBtn setHidden:YES];
        [redPacketBtn setTitleColor:WXColorWithInteger(0x000000) forState:UIControlStateNormal];
        [redPacketBtn addTarget:self action:@selector(redPacketBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:redPacketBtn];
        redRect = redPacketBtn.frame;

    }
    return self;
}

- (void)isAppearRed:(NSInteger)red cut:(NSInteger)cut posgate:(NSInteger)posgate{
    BOOL isRed = (red != 0);  //红包
    BOOL isCut = (cut != 0);  // 有提成
    BOOL isPos = (posgate != 0);  //包邮
    
    if (isCut){ // 有提成
        [usercutBtn setHidden:NO];
        
        if (isPos) { //包邮
            [carriageBtn setHidden:NO];
            
            [self useRed:isRed];
            
        }else{
            [carriageBtn setHidden:YES];
            
            if (isRed) { //红包
                [redPacketBtn setHidden:NO];
                redPacketBtn.frame = carRect;
            }
        }
        
    }else{ // 没有提成
        [usercutBtn setHidden:YES];
        
        if (isPos) { //包邮
            [carriageBtn setHidden:NO];
            carriageBtn.frame = cutRect;
            
            if (isRed) { // 红包
                [redPacketBtn setHidden:NO];
                redPacketBtn.frame = carRect;
            }
            
        }else{ // 不包邮
            [carriageBtn setHidden:YES];
            
            if (isRed) { //红包
                [redPacketBtn setHidden:NO];
                redPacketBtn.frame = cutRect;
            }
            
        }
    }
    
}

- (void)useRed:(BOOL)red{
    if (red) { //红包
        [redPacketBtn setHidden:NO];
    }else{
        [redPacketBtn setHidden:YES];
    }
}

-(void)userCutBtnClicked{
    if(_delegate && [_delegate respondsToSelector:@selector(VirtualGoodsInfoDesCutBtnClicked)]){
        [_delegate VirtualGoodsInfoDesCutBtnClicked];
    }
}

-(void)carriageBtnClicked{
    if(_delegate && [_delegate respondsToSelector:@selector(VirtualGoodsInfoDesCarriageBtnClicked)]){
        [_delegate VirtualGoodsInfoDesCarriageBtnClicked];
    }
}

- (void)redPacketBtnClicked{
    if(_delegate && [_delegate respondsToSelector:@selector(VirtualGoodsInfoDesredPacketBtnClicked)]){
        [_delegate VirtualGoodsInfoDesredPacketBtnClicked];
    }
}




@end
