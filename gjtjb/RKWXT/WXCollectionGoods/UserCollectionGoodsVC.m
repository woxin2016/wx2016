//
//  UserCollectionGoodsVC.m
//  RKWXT
//
//  Created by app on 16/3/23.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "UserCollectionGoodsVC.h"
#import "CollectionGoodsCell.h"
#import "GoodsAttentionModel.h"
#import "WXGoodsInfoVC.h"
#import "CollectionGoodsEntity.h"
#import "MJRefresh.h"

#define Size self.bounds.size

@interface UserCollectionGoodsVC ()<UITableViewDataSource,UITableViewDelegate,CollectionGoodsCellDelegate>
{
    UITableView *_tableView;
    GoodsAttentionModel *_model;
    NSInteger deleteID;
}
@end

#define  collectionIndefi  @"collectionIndefi"

@implementation UserCollectionGoodsVC

- (instancetype)init{
    if (self = [super init]) {
        _model = [[GoodsAttentionModel alloc]init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setCSTTitle:@"收藏列表"];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    [self initSubView];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addOBS];
    
    [self setupRefresh];
}

- (void)initSubView{
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    _tableView.rowHeight = 212;
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

//集成刷新控件
-(void)setupRefresh{
    //1.下拉刷新(进入刷新状态会调用self的headerRefreshing)
    [_tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [_tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
//    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    
    //设置文字
    _tableView.headerPullToRefreshText = @"下拉刷新";
    _tableView.headerReleaseToRefreshText = @"松开刷新";
    _tableView.headerRefreshingText = @"刷新中";
    
    _tableView.footerPullToRefreshText = @"上拉加载";
    _tableView.footerReleaseToRefreshText = @"松开加载";
    _tableView.footerRefreshingText = @"加载中";
}

- (void)addOBS{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestSucceed) name:K_Notification_Name_GoodsAttentionModelSucceed object:_model];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestFaild:) name:K_Notification_Name_GoodsAttentionModelFailed object:nil];
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestDeleteGoodsSucceed) name:K_Notification_Name_GoodsAttentionModelDeleteSucceed object:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return (_model.goodsArr.count + 2 - 1) / 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CollectionGoodsCell *cell = [CollectionGoodsCell collectionGoodsCellWith:tableView];
    NSInteger row = (indexPath.row + 1) * 2;
    NSInteger count = _model.goodsArr.count;
    if (row > count) {
        row = count;
    }
    NSMutableArray *array = [NSMutableArray array];
    for (int i = indexPath.row * 2; i < row; i++) {
        [array addObject:_model.goodsArr[i]];
    }
    cell.height = 212;
    cell.entityArr = array;
    cell.delegate = self;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark  --  上拉刷新
- (void)headerRefreshing{
    [_model searchGoodsPayAttention:0 shopID:0 requestType:GoodsAttentionModel_Type_goodsList likeType:GoodsAttentionModel_likeType_Goods];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

#pragma mark -- delelgate

-(void)colltionGoodsCellClickDeleteGoods:(NSInteger)goodsID{
    deleteID = goodsID;
    WXUIAlertView *alertView = [[WXUIAlertView alloc] initWithTitle:@"" message:@"确定删除此商品吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0)return;
    [_model deleteGoodsID:deleteID requestType:GoodsAttentionModel_Type_removeGoods  likeType:GoodsAttentionModel_likeType_Goods];
}



-(void)colltionGoodsCellClickGoods:(NSInteger)goodsID{
    WXGoodsInfoVC *infoVC = [[WXGoodsInfoVC alloc]init];
    infoVC.goodsId = goodsID;
    [self.wxNavigationController pushViewController:infoVC];
}


#pragma mark -- NSNotification
- (void)requestFaild:(NSNotification*)tion{
    [self unShowWaitView];
    [self addAlphaView];
    [_tableView headerEndRefreshing];
}

- (void)requestSucceed{
    [self unShowWaitView];
    [_tableView headerEndRefreshing];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)requestDeleteGoodsSucceed{
    [self remoceLikeGoods];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    
    if ([_model.goodsArr count] == 0) {
        [self addAlphaView];
    }
}

- (void)remoceLikeGoods{
    NSMutableArray *array = [NSMutableArray arrayWithArray:_model.goodsArr];
    for (CollectionGoodsEntity *entity in array) {
        if (entity.deleGoodsID == deleteID) {
            [_model.goodsArr removeObject:entity];
        }
    }
}


- (void)addAlphaView{
   [_tableView removeFromSuperview];
    
    CGFloat yOffset = 100;
    CGFloat imgWidth = 90;
    CGFloat imgHeight = imgWidth;
    WXUIImageView *imgView = [[WXUIImageView alloc] init];
    imgView.frame = CGRectMake((IPHONE_SCREEN_WIDTH-imgWidth)/2, yOffset, imgWidth, imgHeight);
    [imgView setImage:[UIImage imageNamed:@"AddressEmptyImg.png"]];
    [self addSubview:imgView];
    
    CGFloat logoWidth = 44;
    CGFloat logoHeight = 38;
    WXUIImageView *logoView = [[WXUIImageView alloc] init];
    logoView.frame = CGRectMake((imgWidth-logoWidth)/2, (imgHeight-logoHeight)/2, logoWidth, logoHeight);
    [logoView setImage:[UIImage imageNamed:@"AddressEmptyCollention.png"]];
    [imgView addSubview:logoView];
    
    CGFloat nameWidth = 160;
    CGFloat nameHeight = 20;
    yOffset += imgHeight+5;
    WXUILabel *nameLabel = [[WXUILabel alloc] init];
    nameLabel.frame = CGRectMake((IPHONE_SCREEN_WIDTH-nameWidth)/2, yOffset, nameWidth, nameHeight);
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    [nameLabel setText:@"您还没收藏商品"];
    [nameLabel setTextColor:WXColorWithInteger(0x000000)];
    [nameLabel setFont:WXFont(16.0)];
    [self addSubview:nameLabel];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
