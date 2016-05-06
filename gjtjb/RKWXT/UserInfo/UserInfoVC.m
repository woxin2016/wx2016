//
//  UserInfoVC.m
//  RKWXT
//
//  Created by SHB on 15/3/11.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "UserInfoVC.h"
#import "UserInfoDef.h"
#import "UserHeaderImgModel.h"
#import "WXWeiXinOBJ.h"
#import "ShareBrowserView.h"
#import "ShareSucceedModel.h"
#import "UserHeaderModel.h"
#import "MoreMoneyInfoModel.h"
#import "WXRemotionImgBtn.h"
#import "NewUserCutVC.h"
#import "LuckyGoodsOrderList.h"
#import "UserCollectionGoodsVC.h"

#define UserBgImageViewHeight (126)
#define Size self.view.bounds.size

@interface UserInfoVC()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,PersonalOrderInfoDelegate,ShareBrowserViewDelegate>{
    UITableView *_tableView;
    UIImageView *bgImageView;
    WXUILabel *namelabel;
    
    WXRemotionImgBtn *iconImageView;
    UIImage *_image;
    
    NSArray *menuList;
}
@end

@implementation UserInfoVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addOBS];
    [self setCSTNavigationViewHidden:YES animated:NO];
    if(namelabel){
        WXTUserOBJ *user = [WXTUserOBJ sharedUserOBJ];
        if(user.nickname){
            [namelabel setText:user.nickname];
        }
    }
    
    if([self userIconImage]){
        [iconImageView setImage:[self userIconImage]];
    }
    
  
     [[MoreMoneyInfoModel shareUserMoreMoneyInfo] loadUserMoreMoneyInfo];
    
    if([MoreMoneyInfoModel shareUserMoreMoneyInfo].isChanged){
        [self uploadUserMoreMoneyInfo];
    }
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor:WXColorWithInteger(0xefeff4)];
    
    CGSize size = self.bounds.size;
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, size.width, size.height);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setShowsVerticalScrollIndicator:NO];
    [_tableView setBackgroundColor:WXColorWithInteger(0xefeff4)];
    [self addSubview:_tableView];
    
    [_tableView setTableHeaderView:[self viewForTableHeadView]];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

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

-(void)addOBS{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(uploadUserIconSucceed) name:D_Notification_Name_UploadUserIcon object:nil];
    [notificationCenter addObserver:self selector:@selector(uploadUserInfoSucceed) name:D_Notification_Name_UploadUserInfo object:nil];
    
    //云票和现金相关
    [notificationCenter addObserver:self selector:@selector(uploadUserMoreMoneyInfo) name:K_Notification_Name_LoadUserMoreMoneyInfoSucceed object:nil];
    [notificationCenter addObserver:self selector:@selector(uploadUserMoreMoneyInfo) name:K_Notification_Name_UserCloudTicketChanged object:nil];
    [notificationCenter addObserver:self selector:@selector(uploadUserMoreMoneyInfo) name:K_Notification_Name_UserMoneyBalanceChanged object:nil];
}

-(void)removeOBS{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(UIImage*)userIconImage{
    NSString *iconPath = [NSString stringWithFormat:@"%@",[[UserHeaderImgModel shareUserHeaderImgModel] userIconPath]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:iconPath] && iconImageView){
        UIImage *img = [UIImage imageWithContentsOfFile:iconPath];
        return img;
    }
    return nil;
}

-(void)uploadUserIconSucceed{
    if([self userIconImage]){
        [iconImageView setImage:[self userIconImage]];
    }
}

-(void)uploadUserInfoSucceed{
    if(namelabel){
        WXTUserOBJ *user = [WXTUserOBJ sharedUserOBJ];
        if(user.nickname){
            [namelabel setText:user.nickname];
        }
    }
}

-(void)uploadUserMoreMoneyInfo{
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:PersonalInfo_UserMoney] withRowAnimation:UITableViewRowAnimationFade];
}

