//
//  HomeNewGuessInfoCell.m
//  RKWXT
//
//  Created by app on 16/3/4.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "HomeNewGuessInfoCell.h"
#import "NewHomePageCommonDef.h"
#import "T_ChangeView.h"

@implementation HomeNewGuessInfoCell

- (NSInteger)xNumber{
    return 2;
}

- (CGFloat)cellHeight{
    return T_HomePageGuessInfoHeight;
}

- (CGFloat)sideGap{
    return xGap;
}

- (CGSize)cpxViewSize{
    return CGSizeMake((IPHONE_SCREEN_WIDTH-3*xGap)/2+2-0.5,T_HomePageGuessInfoHeight);
}

- (WXCpxBaseView *)createSubCpxView{
    CGSize size = [self cpxViewSize];
    T_ChangeView *merchandiseView = [[T_ChangeView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    return merchandiseView;
}

@end
