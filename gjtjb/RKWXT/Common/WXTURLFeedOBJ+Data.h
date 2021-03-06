//
//  WXTURLFeedOBJ+Data.h
//  RKWXT
//
//  Created by SHB on 15/3/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTURLFeedOBJ.h"

@interface WXTURLFeedOBJ (Data)
- (void)fetchDataFromFeedType:(WXT_UrlFeed_Type)type httpMethod:(WXT_HttpMethod)httpMethod timeoutIntervcal:(CGFloat)timeoutInterval feed:(NSDictionary*)feed completion:(void(^)(URLFeedData *retData))completion;

@end
