//
//  VirtualStockGoodsView.m
//  RKWXT
//
//  Created by app on 16/4/9.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "VirtualStockGoodsView.h"
#import "VirtualGoodsInfoEntity.h"
#import "VirtualOrderInfoEntity.h"

#import "GoodsInfoStockCell.h"
#import "GoodsStockStyleCell.h"
#import "GoodsBuyNumberCell.h"

#import "NewGoodsStockView.h"

#define kAnimateDefaultDuration (0.3)
#define kMaskShellDefaultAlpha (0.6)

#define DownViewHeight (160)
#define Size [UIScreen mainScreen].bounds.size
#define buyBtnH (44)



@interface VirtualStockGoodsView ()<UITableViewDataSource,UITableViewDelegate,GoodsBuyNumberCellDelegate>
{
    UIView *_maskShell;
    UITableView *tableViews;
    NSArray *goodsArr;
    NSArray *goodsStockArr;
    WXUIButton *buyBtn;
    NSInteger buyNumber;
    VirtualGoodsInfoEntity *entity;
}
@end

@implementation VirtualStockGoodsView

-(id)init{
    self = [super init];
    if(self){
        [self initBaseInfo];
    }
    return self;
}

-(void)initBaseInfo{
    _maskShell = [[UIView alloc] init];
    _maskShell.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_maskShell setBackgroundColor:[UIColor blackColor]];
    [_maskShell setAlpha:kMaskShellDefaultAlpha];
    [self addSubview:_maskShell];
    
    
    tableViews = [[UITableView alloc]initWithFrame:CGRectMake(0,Size.height - DownViewHeight - buyBtnH, Size.width, DownViewHeight) style:UITableViewStylePlain];
    tableViews.delegate = self;
    tableViews.dataSource = self;
    tableViews.backgroundColor = [UIColor whiteColor];
    tableViews.showsHorizontalScrollIndicator = NO;
    tableViews.shouldGroupAccessibilityChildren = NO;
    tableViews.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableViews.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self addSubview:tableViews];
    
    [self tableFootView];
}

-(void)tableFootView{;
    buyBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    buyBtn.frame = CGRectMake(0, Size.height - buyBtnH, Size.width, buyBtnH);
    [buyBtn setBackgroundColor:WXColorWithInteger(AllBaseColor)];
    [buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyBtn.titleLabel setFont:WXFont(14.0)];
    [buyBtn setTitleColor:WXColorWithInteger(0xffffff) forState:UIControlStateNormal];
    [buyBtn addTarget:self action:@selector(buyBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:buyBtn];
}

#pragma mark --------- tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return VirtualGoodsInfoSection_Invalid;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 0;
    if (section == GoodsInfoSectionStock_Number) {
        row = [goodsStockArr count];
    }else{
        row = 1;
    }
    return row;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    CGFloat height = 0.0;
    switch (section) {
        case VirtualGoodsInfoSection_Entity:
            height = 80;
            break;
        case VirtualGoodsInfoSectionStock_Number:
            height = 30;
            break;
    }
    return height;
}

// 商品信息
- (WXUITableViewCell*)tableViewGoodsInfoWithRow:(NSInteger)row{
    GoodsInfoStockCell *cell = [GoodsInfoStockCell GoodsInfoStockCellWithTableView:tableViews];
    [cell setCellInfo:goodsStockArr[row]];
    cell.imgUrl = [goodsArr[0] homeImg];
    [cell load];
    
    if (self.type == VirtualStockView_Type_BuyStore) {
        [cell setPrice];
    }else{
        [cell setPriceAddXnb];
    }
    return cell;
}

// 商品样式
- (WXUITableViewCell*)tableViewGoodsStyleWithRow:(NSInteger)row{
    GoodsStockStyleCell *cell = [GoodsStockStyleCell GoodsStockStyleCellWithTableView:tableViews];
   VirtualGoodsInfoEntity *goodsEntity = goodsStockArr[row];
    [cell setCellInfo:goodsEntity];
    [cell load];
    if (row == 0) {
        [cell setLabelHid:NO];
    }else{
        [cell setLabelHid:YES];
    }
  
    [cell setLabelBackGroundColor:goodsEntity.selected];
    return cell;
}

//购买数量
- (WXUITableViewCell*)tableViewGoodsBuyNumber{
    GoodsBuyNumberCell *cell = [GoodsBuyNumberCell GoodsBuyNumberCellWithTableView:tableViews];
    cell.delegate = self;
    return cell;
}

- (WXUITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    if (section == GoodsInfoSection_Entity) {
        cell = [self tableViewGoodsInfoWithRow:indexPath.row];
    }else if (section == GoodsInfoSectionStock_Number){
        cell = [self tableViewGoodsStyleWithRow:indexPath.row];
    }
    return cell;
}

