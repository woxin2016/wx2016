//
//  WXTMallViewController.m
//  RKWXT
//
//  Created by RoderickKennedy on 15/3/23.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "WXTMallViewController.h"
#import "NewHomePageCommonDef.h"

@interface WXTMallViewController ()<UITableViewDelegate,UITableViewDataSource,WXSysMsgUnreadVDelegate,WXHomeTopGoodCellDelegate,WXHomeBaseFunctionCellBtnClicked,HomeLimitBuyCellDelegate,HomeRecommendInfoCellDelegate,MailShareViewDelegate,HomePageTopDelegate,HomePageRecDelegate,HomePageSurpDelegate,HomeNewGuessInfoCellDelegate,HomeLimitGoodsDelegate,HomePageCommonImgCellDelegate,HomePageClassifyModelDelegate,HomeClassifyInfoCellDelegate,HomeClassifyTitleCellDelegate>{
    UITableView *_tableView;
    WXSysMsgUnreadV * _unreadView;
    NewHomePageModel *_model;
    BOOL buyGoods;
    
    WXUIButton *titleBtn;
    WXUIView *topView;
}
@end

@implementation WXTMallViewController

-(void)dealloc{
    RELEASE_SAFELY(_tableView);
    RELEASE_SAFELY(_model);
    [_model setDelegate:nil];
    [super dealloc];
}

-(id)init{
    self = [super init];
    if(self){
        _model = [[NewHomePageModel alloc] init];
        [_model setDelegate:self];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCSTNavigationViewHidden:YES animated:NO];
    [self addOBS];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self addSubview:_tableView];
    [self setupRefresh];
    [self createTopBtn];
   
    [_model loadData];
    buyGoods = NO;
}

-(void)createTopBtn{
    topView = [[WXUIView alloc] init];
    topView.frame = CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, 60);
    [topView setBackgroundColor:[UIColor clearColor]];
    [topView setBackgroundImage:[UIImage imageNamed:@"HomeTopBgImg.png"]];
    [self.view addSubview:topView];
    
    CGFloat btnWidth = 200;
    CGFloat btnHieght = 20;
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    titleBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    titleBtn.frame = CGRectMake((IPHONE_SCREEN_WIDTH-btnWidth)/2, 30, btnWidth, btnHieght);
    [titleBtn.titleLabel setFont:WXFont(17.0)];
    [titleBtn setBackgroundColor:[UIColor clearColor]];
    [titleBtn setTitle:userObj.sellerName forState:UIControlStateNormal];
    [titleBtn setTitleColor:WXColorWithInteger(0xffffff) forState:UIControlStateNormal];
    [titleBtn addTarget:self action:@selector(changeSellerVC) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:titleBtn];
    
    
    WXUIButton *leftBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(20, 18, 45, 40);
    [leftBtn setImage:[UIImage imageNamed:@"HomePageLeftBtn.png"] forState:UIControlStateNormal];
    [leftBtn setTitle:@"分类" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftBtn.titleLabel setFont:WXFont(10.0)];
    [leftBtn addTarget:self action:@selector(homePageToCategaryView) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:leftBtn];
    
    CGPoint buttonBoundsCenter = CGPointMake(CGRectGetMidX(leftBtn.titleLabel.bounds), CGRectGetMidY(leftBtn.titleLabel.bounds));
    CGPoint endImageViewCenter = CGPointMake(buttonBoundsCenter.x, CGRectGetMidY(leftBtn.imageView.bounds));
    CGPoint endTitleLabelCenter = CGPointMake(buttonBoundsCenter.x, CGRectGetHeight(leftBtn.bounds)-CGRectGetMidY(leftBtn.titleLabel.bounds));
    CGPoint startImageViewCenter = leftBtn.imageView.center;
    CGPoint startTitleLabelCenter = leftBtn.titleLabel.center;
    CGFloat imageEdgeInsetsLeft = endImageViewCenter.x - startImageViewCenter.x;
    CGFloat imageEdgeInsetsRight = -imageEdgeInsetsLeft;
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, imageEdgeInsetsLeft, 40/3, imageEdgeInsetsRight);
    CGFloat titleEdgeInsetsLeft = endTitleLabelCenter.x - startTitleLabelCenter.x;
    CGFloat titleEdgeInsetsRight = -titleEdgeInsetsLeft;
    leftBtn.titleEdgeInsets = UIEdgeInsetsMake(40*2/3-5, titleEdgeInsetsLeft, 0, titleEdgeInsetsRight);
    
    _unreadView = [[WXSysMsgUnreadV alloc] initWithFrame:CGRectMake(IPHONE_SCREEN_WIDTH-40, 18, 44, 44)];
    [_unreadView setDelegate:self];
    [_unreadView showSysPushMsgUnread];
    [topView addSubview:_unreadView];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(IPHONE_SCREEN_WIDTH - 60, 18, 40, 40)];
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(toSysPushMsgView) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:btn];
    
}

