//
//  VirtualOrderListVC.m
//  RKWXT
//
//  Created by app on 16/4/11.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "VirtualOrderListVC.h"
#import "VirtualGoodsOrderVC.h"
#import "VirtualOrderInfoVC.h"

#import "VirtualOrderListCell.h"
#import "VirtualOrderListModel.h"
#import "virtualOrderListEntity.h"

#import "MJRefresh.h"


@interface VirtualOrderListVC ()<UITableViewDataSource,UITableViewDelegate,VirtualOrderListModelDelegate>
{
    UITableView *_tableView;
    VirtualOrderListModel *_model;
}
@end

@implementation VirtualOrderListVC

- (instancetype)init{
    if (self  =[super init]) {
        _model = [[VirtualOrderListModel alloc]init];
        _model.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setCSTTitle:@"云票订单"];
    
    [self initializeTableView];
    
    [self requestNetWork];
    
     [self setupRefresh];
}

- (void)initializeTableView{
    _tableView = [[UITableView alloc]initWithFrame:self.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 80;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self addSubview:_tableView];
}

- (void)requestNetWork{
    [_model loadVirtualOrderListWithStart:0 lenght:10];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

- (void)setupRefresh{
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_tableView addFooterWithTarget:self action:@selector(heardRefreshing)];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_tableView addHeaderWithTarget:self action:@selector(requestNetWork)];
    
    //设置文字
    _tableView.headerPullToRefreshText = @"下拉刷新";
    _tableView.headerReleaseToRefreshText = @"松开刷新";
    _tableView.headerRefreshingText = @"刷新中";
    
    _tableView.footerPullToRefreshText = @"上拉加载";
    _tableView.footerReleaseToRefreshText = @"松开加载";
    _tableView.footerRefreshingText = @"加载中";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _model.listArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VirtualOrderListCell *cell = [VirtualOrderListCell VirtualOrderListCellWithTabelView:_tableView];
    [cell setCellInfo:_model.listArray[indexPath.row]];
    [cell load];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    virtualOrderListEntity *entity = _model.listArray[indexPath.row];
    if ([self orderStants:entity]) {
        VirtualOrderInfoVC *infoVC = [[VirtualOrderInfoVC alloc]init];
        infoVC.entity = entity;
        [self.wxNavigationController pushViewController:infoVC];
    }
}

- (BOOL)orderStants:(virtualOrderListEntity*)entity{
    BOOL isOpen;
    if (entity.order_status == VirtualOrder_Status_Done) { //已完成
        isOpen = NO;
    }else{
        if (entity.pay_status == VirtualOrder_Pay_Done) { //已付款
            
            if (entity.send_status == VirtualOrder_Send_Done) { //已发货
                isOpen = NO;
            }else{
                isOpen = NO;
            }
            
        }else{  //未付款
            isOpen = YES;
        }
    }
    return isOpen;
}

#pragma mark -- model delegate
- (void)VirtualOrderListLoadSucceed{
    [self unShowWaitView];
     [_tableView footerEndRefreshing];
     [_tableView headerEndRefreshing];
    
    if ([_model.listArray count] == 0) {
        [self emptyBackimage];
    }
    
    [_tableView reloadData];
}

-(void)virtualGoodsOrderListFailed:(NSString *)failure{
    [self unShowWaitView];
    [_tableView footerEndRefreshing];
    [_tableView headerEndRefreshing];
    [UtilTool showAlertView:failure];
}

- (void)emptyBackimage{
    CGFloat yOffset = 100;
    CGFloat imgWidth = 90;
    CGFloat imgHeight = imgWidth;
    WXUIImageView *imgView = [[WXUIImageView alloc] init];
    imgView.frame = CGRectMake((IPHONE_SCREEN_WIDTH-imgWidth)/2, yOffset, imgWidth, imgHeight);
    [imgView setImage:[UIImage imageNamed:@"AddressEmptyImg.png"]];
    [self addSubview:imgView];
    
    CGFloat logoWidth = 45;
    CGFloat logoHeight = logoWidth;
    WXUIImageView *logoView = [[WXUIImageView alloc] init];
    logoView.frame = CGRectMake((imgWidth-logoWidth)/2, (imgHeight-logoHeight)/2, logoWidth, logoHeight);
    [logoView setImage:[UIImage imageNamed:@"virtualOrder.png"]];
    [imgView addSubview:logoView];
    
    CGFloat nameWidth = 160;
    CGFloat nameHeight = 20;
    yOffset += imgHeight+5;
    WXUILabel *nameLabel = [[WXUILabel alloc] init];
    nameLabel.frame = CGRectMake((IPHONE_SCREEN_WIDTH-nameWidth)/2, yOffset, nameWidth, nameHeight);
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    [nameLabel setText:@"您还没添加收货地址"];
    [nameLabel setTextColor:WXColorWithInteger(0x000000)];
    [nameLabel setFont:WXFont(16.0)];
    [self addSubview:nameLabel];
}

#pragma mark -- footerRefreshing
- (void)heardRefreshing{
   [_model loadVirtualOrderListWithStart:[_model.listArray count] lenght:10];
}




@end