//选中  刷新
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    if (section == GoodsInfoSectionStock_Number) {  //刷新数据
        entity = goodsStockArr[row];
        
        
        for (VirtualGoodsInfoEntity *stock in goodsStockArr) {
            stock.selected = NO;
        }
        entity.selected = YES;
        
        buyNumber = 1;
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        GoodsInfoStockCell *cell = (GoodsInfoStockCell*)[tableView cellForRowAtIndexPath:path];
        [cell setCellInfo:entity];
        cell.imgUrl = [goodsArr[0] homeImg];
        [cell load];
        
        if (self.type == VirtualStockView_Type_BuyStore) {
            [cell setPrice];
        }else{
            [cell setPriceAddXnb];
        }
        
        [self buyGoodsInfoWithEntity:entity Number:buyNumber];
    }
    
    NSIndexPath *cellPath = [NSIndexPath indexPathForRow:0 inSection:GoodsInfoSectionBuy_Number];
    GoodsBuyNumberCell *buyCell = (GoodsBuyNumberCell*)[tableView cellForRowAtIndexPath:cellPath];
    [buyCell lookGoodsStockNumber:buyNumber];
    
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:GoodsInfoSectionStock_Number] withRowAnimation:UITableViewRowAnimationNone];
  
}


#pragma mark ------  data
- (void)VirtualGoodsStockInfo:(NSArray *)stockArr GoodsInfoArr:(NSArray *)goodsInfoArr{
    goodsArr = goodsInfoArr;
    goodsStockArr = stockArr;
    
    for (VirtualGoodsInfoEntity *stock in goodsStockArr) {
        if (stock.isDefault) {
            stock.selected = YES;
        }
    }

    
    CGFloat IPHONE_Width = [UIScreen mainScreen].bounds.size.width;
    CGFloat IPHONE_HEIGHT = [UIScreen mainScreen].bounds.size.height;
    [self setFrame:CGRectMake(0, 0,IPHONE_Width, IPHONE_HEIGHT)];
    
    __block VirtualStockGoodsView *blockSelf = self;
    [UIView animateWithDuration:kAnimateDefaultDuration animations:^{
        [blockSelf show];
    }];
    
    if (goodsInfoArr.count == 0 || stockArr.count == 0) return;
    
    if (self.type == NewGoodsStockView_Type_ShoppingCart) {
        [buyBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    }
    
    buyNumber = 1;
    entity = [stockArr objectAtIndex:0];
    
    [self buyGoodsInfo];
    
    self.virtualOrder = [VirtualOrderInfoEntity shareVirtualOrderAlloc];
}

#pragma mark  -- cellDelegate


-(void)goodsBuyAddNumber{
    if (buyNumber >= entity.stockNum ) {
        [UtilTool showAlertView:[NSString stringWithFormat:@"库存已不足%ld件",(long)buyNumber + 1]];
        return;
    }
    buyNumber ++;
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:GoodsInfoSectionBuy_Number];
    GoodsBuyNumberCell *cell = (GoodsBuyNumberCell*)[tableViews cellForRowAtIndexPath:path] ;
    [cell lookGoodsStockNumber:buyNumber];
    
    [self buyGoodsInfo];
}

-(void)goodsBuyRemoveNumber{
    if (buyNumber <= 1) {
        return;
    }
    buyNumber --;
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:GoodsInfoSectionBuy_Number];
    GoodsBuyNumberCell *cell = (GoodsBuyNumberCell*)[tableViews cellForRowAtIndexPath:path];
    [cell lookGoodsStockNumber:buyNumber];
    
    [self buyGoodsInfo];
}

- (void)buyGoodsInfo{
    [self buyGoodsInfoWithEntity:entity Number:buyNumber];
}

- (void)buyGoodsInfoWithEntity:(VirtualGoodsInfoEntity*)GoodsEntity Number:(NSInteger)Number{
    VirtualGoodsInfoEntity *infoEntity = goodsArr[0];
    self.virtualOrder.buyNumber = Number;
    self.virtualOrder.postage = infoEntity.postageVirtual;;
    self.virtualOrder.backMoney = GoodsEntity.backMoney;;
    self.virtualOrder.xnbPrice = GoodsEntity.xnb;
    self.virtualOrder.stockID = GoodsEntity.stockID;
    self.virtualOrder.goodsImg = infoEntity.homeImg;
    self.virtualOrder.stockName = GoodsEntity.stockName;
    self.virtualOrder.goodsName = infoEntity.goodsName;
    self.virtualOrder.goodsPrice = GoodsEntity.stockPrice;
}


#pragma mark  ----- show
- (void)show{
    [self setAlpha:1.0];
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [self isClicked];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self isClicked];
}

- (void)isClicked{
    [self unshowAnimated:YES];
}
- (void)unshow{
    [self setAlpha:0.0];
}


- (void)unshowAnimated:(BOOL)animated{
    if (animated){
        __block VirtualStockGoodsView *blockSelf = self;
        [UIView animateWithDuration:0.3 animations:^{
            [blockSelf unshow];
        } completion:^(BOOL finished) {
            [blockSelf removeFromSuperview];
        }];
        
    }else{
        [self removeFromSuperview];
    }
}


//立即购买或加入购物车
-(void)buyBtnClicked{
    [self buyGoodsInfo];
    
    if(_type == VirtualStockView_Type_BuyStore){
       [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_Name_VirtualStoreBuyGoods object:nil];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:K_Notification_Name_VirtualEXchangeBuyGoods object:nil];
    }
    
     entity.selected = NO;
     [self isClicked];
    
}


@end