//用户切换商家通知
-(void)addOBS{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userChangeSeller) name:KNotification_Name_UserChangeSeller object:nil];
}

//集成刷新控件
-(void)setupRefresh{
    [_tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
//    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    
    //设置文字
    _tableView.headerPullToRefreshText = @"下拉刷新";
    _tableView.headerReleaseToRefreshText = @"松开刷新";
    _tableView.headerRefreshingText = @"刷新中";
    
    _tableView.footerPullToRefreshText = @"上拉加载";
    _tableView.footerReleaseToRefreshText = @"松开加载";
    _tableView.footerRefreshingText = @"加载中";
}

#pragma mark scrollChangeTitle
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    UIColor *color = WXColorWithInteger(AllBaseColor);
    CGFloat offset=scrollView.contentOffset.y;
    if(offset == 0){
        [topView setHidden:NO];
        [topView setBackgroundImage:[UIImage imageNamed:@"HomeTopBgImg.png"]];
    }
    if (offset < 0) {
        [topView setHidden:YES];
    }
    if(offset > 0){
        [topView setBackgroundImage:nil];
        [topView setHidden:NO];
        CGFloat alpha = 1-((T_HomePageTopImgHeight-60-offset)/(T_HomePageTopImgHeight-60));
        topView.backgroundColor = [color colorWithAlphaComponent:alpha];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return T_HomePage_Invalid;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 0;
    switch (section) {
        case T_HomePage_TopImg:
        case T_HomePage_BaseFunction:
        case T_HomePage_RecomendTitle:
        case T_HomePage_GuessTitle:
            row = 1;
            break;
        case T_HomePage_LimitBuyInfo:
        case T_HomePage_LimitBuyTitle:
            row = 0;
            if ([_model.limitGoods.data count] > 0) {
            row = 1;
            }
            break;
        case T_HomePage_CenterImg:
            if([_model.top.centerImgArr count] == 1){
                row = 1;
            }
            break;
        case T_HomePage_DownImg:
            if([_model.top.downImgArr count] == 1){
                row = 1;
            }
            break;
        case T_HomePage_ClassifyTitle:
            if([_model.classify.data count] > 0){
                row = 1;
            }
            break;
        case T_HomePage_ClassifyInfo:
            if([_model.classify.data count] > 0){
                row = [_model.classify.data count]/ClassifyShow+([_model.classify.data count]%ClassifyShow>0?1:0);
            }
            break;
        case T_HomePage_RecomendInfo:
            row = [_model.recommend.data count]/RecommendShow+([_model.recommend.data count]%RecommendShow>0?1:0);
            break;
        case T_HomePage_GuessInfo:
            row = [_model.surprise.data count]/GuessInfoShow+([_model.surprise.data count]%GuessInfoShow>0?1:0);
            break;
        default:
            break;
    }
    return row;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == T_HomePage_TopImg || section == T_HomePage_BaseFunction || section == T_HomePage_ClassifyInfo){
        return 0;
    }
    if([_model.limitGoods.data count] == 0 && (section==T_HomePage_LimitBuyInfo || section==T_HomePage_LimitBuyTitle)){
        return 0;
    }
    if(section == T_HomePage_LimitBuyInfo || section == T_HomePage_RecomendInfo || section == T_HomePage_GuessInfo){
        return 0;
    }
    if(section == T_HomePage_CenterImg && [_model.top.centerImgArr count] == 0){
        return 0;
    }
    if(section == T_HomePage_DownImg && [_model.top.downImgArr count] == 0){
        return 0;
    }
    if(section == T_HomePage_DownImg && [_model.top.downImgArr count] == 1){
        return 0;
    }
    return 7;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    WXUIView *backgroundView = [[[WXUIView alloc] init] autorelease];
    backgroundView.frame = CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, 7);
    [backgroundView setBackgroundColor:WXColorWithInteger(0xeeeeee)];
    return backgroundView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0;
    NSInteger section = indexPath.section;
    switch (section) {
        case T_HomePage_TopImg:
            height = T_HomePageTopImgHeight;
            break;
        case T_HomePage_BaseFunction:
            height = T_HomePageBaseFunctionHeight;
            break;
        case T_HomePage_LimitBuyTitle:
        case T_HomePage_RecomendTitle:
        case T_HomePage_GuessTitle:
        case T_HomePage_ClassifyTitle:
            height = T_HomePageTextSectionHeight;
            break;
        case T_HomePage_ClassifyInfo:
            height = T_HomePageClassifyInfoHeight;
            break;
        case T_HomePage_LimitBuyInfo:
            height = T_HomePageLimitBuyHeight;
            break;
        case T_HomePage_CenterImg:
        case T_HomePage_DownImg:
            height = T_HomePageCommonImgHeight;
            break;
        case T_HomePage_RecomendInfo:
            height = T_HomePageRecommendHeight;
            break;
        case T_HomePage_GuessInfo:
            height = T_HomePageGuessInfoHeight;
            break;
        default:
            break;
    }
    return height;
}

