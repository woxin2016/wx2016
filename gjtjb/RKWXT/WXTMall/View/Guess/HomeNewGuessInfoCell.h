//
//  HomeNewGuessInfoCell.h
//  RKWXT
//
//  Created by app on 16/3/4.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "WXMiltiViewCell.h"

@protocol HomeNewGuessInfoCellDelegate <NSObject>;
-(void)changeCellClicked:(id)entity;
@end

@interface HomeNewGuessInfoCell : WXMiltiViewCell
@property (nonatomic,assign)id<HomeNewGuessInfoCellDelegate>delegate;
@end



