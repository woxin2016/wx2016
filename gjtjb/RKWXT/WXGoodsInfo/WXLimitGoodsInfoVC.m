//
//  WXLimitGoodsInfoVC.m
//  RKWXT
//
//  Created by app on 16/3/18.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "WXLimitGoodsInfoVC.h"
#import "GoodsInfoDef.h"

@interface WXLimitGoodsInfoVC ()<ShoppingCartViewDelegate,UITableViewDelegate,UITableViewDataSource,GoodsInfoModelDelegate,UIActionSheetDelegate,CDSideBarControllerDelegate,MerchantImageCellDelegate,GoodsInfoDesCellDelegate>
{
    CDSideBarController *sideBar;
    ShoppingCartView *shoppingCartBtn;
     UITableView *_tableView;
    NewGoodsStockView *goodsView; //库存页面
    
    GoodsInfoModel *_model;
    
    BOOL _isOpen;
    BOOL userCut;
    BOOL pocket;
    NSString *shopPhone;
}
@property (nonatomic,strong) NSIndexPath *selectedIndexPath;
@end

@implementation WXLimitGoodsInfoVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCSTNavigationViewHidden:YES animated:NO];
    [self addOBS];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [sideBar insertMenuButtonOnView:self.view atPosition:CGPointMake(self.bounds.size.width-35 - 40, TopNavigationViewHeight-35)];
    
    shoppingCartBtn = [[ShoppingCartView alloc]initWithFrame:CGRectMake(self.bounds.size.width-35, TopNavigationViewHeight-35, 25, 25)];
    shoppingCartBtn.delegate = self;
    [shoppingCartBtn searchShoppingCartNumber];
    [self.view addSubview:shoppingCartBtn];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackgroundColor:[UIColor whiteColor]];
    [self crateTopNavigationView];
    
    [self initWebView];
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, TopNavigationViewHeight, Size.width, Size.height-DownViewHeight);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_tableView setBackgroundColor:WXColorWithInteger(0xffffff)];
    [self.scrollView addSubview:_tableView];
    
    [self initDropList];
      
    [_model loadGoodsInfoData:self.goodsId  seckillID:self.sckillID type:LimitGoodsInfo_LimitGoods];
    [self.view addSubview:[self limitBaseDownView]];
 
    
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

-(void)crateTopNavigationView{
    WXUIView *topView = [[WXUIView alloc] init];
    topView.frame = CGRectMake(0, 0, Size.width, TopNavigationViewHeight);
    [topView setBackgroundColor:WXColorWithInteger(AllBaseColor)];
    [self.view addSubview:topView];
    
    CGFloat xGap = 5;
    CGFloat yGap = 6;
    
    CGFloat btnWidth = 25;
    CGFloat btnHeight = 25;
    WXUIButton *backBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(xGap, TopNavigationViewHeight-yGap-btnHeight, btnWidth, btnHeight);
    [backBtn setBackgroundColor:[UIColor clearColor]];
    [backBtn setImage:[UIImage imageNamed:@"CommonArrowLeft.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToLastPage) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    
    CGFloat labelWidth = 80;
    CGFloat labelHeight = 30;
    WXUILabel *titleLabel = [[WXUILabel alloc] init];
    titleLabel.frame = CGRectMake((self.bounds.size.width-labelWidth)/2, TopNavigationViewHeight-yGap-labelHeight, labelWidth, labelHeight);
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:WXFont(15.0)];
    [titleLabel setText:@"商品详情"];
    [titleLabel setTextColor:WXColorWithInteger(0xffffff)];
    [topView addSubview:titleLabel];
}

-(void)initWebView{
    //初始化图文详情页面，方便上拉加载数据
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:_goodsId], @"goods_id", userObj.user, @"phone", userObj.wxtID, @"woxin_id", nil];
    
    CGSize size = self.bounds.size;
    self.scrollView.contentSize = CGSizeMake(size.width, size.height);
    self.subViewController = [[NewGoodsInfoWebViewViewController alloc] initWithFeedType:WXT_UrlFeed_Type_NewMall_ImgAndText paramDictionary:dic];
    self.subViewController.mainViewController = self;
}

-(void)initDropList{
    NSArray *imageList = @[[UIImage imageNamed:@"ShareQqImg.png"], [UIImage imageNamed:@"ShareQzoneImg.png"], [UIImage imageNamed:@"ShareWxFriendImg.png"], [UIImage imageNamed:@"ShareWxCircleImg.png"]];
    sideBar = [[CDSideBarController alloc] initWithImages:imageList];
    sideBar.delegate = self;
}