#pragma mark cell
///顶部导航
-(WXUITableViewCell*)headImgCell{
    static NSString *identifier = @"headImg";
    WXHomeTopGoodCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[WXHomeTopGoodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    [cell setDelegate:self];
    [cell setCellInfo:_model.top.data];
    [cell load];
    return cell;
}

//中间
-(WXUITableViewCell*)commonCenterImgCell{
    static NSString *identifier = @"centerImg";
    HomePageCommonImgCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[HomePageCommonImgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    [cell setDelegate:self];
    if([_model.top.centerImgArr count] > 0){
        [cell setCellInfo:[_model.top.centerImgArr objectAtIndex:0]];
    }
    [cell load];
    return cell;
}

//底部
-(WXUITableViewCell*)commonDownImgCell{
    static NSString *identifier = @"downImg";
    HomePageCommonImgCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[HomePageCommonImgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    [cell setDelegate:self];
    if([_model.top.downImgArr count] > 0){
        [cell setCellInfo:[_model.top.downImgArr objectAtIndex:0]];
    }
    [cell load];
    return cell;
}

//基本功能入口
-(WXUITableViewCell*)tableViewForBaseFunctionCell{
    static NSString *identifier = @"baseFunctionCell";
    WXHomeBaseFunctionCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[WXHomeBaseFunctionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell load];
    [cell setDelegate:self];
    return cell;
}

//秒杀
-(WXUITableViewCell*)tableViewForLimitBuyTitleCell{
    static NSString *identifier = @"limitBuyTitle";
    HomeLimitBuyTitleCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[HomeLimitBuyTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if ([_model.limitGoods.data count ] > 0) {
        [cell setCellInfo:_model.limitGoods.data[0]];
        [cell load];
    }
    return cell;
}

-(WXUITableViewCell*)tableViewForLimitBuy:(NSInteger)row{
    static NSString *identifier = @"limitBuyCell";
    HomeLimitBuyCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[HomeLimitBuyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    [cell setBackgroundColor:WXColorWithInteger(HomePageBGColor)];
    
    if ([_model.limitGoods.data count ] > 0) {
        [cell setCellInfo:[_model.limitGoods.data lastObject]];
        [cell setDelegate:self];
    }
   
    return cell;
}

//为我推荐
-(WXUITableViewCell*)tableViewForMeCell{
    static NSString *identifier = @"recommendTitleCell";
    WXUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[WXUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_None];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:WXColorWithInteger(HomePageBGColor)];
    [cell.textLabel setText:@"为我推荐"];
    [cell.textLabel setFont:[UIFont systemFontOfSize:TextFont]];
    [cell.textLabel setTextColor:WXColorWithInteger(0xf74f35)];
    
    UIView *didView = [[UIView alloc]initWithFrame:CGRectMake(0, T_HomePageTextSectionHeight - 0.5, cell.width, 0.5)];
    didView.backgroundColor = WXColorWithInteger(0xcacaca);
    [cell.contentView addSubview:didView];
    return cell;
}

-(WXUITableViewCell*)tableViewForRecommendCell:(NSInteger)row{
    static NSString *identifier = @"recommendInfoCell";
    HomeRecommendInfoCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[HomeRecommendInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:WXColorWithInteger(HomePageBGColor)];
    NSMutableArray *rowArray = [NSMutableArray array];
    NSInteger max = (row+1)*RecommendShow;
    NSInteger count = [_model.recommend.data count];
    if(max > count){
        max = count;
    }
    for(NSInteger i = row*RecommendShow; i < max; i++){
        [rowArray addObject:[_model.recommend.data objectAtIndex:i]];
    }
    [cell setDelegate:self];
    [cell loadCpxViewInfos:rowArray];
    return cell;
}

//分类
-(WXUITableViewCell*)tableViewForClassifyTitleCell{
    static NSString *identifier = @"ClassifyTitleCell";
    HomeClassifyTitleCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[HomeClassifyTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_None];
    [cell setDelegate:self];
    return cell;
}

-(WXUITableViewCell*)tableViewForClassInfoCell:(NSInteger)row{
    static NSString *identifier = @"HomeNewClassifyInfoCell";
    HomeClassifyInfoCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[HomeClassifyInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSMutableArray *rowArray = [NSMutableArray array];
    NSInteger max = (row+1)*ClassifyShow;
    NSInteger count = [_model.classify.data count];
    if(max > count){
        max = count;
    }
    for(NSInteger i = row*ClassifyShow; i < max; i++){
        [rowArray addObject:[_model.classify.data objectAtIndex:i]];
    }
    [cell setDelegate:self];
    [cell loadCpxViewInfos:rowArray];
    return cell;
}

//猜你喜欢
-(WXUITableViewCell*)tableViewForGuessCell{
    static NSString *identifier = @"guessTitleCell";
    WXUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[WXUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_None];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:WXColorWithInteger(HomePageBGColor)];
    [cell.textLabel setText:@"猜你喜欢"];
    [cell.textLabel setFont:[UIFont systemFontOfSize:TextFont]];
    [cell.textLabel setTextColor:WXColorWithInteger(0xf74f35)];
    
    UIView *didView = [[UIView alloc]initWithFrame:CGRectMake(0, T_HomePageTextSectionHeight - 0.5, cell.width, 0.5)];
    didView.backgroundColor = WXColorWithInteger(0xcacaca);
    didView.alpha = 0.5;
    [cell.contentView addSubview:didView];
    return cell;
}


-(WXUITableViewCell*)tableViewForGuessInfoCell:(NSInteger)row{
    static NSString *identifier = @"HomeNewGuessInfoCell";
    HomeNewGuessInfoCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[HomeNewGuessInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:WXColorWithInteger(HomePageBGColor)];
    NSMutableArray *rowArray = [NSMutableArray array];
    NSInteger max = (row+1)*2;
    NSInteger count = [_model.surprise.data count];
    if(max > count){
        max = count;
    }
    for(NSInteger i = row*2; i < max; i++){
        [rowArray addObject:[_model.surprise.data objectAtIndex:i]];
    }
    [cell setDelegate:self];
    [cell loadCpxViewInfos:rowArray];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    switch (section) {
        case T_HomePage_TopImg:
            cell = [self headImgCell];
            break;
        case T_HomePage_BaseFunction:
            cell = [self tableViewForBaseFunctionCell];
            break;
        case T_HomePage_LimitBuyTitle:
            cell = [self tableViewForLimitBuyTitleCell];
            break;
        case T_HomePage_LimitBuyInfo:
            cell = [self tableViewForLimitBuy:row];
            break;
        case T_HomePage_CenterImg:
            cell = [self commonCenterImgCell];
            break;
        case T_HomePage_DownImg:
            cell = [self commonDownImgCell];
            break;
        case T_HomePage_RecomendTitle:
            cell = [self tableViewForMeCell];
            break;
        case T_HomePage_RecomendInfo:
            cell = [self tableViewForRecommendCell:row];
            break;
        case T_HomePage_ClassifyTitle:
            cell = [self tableViewForClassifyTitleCell];
            break;
        case T_HomePage_ClassifyInfo:
            cell = [self tableViewForClassInfoCell:row];
            break;
        case T_HomePage_GuessTitle:
            cell = [self tableViewForGuessCell];
            break;
        case T_HomePage_GuessInfo:
            cell = [self tableViewForGuessInfoCell:row];
            break;
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark 导航
- (void)toSysPushMsgView{
    [[CoordinateController sharedCoordinateController] toJPushCenterVC:self animated:YES];
}

-(void)changeSellerVC{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    if([userObj.userIentifier integerValue] == 1){
        SellerChangeVC *vc = [[SellerChangeVC alloc] init];
        [self.wxNavigationController pushViewController:vc];
    }
}

-(void)homePageToCategaryView{
    [[CoordinateController sharedCoordinateController] toGoodsClassifyVC:self catID:0 animated:YES];
}

#pragma mark topimg
-(void)clickTopGoodAtIndex:(NSInteger)index{
    HomePageTopEntity *entity = nil;
    if([_model.top.data count] > 0){
        entity = [_model.top.data objectAtIndex:index];
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
            [[CoordinateController sharedCoordinateController] toWebVC:self url:webUrl title:@"网站" animated:YES];
        }
            break;
        default:
            break;
    }
}

-(void)homepageCommonImgCellClicked:(id)sender{
    HomePageTopEntity *entity = sender;
    [self homePageClickJump:entity.topAddID withLinkID:entity.linkID withWebUrl:entity.url_address];
}

#pragma mark baseFunction
-(void)wxHomeBaseFunctionBtnClickedAtIndex:(T_BaseFunction)index with:(UIView *)view{
    if(index >= T_BaseFunction_Invalid){
        return;
    }
    switch (index) {
        case T_BaseFunction_Sign:
        {
            SignViewController *signVC = [[SignViewController alloc] init];
            [self.wxNavigationController pushViewController:signVC];
        }
            break;
        case T_BaseFunction_Wallet:
        {
            UserBonusVC *boundsVC = [[UserBonusVC alloc] init];
            [self.wxNavigationController pushViewController:boundsVC];
        }
            break;
        case T_BaseFunction_Invate:
        {
            MailShareView *pictureBrowse = [[MailShareView alloc] init];
            pictureBrowse.delegate = self;
            [pictureBrowse showShareThumbView:view toDestview:self.view withImage:[UIImage imageNamed:@"TwoDimension.png"]];
        }
            break;
        case T_BaseFunction_Cut:
        {
            NewUserCutVC *userCutVC = [[NewUserCutVC alloc] init];
            [self.wxNavigationController pushViewController:userCutVC];
        }
            break;
        case T_BaseFunction_Union:
        {
            FindCommonVC *vc = [[FindCommonVC alloc] init];
            vc.webURl = [NSString stringWithFormat:@"%@wx_union/index.php/Public/alliance_merchant",WXTBaseUrl];
            vc.name = @"商家联盟";
            [self.wxNavigationController pushViewController:vc];
        }
            break;
        case T_BaseFunction_yunP:
        {
            CloudTicketListVC *listVC = [[CloudTicketListVC alloc] init];
            [self.wxNavigationController pushViewController:listVC];
        }
            break;
        default:
            [UtilTool showTipView:@"努力开发中..."];
            break;
    }
}

//share
-(void)sharebtnClicked:(NSInteger)index{
    NSString *shareInfo = nil;
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    shareInfo = userObj.shareInfo;
    if(!shareInfo || [shareInfo isEqualToString:@""]){
        shareInfo = [UtilTool sharedString];
    }
    UIImage *image = [UIImage imageNamed:@"Icon-72.png"];
    if(index == Share_Type_WxFriends){
        [[WXWeiXinOBJ sharedWeiXinOBJ] sendMode:E_WeiXin_Mode_Friend title:kMerchantName description:shareInfo linkURL:[self userShareAppWIthString] thumbImage:image];
    }
    if(index == Share_Type_WxCircle){
        [[WXWeiXinOBJ sharedWeiXinOBJ] sendMode:E_WeiXin_Mode_FriendGroup title:kMerchantName description:shareInfo linkURL:[self userShareAppWIthString] thumbImage:image];
    }
    if(index == Share_Type_Qq){
        NSData *data = UIImagePNGRepresentation(image);
        QQApiNewsObject *newObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:[self userShareAppWIthString]] title:kMerchantName description:shareInfo previewImageData:data];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObj];
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        if(sent == EQQAPISENDSUCESS){
            NSLog(@"qq好友分享成功");
        }
    }
    if(index == Share_Type_Qzone){
        NSData *data = UIImagePNGRepresentation(image);
        QQApiNewsObject *newObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:[self userShareAppWIthString]] title:kMerchantName description:shareInfo previewImageData:data];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObj];
        QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
        if(sent == EQQAPISENDSUCESS){
            NSLog(@"qq空间分享成功");
        }
    }
}

