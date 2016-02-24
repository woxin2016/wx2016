//
//  WXTGuideVC.m
//  RKWXT
//
//  Created by SHB on 15/7/27.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#define kAnimateDuration (2.0)
#define kGuideViewNumber (3)

#import "WXTGuideVC.h"
#import "LoginVC.h"

@interface WXTGuideVC ()<UIScrollViewDelegate>{
    UIScrollView *_scrollView;
    BOOL _finishd;
    WXUIImageView *_lastView;
}
@property (nonatomic,assign) NSInteger page;
@end

@implementation WXTGuideVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCSTNavigationViewHidden:YES animated:NO];
    
    CGSize size = self.bounds.size;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [_scrollView setDelegate:self];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView setBounces:NO];
    [_scrollView setPagingEnabled:YES];
    [_scrollView setContentSize:CGSizeMake(size.width*self.page + 5, size.height)];
    [self addSubview:_scrollView];
    [_scrollView setAutoresizingMask:UIViewAutoresizingNone];
    
    
    CGSize scrollViewSize = _scrollView.bounds.size;
    for(NSInteger i = 0; i < kGuideViewNumber; i++){
        WXUIImageView *imageView = [[WXUIImageView alloc] initWithFrame:CGRectMake(size.width*i, 0, size.width, scrollViewSize.height)];
        UIImage *img = [self imageAtIndex:i];
        [imageView setImage:img];
        [_scrollView addSubview:imageView];
        
        if(i == kGuideViewNumber-1){
            CGFloat btnWidth = 140;
            CGFloat btnHeight = 40;
            WXUIButton *button = [WXUIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake((size.width-btnWidth)/2, size.height-btnHeight-60, btnWidth, btnHeight);
            [button setBackgroundImage:[UIImage imageNamed:@"GuideStartUseBtnNor.png"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"GuideStartUseBtnSel.png"] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(guideviewScrollFinished) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:button];
            [imageView setUserInteractionEnabled:YES];
        }
    }
}

-(NSInteger)page{
    return kGuideViewNumber;
}

-(UIImage*)imageAtIndex:(NSInteger)index{
    NSString *imgFileName = [NSString stringWithFormat:@"guideIllustrate_%d.jpg",(int)index];
    if(self.view.bounds.size.width >= 320){
        imgFileName = [NSString stringWithFormat:@"guideIllustrate_%d-568h@2x.jpg",(int)index];
    }
    return [UIImage imageNamed:imgFileName];
}

-(void)finisehdAnimated{
    [self guideviewScrollFinished];
    if(_finishd){
        return;
    }
    [_scrollView setUserInteractionEnabled:NO];
    [UIView animateWithDuration:kAnimateDuration animations:^{
        [_lastView setAlpha:0.3];
    }completion:^(BOOL finished) {
        [self guideviewScrollFinished];
    }];
}

-(void)guideviewScrollFinished{
    if(_finishd){
        return;
    }
    _finishd = YES;
    LoginVC *loginVC = [[LoginVC alloc] init];
    [loginVC.navigationController setNavigationBarHidden:YES];
    [self.wxNavigationController pushViewController:loginVC];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat xOffset = scrollView.contentOffset.x;
    
    if(xOffset > self.bounds.size.width * (self.page-1)+1){
        [self finisehdAnimated];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