-(id)init{
    self = [super init];
    if(self){
        _model = [[GoodsInfoModel alloc] init];
        [_model setDelegate:self];
        _isOpen = NO;
    }
    return self;
}

-(void)addOBS{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(userBuyBtnClicked) name:K_Notification_Name_UserBuyGoods object:nil];
    [notificationCenter addObserver:self selector:@selector(userAddShoppingCartBtnClicked) name:K_Notification_Name_UserAddShoppingCart object:nil];
//    [notificationCenter addObserver:self selector:@selector(addShoppingCartSucceed:) name:D_Notification_AddGoodsShoppingCart_Succeed object:nil];
//    [notificationCenter addObserver:self selector:@selector(addShoppingCartFailed:) name:D_Notification_AddGoodsShoppingCart_Failed object:nil];
    //    [notificationCenter addObserver:self selector:@selector(goodsCollectionSucceed) name:K_Notification_Name_GoodsAddCollectionSucceed object:nil];
    //    [notificationCenter addObserver:self selector:@selector(goodsCancelCollectionSucceed) name:K_Notification_Name_GoodsCancelCollectionSucceed object:nil];
    
}

- (WXUIView*)limitBaseDownView{
    WXUIView *downView = [[WXUIView alloc] init];
    [downView setBackgroundColor:RGB_COLOR(210, 210, 210)];
    
    CGFloat btnWidth = [UIScreen mainScreen].bounds.size.width /2;
    CGFloat xOffset = 0;
    CGFloat yOffset = 0.5;
    UIButton *phontBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    phontBtn.frame = CGRectMake(xOffset, yOffset, btnWidth, DownViewHeight - yOffset);
    [phontBtn setBackgroundColor:[UIColor whiteColor]];
    [phontBtn.titleLabel setFont:WXFont(14.0)];
    [phontBtn setTitle:@"联系卖家" forState:UIControlStateNormal];
    [phontBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [phontBtn setImage:[UIImage imageNamed:@"storeCart.png"] forState:UIControlStateNormal];
    phontBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8);
    [phontBtn addTarget:self action:@selector(contactSeller) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:phontBtn];
    
    
    xOffset += btnWidth;
    WXUIButton *limitBuyBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    limitBuyBtn.frame = CGRectMake(xOffset, yOffset, btnWidth, DownViewHeight - yOffset);
    [limitBuyBtn setBackgroundColor:[UIColor clearColor]];
    [limitBuyBtn setTag:1];
    [limitBuyBtn.titleLabel setFont:WXFont(14.0)];
    [limitBuyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [limitBuyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [limitBuyBtn addTarget:self action:@selector(buyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [limitBuyBtn setBackgroundColor:[UIColor colorWithHexString:@"f74f35"]];
    [downView addSubview:limitBuyBtn];
    
    CGFloat height = self.view.frame.size.height;
    downView.frame = CGRectMake(0,height-DownViewHeight, Size.width, DownViewHeight);
    
    return downView;
}

#pragma mark -- tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return GoodsInfo_Section_Invalid;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 0;
    switch (section) {
        case GoodsInfo_Section_TopImg:
        case GoodsInfo_Section_GoodsDesc:
            row = 1;
            break;
        case GoodsInfo_Section_GoodsBaseData:
            if(_isOpen){
                if(_selectedIndexPath.section == section){
                    if([_model.attrArr count] > 0){
                        return [_model.attrArr count]+1;
                    }else{
                        return 1;
                    }
                }
            }else{
                return 1;
            }
            break;
        case GoodsInfo_Section_GoodsInfo:
            row = 1;
            break;
        default:
            break;
    }
    return row;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    NSInteger section = indexPath.section;
    switch (section) {
        case GoodsInfo_Section_TopImg:
            height = IPHONE_SCREEN_WIDTH;
            break;
        case GoodsInfo_Section_GoodsDesc:
        {
            height = GoodsInfoDesCellHeight;
            if([_model.goodsInfoArr count] > 0){
                GoodsInfoEntity *entity = [_model.goodsInfoArr objectAtIndex:0];
                if(entity.postage == Goods_Postage_None || userCut || pocket){
                    height += 60;
                }
            }
        }
            break;
        case GoodsInfo_Section_GoodsInfo:
            //            height = LMGoodsBaseInfoCellHeight;
            height = 44;
            break;
        case GoodsInfo_Section_GoodsBaseData:
            if (indexPath.row == 0) {
                height = 44;
            }else{
                height = [NewGoodsInfoDownCell cellHeightOfInfo:nil];;
            }
        default:
            break;
    }
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0;
    switch (section) {
        case GoodsInfo_Section_GoodsInfo:
            height = 20;
            break;
        default:
            break;
    }
    return height;
}

-(void)viewDidLayoutSubviews {
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }

}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

-(WXUITableViewCell*)tableViewForTopImgCell{
    static NSString *identifier = @"headImg";
    MerchantImageCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[MerchantImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSMutableArray *merchantImgViewArray = [[NSMutableArray alloc] init];
    GoodsInfoEntity *entity = nil;
    if([_model.goodsInfoArr count] > 0){
        entity = [_model.goodsInfoArr objectAtIndex:0];
    }
    for(int i = 0; i< [entity.goodsImgArr count]; i++){
        WXRemotionImgBtn *imgView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_WIDTH)];
        [imgView setExclusiveTouch:NO];
        [imgView setCpxViewInfo:[entity.goodsImgArr objectAtIndex:i]];
        [merchantImgViewArray addObject:imgView];
    }
    cell = [[MerchantImageCell alloc] initWithReuseIdentifier:identifier imageArray:merchantImgViewArray];
    [cell setDelegate:self];
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
    [cell load];
    return cell;
}

-(void)clickTopGoodAtIndex:(NSInteger)index{
    GoodsInfoEntity *entity = nil;
    if([_model.goodsInfoArr count] > 0){
        entity = [_model.goodsInfoArr objectAtIndex:0];
    }
    
    NewImageZoomView *img = [[NewImageZoomView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height )imgViewSize:CGSizeZero];
    [self.view addSubview:img];
    [img updateImageDate:entity.goodsImgArr selectIndex:index];
}


//商品介绍
-(WXUITableViewCell*)goodsDesCell{
    static NSString *identifier = @"desCell";
    GoodsInfoDesCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[GoodsInfoDesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDelegate:self];
    if([_model.goodsInfoArr count] > 0){
        [cell setCellInfo:[_model.goodsInfoArr objectAtIndex:0]];
        [cell setUserCut:userCut];
        [cell setPocket:pocket];
        cell.stockEntity = [_model.stockArr objectAtIndex:0];
    }
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
    [cell limitGoodsInfoHidden];
    [cell load];
    return cell;
}


//图文详情
- (WXUITableViewCell*)goodsInfoCell:(NSInteger)row{
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

//产品参数
-(WXUITableViewCell*)tableViewForBaseDataCell:(NSIndexPath*)indexpath{
    static NSString *identifier = @"baseDateCell";
    NewGoodsInfoBDCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[NewGoodsInfoBDCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell.imageView setImage:[UIImage imageNamed:@"T_GoodsIInfoDetail.png"]];
    [cell.textLabel setText:@"产品参数"];
    [cell changeArrowWithDown:_isOpen];
    [cell.textLabel setFont:WXFont(13.0)];
    return cell;
}

-(WXUITableViewCell*)tabelViewForDownCellAtRow:(NSInteger)row{
    static NSString *identifier = @"textCell";
    NewGoodsInfoDownCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[NewGoodsInfoDownCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if([_model.attrArr count] > 0){
        for (GoodsInfoEntity *entity in _model.attrArr) {
            [cell setName:entity.attrName];
            [cell setInfo:entity.attrValue];
        }
    }
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_isOpen && indexPath.section == GoodsInfo_Section_GoodsBaseData){
        static NSString *identifier = @"goodsInfoBDCell";
        NewGoodsInfoBDCell *cell = (NewGoodsInfoBDCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell){
            cell = [[NewGoodsInfoBDCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        if(indexPath.row > 0){
            cell = (NewGoodsInfoBDCell*)[self tabelViewForDownCellAtRow:indexPath.row];
        }
        if(indexPath.row == 0){
            [cell changeArrowWithDown:_isOpen];
            [cell.imageView setImage:[UIImage imageNamed:@"T_GoodsIInfoDetail.png"]];
            [cell.textLabel setText:@"产品参数"];
            [cell.textLabel setFont:WXFont(13.0)];
        }
        return cell;
    }else{
        WXUITableViewCell *cell = nil;
        NSInteger section = indexPath.section;
        NSInteger row = indexPath.row;
        switch (section) {
            case GoodsInfo_Section_TopImg:
                cell = [self tableViewForTopImgCell];
                break;
            case GoodsInfo_Section_GoodsDesc:
                cell = [self goodsDesCell];
                break;
            case GoodsInfo_Section_GoodsInfo:
                cell = [self goodsInfoCell:row];
                break;
            case GoodsInfo_Section_GoodsBaseData:
                cell = [self tableViewForBaseDataCell:indexPath];
                break;
            default:
                break;
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    if(section == GoodsInfo_Section_GoodsInfo){
        [self gotoWebView];
    }
    if(section == GoodsInfo_Section_GoodsBaseData){
        if(indexPath.row == 0){
            if([indexPath isEqual:_selectedIndexPath]){
                [self didSelectCellRowFirstDo:NO nextDo:NO];
                _selectedIndexPath = nil;
            }else{
                if(!_selectedIndexPath){
                    [self setSelectedIndexPath:indexPath];
                    [self didSelectCellRowFirstDo:YES nextDo:NO];
                }else{
                    [self didSelectCellRowFirstDo:NO nextDo:YES];
                }
            }
        }
    }
}

-(void)gotoWebView{
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    NSString *urlStr = [NSString stringWithFormat:@"%@wx_union/index.php/Public/good_info?phone=%@&woxin_id=%@&goods_id=%@&pid=%@",WXTBaseUrl,userObj.user,userObj.wxtID,[NSString stringWithFormat:@"%d",self.goodsId],@"ios"];
    FindCommonVC *webViewVC = [[FindCommonVC alloc]init];
    webViewVC.name = @"商品详情";
    webViewVC.webURl = urlStr;
    [self.wxNavigationController pushViewController:webViewVC];
}
-(void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert{
    _isOpen = firstDoInsert;
    NewGoodsInfoBDCell *cell = (NewGoodsInfoBDCell*)[_tableView cellForRowAtIndexPath:_selectedIndexPath];
    [cell changeArrowWithDown:firstDoInsert];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:GoodsInfo_Section_GoodsBaseData] withRowAnimation:UITableViewRowAnimationFade];
    if(_isOpen){
        [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:GoodsInfo_Section_GoodsBaseData] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
}

#pragma mark -- cellDelegate
-(void)goodsInfoDesCarriageBtnClicked{
    [UtilTool showTipView:@"该商品免运费"];
}

-(void)goodsInfoDesCutBtnClicked{
    [UtilTool showTipView:@"该商品有分成"];
}

- (void)goodsInfoDesredPacketBtnClicked{
    [UtilTool showTipView:@"该商品可以使用红包"];
}

#pragma mark dataDelegate


-(void)loadGoodsInfoDataSucceed{
    [self unShowWaitView];
    if([_model.evaluteArr count] == 0){
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    }
    
    if([_model.stockArr count] > 0){
        for(GoodsInfoEntity *entity in _model.stockArr){
            if(entity.userCut > 0){
                userCut = YES;
            }
            if (entity.redPacket > 0 ) {
                pocket = YES;
            }
        }
    }
    [_tableView reloadData];
}

-(void)loadGoodsInfoDataFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    if(!errorMsg){
        errorMsg = @"获取数据失败";
    }
    [UtilTool showAlertView:errorMsg];
}

#pragma mark --  notificationCenter

//加入购物车
-(void)userAddShoppingCartBtnClicked{
    GoodsInfoEntity *entity = nil;
    if([_model.goodsInfoArr count] > 0){
        entity = [_model.goodsInfoArr objectAtIndex:0];
    }
//    假如购物车  传入商品库存ID  和名称
    [[ShoppingCartModel shareShoppingCartModel] insertOneGoodsToShoppingCart:goodsView.stockID num:goodsView.buyNum];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}


#pragma mark -- shoppingCart
- (void)shoppingCartViewInShoppingVC{
    ShoppingCartVC *cartVC = [[ShoppingCartVC alloc]init];
    [self.wxNavigationController pushViewController:cartVC];
}

#pragma mark sharedDelegate
-(void)menuButtonClicked:(int)index{
    UIImage *image = [UIImage imageNamed:@"Icon-72.png"];
    if([_model.goodsInfoArr count] > 0){
        GoodsInfoEntity *entity = [_model.goodsInfoArr objectAtIndex:0];
        NSURL *url = [NSURL URLWithString:entity.homeImg];
        NSData *data = [NSData dataWithContentsOfURL:url];
        if(data){
            image = [UIImage imageWithData:data];
        }
    }
    if(index == Share_Friends){
        [[WXWeiXinOBJ sharedWeiXinOBJ] sendMode:E_WeiXin_Mode_Friend title:[self sharedGoodsInfoTitle] description:[self sharedGoodsInfoDescription] linkURL:[self sharedGoodsInfoUrlString] thumbImage:image];
    }
    if(index == Share_Clrcle){
        [[WXWeiXinOBJ sharedWeiXinOBJ] sendMode:E_WeiXin_Mode_FriendGroup title:[self sharedGoodsInfoTitle] description:[self sharedGoodsInfoDescription] linkURL:[self sharedGoodsInfoUrlString] thumbImage:image];
    }
    if(index == Share_Qq){
        NSData *data = UIImagePNGRepresentation(image);
        QQApiNewsObject *newObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:[self sharedGoodsInfoUrlString]] title:[self sharedGoodsInfoTitle] description:[self sharedGoodsInfoDescription] previewImageData:data];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObj];
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        if(sent == EQQAPISENDSUCESS){
            NSLog(@"qq好友分享成功");
        }
    }
    if(index == Share_Qzone){
        NSData *data = UIImagePNGRepresentation(image);
        QQApiNewsObject *newObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:[self sharedGoodsInfoUrlString]] title:[self sharedGoodsInfoTitle] description:[self sharedGoodsInfoDescription] previewImageData:data];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObj];
        QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
        if(sent == EQQAPISENDSUCESS){
            NSLog(@"qq空间分享成功");
        }
    }
}

