//
//  VirtualTopImgCell.m
//  RKWXT
//
//  Created by app on 16/4/6.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "VirtualTopImgCell.h"
#import "CSTScrollBrowser.h"
#import "WXRemotionImgBtn.h"

@interface VirtualTopImgCell ()<UIScrollViewDelegate,WXRemotionImgBtnDelegate>{
    CSTScrollBrowser *_browser;
    UIPageControl *_pageControl;
}
@property (nonatomic,retain) NSArray *subPageViews;
@end

@implementation VirtualTopImgCell

+ (instancetype)VirtualTopImgCellWithTabelView:(UITableView*)tableView{
    NSString *identifier = @"VirtualTopImgCell";
    VirtualTopImgCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[VirtualTopImgCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier imageArray:(NSArray *)imageArray{
    if(self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]){
        CGRect rect = [self bounds];
        rect.size.height = IPHONE_SCREEN_WIDTH;
        _browser = [[CSTScrollBrowser alloc] initWithFrame:rect];
        [_browser setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight];
        [_browser setScrollDelegate:self];
        [_browser setSubScrollViews:imageArray];
        [_browser setGap:0.0];
        [self setSubPageViews:imageArray];
        [self.contentView addSubview:_browser];
        
        CGFloat height = 20;
        CGFloat xOffset = 220;
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(xOffset, rect.size.height - height, rect.size.width-xOffset, height)];
        [self.contentView addSubview:_pageControl];
        
        for(WXRemotionImgBtn *btn in imageArray){
            [btn setDelegate:self];
        }
    }
    return self;
}

-(void)load{
    NSInteger pageCount = [_subPageViews count];
    if(pageCount){
        [_browser setPagingEnabled:YES];
        [_pageControl setNumberOfPages:pageCount];
        [_pageControl setHidden:NO];
    }else{
        [_pageControl setHidden:NO];
    }
    
    for(WXRemotionImgBtn *imgView in _subPageViews){
        [imgView load];
    }
    
    [_browser setPagingEnabled:pageCount > 1];
    [_pageControl setHidden:pageCount <= 1];
    [_pageControl setNumberOfPages:pageCount];
    [_browser reload];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    // 在滚动超过页面宽度的50%的时候，切换到新的页面
    int page = floor((scrollView.contentOffset.x + pageWidth/2)/pageWidth) ;
    [_pageControl setCurrentPage:page];
}

- (void)buttonImageClicked:(id)sender{
    WXRemotionImgBtn *btn = sender;
    NSInteger index = [_subPageViews indexOfObject:btn];
    if(index == NSNotFound){
        return;
    }
    if(_delegate && [_delegate respondsToSelector:@selector(virtualClickTopGoodAtIndex:)]){
        [_delegate virtualClickTopGoodAtIndex:index];
    }
}


@end
