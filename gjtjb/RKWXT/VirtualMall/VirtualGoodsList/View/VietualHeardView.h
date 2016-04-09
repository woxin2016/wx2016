//
//  VietualHeardView.h
//  RKWXT
//
//  Created by app on 16/4/5.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    HeardViewBtnStore = 0,
    HeardViewBtnExchange
}HeardViewBtn;

@protocol VietualHeardViewDelegate;
@interface VietualHeardView : UIView
@property (nonatomic,weak)id<VietualHeardViewDelegate> delegate;
@end


@protocol VietualHeardViewDelegate <NSObject>
- (void)vietualHeardViewClickBtnTag:(HeardViewBtn)tag;
@end
