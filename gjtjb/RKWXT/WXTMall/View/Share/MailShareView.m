//
//  MailShareView.m
//  RKWXT
//
//  Created by SHB on 16/4/26.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "MailShareView.h"
#import "QRCodeGenerator.h"

#define kAnimateDefaultDuration (0.3)
#define kMaskShellDefaultAlpha (0.6)

#define shareViewWidth (240)
#define shareViewHeight (330)

static NSString *shareImgArr[]={
    @"ShareQqImg.png",
    @"ShareQzoneImg.png",
    @"ShareWxFriendImg.png",
    @"ShareWxCircleImg.png",
};

static NSString *shareNameArr[]={
    @"QQ好友",
    @"QQ空间",
    @"微信好友",
    @"朋友圈",
};

@interface MailShareView(){
    UIView *_maskShell;
    UIView *_shareView;
    UIImageView *_imageView;
    
    CGRect _imageViewDestRect;
    CGRect _imageViewSourceRect;
    
    CGFloat _duration;
    CGFloat _maskAlpha;
}
@property (nonatomic,strong) UIView *thumbView;
@end

@implementation MailShareView

-(id)init{
    self = [super init];
    if(self){
        [self initial];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initial];
    }
    return self;
}

-(void)initial{
    _maskShell = [[UIView alloc] init];
    [_maskShell setFrame:self.bounds];
    [_maskShell setBackgroundColor:[UIColor blackColor]];
    [_maskShell setAlpha:kMaskShellDefaultAlpha];
    [self addSubview:_maskShell];
    
    _shareView = [[UIView alloc] init];
    [_shareView setFrame:CGRectMake((IPHONE_SCREEN_WIDTH-shareViewWidth)/2, (IPHONE_SCREEN_HEIGHT-shareViewHeight)/2, shareViewWidth, shareViewHeight)];
    [_shareView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:_shareView];
    
    
    CGFloat textlabelWidth = 140;
    CGFloat textLabelHeight = 22;
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.frame = CGRectMake((shareViewWidth-textlabelWidth)/2, 15, textlabelWidth, textLabelHeight);
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setText:@"推荐应用给好友"];
    [textLabel setFont:WXFont(18.0)];
    [textLabel setTextAlignment:NSTextAlignmentCenter];
    [textLabel setTextColor:WXColorWithInteger(0x9b9b9b)];
    [_shareView addSubview:textLabel];
    
    CGFloat yOffset = textLabelHeight+15+5;
    UILabel *linelabel = [[UILabel alloc] init];
    linelabel.frame = CGRectMake(0, yOffset, shareViewWidth, 0.5);
    [linelabel setBackgroundColor:WXColorWithInteger(0xdedede)];
    [_shareView addSubview:linelabel];
    
    CGFloat imgWidth = 145;
    CGFloat imgHeight = imgWidth;
    _imageView = [[UIImageView alloc] init];
    [_imageView setFrame:CGRectMake((shareViewWidth-imgWidth)/2, yOffset, imgWidth, imgHeight)];
    [_shareView addSubview:_imageView];
    
    yOffset += imgHeight+5;
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSString *infoStr = userObj.userCutInfo;
    if(!infoStr || [infoStr isEqualToString:@""]){
        infoStr = @"成功邀请新用户注册后，该用户购买有提成的商品，您将获得一定比例的提成.";
    }
    CGFloat xGap = 15;
    CGFloat infoHeight = 60;
    WXUILabel *infoLabel = [[WXUILabel alloc] init];
    infoLabel.frame = CGRectMake(xGap, yOffset, (shareViewWidth-2*xGap), infoHeight);
    [infoLabel setBackgroundColor:[UIColor clearColor]];
    [infoLabel setText:infoStr];
    [infoLabel setTextColor:WXColorWithInteger(0x000000)];
    [infoLabel setFont:WXFont(12.0)];
    [infoLabel setNumberOfLines:0];
    [_shareView addSubview:infoLabel];
    
    //行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:infoStr];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [infoStr length])];
    infoLabel.attributedText = attributedString;
    [infoLabel sizeToFit];
    
    yOffset += infoHeight;
    [self createMoreShareBtn:yOffset];
    
    _duration = kAnimateDefaultDuration;
    _maskAlpha = kMaskShellDefaultAlpha;
    
    [self setUserInteractionEnabled:YES];
}