-(UIView *)viewForTableHeadView{
    UIView *headView = [[UIView alloc] init];
    
    bgImageView = [[UIImageView alloc] init];
    bgImageView.frame = CGRectMake(0, 0, Size.width, UserBgImageViewHeight);
    [bgImageView setImage:[UIImage imageNamed:@"PersonalInfoBgViewImg.png"]];
    [bgImageView setContentMode:UIViewContentModeScaleAspectFill];
    [headView addSubview:bgImageView];
    
    
    UIImage *iconImg = [UIImage imageNamed:@"PersonalInfo.png"];
    CGFloat xOffset = ([UIScreen mainScreen].bounds.size.width - iconImg.size.width) / 2;
    CGFloat yOffset = (UserBgImageViewHeight-20-iconImg.size.height)/2;
    iconImageView = [[WXRemotionImgBtn alloc] initWithFrame:CGRectMake(xOffset, yOffset, iconImg.size.width, iconImg.size.height)];
    [iconImageView setImage:iconImg];
    [iconImageView setUserInteractionEnabled:NO];
    [iconImageView setBorderRadian:iconImg.size.width/2 width:1.0 color:[UIColor clearColor]];
    [headView addSubview:iconImageView];
    if([UserHeaderModel shareUserHeaderModel].userHeaderImg){
        [iconImageView setCpxViewInfo:[UserHeaderModel shareUserHeaderModel].userHeaderImg];
        [iconImageView load];
    }
    
    WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
    yOffset = CGRectGetMaxY(iconImageView.frame) + 5;
    namelabel = [[WXUILabel alloc] init];
    namelabel.frame = CGRectMake(xOffset, yOffset, iconImg.size.width, 20);
    [namelabel setBackgroundColor:[UIColor clearColor]];
    [namelabel setFont:WXFont(12.0)];
    [namelabel setTextColor:WXColorWithInteger(0xffffff)];
    [namelabel setTextAlignment:NSTextAlignmentCenter];
    [headView addSubview:namelabel];
    
    if(userDefault.nickname.length != 0){
        [namelabel setText:userDefault.nickname];
    }else{
        [namelabel setText:@"dsfsdfas"];
    }
    
    

    WXUIButton *nextBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = iconImageView.frame;
    [nextBtn setBackgroundColor:[UIColor clearColor]];
    [nextBtn addTarget:self action:@selector(nextPageSetInfo) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:nextBtn];
    
    CGRect rect = CGRectMake(0, 0, Size.width, UserBgImageViewHeight);
    [headView setFrame:rect];
    return headView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset  = scrollView.contentOffset.y;
    CGFloat xOffset = 0;
    if (yOffset < 0) {
        CGRect rect = bgImageView.frame;
        rect.origin.y = yOffset;
        rect.size.height =  -yOffset+UserBgImageViewHeight;
        rect.origin.x = xOffset;
        rect.size.width = IPHONE_SCREEN_WIDTH + fabsf(xOffset)*2;
        bgImageView.frame = rect;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return PersonalInfo_Invalid;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == PersonalInfo_Order){
        return 0;
    }
    return 7;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger number = 0;
    switch (section) {
        case PersonalInfo_Order:
            number = Order_Invalid;
            break;
        case PersonalInfo_SharkOrder:
            number = Address_Invalid;
            break;
        case PersonalInfo_UserMoney:
            number = UserMoneyInvalid;
            break;
        case PersonalInfo_CutAndShare:
            number = User_Invalid;
            break;
        case PersonalInfo_System:
            number = System_Invalid;
            break;
        default:
            break;
    }
    return number;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = CommonCellHeight;
    if(indexPath.section == PersonalInfo_Order && indexPath.row == Order_Category){
        height = PersonalOrderInfoCellHeight;
    }
    return height;
}

-(WXTUITableViewCell*)tabelForUserInfoCommonCell:(NSInteger)row{
    static NSString *identifier = @"commonCell";
    UserInfoCommonCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[UserInfoCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDefaultAccessoryView:WXT_CellDefaultAccessoryType_HasNext];
    [cell loadUserInfoBaseData:row];
    return cell;
}

