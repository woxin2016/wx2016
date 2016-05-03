//
//  MakeOrderVC.m
//  RKWXT
//
//  Created by SHB on 16/1/8.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "MakeOrderVC.h"
#import "MakeOrderDef.h"
#import "MakeOrderModel.h"
#import "GoodsInfoEntity.h"
#import "OrderPayVC.h"
#import "ManagerAddressVC.h"
#import "UserBonusModel.h"
#import "SearchCarriageMoney.h"
//地址
#import "NewUserAddressModel.h"
#import "AreaEntity.h"

#define Size self.bounds.size
#define DownViewHeight (59)

@interface MakeOrderVC()<UITableViewDataSource,UITableViewDelegate,MakeOrderUserMsgTextFieldCellDelegate,WXUITableViewCellDelegate,MakeOrderSwitchCellDelegate,MakeOrderDelegate,SearchCarriageMoneyDelegate,UIAlertViewDelegate/*,MakeOrderBananceSwitchCellDelegate*/>{
    UITableView *_tableView;
    MakeOrderModel *_model;
    
    BOOL userBonus;
    NSInteger _bonus;
    
    CGFloat allGoodsMoney;
    
    SearchCarriageMoney *carriageModel;
}
@property (nonatomic,strong) NSString *userMessage;
@end

@implementation MakeOrderVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCSTNavigationViewHidden:NO animated:NO];
    if(_tableView){
            if([[NewUserAddressModel shareUserAddress].userAddressArr count] != 0){
            [self loadCarriageMoney];
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:Order_Section_UserInfo] withRowAnimation:UITableViewRowAnimationFade];
      }
  }
}

-(id)init{
    self = [super init];
    if(self){
        _model = [[MakeOrderModel alloc] init];
        [_model setDelegate:self];
        
        carriageModel = [[SearchCarriageMoney alloc] init];
        [carriageModel setDelegate:self];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"订单确认"];
    [self setBackgroundColor:[UIColor whiteColor]];
    userBonus = NO;
    
    [self  lookUserInfoSite];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Size.width, Size.height-DownViewHeight)];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self addSubview:[self createDownView]];
    
    [self addNotification];
    [self censusBonusValue];
    
}

