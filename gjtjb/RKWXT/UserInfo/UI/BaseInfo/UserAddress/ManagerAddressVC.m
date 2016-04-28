//
//  ManagerAddressVC.m
//  RKWXT
//
//  Created by SHB on 15/6/2.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "ManagerAddressVC.h"
#import "AddressBaseInfoCell.h"
#import "AddressManagerCell.h"
#import "NewUserAddressModel.h"
#import "EditUserAreaVC.h"
#import "LocalAreaModel.h"
#import "AreaEntity.h"

enum{
    Address_BaseInfo = 0,
    Address_Manager,
    
    Address_Invalid,
};

@interface ManagerAddressVC()<UITableViewDataSource,UITableViewDelegate,AddressManagerDelegate,UIAlertViewDelegate>{
    UITableView *_tableView;
    NSArray *_addListArr;
    
    AreaEntity *delAreaEnt;
}
@end

@implementation ManagerAddressVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(_addListArr){
        [NewUserAddressModel shareUserAddress].address_type = UserAddress_Type_Search;
        [[NewUserAddressModel shareUserAddress] loadUserAddress];
        [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
    }
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"地址管理"];
    
    CGSize size = self.bounds.size;
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, size.width, size.height);
    [_tableView setBackgroundColor:WXColorWithInteger(0xefeff4)];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [self addnotification];
    [self createRightView];
    
    _addListArr = [NewUserAddressModel shareUserAddress].userAddressArr;
    [[LocalAreaModel shareLocalArea] loadLocalAreaData];
}

-(void)addnotification{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(loadAddressDataSucceed) name:K_Notification_UserAddress_LoadDateSucceed object:nil];
    [notificationCenter addObserver:self selector:@selector(loadAddressDataFailed:) name:K_Notification_UserAddress_LoadDateFailed object:nil];
    [notificationCenter addObserver:self selector:@selector(delAddressDataSucceed) name:K_Notification_UserAddress_DelDateSucceed object:nil];
    [notificationCenter addObserver:self selector:@selector(delAddressDataFailed:) name:K_Notification_UserAddress_DelDateFailed object:nil];
    [notificationCenter addObserver:self selector:@selector(setAddNormalSucceed) name:K_Notification_UserAddress_SetNorAddSucceed object:nil];
    [notificationCenter addObserver:self selector:@selector(setAddNormalFailed:) name:K_Notification_UserAddress_SetNorAddFailed object:nil];
}

