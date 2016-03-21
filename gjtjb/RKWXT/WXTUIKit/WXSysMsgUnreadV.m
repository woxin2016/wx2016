//
//  WXSysMsgUnreadV.m
//  CallTesting
//
//  Created by le ting on 5/8/14.
//  Copyright (c) 2014 ios. All rights reserved.
//

#import "WXSysMsgUnreadV.h"
#import "WXUnreadSysMsgOBJ.h"
#import "JPushDef.h"

#define D_Notification_Name_RewardPacketDetected @"D_Notification_Name_RewardPacketDetected" //检测到一个红包推送

@interface WXSysMsgUnreadV()
{
    WXUIImageView *_unreadNumberImgV;
    WXUILabel *_unreadLabel;
}
@end

@implementation WXSysMsgUnreadV

- (void)dealloc{
    [self removeOBS];
//    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *btnImg = [UIImage imageNamed:@"sysPushMessageIcon.png"];
        
        WXUIButton *leftBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [leftBtn setImage:btnImg forState:UIControlStateNormal];
        [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [leftBtn.titleLabel setFont:WXFont(10.0)];
        [leftBtn addTarget:self action:@selector(toUnreadSysMsg) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftBtn];
        
//        CGPoint buttonBoundsCenter = CGPointMake(CGRectGetMidX(leftBtn.titleLabel.bounds), CGRectGetMidY(leftBtn.titleLabel.bounds));
//        CGPoint endImageViewCenter = CGPointMake(buttonBoundsCenter.x, CGRectGetMidY(leftBtn.imageView.bounds));
//        CGPoint endTitleLabelCenter = CGPointMake(buttonBoundsCenter.x, CGRectGetHeight(leftBtn.bounds)-CGRectGetMidY(leftBtn.titleLabel.bounds));
//        CGPoint startImageViewCenter = leftBtn.imageView.center;
//        CGPoint startTitleLabelCenter = leftBtn.titleLabel.center;
//        CGFloat imageEdgeInsetsLeft = endImageViewCenter.x - startImageViewCenter.x;
//        CGFloat imageEdgeInsetsRight = -imageEdgeInsetsLeft;
//        leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, imageEdgeInsetsLeft, 40/3, imageEdgeInsetsRight);
//        CGFloat titleEdgeInsetsLeft = endTitleLabelCenter.x - startTitleLabelCenter.x;
//        CGFloat titleEdgeInsetsRight = -titleEdgeInsetsLeft;
//        leftBtn.titleEdgeInsets = UIEdgeInsetsMake(40*2/3-5, titleEdgeInsetsLeft, 0, titleEdgeInsetsRight);
        
        
        UIImage *image = [UIImage imageNamed:@"unreadBg.png"];
        CGSize imgSize = image.size;
        _unreadNumberImgV = [[WXUIImageView alloc] initWithImage:image];
        CGFloat X = leftBtn.frame.size.width / 2 + imgSize.width / 4;
        CGFloat Y = - (imgSize.height / 4);
        CGRect unreadViewRect = CGRectMake(X,Y, imgSize.width, imgSize.height);
        [_unreadNumberImgV setFrame:unreadViewRect];
        [leftBtn addSubview:_unreadNumberImgV];
        
        
        _unreadLabel = [[WXUILabel alloc] initWithFrame:_unreadNumberImgV.frame];
        [_unreadLabel setFont:[UIFont systemFontOfSize:9.0]];
        [_unreadLabel setTextColor:[UIColor whiteColor]];
        _unreadLabel.textAlignment = NSTextAlignmentCenter;
        [leftBtn addSubview:_unreadLabel];
        
        [self addOBS];

    }
    return self;
}

- (void)setUnreadNumber:(NSInteger)number{
    [_unreadNumberImgV setHidden:number <= 0];
    [_unreadLabel setHidden:number <= 0];
    if(number > 0){
        NSString *text = [NSString stringWithFormat:@"%d",(int)number];
        
        [_unreadLabel setText:text];
        _unreadLabel.center = _unreadNumberImgV.center;
    }
}

- (void)showSysPushMsgUnread{
    NSInteger unreadNumber = [[WXUnreadSysMsgOBJ sharedUnreadSysMsgOBJ] unreadNumber];
    [self setUnreadNumber:unreadNumber];
}

- (void)toUnreadSysMsg{
    if(_delegate && [_delegate respondsToSelector:@selector(toSysPushMsgView)]){
        [_delegate toSysPushMsgView];
    }
}

- (void)addOBS{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(incomeMsgPush) name:D_Notification_Name_SystemMessageDetected object:nil];
    [notificationCenter addObserver:self selector:@selector(unreadSystemMessageNumberChanged) name:D_NotificationName_UnreadSysMessageNumberChanged object:nil];
}

- (void)unreadSystemMessageNumberChanged{
    [self showSysPushMsgUnread];
}

- (void)incomeMsgPush{
    [[WXUnreadSysMsgOBJ sharedUnreadSysMsgOBJ] increaseUnreadSysMsg:1];
    [self showSysPushMsgUnread];
}

- (void)removeOBS{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
