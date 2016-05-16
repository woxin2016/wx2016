//
//  VirtualGoodsInfoVC.m
//  RKWXT
//
//  Created by app on 16/4/6.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "VirtualGoodsInfoVC.h"
#import "VirtualGoods.h"

@interface VirtualGoodsInfoVC ()<UITableViewDataSource,UITableViewDelegate,VirtualTopImgCellDelegate,UIActionSheetDelegate,VirtualGoodsInfoModelDelegate,VirtualGoodsRedCutCellDelegate>
{
    UITableView *_tableView;
    VirtualGoodsInfoModel *_model;
    VirtualGoodsInfoTool *_tool;
    BOOL _isOpen; // 是否点开产品参数
    BOOL _isApper; // 是否显示包邮 红包等
    NSString *shopPhone;
    VirtualStockGoodsView *stockView;
}
@property (nonatomic,strong)NSIndexPath *seleIndexPath;
@end

@implementation VirtualGoodsInfoVC

- (instancetype)init{
    if (self = [super init]) {
        _tool = [[VirtualGoodsInfoTool alloc]init];
        _model = [[VirtualGoodsInfoModel alloc]init];
        _model.delegate = self;
        _isOpen = NO;
        _isApper = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self crateTopNavigationView];
    
    [self initWebView];
    
    [self initTableView];
    
    [self.view addSubview:[self baseInitDownView]];
    
    
    [self requestNetWork];
    
}

- (void)initTableView{
    _tableView = [[UITableView alloc]init];
    _tableView.frame = CGRectMake(0, TopNavigationViewHeight, Size.width, Size.height-TopNavigationViewHeight);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_tableView setBackgroundColor:WXColorWithInteger(0xffffff)];
    [self.scrollView addSubview:_tableView];
}

- (void)initWebView{
    //初始化图文详情页面，方便上拉加载数据
        WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:_goodsID], @"goods_id", userObj.user, @"phone", userObj.wxtID, @"woxin_id", nil];
    
        CGSize size = self.bounds.size;
        self.scrollView.contentSize = CGSizeMake(size.width, size.height);
        self.subViewController = [[VirtualSubGoodsInfoWebVC alloc] initWithFeedType:WXT_UrlFeed_Type_NewMall_ImgAndText paramDictionary:dic];
        self.subViewController.mainViewController = self;
}


- (UIView*)baseInitDownView{
    WXUIView *downView = [[WXUIView alloc] init];
    [downView setBackgroundColor:RGB_COLOR(210, 210, 210)];
    
    CGFloat btnWidth = [UIScreen mainScreen].bounds.size.width / 2;
    CGFloat xOffset = 0;
    CGFloat yOffset = 0.5;
    UIButton *phontBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    phontBtn.frame = CGRectMake(xOffset, yOffset, btnWidth, DownViewHeight - yOffset);
    [phontBtn setBackgroundColor:[UIColor whiteColor]];
    [phontBtn.titleLabel setFont:WXFont(14.0)];
    [phontBtn setTitle:@"联系客服" forState:UIControlStateNormal];
    [phontBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [phontBtn setImage:[UIImage imageNamed:@"storeCart.png"] forState:UIControlStateNormal];
    phontBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8);
    [phontBtn addTarget:self action:@selector(contactSeller) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:phontBtn];
    
    WXUIButton *addBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(xOffset+(IPHONE_SCREEN_WIDTH-xOffset)/2, yOffset, btnWidth, DownViewHeight - yOffset);
    [addBtn setTag:1];
    [addBtn.titleLabel setFont:WXFont(14.0)];
    [addBtn setBackgroundColor:[UIColor colorWithHexString:@"#f74f35"]];
    [addBtn setTitle:@"立即兑换" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(buyBtnVirtual) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:addBtn];
    
    CGFloat height = self.view.frame.size.height;
    downView.frame = CGRectMake(0,height-DownViewHeight, Size.width, DownViewHeight);
    return downView;
}

