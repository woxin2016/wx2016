//
//  PersonalSexCell.m
//  RKWXT
//
//  Created by SHB on 16/3/17.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "PersonalSexCell.h"
#import "BaseInfoDef.h"

@interface PersonalSexCell(){
    WXUIButton *boyBtn;
    WXUIButton *girlBtn;
}

@end

@implementation PersonalSexCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        WXUILabel *nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(15, (BaseInfoForCommonCellHeight-20)/2, 50, 20);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setText:@"性别"];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [nameLabel setFont:WXFont(15.0)];
        [self.contentView addSubview:nameLabel];
        
        CGFloat xOffset = 100;
        CGFloat imgWidth = 16;
        CGFloat imgHeight = imgWidth;
        CGFloat nameWidth = 30;
        CGFloat nameHeight = 18;
        boyBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        boyBtn.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset, (BaseInfoForCommonCellHeight-imgHeight)/2, imgWidth, imgHeight);
        [boyBtn setBackgroundColor:[UIColor clearColor]];
        [boyBtn setImage:[UIImage imageNamed:@"PersonalSexSel.png"] forState:UIControlStateNormal];
        [boyBtn setTag:1];
        [boyBtn addTarget:self action:@selector(sexBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:boyBtn];
        
        CGFloat xGap = boyBtn.frame.origin.x+imgWidth+4;
        WXUILabel *boyLabel = [[WXUILabel alloc] init];
        boyLabel.frame = CGRectMake(xGap, (BaseInfoForCommonCellHeight-nameHeight)/2, nameWidth, nameHeight);
        [boyLabel setBackgroundColor:[UIColor clearColor]];
        [boyLabel setText:@"男"];
        [boyLabel setTextAlignment:NSTextAlignmentLeft];
        [boyLabel setTextColor:WXColorWithInteger(0xbababa)];
        [boyLabel setFont:WXFont(13.0)];
        [self.contentView addSubview:boyLabel];
        
        xGap += nameWidth+6;
        girlBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        girlBtn.frame = CGRectMake(xGap, (BaseInfoForCommonCellHeight-imgHeight)/2, imgWidth, imgHeight);
        [girlBtn setBackgroundColor:[UIColor clearColor]];
        [girlBtn setImage:[UIImage imageNamed:@"PersonalSex.png"] forState:UIControlStateNormal];
        [girlBtn setTag:2];
        [girlBtn addTarget:self action:@selector(sexBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:girlBtn];
        
        xGap += imgWidth+4;
        WXUILabel *girlLabel = [[WXUILabel alloc] init];
        girlLabel.frame = CGRectMake(xGap, (BaseInfoForCommonCellHeight-nameHeight)/2, nameWidth, nameHeight);
        [girlLabel setBackgroundColor:[UIColor clearColor]];
        [girlBtn setImage:[UIImage imageNamed:@"PersonalSexNor.png"] forState:UIControlStateNormal];
        [girlLabel setText:@"女"];
        [girlLabel setTextAlignment:NSTextAlignmentLeft];
        [girlLabel setTextColor:WXColorWithInteger(0xbababa)];
        [girlLabel setFont:WXFont(13.0)];
        [self.contentView addSubview:girlLabel];
    }
    return self;
}

-(void)load{
    NSString *index = self.cellInfo;
    if([index integerValue] == 1){
        [boyBtn setImage:[UIImage imageNamed:@"PersonalSexSel.png"] forState:UIControlStateNormal];
        [girlBtn setImage:[UIImage imageNamed:@"PersonalSexNor.png"] forState:UIControlStateNormal];
    }
    if([index integerValue] == 2){
        [boyBtn setImage:[UIImage imageNamed:@"PersonalSexNor.png"] forState:UIControlStateNormal];
        [girlBtn setImage:[UIImage imageNamed:@"PersonalSexSel.png"] forState:UIControlStateNormal];
    }
}

-(void)sexBtnClicked:(WXUIButton*)btn{
    NSInteger tag = btn.tag;
    
    if(tag == 1){
        [boyBtn setImage:[UIImage imageNamed:@"PersonalSexSel.png"] forState:UIControlStateNormal];
        [girlBtn setImage:[UIImage imageNamed:@"PersonalSexNor.png"] forState:UIControlStateNormal];
    }
    if(tag == 2){
        [boyBtn setImage:[UIImage imageNamed:@"PersonalSexNor.png"] forState:UIControlStateNormal];
        [girlBtn setImage:[UIImage imageNamed:@"PersonalSexSel.png"] forState:UIControlStateNormal];
    }
    
    if(_delegate && [_delegate respondsToSelector:@selector(personalSexButtonClicked:)]){
        [_delegate personalSexButtonClicked:tag];
    }
}

@end