//订单
-(WXTUITableViewCell*)tableViewForOrderCell:(NSInteger)row{
    static NSString *identifier = @"orderCell";
    PersonalInfoOrderListCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[PersonalInfoOrderListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if(row == Order_listAll){
        [cell setDefaultAccessoryView:WXT_CellDefaultAccessoryType_HasNext];
        [cell.imageView setImage:[UIImage imageNamed:@"OrderListImg.png"]];
        [cell.textLabel setText:@"我的订单"];
        [cell.textLabel setFont:WXFont(15.0)];
        [cell.textLabel setTextColor:WXColorWithInteger(0x000000)];
        [cell load];
    }else{
        cell = (PersonalInfoOrderListCell*)[self tableViewForOrderInfoCell:row];
    }
    return cell;
}

-(WXTUITableViewCell*)tableViewForOrderInfoCell:(NSInteger)row{
    static NSString *identifier = @"orderInfoCell";
    PersonalOrderInfoCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[PersonalOrderInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDelegate:self];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell load];
    return cell;
}

//抽奖订单
-(WXTUITableViewCell*)tableViewForSharkOrderCell:(NSInteger)row{
    static NSString *identifier = @"sharkOrderCell";
    WXTUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXTUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDefaultAccessoryView:WXT_CellDefaultAccessoryType_HasNext];
    switch (row) {
        case Address_userShopping:
        {
            [cell.imageView setImage:[UIImage imageNamed:@"SharkImg.png"]];
            [cell.textLabel setText:@"收货地址管理"];
            [cell.textLabel setFont:WXFont(15.0)];
            [cell.textLabel setTextColor:WXColorWithInteger(0x000000)];
        }
            break;
    }
    return cell;
}

//钱包
-(WXTUITableViewCell*)tableViewForMoneyCell:(NSInteger)row{
    static NSString *identifier = @"moneyCell";
    WXTUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXTUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDefaultAccessoryView:WXT_CellDefaultAccessoryType_HasNext];
    switch (row) {
        case Money_listAll:
        {
            [cell.imageView setImage:[UIImage imageNamed:@"MyCallMoneyImg.png"]];
            [cell.textLabel setText:@"我信话费"];
            [cell.textLabel setFont:WXFont(15.0)];
            [cell.textLabel setTextColor:WXColorWithInteger(0x000000)];
        }
            break;
        case Money_Category:
        {
            [cell.imageView setImage:[UIImage imageNamed:@"SignGainCallMoney.png"]];
            [cell.textLabel setText:@"签到送话费"];
            [cell.textLabel setFont:WXFont(15.0)];
            [cell.textLabel setTextColor:WXColorWithInteger(0x000000)];
        }
            break;
        default:
            break;
    }
    return cell;
}

//提成
-(WXTUITableViewCell*)tableViewForUserCutCellAtRow:(NSInteger)row{
    static NSString *identifier = @"userCutCell";
    WXTUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXTUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDefaultAccessoryView:WXT_CellDefaultAccessoryType_HasNext];
    switch (row) {
        case User_Cut:
        {
            [cell.imageView setImage:[UIImage imageNamed:@"userCollection.png"]];
            [cell.textLabel setText:@"我的收藏"];
            [cell.textLabel setFont:WXFont(15.0)];
            [cell.textLabel setTextColor:WXColorWithInteger(0x000000)];
        }
            break;
//        case User_Share:
//        {
//            [cell.imageView setImage:[UIImage imageNamed:@"SharkNewImg.png"]];
//            [cell.textLabel setText:@"我的奖品"];
//            [cell.textLabel setFont:WXFont(15.0)];
//            [cell.textLabel setTextColor:WXColorWithInteger(0x000000)];
//        }
//            break;
        default:
            break;
    }
    return cell;
}