-(void)createMoreShareBtn:(CGFloat)yGap{
    CGFloat imgWidth = 40;
    CGFloat imgHeight = imgWidth;
    CGFloat xOffset = 18;
    CGFloat xGap = (shareViewWidth-2*xOffset-Share_Type_Invalid*imgWidth)/3;
    for(int i = 0; i < Share_Type_Invalid; i++){
        WXUIButton *sharebtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        sharebtn.frame = CGRectMake(xGap+i*(imgWidth+xGap), yGap, imgWidth, imgHeight);
        sharebtn.tag = i;
        [sharebtn setImage:[UIImage imageNamed:shareImgArr[i]] forState:UIControlStateNormal];
        [sharebtn addTarget:self action:@selector(sharebtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_shareView addSubview:sharebtn];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.frame = CGRectMake(xGap+i*(imgWidth+xGap), yGap+imgHeight, imgWidth, 20);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setText:shareNameArr[i]];
        [nameLabel setFont:WXFont(10.0)];
        [nameLabel setTextAlignment:NSTextAlignmentCenter];
        [nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [_shareView addSubview:nameLabel];
    }
}

-(void)sharebtnClicked:(WXUIButton*)btn{
    if(btn.tag > Share_Type_Invalid){
        return;
    }
    if(_delegate && [_delegate respondsToSelector:@selector(sharebtnClicked:)]){
        [_delegate sharebtnClicked:btn.tag];
    }
    [self unshow];
}

-(void)showShareThumbView:(UIView *)thumbView toDestview:(UIView *)destView withImage:(UIImage *)image{
    self.hidden = NO;
    self.alpha = 0.0;
    
    [self setThumbView:thumbView];
    [_maskShell setFrame:destView.bounds];
    [self setFrame:destView.bounds];
    //    UIView *superView = thumbView.superview;
    //    NSAssert(superView, @"thumb view has not add to super view");
    
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSString *imgUrlStr = [NSString stringWithFormat:@"%@/wx_union/index.php/Register/index?sid=%@&phone=%@",WXTShareBaseUrl,userObj.sellerID,userObj.user];
    _imageViewSourceRect = [destView convertRect:CGRectMake(_shareView.frame.size.width/2, _shareView.frame.size.height/2, 0, 0) fromView:thumbView.superview];
    [_imageView setImage:[QRCodeGenerator qrImageForString:imgUrlStr imageSize:shareViewWidth/2]];
//    [_imageView setFrame:_imageViewSourceRect];
    
    CGSize destViewSize = destView.bounds.size;
    CGSize destThumbSize = image.size;
    _imageViewDestRect = CGRectMake((destViewSize.width-destThumbSize.width)*0.5, (destViewSize.height-destThumbSize.height)*0.5, destThumbSize.width, destThumbSize.height);
    
    [destView addSubview:self];
    
    __block MailShareView *blockSelf = self;
    [UIView animateWithDuration:_duration animations:^{
        [blockSelf show];
    }];
}

- (void)show{
    [self.thumbView setAlpha:0.0];
    [self setAlpha:1.0];
}

- (void)unshow{
    [self.thumbView setAlpha:1.0];
    [self setAlpha:0.0];
}

- (void)unshowAnimated:(BOOL)animated{
    if (animated){
        __block MailShareView *blockSelf = self;
        [UIView animateWithDuration:_duration animations:^{
            [blockSelf unshow];
        } completion:^(BOOL finished) {
            [blockSelf removeFromSuperview];
        }];
        
    }else{
        [self removeFromSuperview];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [self isClicked];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self isClicked];
}

- (void)isClicked{
    [self unshowAnimated:YES];
}

@end
