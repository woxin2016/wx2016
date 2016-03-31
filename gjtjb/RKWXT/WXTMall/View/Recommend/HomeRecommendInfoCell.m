//
//  HomeRecommendInfoCell.m
//  RKWXT
//
//  Created by SHB on 16/1/7.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "HomeRecommendInfoCell.h"
#import "NewHomePageCommonDef.h"
#import "HomeRecommendInfoView.h"

#define xGap (0)
@implementation HomeRecommendInfoCell

- (NSInteger)xNumber{
    return RecommendShow;
}

- (CGFloat)cellHeight{
    return T_HomePageRecommendHeight;
}

- (CGFloat)sideGap{
    return 0;
}

- (CGSize)cpxViewSize{
    return CGSizeMake((IPHONE_SCREEN_WIDTH-3*xGap)/RecommendShow,T_HomePageRecommendHeight);
}

- (WXCpxBaseView *)createSubCpxView{
    CGSize size = [self cpxViewSize];
    HomeRecommendInfoView *merchandiseView = [[HomeRecommendInfoView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    return merchandiseView;
}

@end
