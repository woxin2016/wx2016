//
//  VirtualGoodsListVC.m
//  RKWXT
//
//  Created by app on 16/4/5.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "VirtualGoodsListVC.h"
#import "VirtualGoodsInfoVC.h"

#import "VietualHeardView.h"
#import "ViteualExchangeCell.h"
#import "ViteualStoreCell.h"
#import "VietualTopImgCell.h"

#import "ViteualGoodsModel.h"
#import "ViteualGoodsEntity.h"
#import "MJRefresh.h"
 enum{
    SubSections_TopImg = 0,
    SubSections_List,
    SubSections_Invalid
 };

#define heardViewH (44)


@interface VirtualGoodsListVC ()<UITableViewDelegate,UITableViewDataSource,VietualHeardViewDelegate,viteualGoodsModelDelegate>
{
    ViteualGoodsModel *_model;
    UITableView *_tableView;
    BOOL _isExchange;  // YES 为兑换商城  NO为品牌兑换
    VietualHeardView *_heardView;
}
@end

@implementation VirtualGoodsListVC

- (instancetype)init{
    if (self = [super init]) {
        _model = [[ViteualGoodsModel alloc]init];
        _model.delegate = self;
        _isExchange = NO;
        _heardView = [[VietualHeardView alloc]initWithFrame:CGRectMake(0, 0,IPHONE_SCREEN_WIDTH, heardViewH)];
        _heardView.delegate  =self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCSTTitle:@"云票返现"];
    
    [self initTabelView];
    
    [self requestNetWork];
    
    [self setupRefresh];
}

- (void)initTabelView{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
}

- (void)requestNetWork{
    [_model viteualGoodsModelRequeatNetWork:ModelType_Store start:0 length:10];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

- (void)setupRefresh{
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    
    //设置文字
    _tableView.headerPullToRefreshText = @"下拉刷新";
    _tableView.headerReleaseToRefreshText = @"松开刷新";
    _tableView.headerRefreshingText = @"刷新中";
    
    _tableView.footerPullToRefreshText = @"上拉加载";
    _tableView.footerReleaseToRefreshText = @"松开加载";
    _tableView.footerRefreshingText = @"加载中";
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return SubSections_Invalid;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 0;
    if (section == SubSections_TopImg) {
        row = 1;
    }else{
       row = _model.goodsArray.count;
    }
    return row;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0;
    switch (indexPath.section) {
        case SubSections_TopImg:
            height = 140;
            break;
            case SubSections_List:
            if (_isExchange) {
                height = [ViteualExchangeCell cellHeightOfInfo:nil];
            }else{
                height = [ViteualStoreCell cellHeightOfInfo:nil];
            }
        default:
            break;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == SubSections_List) {
        return heardViewH;
    }
    return 0.0;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == SubSections_List) {
        return _heardView;
    }
    return nil;
}

// 轮播图
- (WXUITableViewCell*)tableViewCellTopimg{
    VietualTopImgCell *cell = [VietualTopImgCell viteualTopImgCellWithTabelView:_tableView];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

// 兑换商城
- (WXUITableViewCell*)tableViewCellStore:(NSInteger)row{
    ViteualStoreCell *cell = [ViteualStoreCell viteualStoreCellWithTabelView:_tableView];
    [cell setCellInfo:_model.goodsArray[row]];
    [cell load];
    return cell;
}

// 品牌兑换
- (WXUITableViewCell*)tableViewCellExchange:(NSInteger)row{
    ViteualExchangeCell *cell = [ViteualExchangeCell viteualExchangeCellWithTabelView:_tableView];
    [cell setCellInfo:_model.goodsArray[row]];
    [cell load];
    return cell;
}

- (WXUITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WXUITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    switch (section) {
        case SubSections_TopImg:
            cell = [self tableViewCellTopimg];
            break;
        case SubSections_List:
            if (_isExchange) {
                cell =  [self tableViewCellExchange:indexPath.row];
            }else{
                cell = [self tableViewCellStore:indexPath.row];
            }
          break;
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == SubSections_List) {
        ViteualGoodsEntity *entity = _model.goodsArray[indexPath.row];
        VirtualGoodsInfoVC *infoVC = [[VirtualGoodsInfoVC alloc]init];
        infoVC.goodsID = entity.goodsID;
        [self.wxNavigationController pushViewController:infoVC];
    }
}

#pragma mark ---- heardViewDelegate
- (void)vietualHeardViewClickBtnTag:(HeardViewBtn)tag{
    switch (tag) {
        case HeardViewBtnStore:
        {
            _isExchange = NO;
             [_model viteualGoodsModelRequeatNetWork:ModelType_Store start:0 length:10];
        }
            break;
        case HeardViewBtnExchange:
        {
            _isExchange = YES;
            [_model viteualGoodsModelRequeatNetWork:ModelType_Exchange start:0 length:10];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -- footerRefreshing
- (void)footerRefreshing{
    if (_isExchange) {
        [_model viteualGoodsModelRequeatNetWork:ModelType_Exchange start:[_model.goodsArray count] length:10];
    }else{
        [_model viteualGoodsModelRequeatNetWork:ModelType_Store start:[_model.goodsArray count] length:10];
    }
}


#pragma mark ---- model deleagete
-(void)viteualGoodsModelFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    
    [_tableView footerEndRefreshing];
    [UtilTool showAlertView:errorMsg];
}

-(void)viteualGoodsModelSucceed{
    [self unShowWaitView];
    
    [_tableView footerEndRefreshing];
    [_tableView reloadData];
}

@end