//云票
-(WXTUITableViewCell*)tableViewForUserCloudTicketCell:(NSInteger)row{
    static NSString *identifier = @"userCommonCell";
    UserCommonShowCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[UserCommonShowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDefaultAccessoryView:WXT_CellDefaultAccessoryType_HasNext];
    [cell.textLabel setFont:WXFont(15.0)];
    [cell.textLabel setTextColor:WXColorWithInteger(0x000000)];
    if (row == userXNBOrder) {
        cell = [self tableViewForOrderListCell];
    }else if(row == UserCloudTicket){
        [cell.imageView setImage:[UIImage imageNamed:@"CloudTicketImg.png"]];
        [cell.textLabel setText:@"我的云票"];
        [cell setCellInfo:[NSString stringWithFormat:@"%d",[MoreMoneyInfoModel shareUserMoreMoneyInfo].userCloudBalance]];
        [cell load];
    }else{
        [cell.imageView setImage:[UIImage imageNamed:@"UserMoneyImg.png"]];
        [cell.textLabel setText:@"我的现金"];
        [cell setCellInfo:[NSString stringWithFormat:@"￥%.2f",[MoreMoneyInfoModel shareUserMoreMoneyInfo].userMoneyBalance]];
        [cell load];
    }
    return cell;
}

- (UserCommonShowCell*)tableViewForOrderListCell{
    static NSString *identifier = @"ForOrderListCell";
    UserCommonShowCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[UserCommonShowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDefaultAccessoryView:WXT_CellDefaultAccessoryType_HasNext];
    [cell.textLabel setFont:WXFont(15.0)];
    [cell.textLabel setTextColor:WXColorWithInteger(0x000000)];
    [cell.imageView setImage:[UIImage imageNamed:@"userXNBorder.png"]];
    [cell.textLabel setText:@"兑换订单"];
    return cell;
}

//设置
-(WXTUITableViewCell*)tableViewForSystemCellAtRow:(NSInteger)row{
    static NSString *identifier = @"systemCell";
    WXTUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXTUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDefaultAccessoryView:WXT_CellDefaultAccessoryType_HasNext];
    switch (row) {
        case System_About:
        {
            [cell.imageView setImage:[UIImage imageNamed:@"AboutWxImg.png"]];
            [cell.textLabel setText:@"关于我们"];
            [cell.textLabel setFont:WXFont(15.0)];
            [cell.textLabel setTextColor:WXColorWithInteger(0x000000)];
        }
            break;
        case System_Question:
        {
            [cell.imageView setImage:[UIImage imageNamed:@"MyQuestionImg.png"]];
            [cell.textLabel setText:@"意见反馈"];
            [cell.textLabel setFont:WXFont(15.0)];
            [cell.textLabel setTextColor:WXColorWithInteger(0x000000)];
        }
            break;
        case System_Setting:
        {
            [cell.imageView setImage:[UIImage imageNamed:@"SysSettingImg.png"]];
            [cell.textLabel setText:@"系统设置"];
            [cell.textLabel setFont:WXFont(15.0)];
            [cell.textLabel setTextColor:WXColorWithInteger(0x000000)];
        }
            break;
        default:
            break;
    }
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXTUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    switch (section) {
        case PersonalInfo_Order:
            cell = [self tableViewForOrderCell:row];
            break;
        case PersonalInfo_SharkOrder:
            cell = [self tableViewForSharkOrderCell:row];
            break;
        case PersonalInfo_UserMoney:
            cell = [self tableViewForUserCloudTicketCell:row];
            break;
        case PersonalInfo_CutAndShare:
            cell = [self tableViewForUserCutCellAtRow:row];
            break;
        case PersonalInfo_System:
            cell = [self tableViewForSystemCellAtRow:row];
            break;
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    switch (section) {
        case PersonalInfo_Order:
        {
            if(row == Order_listAll){
                WXHomeOrderListVC *homeOrderListVC = [[WXHomeOrderListVC alloc] init];
                homeOrderListVC.selectedNum = 0;
                [self.wxNavigationController pushViewController:homeOrderListVC];
            }
        }
            break;
        case PersonalInfo_SharkOrder:
        {
            if(row == Address_userShopping){
                ManagerAddressVC *addressVC = [[ManagerAddressVC alloc] init];
                [self.wxNavigationController pushViewController:addressVC];
            }
        }
            break;
        case PersonalInfo_UserMoney:
        {
            if (row == userXNBOrder) {
                VirtualOrderListVC *listVC = [[VirtualOrderListVC alloc]init];
                [self.wxNavigationController pushViewController:listVC];
            }
            if(row == UserCloudTicket){
                CloudTicketListVC *cloudVC = [[CloudTicketListVC alloc] init];
                [self.wxNavigationController pushViewController:cloudVC];
            }
            if(row == UserAccountMoney){
                UserMoneyShowVC *moneyVC = [[UserMoneyShowVC alloc] init];
                [self.wxNavigationController pushViewController:moneyVC];
            }
        }
            break;
        case PersonalInfo_CutAndShare:
        {
            if(row == User_Cut){
                UserCollectionGoodsVC *collection = [[UserCollectionGoodsVC alloc]init];
               [self.wxNavigationController pushViewController:collection];
            }
//            if(row == User_Share){
//                LuckyGoodsOrderList *orderListVC = [[LuckyGoodsOrderList alloc] init];
//                [self.wxNavigationController pushViewController:orderListVC];
//            }
        }
            break;
        case PersonalInfo_System:
        {
            if(row == System_Setting){
                NewSystemSettingVC *systemSetting = [[NewSystemSettingVC alloc] init];
                [self.wxNavigationController pushViewController:systemSetting];
            }
            if(row == System_Question){
                WXUserQuestionVC *questionVC = [[WXUserQuestionVC alloc] init];
                [self.wxNavigationController pushViewController:questionVC];
            }
            if(row == System_About){
                AboutWxtInfoVC *aboutVC = [[AboutWxtInfoVC alloc] init];
                [self.wxNavigationController pushViewController:aboutVC];
            }
        }
            break;
        default:
            [UtilTool showTipView:@"努力开发中..."];
            break;
    }
}