-(NSString*)userShareAppWIthString{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSString *imgUrlStr = [NSString stringWithFormat:@"%@wx_union/index.php/Register/index?sid=%@&phone=%@",WXTShareBaseUrl,userObj.sellerID,userObj.user];
    return imgUrlStr;
}

#pragma mark HomePageTopDelegate
-(void)homePageTopLoadedSucceed{
    [_tableView headerEndRefreshing];
    [_tableView reloadData];
//    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:T_HomePage_TopImg] withRowAnimation:UITableViewRowAnimationFade];
//    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:T_HomePage_CenterImg] withRowAnimation:UITableViewRowAnimationFade];
//    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:T_HomePage_DownImg] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)homePageTopLoadedFailed:(NSString *)error{
    [_tableView headerEndRefreshing];
    if(!error){
        error = @"获取置顶图片失败";
    }
    [UtilTool showAlertView:error];
}

#pragma mark classify
-(void)homePageClassifyLoadedSucceed{
    [_tableView reloadData];
}

-(void)homePageClassifyLoadedFailed:(NSString *)errorMsg{
}

-(void)homeClassifyMoreBtnClicked{
    [[CoordinateController sharedCoordinateController] toGoodsClassifyVC:self catID:0 animated:YES];
}

-(void)homeClassifyInfoBtnClicked:(id)sender{
    HomePageClassifyEntity *entity = sender;
    [[CoordinateController sharedCoordinateController] toGoodsClassifyVC:self catID:entity.cat_id animated:YES];
}

