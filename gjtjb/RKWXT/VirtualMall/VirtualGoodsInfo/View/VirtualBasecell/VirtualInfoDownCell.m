//
//  VirtualInfoDownCell.m
//  RKWXT
//
//  Created by app on 16/4/6.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "VirtualInfoDownCell.h"

#define OneCellHeight (30)

@interface VirtualInfoDownCell ()
{
    WXUILabel *_commonLabel;
    WXUILabel *_infoLabel;
}

@end

@implementation VirtualInfoDownCell

+ (instancetype)VirtualInfoDownCellWithTabelView:(UITableView*)tableView{
    NSString *identifier = @"VirtualInfoDownCell";
    VirtualInfoDownCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[VirtualInfoDownCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setBackgroundColor:[UIColor whiteColor]];
        _commonLabel = [[WXUILabel alloc] init];
        _commonLabel.frame = CGRectMake(15, 0, 100, OneCellHeight);
        [_commonLabel setBackgroundColor:[UIColor clearColor]];
        [_commonLabel setTextAlignment:NSTextAlignmentLeft];
        [_commonLabel setTextColor:WXColorWithInteger(0x9c9d9f)];
        [_commonLabel setFont:[UIFont systemFontOfSize:11.0]];
        [self.contentView addSubview:_commonLabel];
        
        _infoLabel = [[WXUILabel alloc] init];
        _infoLabel.frame = CGRectMake(150, 0, IPHONE_SCREEN_WIDTH-150-15, OneCellHeight);
        [_infoLabel setBackgroundColor:[UIColor clearColor]];
        [_infoLabel setTextAlignment:NSTextAlignmentRight];
        [_infoLabel setTextColor:[UIColor blackColor]];
        [_infoLabel setFont:[UIFont systemFontOfSize:11.0]];
        [self.contentView addSubview:_infoLabel];
    }
    return self;
}

- (void)downWithName:(NSString*)name info:(NSString*)info{
    [_commonLabel setText:name];
    [_infoLabel setText:info];
}



+(CGFloat)cellHeightOfInfo:(id)cellInfo{
    return OneCellHeight;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
}


@end
