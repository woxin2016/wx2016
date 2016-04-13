//
//  VirtualInfoBDCell.m
//  RKWXT
//
//  Created by app on 16/4/6.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "VirtualInfoBDCell.h"

#define xOffset (15)
#define imgWidth (7)
#define imgHeight (11)

@interface VirtualInfoBDCell ()
{
    WXUIImageView *_imgView;
}
@end

@implementation VirtualInfoBDCell

+ (instancetype)VirtualInfoBDCellWithTabelView:(UITableView*)tableView{
    NSString *identifier = @"VirtualInfoBDCell";
    VirtualInfoBDCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[VirtualInfoBDCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _imgView = [[WXUIImageView alloc] init];
        _imgView.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-imgWidth, (44-imgHeight)/2, imgWidth, imgHeight);
        [_imgView setImage:[UIImage imageNamed:@"T_ArrowRight.png"]];
        [self.contentView addSubview:_imgView];
    }
    return self;
}

-(void)changeArrowWithDown:(BOOL)down{
    if (down) {
        _imgView.image = [UIImage imageNamed:@"T_ArrowDown.png"];
        _imgView.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-imgWidth-4, (44-imgHeight)/2, imgHeight, imgWidth);
    }else{
        _imgView.image = [UIImage imageNamed:@"T_ArrowRight.png"];
        _imgView.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-imgWidth, (44-imgHeight)/2, imgWidth, imgHeight);
    }
}


@end
