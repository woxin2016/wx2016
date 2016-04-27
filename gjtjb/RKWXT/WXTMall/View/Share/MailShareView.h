//
//  MailShareView.h
//  RKWXT
//
//  Created by SHB on 16/4/26.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WXUIView.h"

enum{
    Share_Type_Qq,
    Share_Type_Qzone,
    Share_Type_WxFriends,
    Share_Type_WxCircle,
    
    Share_Type_Invalid,
};

@protocol MailShareViewDelegate;

@interface MailShareView : WXUIView
@property (nonatomic,assign) id<MailShareViewDelegate>delegate;

-(void)showShareThumbView:(UIView*)thumbView toDestview:(UIView*)destView withImage:(UIImage*)image;
@end

@protocol MailShareViewDelegate <NSObject>
-(void)sharebtnClicked:(NSInteger)index;

@end
