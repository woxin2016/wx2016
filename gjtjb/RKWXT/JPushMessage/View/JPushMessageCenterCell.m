//
//  JPushMessageCenterCell.m
//  RKWXT
//
//  Created by SHB on 15/7/2.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "JPushMessageCenterCell.h"
#import "JPushMsgEntity.h"
#import "WXRemotionImgBtn.h"

@interface JPushMessageCenterCell(){
    WXRemotionImgBtn *_imgView;
    UILabel *ifier;
    UILabel *title;
    UILabel *info;
    UILabel *time;
}
@end

@implementation JPushMessageCenterCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat imgWidth = 42;
        CGFloat imgHeight = imgWidth;
        _imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, (JPushMessageCenterCellHeight-imgHeight)/2, imgWidth, imgHeight)];
        [self.contentView addSubview:_imgView];
        
        // 区分未读已读
        ifier = [[UILabel alloc]initWithFrame:CGRectMake(42 - 5, -5, 8, 8)];
        ifier.backgroundColor = [UIColor redColor];
        [ifier setBorderRadian:5 width:0.0 color:[UIColor clearColor]];
        [_imgView addSubview:ifier];
        
        
        xOffset += imgWidth+10;
        CGFloat yOffset = 15;
        CGFloat titleWidth = 95;
        CGFloat titleHeight = 18;
        title = [[UILabel alloc] init];
        title.frame = CGRectMake(xOffset, yOffset, titleWidth, titleHeight);
        [title setBackgroundColor:[UIColor clearColor]];
        [title setTextAlignment:NSTextAlignmentLeft];
        [title setTextColor:WXColorWithInteger(0x323639)];
        [title setFont:WXFont(14.0)];
        [self.contentView addSubview:title];
        
        yOffset += titleHeight+10;
        info = [[UILabel alloc] init];
        info.frame = CGRectMake(xOffset, yOffset-5, IPHONE_SCREEN_WIDTH-xOffset, titleHeight);
        [info setBackgroundColor:[UIColor clearColor]];
        [info setTextAlignment:NSTextAlignmentLeft];
        [info setTextColor:WXColorWithInteger(0xa5a3a3)];
        [info setFont:WXFont(12.0)];
        [self.contentView addSubview:info];
        
        // 修改Y
        CGFloat xGap = 10;
        CGFloat timeWidth = IPHONE_SCREEN_WIDTH-xOffset-xGap-10;
        yOffset = self.frame.size.height - (titleHeight+10);
        time = [[UILabel alloc] init];
        time.frame = CGRectMake(IPHONE_SCREEN_WIDTH-timeWidth-10, yOffset, timeWidth, titleHeight);
        [time setBackgroundColor:[UIColor clearColor]];
        [time setTextAlignment:NSTextAlignmentRight];
        [time setTextColor:WXColorWithInteger(0xa5a3a3)];
        [time setFont:WXFont(11.0)];
        [self.contentView addSubview:time];
        
        
    }
    return self;
}

-(void)load{
    JPushMsgEntity *entity = self.cellInfo;
    [title setText:entity.content];
    [info setText:entity.abstract];
    
    [_imgView setCpxViewInfo:entity.msgURL];
    [_imgView load];
    if(!entity.msgURL){
        [_imgView setImage:[UIImage imageNamed:@"Icon.png"]];
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[entity.pushTime integerValue]];
    NSString *timeString = [self notionWithData:date];
    [time setText:timeString];
    
    [ifier setHidden:[entity.toView isEqualToString:@"red"]];
}

- (NSString*)notionWithData:(NSDate*)date{
    NSDateFormatter *matter = [[NSDateFormatter alloc]init];
    [matter setDateFormat:@"yyyy-MM-dd"];
    return [matter stringFromDate:date];
}

- (void)setIfierHidYes{
    [ifier setHidden:YES];
}



@end