-(void)crateTopNavigationView{
    WXUIView *topView = [[WXUIView alloc] init];
    topView.frame = CGRectMake(0, 0, Size.width, TopNavigationViewHeight);
    [topView setBackgroundColor:WXColorWithInteger(AllBaseColor)];
    [self.view addSubview:topView];
    
    CGFloat xGap = 3;
    CGFloat yGap = 6;
    CGFloat btnWidth = 25;
    CGFloat btnHeight = 25;
    WXUIButton *backBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(xGap, TopNavigationViewHeight-yGap-btnHeight - 0.5, btnWidth, btnHeight);
    [backBtn setBackgroundColor:[UIColor clearColor]];
    [backBtn setImage:[UIImage imageNamed:@"CommonArrowLeft.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToLastPage) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    
    CGFloat labelWidth = 80;
    CGFloat labelHeight = 30;
    WXUILabel *titleLabel = [[WXUILabel alloc] init];
    titleLabel.frame = CGRectMake((self.bounds.size.width-labelWidth)/2, TopNavigationViewHeight-yGap-labelHeight - 0.5, labelWidth, labelHeight);
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:WXFont(15.0)];
    [titleLabel setText:@"商品详情"];
    [titleLabel setTextColor:WXColorWithInteger(0xffffff)];
    [topView addSubview:titleLabel];
}


- (void)requestNetWork{
    [_model virtualLoadGoodsInfoData:self.goodsID type:VirtualModelRequestType_Default];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCSTNavigationViewHidden:YES animated:NO];
    [self addOBS];
}

- (void)addOBS{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(userBuyBtnClicked) name:K_Notification_Name_VirtualStoreBuyGoods object:nil];
     [notificationCenter addObserver:self selector:@selector(userBuyExchangeBtnClicked) name:K_Notification_Name_VirtualEXchangeBuyGoods object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [_model setDelegate:nil];
    [self removeOBS];
}

- (void)removeOBS{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -- tableView
//改变cell分割线置顶
-(void)viewDidLayoutSubviews{
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return  VirtualGoodsInfo_Section_Invalid;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row;
    switch (section) {
        case VirtualGoodsInfo_Section_TopImg:
        case VirtualGoodsInfo_Section_GoodsDesc:
        case VirtualGoodsInfo_Section_Integral:
        case VirtualGoodsInfo_Section_Explain:
        case VirtualGoodsInfo_Section_GoodsInfo:
            row = 1;
            break;
        case VirtualGoodsInfo_Section_Unstable:
            if (_isApper) {
                row = 1;
            }else{
                row = 0;
            }
            break;
        case VirtualGoodsInfo_Section_GoodsBaseData:
            if (_isOpen) {
                    if ([_model.attrArr count] > 0) {
                        row  =  [_model.attrArr count] + 1;
                    }else{
                        row =  1;
                    }
            }else{
                row = 1;
            }
            break;
            
        default:
            break;
    }
    return row;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0.0;
    switch (section) {
        case VirtualGoodsInfo_Section_GoodsInfo:
        case VirtualGoodsInfo_Section_Integral:
            height = 7;
            break;
        case VirtualGoodsInfo_Section_Unstable:
            if (_isApper) {
                 height = 7;
            }else{
                height = 0;
            }
           
            break;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    CGFloat height = 0.0;
    switch (section) {
        case VirtualGoodsInfo_Section_TopImg:
            height = IPHONE_SCREEN_WIDTH;
            break;
        case VirtualGoodsInfo_Section_GoodsDesc:
            if (self.type == VirtualGoodsType_Store) {
                height = DseCellHeight;
            }else{
                height = 120;
            }
            break;
        case VirtualGoodsInfo_Section_GoodsInfo:
        case VirtualGoodsInfo_Section_Integral:
        case VirtualGoodsInfo_Section_Unstable:
            height = 44;
            break;
        case VirtualGoodsInfo_Section_Explain:
            height = ExplainCellHeight;
            break;
        case VirtualGoodsInfo_Section_GoodsBaseData:
            if (row == 0) {
                height = 44;
            }else{
                height = [VirtualInfoDownCell cellHeightOfInfo:nil];
            }
            break;
        default:
            break;
    }
    return height;
}


// 顶部大图
- (WXUITableViewCell*)virtualTableViewTopImg{
    VirtualTopImgCell *cell = [VirtualTopImgCell VirtualTopImgCellWithTabelView:_tableView];
    NSMutableArray *merchantImgViewArray = [[NSMutableArray alloc] init];
    VirtualGoodsInfoEntity *entity = nil;
    if([_model.goodsInfoArr count] > 0){
        entity = [_model.goodsInfoArr objectAtIndex:0];
    }
    for(int i = 0; i< [entity.goodsImgArr count]; i++){
        WXRemotionImgBtn *imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_WIDTH)];
        [imgView setExclusiveTouch:NO];
        [imgView setCpxViewInfo:[entity.goodsImgArr objectAtIndex:i]];
        [merchantImgViewArray addObject:imgView];
    }
    NSString *identifier = @"VirtualTopImgCell";
    cell = [[VirtualTopImgCell alloc] initWithReuseIdentifier:identifier imageArray:merchantImgViewArray];
    [cell setDelegate:self];
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
    [cell load];
    return cell;
}

