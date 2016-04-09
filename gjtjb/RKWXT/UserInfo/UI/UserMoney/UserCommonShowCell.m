//
//  UserCommonShowCell.m
//  RKWXT
//
//  Created by SHB on 16/4/6.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "UserCommonShowCell.h"

@interface UserCommonShowCell(){
    WXUILabel *commonLabel;
}

@end

@implementation UserCommonShowCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 25;
        CGFloat labelWidth = 80;
        CGFloat labelHeight = 18;
        commonLabel = [[WXUILabel alloc] init];
        commonLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-xOffset-labelWidth, (44-labelHeight)/2, labelWidth, labelHeight);
        [commonLabel setBackgroundColor:[UIColor clearColor]];
        [commonLabel setTextAlignment:NSTextAlignmentRight];
        [commonLabel setTextColor:WXColorWithInteger(0xcccccc)];
        [commonLabel setFont:WXFont(14.0)];
        [self.contentView addSubview:commonLabel];
    }
    return self;
}

-(void)load{
    NSString *name = self.cellInfo;
    [commonLabel setText:name];
}

@end