-(NSString*)sharedGoodsInfoTitle{
    NSString *title = @"";
    if([_model.goodsInfoArr count] > 0){
        GoodsInfoEntity *entity = [_model.goodsInfoArr objectAtIndex:0];
        title = entity.goodsName;
    }
    return title;
}

-(NSString*)sharedGoodsInfoDescription{
    NSString *description = @"";
    description = [NSString stringWithFormat:@"我在%@发现一个不错的商品，赶快来看看吧。",kMerchantName];
    return description;
}

-(NSString*)sharedGoodsInfoUrlString{
    GoodsInfoEntity *entity = nil;
    if([_model.goodsInfoArr count] > 0){
        entity = [_model.goodsInfoArr objectAtIndex:0];
    }
    
    GoodsInfoEntity *sidEntity = nil;
    if([_model.sellerArr count] > 0){
        sidEntity = [_model.sellerArr objectAtIndex:0];
    }
    
    NSString *strB = [[self sharedGoodsInfoTitle] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
    NSString *urlString =  [NSString stringWithFormat:@"%@wx_union/index.php/Shop/index?go=good_details&seckill_id=%d&title=%@&goods_id=%ld&woxin_id=%@&sid=%d&shop_id=%d&shop_name=%@",WXTShareBaseUrl,self.sckillID,strB,(long)_goodsId, userDefault.wxtID,sidEntity.sellerID,entity.goodsID,entity.goodsName];

    return urlString;
}


#pragma mark --- button

-(void)buyBtnClick:(id)sender{
    if([_model.goodsInfoArr count] == 0){
        [UtilTool showAlertView:@"数据加载失败"];
        return;
    }
    
    if (self.buyGoods) {
        [UtilTool showAlertView:@"活动还未开始"];
        return;
    }
    
    WXUIButton *btn = sender;
    goodsView = [[NewGoodsStockView alloc] init];
    if(btn.tag == 1){
        [goodsView setGoodsViewType:NewGoodsStockView_Type_Buy];
        
    }
    [goodsView loadGoodsStockInfo:_model.stockArr GoodsInfoArr:_model.goodsInfoArr];
    [self.view addSubview:goodsView];
}


//购买
-(void)userBuyBtnClicked{
    MakeOrderVC *makeOrderVC = [[MakeOrderVC alloc] init];
    makeOrderVC.goodsList = [self makeOrderInfoArr];
    makeOrderVC.payType = MakePayType_Limit;
    [self.wxNavigationController pushViewController:makeOrderVC];
}

-(NSArray*)makeOrderInfoArr{
    NSMutableArray *goodsInfoArr = [[NSMutableArray alloc] init];
    GoodsInfoEntity *entity = nil;
    if([_model.goodsInfoArr count] > 0){
        entity = [_model.goodsInfoArr objectAtIndex:0];
    }
    if(!entity){
        return nil;
    }
    entity.goodsID = _goodsId;
    entity.stockID = goodsView.stockID;   // 库存
    entity.stockName = goodsView.stockName;
    entity.stockPrice = goodsView.stockPrice;
    entity.buyNumber = goodsView.buyNum;      //下单商品个数
    entity.redPacket = goodsView.redPacket;
    [goodsInfoArr addObject:entity];
    
    return goodsInfoArr;
}

-(void)backToLastPage{
    [self.wxNavigationController popViewControllerAnimated:YES completion:^{
    }];
}

- (void)contactSeller{
    GoodsInfoEntity *entity = nil;
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

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
