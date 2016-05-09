//
//  VirtualGoodsListVC.m
//  RKWXT
//
//  Created by app on 16/4/5.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "VirtualGoodsListVC.h"
#import "VirtualGoodsInfoVC.h"
#import "RechargeCloudTicketVC.h"


#import "VietualHeardView.h"
#import "VietualFootView.h"
#import "ViteualExchangeCell.h"
#import "ViteualStoreCell.h"
#import "VietualTopImgCell.h"

#import "ViteualGoodsModel.h"
#import "ViteualGoodsEntity.h"
#import "HomePageTopEntity.h"
#import "MJRefresh.h"

 enum{
    SubSections_TopImg = 0,
    SubSections_List,
    SubSections_Invalid
 };

enum{
    HomePageJump_Type_GoodsInfo = 1,    //商品详情
    HomePageJump_Type_Catagary,         //分类列表
    HomePageJump_Type_MessageCenter,    //消息中心
    HomePageJump_Type_MessageInfo,      //消息详情
    HomePageJump_Type_UserBonus,        //红包
    HomePageJump_Type_BusinessAlliance, //商家联盟
    HomePageJump_Type_Web,              //跳转网页
    HomePageJump_Type_None,             //不跳转
    HomePageJump_Type_XNBRechange,      //云票充值中心
    
    HomePageJump_Type_Invalid
};

#define heardViewH (44)


@interface VirtualGoodsListVC ()<UITableViewDelegate,UITableViewDataSource,VietualHeardViewDelegate,viteualGoodsModelDelegate,VietualTopImgCellDelegate,VietualFootViewDelegate,UIScrollViewDelegate>
{
    ViteualGoodsModel *_model;
    UITableView *_tableView;
    BOOL _isExchange;  // YES 为兑换商城  NO为品牌兑换
    VietualHeardView *_heardView;
    VietualFootView *_footView;
    UIButton *_backTop;
}
@end

@implementation VirtualGoodsListVC

