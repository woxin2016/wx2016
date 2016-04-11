//
//  VirtualSubGoodsInfoWebVC.h
//  RKWXT
//
//  Created by app on 16/4/6.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "NLSubViewController.h"
#import "WXTURLFeedOBJ.h"

@interface VirtualSubGoodsInfoWebVC : NLSubViewController
-(id)initWithFeedType:(WXT_UrlFeed_Type)urlFeedType paramDictionary:(NSDictionary*)paramDictionary;
@end