// 产品基础信息
- (WXUITableViewCell*)virtualGoodsDesCell{
    VietualInfoDesCell *cell = [VietualInfoDesCell VietualInfoDesCellWithTabelView:_tableView];
    if ([_model.goodsInfoArr count] > 0) {
        [cell setCellInfo:[_model.goodsInfoArr objectAtIndex:0]];
    }
     [cell backMoney:[VirtualGoodsInfoTool backMoney:_model] xnb:[VirtualGoodsInfoTool xnb:_model]];
    [cell load];
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width - 20);
    return cell;
}

// 商城样式产品基础信息
- (WXUITableViewCell*)VirtualInfoDesExchangeCell{
    VirtualInfoDesExchangeCell *cell = [VirtualInfoDesExchangeCell VirtualInfoDesExchangeCellWithTabelView:_tableView];
    if ([_model.goodsInfoArr count] > 0) {
        [cell setCellInfo:[_model.goodsInfoArr objectAtIndex:0]];
    }
    [cell backMoney:[VirtualGoodsInfoTool backMoney:_model] xnb:[VirtualGoodsInfoTool xnb:_model] goodsPrice:[VirtualGoodsInfoTool goodsPrice:_model]];
    [cell load];
    return cell;
}

// 是否显示包邮 红包
- (WXUITableViewCell*)virtualIsRedCutPosgetCell{
    VirtualGoodsRedCutCell *cell = [VirtualGoodsRedCutCell VirtualGoodsRedCutCellWithTabelView:_tableView];
    cell.delegate = self;
    [cell isAppearRed:_tool.red cut:_tool.cut posgate:_tool.postage];
    return cell;
}


// 可兑换积分
- (WXUITableViewCell*)virtualGoodsIntegralCell{
    VirtualInfoIntegralCell *cell = [VirtualInfoIntegralCell VirtualInfoIntegralCellWithTabelView:_tableView];
    [cell canuseInterral:[VirtualGoodsInfoTool canUseVirtual:_model] cantBe:[VirtualGoodsInfoTool pastVirtual:_model]];
    return cell;
}


// 商品说明
- (WXUITableViewCell*)virtualGoodsExplainCell{
    VirtualInfoExplainCell *cell = [VirtualInfoExplainCell VirtualInfoExplainCellWithTabelView:_tableView];
    [cell setCellInfo:_model.goodsInfoArr[0]];
    [cell load];
    return cell;
}

// 图文详情
- (WXUITableViewCell*)virtualGoodsInfoCell{
    static NSString *identifier = @"webShowCell";
    WXUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_HasNext];
    [cell.imageView setImage:[UIImage imageNamed:@"T_GoodsInfo.png"]];
    [cell.textLabel setText:@"图文详情"];
    [cell.textLabel setFont:WXFont(13.0)];
    return cell;
}

