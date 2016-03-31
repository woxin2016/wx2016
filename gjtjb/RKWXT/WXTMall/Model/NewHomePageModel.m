//
//  NewHomePageModel.m
//  RKWXT
//
//  Created by SHB on 16/1/15.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "NewHomePageModel.h"
#import "HomePageTop.h"

@interface NewHomePageModel(){
    HomePageTop *_top;
    HomePageRecModel *_recommend;
    HomePageSurpModel *_surprise;
    HomeLimitGoodsModel *_limitGoods;
    HomePageClassifyModel *_classify;
}
@end

@implementation NewHomePageModel

-(id)init{
    self = [super init];
    if(self){
        _top = [[HomePageTop alloc] init];
        _recommend = [[HomePageRecModel alloc] init];
        _surprise = [[HomePageSurpModel alloc] init];
        _limitGoods = [[HomeLimitGoodsModel alloc]init];
        _classify = [[HomePageClassifyModel alloc] init];
    }
    return self;
}

-(void)toInit{
    [_top toInit];
    [_recommend toInit];
    [_surprise toInit];
    [_limitGoods toInit];
    [_classify toInit];
}

-(void)setDelegate:(id<HomePageTopDelegate,HomePageRecDelegate,HomePageSurpDelegate,HomeLimitGoodsDelegate,HomePageClassifyModelDelegate>)delegate{
    [_top setDelegate:delegate];
    [_recommend setDelegate:delegate];
    [_surprise setDelegate:delegate];
    [_limitGoods setDelegate:delegate];
    [_classify setDelegate:delegate];
}

-(BOOL)isSomeDataNeedReload{
    return [_top dataNeedReload] || [_recommend dataNeedReload] || [_surprise dataNeedReload] || [_limitGoods dataNeedReload] || [_classify dataNeedReload];
}

-(void)loadData{
    [_top loadData];
    [_recommend loadData];
    [_surprise loadData];
    [_limitGoods loadData];
    [_classify loadData];
}

@end