#pragma mark share
-(void)showShareBrowerFromThumbView:(UIView*)thumb{
    ShareBrowserView *pictureBrowse = [[ShareBrowserView alloc] init];
    pictureBrowse.delegate = self;
    [pictureBrowse showShareThumbView:thumb toDestview:self.view withImage:[UIImage imageNamed:@"TwoDimension.png"]];
}

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

#pragma mark qqDelegate
-(void)onResp:(QQBaseResp *)resp{
    if([resp isKindOfClass:[SendMessageToQQResp class]]){
        NSInteger error = [resp.result integerValue];
        if(error != 0){
        }else{
            [[ShareSucceedModel sharedSucceed] sharedSucceed];
            [UtilTool showAlertView:nil message:@"QQ分享成功" delegate:nil tag:0 cancelButtonTitle:@"确定" otherButtonTitles:nil];
        }
    }
}
-(void)onReq:(QQBaseReq *)req{}
-(void)isOnlineResponse:(NSDictionary *)response{}

-(void)nextPageSetInfo{
    BaseInfoVC *baseInfoVC = [[BaseInfoVC alloc] init];
    [self.wxNavigationController pushViewController:baseInfoVC];
}

//订单delegate
-(void)personalInfoToShoppingCart{
    [[CoordinateController sharedCoordinateController] toShoppingCartVC:self animated:YES];
}

-(void)personalInfoToWaitPayOrderList{
    [[CoordinateController sharedCoordinateController] toOrderList:self selectedShow:1 animated:YES];
}

-(void)personalInfoToWaitReceiveOrderList{
    [[CoordinateController sharedCoordinateController] toOrderList:self selectedShow:3 animated:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self removeOBS];
    [MoreMoneyInfoModel shareUserMoreMoneyInfo].isChanged = NO;
}

@end