// 产品规格
- (WXUITableViewCell*)virtualGoodsBDCell{
    VirtualInfoBDCell *cell = [VirtualInfoBDCell VirtualInfoBDCellWithTabelView:_tableView];
    [cell.imageView setImage:[UIImage imageNamed:@"T_GoodsIInfoDetail.png"]];
    [cell.textLabel setText:@"产品参数"];
    [cell changeArrowWithDown:_isOpen];
    [cell.textLabel setFont:WXFont(13.0)];
    return cell;
}

// 产品规格 详细信息
- (WXUITableViewCell*)virtualGoodsDownCell:(NSInteger)row{
    VirtualInfoDownCell *cell = [VirtualInfoDownCell VirtualInfoDownCellWithTabelView:_tableView];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if([_model.attrArr count] > 0){
        VirtualGoodsInfoEntity *entity = _model.attrArr[row];
       [cell downWithName:entity.attrName info:entity.attrValue];
    }
    return cell;
}

- (WXUITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WXUITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (section) {
        case VirtualGoodsInfo_Section_TopImg:
            cell = [self virtualTableViewTopImg];
            break;
        case VirtualGoodsInfo_Section_GoodsDesc:
            if (self.type == VirtualGoodsType_Store) {
                cell = [self virtualGoodsDesCell];
            }else{
                cell = [self VirtualInfoDesExchangeCell];
            }
            break;
        case VirtualGoodsInfo_Section_Integral:
            cell = [self virtualGoodsIntegralCell];
            break;
        case VirtualGoodsInfo_Section_Explain:
            cell = [self virtualGoodsExplainCell];
            break;
        case VirtualGoodsInfo_Section_GoodsInfo:
           cell = [self virtualGoodsInfoCell];
            break;
        case VirtualGoodsInfo_Section_Unstable:
            cell = [self virtualIsRedCutPosgetCell];
            break;
        case VirtualGoodsInfo_Section_GoodsBaseData:
            if (row == 0) {
                cell = [self virtualGoodsBDCell];
            }else{
                cell = [self virtualGoodsDownCell:indexPath.row - 1];
            }
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == VirtualGoodsInfo_Section_GoodsInfo) {
        [self gotoWebView];
    }
    
    if (section == VirtualGoodsInfo_Section_GoodsBaseData) {
        VirtualInfoBDCell *cell = (VirtualInfoBDCell*)[_tableView cellForRowAtIndexPath:indexPath];
        if (row == 0) {
            _isOpen = !_isOpen;
            [cell changeArrowWithDown:!_isOpen];
              cell.selectionStyle = _isOpen ? UITableViewCellSelectionStyleNone :UITableViewCellSelectionStyleGray;
            [self didSeleCellisOpne];
       
          
        }
    }
    
}

