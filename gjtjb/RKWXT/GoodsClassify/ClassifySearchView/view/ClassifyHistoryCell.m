//
//  ClassifyHistoryCell.m
//  RKWXT
//
//  Created by SHB on 15/10/21.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "ClassifyHistoryCell.h"
#import "ClassifySqlEntity.h"

@interface ClassifyHistoryCell(){
    WXUILabel *nameLabel;
    WXUILabel *_timeLabel;
    
}
@end

@implementation ClassifyHistoryCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat xOffset = 10;
        CGFloat labelWidth = 150;
        CGFloat labelHeight = 25;
        nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake(xOffset, (44-labelHeight)/2, labelWidth, labelHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setTextColor:WXColorWithInteger(0x606062)];
        [nameLabel setFont:WXFont(14.0)];
        [self.contentView addSubview:nameLabel];
        
        CGFloat timeWidth = 140;
        _timeLabel = [[WXUILabel alloc] init];
        _timeLabel.frame = CGRectMake(IPHONE_SCREEN_WIDTH-timeWidth-xOffset, (44-labelHeight)/2, timeWidth, labelHeight);
        [_timeLabel setBackgroundColor:[UIColor clearColor]];
        [_timeLabel setTextAlignment:NSTextAlignmentRight];
        [_timeLabel setTextColor:[UIColor grayColor]];
        [_timeLabel setFont:WXFont(14.0)];
        [self.contentView addSubview:_timeLabel];
        
        self._deleAllBtn = [[WXUIButton alloc]initWithFrame:CGRectMake(IPHONE_SCREEN_WIDTH-80-xOffset, 0, 80, self.frame.size.height)];
        [self._deleAllBtn setTitle:@"删除历史记录" forState:UIControlStateNormal];
        [self._deleAllBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self._deleAllBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self._deleAllBtn addTarget:self action:@selector(clickDeleAllBtn) forControlEvents:UIControlEventTouchDown];
        [self.contentView addSubview:self._deleAllBtn];
    }
    return self;
}

-(void)load{
    ClassifySqlEntity *entity = self.cellInfo;
    if([entity isKindOfClass:[NSString class]]){
        [_timeLabel setHidden:YES];
        [nameLabel setText:[NSString stringWithFormat:@"%@  (%ld条)",AlertRecordName,(long)_count]];
        [nameLabel setFont:WXFont(12.0)];
        [nameLabel setTextColor:[UIColor grayColor]];
    }else{
        //        [nameLabel setText:entity.recordName];
        //        [nameLabel setTextColor:WXColorWithInteger(0x606062)];
        //        [nameLabel setFont:WXFont(14.0)];
        //
        //        NSString *time = [UtilTool getDateTimeFor:entity.recordTime type:1];
        //        NSString *timerStr = [self dateWithTimeInterval:time];
        //        [_timeLabel setText:timerStr];
        //        [_timeLabel setHidden:NO];
        //        [_timeLabel setFont:WXFont(14.0)];
    }
}

-(NSString*)dateWithTimeInterval:(NSString*)timer{
    if(!timer){
        return nil;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:timer];
    NSInteger timeSp = [date timeIntervalSince1970];
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:timeSp];
    NSString *timeStr = [date1 YMRSFMString];
    
    return timeStr;
}

- (void)clickDeleAllBtn{
    if (_delegate && [_delegate respondsToSelector:@selector(classifyHistoryDeleAll)]) {
        [_delegate classifyHistoryDeleAll];
    }
}

@end