- (instancetype)init{
    if (self = [super init]) {
         _isExchange = NO;
        _model = [[ViteualGoodsModel alloc]init];
        _model.delegate = self;
        _heardView = [[VietualHeardView alloc]initWithFrame:CGRectMake(0, 0,IPHONE_SCREEN_WIDTH, heardViewH)];
        _heardView.delegate  =self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    [self setCSTTitle:@"免费兑换"];
    
    [self.view addSubview:[self rightBtn]];
    
    [self initTabelView];
    
    [self requestNetWork];
    
    [self setupRefresh];
}

-(WXUIButton*)rightBtn{
    CGFloat btnWidth = 85;
    CGFloat btnHeight = 20;
    WXUIButton *rightBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(self.bounds.size.width-btnWidth - 10, 33, btnWidth, btnHeight);
    [rightBtn setBackgroundColor:[UIColor clearColor]];
    [rightBtn setTitle:@"余额/云票充值" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:WXFont(13.0)];
    [rightBtn addTarget:self action:@selector(gotoRechargeCTVC) forControlEvents:UIControlEventTouchUpInside];
    
    return rightBtn;
}

- (void)initTabelView{
    _tableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [self tableViewFootView];
    [self addSubview:_tableView];
    
    UIImage *btnImg = [UIImage imageNamed:@"backTopImg.png"];
    _backTop = [[UIButton alloc]initWithFrame:CGRectMake(self.bounds.size.width - 65, self.bounds.size.height - 65,45,45)];
    [_backTop setBorderRadian:_backTop.width / 2 width:0 color:[UIColor clearColor]];
    [_backTop addTarget:self action:@selector(backTopBtn) forControlEvents:UIControlEventTouchDown];
    [_backTop setBackgroundImage:btnImg forState:UIControlStateNormal];
    [self.view addSubview:_backTop];
}

- (UIView*)tableViewFootView{
    _footView = [[VietualFootView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, heardViewH)];
    _footView.delegate = self;
    return _footView;
}

- (void)requestNetWork{
    [_model virtualLoadDataFromWeb];
    
    if (_isExchange) {
        [_model viteualGoodsModelRequeatNetWork:ModelType_Exchange start:0 length:10];
    }else{
        [_model viteualGoodsModelRequeatNetWork:ModelType_Store start:0 length:10];
    }
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

- (void)setupRefresh{
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_tableView addHeaderWithTarget:self action:@selector(requestNetWork)];
    
    //设置文字
    _tableView.headerPullToRefreshText = @"下拉刷新";
    _tableView.headerReleaseToRefreshText = @"松开刷新";
    _tableView.headerRefreshingText = @"刷新中";
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    UIColor *color = [UIColor colorWithHexString:@"f74f35"];
    CGFloat offset=scrollView.contentOffset.y;
    if(offset <= 0){
        [_backTop setHidden:YES];
    }
 
    if(offset > 0){
        [_backTop setHidden:NO];
        CGFloat alpha = offset / 640;
        _backTop.backgroundColor = [color colorWithAlphaComponent:alpha];
    }

    if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 40) {
        [_footView footbtnWithTitle:@"正在加载中" andIsStart:YES];
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.frame.size.height + scrollView.contentOffset.y > scrollView.contentSize.height + 30) {
        [self vietualFootViewClickFootBtn];
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return SubSections_Invalid;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 0;
    if (section == SubSections_TopImg) {
        row = 1;
    }else{
        if (_isExchange) {
             row = _model.exchangeArray.count;
        }else{
             row = _model.storeArray.count;
        }
    }
    return row;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0;
    switch (indexPath.section) {
        case SubSections_TopImg:
            height = [VietualTopImgCell cellHeightOfInfo:nil];
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
    [cell setDelegate:self];
    [cell setCellInfo:_model.downImgArr];
    [cell load];
    return cell;
}

// 兑换商城
- (WXUITableViewCell*)tableViewCellStore:(NSInteger)row{
    ViteualStoreCell *cell = [ViteualStoreCell viteualStoreCellWithTabelView:_tableView];
       [cell setCellInfo:_model.storeArray[row]];
       [cell load];
    return cell;
}

// 品牌兑换
- (WXUITableViewCell*)tableViewCellExchange:(NSInteger)row{
    ViteualExchangeCell *cell = [ViteualExchangeCell viteualExchangeCellWithTabelView:_tableView];
    [cell setCellInfo:_model.exchangeArray[row]];
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
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == SubSections_List) {
        ViteualGoodsEntity *entity = nil;
        VirtualGoodsInfoVC *infoVC = [[VirtualGoodsInfoVC alloc]init];
        
        if (_isExchange) {
            entity = _model.exchangeArray[indexPath.row];
            infoVC.type = VirtualGoodsType_Exchange;
        }else{
            entity = _model.storeArray[indexPath.row];
            infoVC.type = VirtualGoodsType_Store;
        }
        
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
    
    [_footView footbtnWithTitle:@"点击加载更多" andIsStart:NO];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

#pragma mark -- footerRefreshing
- (void)vietualFootViewClickFootBtn{
    [_footView footbtnWithTitle:@"正在加载中" andIsStart:YES];
    
    if (_isExchange) {
        [_model viteualGoodsModelRequeatNetWork:ModelType_Exchange start:[_model.exchangeArray count] length:10];
    }else{
        [_model viteualGoodsModelRequeatNetWork:ModelType_Store start:[_model.storeArray count] length:10];
    }
}

#pragma mark -- topImg
-(void)clickTopGoodAtIndex:(NSInteger)index{
    HomePageTopEntity *entity = nil;
    if([_model.downImgArr count] > 0){
        entity = [_model.downImgArr objectAtIndex:index];
    }
    
    if(index >= HomePageJump_Type_Invalid){
        return;
    }
    [self homePageClickJump:entity.topAddID withLinkID:entity.linkID withWebUrl:entity.url_address];
}

-(void)homePageClickJump:(NSInteger)addID withLinkID:(NSInteger)linkID withWebUrl:(NSString*)webUrl{
    switch (addID) {
        case HomePageJump_Type_GoodsInfo:
        {
            [[CoordinateController sharedCoordinateController] toGoodsInfoVC:self goodsID:linkID animated:YES];
        }
            break;
        case HomePageJump_Type_Catagary:
        {
            [[CoordinateController sharedCoordinateController] toGoodsClassifyVC:self catID:linkID animated:YES];
        }
            break;
        case HomePageJump_Type_MessageCenter:
        {
            [self toSysPushMsgView];
        }
            break;
        case HomePageJump_Type_MessageInfo:
        {
            [[CoordinateController sharedCoordinateController] toJPushMessageInfoVC:self messageID:linkID animated:YES];
        }
            break;
        case HomePageJump_Type_UserBonus:
        {
            [[CoordinateController sharedCoordinateController] toUserBonusVC:self animated:YES];
        }
            break;
        case HomePageJump_Type_BusinessAlliance:
        {
            NSString *shopUnionUrl = [NSString stringWithFormat:@"%@wx_union/index.php/Public/alliance_merchant",WXTBaseUrl];
            [[CoordinateController sharedCoordinateController] toWebVC:self url:shopUnionUrl title:@"商家联盟" animated:YES];
        }
            break;
        case HomePageJump_Type_Web:
        {
            [[CoordinateController sharedCoordinateController] toWebVC:self url:webUrl title:@"使用说明" animated:YES];
        }
            break;
        case HomePageJump_Type_XNBRechange:
        {
            [[CoordinateController sharedCoordinateController] toXNBRechargeVC:self animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)toSysPushMsgView{
    [[CoordinateController sharedCoordinateController] toJPushCenterVC:self animated:YES];
}

#pragma mark ---- model deleagete
-(void)viteualGoodsModelFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    
    [_tableView headerEndRefreshing];
    [_tableView footerEndRefreshing];
    [UtilTool showAlertView:errorMsg];
}

-(void)viteualGoodsModelSucceed{
    [self unShowWaitView];
    [_footView footbtnWithTitle:@"查看更多" andIsStart:NO];
    
    
    [_tableView headerEndRefreshing];
    [_tableView footerEndRefreshing];
    [_tableView reloadData];
    _tableView.frame = self.bounds;
}

-(void)viteualTopImgFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    
    [UtilTool showRoundView:errorMsg];
}

- (void)vieualNoGoodsData{
    [self unShowWaitView];
     [_footView footbtnWithTitle:@"无更多" andIsStart:NO];
}

-(void)viteualTopImgSucceed{
     [self unShowWaitView];
     [_tableView reloadSections:[NSIndexSet indexSetWithIndex:SubSections_TopImg] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -- gotoRechargeCTVC
- (void)gotoRechargeCTVC{
    RechargeCloudTicketVC *cloudTicketVC = [[RechargeCloudTicketVC alloc] init];
    [self.wxNavigationController pushViewController:cloudTicketVC];
}


#pragma mark -- btn
- (void)backTopBtn{
    [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}



@end
