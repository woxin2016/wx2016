//
//  VirtualCompanyCell.m
//  RKWXT
//
//  Created by app on 16/4/8.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "VirtualCompanyCell.h"

@implementation VirtualCompanyCell
+ (instancetype)VirtualCompanyCellWithTabelView:(UITableView*)tableView{
    NSString *identifier = @"VirtualCompanyCell";
    VirtualCompanyCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[VirtualCompanyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat imgWidth = 15;
        CGFloat imgHeight = 15;
        CGFloat xOffset = 12;
        UIImage *img = [UIImage imageNamed:@"AboutUsLogo.png"];
        UIImageView *iconImgView = [[UIImageView alloc] init];
        iconImgView.frame = CGRectMake(xOffset, ([VirtualCompanyCell cellHeightOfInfo:nil]-imgHeight)/2, imgWidth, imgHeight);;
        [iconImgView setImage:img];
        [self.contentView addSubview:iconImgView];
        
        xOffset += imgWidth+5;
        UIFont *font = WXFont(14.0);
        CGSize labelSize = [self sizeOfString:@"我信云科技有限公司" font:font];
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, ([VirtualCompanyCell cellHeightOfInfo:nil]-labelSize.height)/2, labelSize.width, labelSize.height);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentCenter];
        [nameLabel setTextColor:WXColorWithInteger(0x202020)];
        [nameLabel setFont:font];
        [nameLabel setText:@"我信云科技有限公司"];
        [self.contentView addSubview:nameLabel];
        
        xOffset +=labelSize.width+2;
        UIImage *arrowImg = [UIImage imageNamed:@"MakeOrderNextPageImg.png"];
        UIImageView *arrowImgView = [[UIImageView alloc] init];
        arrowImgView.frame = CGRectMake(xOffset, ([VirtualCompanyCell cellHeightOfInfo:nil]-imgHeight)/2, imgWidth-3, imgHeight);
        [arrowImgView setImage:arrowImg];
    }
    return self;
}

- (CGSize)sizeOfString:(NSString*)txt font:(UIFont*)font{
    if(!txt || [txt isKindOfClass:[NSNull class]]){
        txt = @" ";
    }
    if(isIOS7){
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
        return [txt sizeWithAttributes:@{NSFontAttributeName: font}];
#endif
    }else{
        return [txt sizeWithFont:font];
    }
}

+(CGFloat)cellHeightOfInfo:(id)cellInfo{
    return 45;
}

@end