- (void)lookUserInfoSite{
    if ([[NewUserAddressModel shareUserAddress].userAddressArr count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请添加默认地址" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)loadCarriageMoney{
    BOOL is_postage = YES;  //默认包邮
    NSInteger provinceID = [self parseUserAddressProvinceID];
    NSString *goodsInfo = [[NSString alloc] init];
    for(GoodsInfoEntity *entity in _goodsList){
        if(goodsInfo.length > 0){
            goodsInfo = [goodsInfo stringByAppendingString:@"^"];
        }
        goodsInfo = [goodsInfo stringByAppendingString:[NSString stringWithFormat:@"%ld:%ld",(long)entity.goodsID,(long)entity.buyNumber]];
        if(entity.postage == Goods_Postage_Have){
            is_postage = NO;  //不包邮
        }
    }
    if(!is_postage){
        [carriageModel searchCarriageMoneyWithProvinceID:provinceID goodsInfo:goodsInfo];
        [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
    }
}

//可使用红包
-(void)censusBonusValue{
    for(GoodsInfoEntity *entity in _goodsList){
        _bonus += entity.redPacket*entity.buyNumber;
    }
    if(_bonus > [UserBonusModel shareUserBonusModel].bonusMoney){
        _bonus = [UserBonusModel shareUserBonusModel].bonusMoney;
    }
    if(_bonus > [UserBonusModel shareUserBonusModel].bonusMoney && [_goodsList count] > 1){
        _bonus = 0;
    }
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

-(void)addNotification{
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    [notification addObserver:self selector:@selector(InfokeyboardWillShown:)
                         name:UIKeyboardWillShowNotification object:nil];
    [notification addObserver:self selector:@selector(InfokeyboardWillHide:)
                         name:UIKeyboardWillHideNotification object:nil];
}

-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(UIView*)createDownView{
    UIView *downView = [[UIView alloc] init];
    [downView setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat xGap = 13;
    CGFloat btnWidth = 85;
    CGFloat btnHeight = 40;
    WXUIButton *okBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(Size.width-xGap-btnWidth, (DownViewHeight-btnHeight)/2, btnWidth, btnHeight);
    [okBtn setBackgroundColor:WXColorWithInteger(AllBaseColor)];
    [okBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    [okBtn.titleLabel setFont:WXFont(14.0)];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(submitOrder) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:okBtn];
    
    [downView setFrame:CGRectMake(0, Size.height-DownViewHeight, Size.width, DownViewHeight)];
    return downView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return Order_Section_Invalid;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
//
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (section) {
        case Order_Section_UserInfo:
            height = Order_Section_Height_UserInfo;
            break;
        case Order_Section_ShopName:
            height = Order_Section_Height_ShopName;
            break;
        case Order_Section_GoodsList:
            height = Order_Section_Height_GoodsList;
            break;
        case Order_Section_PayStatus:
            height = Order_Section_Height_PayStatus;
            break;
        case Order_Section_UserMessage:
            height = Order_Section_Height_UserMesg;
            break;
        case Order_Section_UseBonus:
        {
            if(row == 0){
                height = Order_Section_Height_UseBonus;
            }else{
                height = Order_Section_Height_BonusInfo;
            }
        }
            break;
        case Order_Section_GoodsMoney:
            if(row == 0){
                height = Order_Section_Height_MoneyInfo;
            }else{
                height = Order_Section_Height_GoodsMoney;
            }
            break;
        default:
            break;
    }
    return height;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 0;
    switch (section) {
        case Order_Section_UserInfo:
        case Order_Section_ShopName:
        case Order_Section_PayStatus:
        case Order_Section_UserMessage:
            row = 1;
            break;
        case Order_Section_UseBonus:
            row = (userBonus?2:1);
            break;
        case Order_Section_GoodsList:
            row = [_goodsList count];
            break;
        case Order_Section_GoodsMoney:
            row = 2;
            break;
        default:
            break;
    }
    return row;
}

//个人信息
-(WXUITableViewCell*)tableViewForUserInfoCell{
    static NSString *identifier = @"userInfoCell";
    MakeOrderUserInfoCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[MakeOrderUserInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_HasNext];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell load];
    return cell;
}

//店铺
-(WXUITableViewCell*)tabelViewForShopNameCell{
    static NSString *identifier = @"shopNameCell";
    MakeOrderShopCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[MakeOrderShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_HasNext];
    GoodsInfoEntity *entity = [_goodsList objectAtIndex:0];
    [cell setCellInfo:entity.homeImg];
    [cell load];
    return cell;
}

//商品列表
-(WXUITableViewCell*)tableViewForGoodsListCellAtRow:(NSInteger)row{
    static NSString *identifier = @"goodsListCell";
    MakeOrderGoodsListCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MakeOrderGoodsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];;
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setCellInfo:[_goodsList objectAtIndex:row]];
    [cell load];
    return cell;
}

//支付方式
-(WXUITableViewCell*)tableViewForPayStatusCell{
    static NSString *identifier = @"payCell";
    MakeOrderPayStatusCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[MakeOrderPayStatusCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell load];
    return cell;
}

//用户留言
-(WXUITableViewCell *)tableViewForUserMessageTextFieldCell{
    static NSString *identififer = @"userMsgCell";
    MakeOrderUserMsgTextFieldCell *cell = [_tableView dequeueReusableCellWithIdentifier:identififer];
    if(!cell){
        cell = [[MakeOrderUserMsgTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identififer];
    }
    [cell setDelegate:self];
    [cell load];
    return cell;
}

//使用红包
-(WXUITableViewCell *)tableViewForBonusSwitchCellAtRow:(NSInteger)row{
    static NSString *identifier = @"bonusCell";
    MakeOrderSwitchCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[MakeOrderSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setDelegate:self];
    [cell setCellInfo:[NSNumber numberWithInt:(userBonus?1:0)]];
    
    [cell.textLabel setText:@"使用红包抵现"];
    [cell.textLabel setFont:WXFont(14.0)];
    [cell.textLabel setTextColor:WXColorWithInteger(0x646464)];
    [cell load];
    return cell;
}

-(WXUITableViewCell*)tableViewForBonusMoneyCellAtRow:(NSInteger)row{
    static NSString *identifier = @"bonusMoneyCell";
    MakeOrderUseBonusCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[MakeOrderUseBonusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setCellInfo:[NSString stringWithFormat:@"%ld",(long)_bonus]];
    [cell load];
    return cell;
}

//商品价格
-(WXUITableViewCell*)tableViewForGoodsMoneyInfoAtRow:(NSInteger)row{
    static NSString *identifier = @"allMoneyCell";
    MakeOrderGoodsMoneyCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[MakeOrderGoodsMoneyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if(userBonus){
        [cell setBonusMoney:_bonus];
    }else{
        [cell setBonusMoney:0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setCarriageMoney:carriageModel.carriageMoney];
    [cell setCellInfo:_goodsList];
    [cell load];
    return cell;
}

-(WXUITableViewCell*)tableViewForAllGoodsMoneyAtRow:(NSInteger)row{
    static NSString *identifier = @"totalMoneyCell";
    MakeOrderAllGoodsMoneyCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[MakeOrderAllGoodsMoneyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if(userBonus){
        [cell setBonusMoney:_bonus];
    }else{
        [cell setBonusMoney:0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setCarriageMoney:carriageModel.carriageMoney];
    [cell setCellInfo:_goodsList];
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (section) {
        case Order_Section_UserInfo:
            cell = [self tableViewForUserInfoCell];
            break;
        case Order_Section_ShopName:
            cell = [self tabelViewForShopNameCell];
            break;
        case Order_Section_GoodsList:
            cell = [self tableViewForGoodsListCellAtRow:row];
            break;
        case Order_Section_PayStatus:
            cell = [self tableViewForPayStatusCell];
            break;
        case Order_Section_UserMessage:
            cell = [self tableViewForUserMessageTextFieldCell];
            break;
        case Order_Section_UseBonus:
        {
            if(userBonus){
                if(row == 0){
                    cell = [self tableViewForBonusSwitchCellAtRow:row];
                }else{
                    cell = [self tableViewForBonusMoneyCellAtRow:row];
                }
            }else{
                cell = [self tableViewForBonusSwitchCellAtRow:row];
            }
        }
            break;
        case Order_Section_GoodsMoney:
        {
            if(row == 0){
                cell = [self tableViewForGoodsMoneyInfoAtRow:row];
            }else{
                cell = [self tableViewForAllGoodsMoneyAtRow:row];
            }
        }
            break;
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    switch (section) {
        case Order_Section_UserInfo:
        {
            ManagerAddressVC *addressVC = [[ManagerAddressVC alloc] init];
            [self.wxNavigationController pushViewController:addressVC];
        }
            break;
            
        case Order_Section_ShopName:
        {
//            [[CoordinateController sharedCoordinateController] toAboutShopVC:self animated:YES];
        }
        default:
            break;
    }
}

#pragma mark userMessageDelegate
-(void)userMessageTextFieldChanged:(MakeOrderUserMsgTextFieldCell *)cell{
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    if(indexPath){
        NSInteger section = indexPath.section;
        if(section == Order_Section_UserMessage){
            self.userMessage = cell.textField.text;
        }
    }
}

-(void)InfokeyboardWillShown:(NSNotification *)notification{
    CGRect rect = CGRectMake(0, -100, self.bounds.size.width, self.bounds.size.height-DownViewHeight);
    [UIView animateWithDuration:0.2 animations:^{
        [_tableView setFrame:rect];
    } completion:^(BOOL finished) {
    }];
}

-(void)InfokeyboardWillHide:(NSNotification *)notification{
    CGRect rect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-DownViewHeight);
    [UIView animateWithDuration:0.2 animations:^{
        [_tableView setFrame:rect];
    } completion:^(BOOL finished) {
    }];
}

#pragma mark BonusCell下拉
-(void)didSelectCellRowFirstDo:(BOOL)firstDoInsert{
    userBonus = firstDoInsert;
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:Order_Section_UseBonus] withRowAnimation:UITableViewRowAnimationFade];
    if(userBonus){
        [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:Order_Section_UseBonus] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
}

#pragma mark useBonusDelegate
-(void)switchValueChanged{
    userBonus = !userBonus;
    [self didSelectCellRowFirstDo:userBonus];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:Order_Section_GoodsMoney] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark carriageDelegate
-(void)searchCarriageMoneySucceed{
    [self unShowWaitView];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:Order_Section_GoodsMoney] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)searchCarriageMoneyFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    if(!errorMsg){
        errorMsg = @"获取运费失败";
    }
    [UtilTool showAlertView:errorMsg];
}

#pragma mark submit
-(void)submitOrder{
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];

    if (self.payType == MakePayType_Limit) {
        [_model limitSubmitOrderDataWithTotalMoney:[self allGoodsOldMoney] factPay:[self allGoodsTotalMoney] redPac:(userBonus?_bonus:0) carriage:carriageModel.carriageMoney remark:(self.userMessage.length==0?@"无":self.userMessage) goodsInfo:[self makeOrderGoodsInfo] inventory:[self makeLimitGoods] goodsID:[self makeLimitGoodsID]];
    }else if(self.payType == MakePayType_Normal){
       [_model submitOrderDataWithTotalMoney:[self allGoodsOldMoney] factPay:[self allGoodsTotalMoney] redPac:(userBonus?_bonus:0) carriage:carriageModel.carriageMoney remark:(self.userMessage.length==0?@"无":self.userMessage) goodsInfo:[self makeOrderGoodsInfo]];
    }
}

- (NSString*)makeLimitGoodsID{
    NSString *stock = nil;
    for(GoodsInfoEntity *entity in _goodsList){
        stock = [NSString stringWithFormat:@"%ld",(long)entity.goodsID];
    }
    return stock;
}

- (NSString*)makeLimitGoods{
    NSString *stock = nil;
    for(GoodsInfoEntity *entity in _goodsList){
        stock = [NSString stringWithFormat:@"%ld",(long)entity.stockID];
    }
    return stock;
}

-(NSString*)makeOrderGoodsInfo{
    NSString *goodsInfo = [[NSString alloc] init];
    for(GoodsInfoEntity *entity in _goodsList){
        if(goodsInfo.length > 0){
            goodsInfo = [goodsInfo stringByAppendingString:@"^"];
        }
        goodsInfo = [goodsInfo stringByAppendingString:[NSString stringWithFormat:@"%ld:%ld",(long)entity.stockID,(long)entity.buyNumber]];
    }
    return goodsInfo;
}

-(NSDictionary*)goodsDicWithEntity:(GoodsInfoEntity*)entity{
    NSString *goodsID = [NSString stringWithFormat:@"%ld",(long)entity.goodsID];
    NSString *stockID = [NSString stringWithFormat:@"%ld",(long)entity.stockID];
    NSString *stockName = [NSString stringWithFormat:@"%@",entity.stockName];
    NSString *price = [NSString stringWithFormat:@"%f",entity.stockPrice];
    NSString *number = [NSString stringWithFormat:@"%ld",(long)entity.buyNumber];
    NSInteger length = AllImgPrefixUrlString.length;
    NSString *smallImgStr = [entity.goodsImg substringFromIndex:length];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:goodsID ,@"goods_id", entity.goodsName, @"goods_name", smallImgStr, @"goods_img", stockID, @"goods_stock_id", stockName, @"goods_stock_name", price, @"sales_price", number, @"sales_number", nil];
    return dic;
}

//限时购
//-(void)submitLimitOrder{
//    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
//    NSMutableArray *arr = [[NSMutableArray alloc] init];
//    for(GoodsInfoEntity *entity in _goodsList){
//        NSDictionary *dic = [self limitGoodsDicWithEntity:entity];
//        [arr addObject:dic];
//    }
//    [_model submitLimitOrderWithAllMoney:[self allGoodsOldMoney] withTotalMoney:[self allGoodsTotalMoney] withRedPacket:(userBonus?_bonus:0) withRemark:(self.userMessage.length==0?@"无":self.userMessage) withProID:[self parseUserAddressProvinceID] withCarriage:carriageModel.carriageMoney withGoodsList:arr];
//}
//
//-(NSDictionary*)limitGoodsDicWithEntity:(GoodsInfoEntity*)entity{
//    NSString *goodsID = [NSString stringWithFormat:@"%ld",(long)entity.goods_id];
//    NSString *stockID = [NSString stringWithFormat:@"%ld",(long)entity.stockID];
//    NSString *stockName = [NSString stringWithFormat:@"%@",entity.stockName];
//    NSString *price = [NSString stringWithFormat:@"%f",entity.stockPrice];
//    NSString *number = [NSString stringWithFormat:@"%ld",(long)entity.buyNumber];
//    NSInteger length = AllImgPrefixUrlString.length;
//    NSString *limitID = [NSString stringWithFormat:@"%ld",(long)[limitEntity.scare_buying_id integerValue]];
//    NSString *smallImgStr = [entity.smallImg substringFromIndex:length];
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:goodsID ,@"goods_id", entity.intro, @"goods_name", smallImgStr, @"goods_img", stockID, @"goods_stock_id", stockName, @"goods_stock_name", price, @"sales_price", number, @"sales_number", limitID, @"scare_buying_id", nil];
//    return dic;
//}

//省份ID
-(NSInteger)parseUserAddressProvinceID{
    for(AreaEntity *entity in [NewUserAddressModel shareUserAddress].userAddressArr){
        if(entity.normalID == 1){
            return entity.proID;
        }
    }
    return 0;
}

//订单总金额
-(CGFloat)allGoodsOldMoney{
    CGFloat price = 0.0;
    for(GoodsInfoEntity *entity in _goodsList){
        price += entity.stockPrice*entity.buyNumber;
    }
    allGoodsMoney = price;
    
    return price;
}

//订单应付金额
-(CGFloat)allGoodsTotalMoney{
    CGFloat totalMoney = [self allGoodsOldMoney];
    if(userBonus){
        totalMoney -= _bonus;
    }
    totalMoney += carriageModel.carriageMoney;
    return totalMoney;
}

-(void)makeOrderSucceed{
//    [UtilTool showAlertView:@"下单成功"];
    [self unShowWaitView];
    if(allGoodsMoney == 0){
        return;
    }
    if(userBonus){
        [UserBonusModel shareUserBonusModel].bonusMoney -= _bonus;
    }
    
    OrderPayVC *payVC = [[OrderPayVC alloc] init];
    payVC.payMoney = [self allGoodsTotalMoney];
    payVC.orderID = _model.orderID;
    payVC.orderpay_type = OrderPay_Type_Order;
    [self.wxNavigationController pushViewController:payVC];
}

-(void)makeOrderFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    if(!errorMsg){
        errorMsg = @"下单失败,请重试";
    }
    [UtilTool showAlertView:errorMsg];
    return;
}

#pragma mark   --- alert
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    ManagerAddressVC *addressVC = [[ManagerAddressVC alloc] init];
    [self.wxNavigationController pushViewController:addressVC];
}

@end
