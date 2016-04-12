//
//  HomePageTopEntity.h
//  RKWXT
//
//  Created by SHB on 16/1/15.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomePageTopEntity : NSObject
@property (nonatomic,assign) NSInteger topAddID;
@property (nonatomic,assign) NSInteger linkID; //链接地址
@property (nonatomic,strong) NSString *topImg; //图片URL
@property (nonatomic,assign) NSInteger sortID; //排序
@property (nonatomic,assign) NSInteger position;  //显示位置   1.首页顶部 2.首页中间  3.首页底部  4.兑换商城  5.发现
@property (nonatomic,strong) NSString *url_address; //跳转的网站

+(HomePageTopEntity*)homePageTopEntityWithDictionary:(NSDictionary*)dic;

@end