-(void)remoNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)createEmptyView{
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
    [logoView setImage:[UIImage imageNamed:@"AddressEmptyLogo.png"]];
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

-(void)createRightView{
    WXUIButton *createBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    createBtn.frame = CGRectMake(0, 0, 50, 30);
    [createBtn setBackgroundColor:[UIColor clearColor]];
    [createBtn setTitle:@"新建" forState:UIControlStateNormal];
    [createBtn.titleLabel setFont:WXFont(14.0)];
    [createBtn setTitleColor:WXColorWithInteger(0xffffff) forState:UIControlStateNormal];
    [createBtn addTarget:self action:@selector(createNewAddress) forControlEvents:UIControlEventTouchUpInside];
    [self setRightNavigationItem:createBtn];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_addListArr count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return Address_Invalid;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0;
    switch (indexPath.row) {
        case Address_BaseInfo:
            if([_addListArr count] > 0){
                height = [AddressBaseInfoCell cellHeightOfInfo:_addListArr[indexPath.section]];
            }
            break;
        case Address_Manager:
            height = AddressManagerCellHeight;
            break;
        default:
            break;
    }
    return height;
}

-(WXUITableViewCell *)tableViewForAddressBaseInfoCellAtSection:(NSInteger)section atRow:(NSInteger)row{
    static NSString *identifier = @"baseInfoCell";
    AddressBaseInfoCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[AddressBaseInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if(row == Address_Manager){
        cell = (AddressBaseInfoCell*)[self tableViewForManagerAddress:section];
    }else{
        [cell setCellInfo:_addListArr[section]];
        [cell load];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0.0;
    if(section != 0){
        height = 10;
    }
    return height;
}

-(WXUITableViewCell *)tableViewForManagerAddress:(NSInteger)section{
    static NSString *identifier = @"baseCell";
    AddressManagerCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[AddressManagerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setDelegate:self];
    [cell setCellInfo:_addListArr[section]];
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    cell = [self tableViewForAddressBaseInfoCellAtSection:section atRow:row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AreaEntity *entity = _addListArr[indexPath.section];
    if(entity.normalID == 1){
        return;
    }
    NSInteger oldID = 0;
    for(AreaEntity *entity in _addListArr){
        if(entity.normalID == 1){
            oldID = entity.address_id;
        }
    }
    [NewUserAddressModel shareUserAddress].address_type = UserAddress_Type_Normal;
    [[NewUserAddressModel shareUserAddress] setNormalAddressWithOldAddID:oldID withNewAddID:entity.address_id];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];

}

-(void)createNewAddress{
    EditUserAreaVC *addVC = [[EditUserAreaVC alloc] init];
    addVC.address_type = UserArea_Type_Insert;
    [self.wxNavigationController pushViewController:addVC];
}

-(void)editAddressInfo:(AreaEntity *)entity{
    EditUserAreaVC *addeditVC = [[EditUserAreaVC alloc] init];
    addeditVC.address_type = UserArea_Type_Modify;
    addeditVC.entity = entity;
    [self.wxNavigationController pushViewController:addeditVC completion:^{
    }];
}

#pragma mark addressManagerDelegate
-(void)setAddressNormal:(AreaEntity *)entity{
    if(!entity){
        return;
    }
    if(entity.normalID == 1){
        return;
    }
    NSInteger oldID = 0;
    for(AreaEntity *entity in _addListArr){
        if(entity.normalID == 1){
            oldID = entity.address_id;
        }
    }
    [NewUserAddressModel shareUserAddress].address_type = UserAddress_Type_Normal;
    [[NewUserAddressModel shareUserAddress] setNormalAddressWithOldAddID:oldID withNewAddID:entity.address_id];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

-(void)setAddNormalSucceed{
    [self unShowWaitView];
    _addListArr = [NewUserAddressModel shareUserAddress].userAddressArr;
    [_tableView reloadData];
}

-(void)setAddNormalFailed:(NSNotification*)notification{
    [self unShowWaitView];
    NSString *errorMsg = notification.object;
    if(!errorMsg){
        errorMsg = @"设置默认收货信息失败";
    }
    [UtilTool showAlertView:errorMsg];
}

#pragma mark load
-(void)loadAddressDataSucceed{
    [self unShowWaitView];
    _addListArr = [NewUserAddressModel shareUserAddress].userAddressArr;
    [_tableView reloadData];
    
    if([_addListArr count] == 0){
        [self createEmptyView];
    }
}

-(void)loadAddressDataFailed:(NSNotification*)notification{
    [self unShowWaitView];
    NSString *errorMsg = notification.object;
    if(!errorMsg){
        errorMsg = @"查询数据失败";
    }
    [UtilTool showAlertView:errorMsg];
    
    [self createEmptyView];
}

#pragma mark del
-(void)delAddress:(AreaEntity *)entity{
    if(entity.normalID == 1){
        [UtilTool showAlertView:@"请先更改默认地址后再删除!"];
        return;
    }
    
    delAreaEnt = entity;
    [UtilTool showAlertView:@"" message:@"确认删除此收货地址吗?" delegate:self tag:0 cancelButtonTitle:@"取消" otherButtonTitles:@"确定"];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        [NewUserAddressModel shareUserAddress].address_type = UserAddress_Type_Delete;
        [[NewUserAddressModel shareUserAddress] deleteUserAddressWithAddressID:delAreaEnt.address_id];
        [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
    }
}

-(void)delAddressDataSucceed{
    [self unShowWaitView];
    _addListArr = [NewUserAddressModel shareUserAddress].userAddressArr;
    [_tableView reloadData];
}

-(void)delAddressDataFailed:(NSNotification*)notification{
    [self unShowWaitView];
    NSString *errorMsg = notification.object;
    if(!errorMsg){
        errorMsg = @"删除数据失败";
    }
    [UtilTool showAlertView:errorMsg];
}

@end
