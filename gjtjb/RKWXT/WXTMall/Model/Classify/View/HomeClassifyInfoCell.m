//
//  HomeClassifyInfoCell.m
//  RKWXT
//
//  Created by SHB on 16/4/1.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "HomeClassifyInfoCell.h"
#import "NewHomePageCommonDef.h"
#import "HomeClassifyInfoView.h"

#define xGap (0)
@implementation HomeClassifyInfoCell

- (NSInteger)xNumber{
    return ClassifyShow;
}

- (CGFloat)cellHeight{
    return T_HomePageClassifyInfoHeight;
}

- (CGFloat)sideGap{
    return 0;
}

- (CGSize)cpxViewSize{
    return CGSizeMake(IPHONE_SCREEN_WIDTH/ClassifyShow,T_HomePageClassifyInfoHeight);
}

- (WXCpxBaseView *)createSubCpxView{
    CGSize size = [self cpxViewSize];
    HomeClassifyInfoView *merchandiseView = [[HomeClassifyInfoView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    return merchandiseView;
}

@end