#pragma mark limitbuy
-(void)homePageLimitGoodsSucceed{
    [_tableView reloadData];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:T_HomePage_LimitBuyInfo] withRowAnimation:UITableViewRowAnimationFade];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:T_HomePage_LimitBuyTitle] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)homePageLimitGoodsFailed:(NSString*)errorMsg{
    [_tableView reloadData];
}

-(void)homeLimitBuyCellbtnClicked:(id)sender{
    HomeLimitGoodsEntity*goods = _model.limitGoods.data[0];
    LImitGoodsEntity *entity = sender;
    WXLimitGoodsInfoVC *goodsInfoVC = [[WXLimitGoodsInfoVC alloc] init];
    goodsInfoVC.goodsId = entity.goodsID;
    goodsInfoVC.sckillID = goods.sckillID;
    goodsInfoVC.LimitGoodsInfo_Type = LimitGoodsInfo_LimitGoods;
    goodsInfoVC.buyGoods = buyGoods;
    [self.wxNavigationController pushViewController:goodsInfoVC];
}

#pragma mark recommend
-(void)homePageRecLoadedSucceed{
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:T_HomePage_RecomendInfo] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)homePageRecLoadedFailed:(NSString *)errorMsg{
    
}

-(void)homeRecommendCellbtnClicked:(id)sender{
    HomePageRecEntity *entity = sender;
    [[CoordinateController sharedCoordinateController] toGoodsInfoVC:self goodsID:entity.goods_id animated:YES];
}

#pragma mark surprice
-(void)homePageSurpLoadedSucceed{
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:T_HomePage_GuessInfo] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)homePageSurpLoadedFailed:(NSString *)errorMsg{
}

-(void)changeCellClicked:(id)entity{
    HomePageSurpEntity *ent = entity;
    [[CoordinateController sharedCoordinateController] toGoodsInfoVC:self goodsID:ent.goods_id animated:YES];
}

#pragma mark  shopping cart
- (void)shoppingCartViewInShoppingVC{
    [[CoordinateController sharedCoordinateController] toShoppingCartVC:self animated:YES];
}

#pragma mark  shopping Btn 
- (void)clickShopCartBtn{
     [[CoordinateController sharedCoordinateController] toShoppingCartVC:self  animated:YES];
}

#pragma mark refresh
-(void)headerRefreshing{
    [_model loadData];
}

#pragma mark --- limitBuyGoods
- (void)limitBuyNoStartBuyGoods{
    buyGoods = YES;
}

-(void)clickClassifyBtnAtIndex:(NSInteger)index{
}

#pragma mark changeSeller
-(void)userChangeSeller{
    [_model loadData];
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    [titleBtn setTitle:userObj.sellerName forState:UIControlStateNormal];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end