- (void)didSeleCellisOpne{
    [_tableView   reloadSections:[NSIndexSet indexSetWithIndex:VirtualGoodsInfo_Section_GoodsBaseData] withRowAnimation:UITableViewRowAnimationFade];
    [_tableView   selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:VirtualGoodsInfo_Section_GoodsBaseData] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

-(void)gotoWebView{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSString *urlStr = [NSString stringWithFormat:@"%@wx_union/index.php/Public/good_info?phone=%@&woxin_id=%@&goods_id=%@&pid=%@",WXTBaseUrl,userObj.user,userObj.wxtID,[NSString stringWithFormat:@"%d",self.goodsID],@"ios"];
    FindCommonVC *webViewVC = [[FindCommonVC alloc]init];
    webViewVC.name = @"图文详情";
    webViewVC.webURl = urlStr;
    [self.wxNavigationController pushViewController:webViewVC];
}


#pragma mark back
- (void)backToLastPage{
    [self.wxNavigationController popViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark -- DownView
- (void)buyBtnVirtual{
    
    if([_model.goodsInfoArr count] == 0){
        [UtilTool showAlertView:@"数据加载失败"];
        return;
    }
    
    stockView = [[VirtualStockGoodsView alloc]init];
    if (self.type == VirtualGoodsType_Store) {
        stockView.type = VirtualStockView_Type_BuyStore;
    }else if (self.type == VirtualGoodsType_Exchange){
        stockView.type = VirtualOrderInfoEntity_BuyEXchange;
    }
    [stockView VirtualGoodsStockInfo:_model.stockArr GoodsInfoArr:_model.goodsInfoArr];
    [self.view addSubview:stockView];
}

- (void)contactSeller{
    VirtualGoodsInfoEntity *entity = nil;
    if ([_model.sellerArr  count] > 0) {
        entity = [_model.sellerArr objectAtIndex:0];
    }
    
    shopPhone = entity.sellerPhone;
    [self showAlertView:shopPhone];
}

-(void)showAlertView:(NSString*)phone{
    NSString *title = [NSString stringWithFormat:@"联系商家:%@",phone];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:title
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:[NSString stringWithFormat:@"使用%@",kMerchantName]
                                  otherButtonTitles:@"系统", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex > 2){
        return;
    }
    if(shopPhone.length == 0){
        return;
    }
    if(buttonIndex == 1){
        [UtilTool callBySystemAPI:shopPhone];
        return;
    }
    if(buttonIndex == 0){
        CallBackVC *backVC = [[CallBackVC alloc] init];
        backVC.phoneName = kMerchantName;
        if([backVC callPhone:shopPhone]){
            [self presentViewController:backVC animated:YES completion:^{
            }];
        }
    }
}

-(NSString*)phoneWithoutNumber:(NSString*)phone{
    NSString *new = [[NSString alloc] init];
    for(NSInteger i = 0; i < phone.length; i++){
        char c = [phone characterAtIndex:i];
        if(c >= '0' && c <= '9'){
            new = [new stringByAppendingString:[NSString stringWithFormat:@"%c",c]];
        }
    }
    return new;
}


#pragma  mark VirtualTopImgCell Delegate

- (void)virtualClickTopGoodAtIndex:(NSInteger)index{
    VirtualGoodsInfoEntity *entity = nil;
    if([_model.goodsInfoArr count] > 0){
        entity = [_model.goodsInfoArr objectAtIndex:0];
    }
    
    NewImageZoomView *img = [[NewImageZoomView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height )imgViewSize:CGSizeZero];
    [self.view addSubview:img];
    [img updateImageDate:entity.goodsImgArr selectIndex:index];
}

#pragma mark  VirtualGoodsRedCutCell Delegate

- (void)VirtualGoodsInfoDesCarriageBtnClicked{
    [UtilTool showTipView:@"该商品免运费"];
}

-(void)VirtualGoodsInfoDesCutBtnClicked{
       [UtilTool showTipView:@"该商品有分成"];
}

-(void)VirtualGoodsInfoDesredPacketBtnClicked{
    [UtilTool showTipView:@"该商品可以使用红包"];
}



#pragma mark  --  requestNetWork
-(void)virtualLoadGoodsInfoDataSucceed{
    [self unShowWaitView];
    
    _isApper = [_tool GoodsInfoToolWithModel:_model];

    [_tableView reloadData];
}

-(void)virtualLoadGoodsInfoDataFailed:(NSString*)errorMsg{
    [self unShowWaitView];
    [UtilTool showAlertView:errorMsg];
}

#pragma mark --  NSNotificationCenter
- (void)userBuyBtnClicked{
        VirtualGoodsOrderVC *orderVC = [[VirtualGoodsOrderVC alloc]init];
        orderVC.virtualOrder = [VirtualGoodsInfoTool buyGoodsInfo:stockView];
        orderVC.type = virtualParOrderType_Store;
        orderVC.orderType = VirtualOrderType_PayOrder;
        [self.wxNavigationController pushViewController:orderVC];
}

- (void)userBuyExchangeBtnClicked{
    VirtualGoodsOrderVC *orderVC = [[VirtualGoodsOrderVC alloc]init];
    orderVC.virtualOrder = [VirtualGoodsInfoTool buyGoodsInfo:stockView];
    orderVC.type = virtualParOrderType_Exchange;
    orderVC.orderType = VirtualOrderType_PayOrder;
    [self.wxNavigationController pushViewController:orderVC];
}

#pragma mark  -- pullUP WebView




@end
