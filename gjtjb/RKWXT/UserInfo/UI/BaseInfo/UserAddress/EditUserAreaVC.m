//
//  EditUserAreaVC.m
//  RKWXT
//
//  Created by SHB on 16/1/8.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "EditUserAreaVC.h"
#import "NewAddressAreaCell.h"
#import "NewAddressInfoCell.h"
#import "NewAddressTextfieldCell.h"
#import "NewUserAddressPhoneCell.h"
#import "UserDefaultSiteCell.h"
#import "NewUserAddressModel.h"
#import "LocalAreaModel.h"
#import "AreaEntity.h"

#define Size self.bounds.size
#define pickerViewHeight (240)

enum{
    AddressEdit_Row_Name = 0,
    AddressEdit_Row_Phone,
    AddressEdit_Row_Area,
    AddressEdit_Row_Info,
    
    AddressEdit_Row_Invalid,
};

@interface EditUserAreaVC()<UITableViewDataSource,UITableViewDelegate,NewAddressInfoCellDelegate,NewTextFieldCellDelegate,UIPickerViewDataSource,UIPickerViewDelegate,NewUserAddressPhoneCellDelegate,UserDefaultSiteCellDelegate>{
    UITableView *_tableView;
    UIPickerView *picker;
    
    UIView *shellView;
    BOOL showPicker;
    BOOL defultSite;
}
@property (nonatomic,strong) AreaEntity *proEnt;
@property (nonatomic,strong) AreaEntity *cityEnt;
@property (nonatomic,strong) AreaEntity *disEnt;

//临时存储市和区
@property (nonatomic,strong) NSArray *cityList;
@property (nonatomic,strong) NSArray *disList;

@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *userPhone;
@property (nonatomic,strong) NSString *infoStr;
@property (nonatomic,strong) NSString *addressStr;
@end

@implementation EditUserAreaVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self addNotification];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    if (self.address_type == UserArea_Type_Insert) {
        [self setCSTTitle:@"新建收货地址"];
    }else{
        [self setCSTTitle:@"地址编辑"];

    }
    
    self.backgroundColor = WXColorWithInteger(0xefeff4);
   
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setBackgroundColor:WXColorWithInteger(0xefeff4)];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [self createSelectAreaPickerView];
    [self rightCompleteBtn];
    
    self.cityList = [[LocalAreaModel shareLocalArea] searchCityArrayWithProvinceID:[LocalAreaModel shareLocalArea].areaEntity.areaID];
    if([self.cityList count] > 0){
        AreaEntity *cityEntity = [self.cityList objectAtIndex:0];
        self.disList = [[LocalAreaModel shareLocalArea] searchDistricArrayWithCityID:cityEntity.areaID];
    }
    
    if(_entity){
        self.userName = _entity.userName;
        self.userPhone = _entity.userPhone;
        self.infoStr = _entity.address;
        self.addressStr = [NSString stringWithFormat:@"%@%@%@",_entity.proName,_entity.cityName,_entity.disName];
    }
}

-(void)addNotification{
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    [notification addObserver:self selector:@selector(insertAddressSucceed) name:K_Notification_UserAddress_InsertDataSucceed object:nil];
    [notification addObserver:self selector:@selector(insertAddressFailed:) name:K_Notification_UserAddress_InsertDataFailed object:nil];
    [notification addObserver:self selector:@selector(modifyAddressSucceed) name:K_Notification_UserAddress_ModifyDateSucceed object:nil];
    [notification addObserver:self selector:@selector(modifyAddressFailed:) name:K_Notification_UserAddress_ModifyDateFailed object:nil];
}

-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)createSelectAreaPickerView{
    shellView = [[WXUIView alloc] init];
    shellView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [shellView setHidden:YES];
    [shellView setUserInteractionEnabled:YES];
    [shellView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:shellView];
    
    picker = [[UIPickerView alloc] initWithFrame: CGRectMake(0, IPHONE_SCREEN_HEIGHT, Size.width, pickerViewHeight)];
    picker.dataSource = self;
    picker.delegate = self;
    [picker setBackgroundColor:[UIColor whiteColor]];
    picker.showsSelectionIndicator = YES;
    [picker selectRow:0 inComponent:0 animated:YES];
    [self.view addSubview:picker];
}

-(void)rightCompleteBtn{
    WXUIButton *submitBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(0, 0, 40, 30);
    [submitBtn setBackgroundColor:WXColorWithInteger(AllBaseColor)];
    [submitBtn setTitle:@"保存" forState:UIControlStateNormal];
    [submitBtn setTitleColor:WXColorWithInteger(0xffffff) forState:UIControlStateNormal];
    [submitBtn.titleLabel setFont:WXFont(13.0)];
    [submitBtn addTarget:self action:@selector(submitUserInfoData) forControlEvents:UIControlEventTouchUpInside];
    [self setRightNavigationItem:submitBtn];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row < AddressEdit_Row_Info){
        return 44.0;
    }
    return NewAddressInfoCellHeight;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return AddressEdit_Row_Invalid;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.0000000000;
    }
    return 20;
}

-(WXUITableViewCell *)tableViewForAddressNameCell{
    static NSString *identifier = @"nameCell";
    NewAddressTextfieldCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[NewAddressTextfieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setAlertText:@"收货人姓名"];
    [cell setDelegate:self];
    [cell setCellInfo:self.userName];
    [cell load];
    return cell;
}

-(WXUITableViewCell *)tableViewForAddressPhoneCell{
    static NSString *identifier = @"phoneCell";
    NewUserAddressPhoneCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[NewUserAddressPhoneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setAlertText:@"收货人电话"];
    [cell setDelegate:self];
    [cell setCellInfo:self.userPhone];
    [cell load];
    return cell;
}

-(WXUITableViewCell*)tableViewForAddressAreaCell{
    static NSString *identifier = @"areaCell";
    NewAddressAreaCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[NewAddressAreaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setNormalAddress:self.addressStr];
    if(self.proEnt.areaName){
        NSString *address = [NSString stringWithFormat:@"%@%@%@",self.proEnt.areaName,self.cityEnt.areaName,self.disEnt.areaName];
        [cell setCellInfo:address];
    }
    [cell load];
    return cell;
}

-(WXUITableViewCell*)tableViewForAddressInfoCell{
    static NSString *identifier = @"infoCell";
    NewAddressInfoCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[NewAddressInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setCellInfo:self.infoStr];
    [cell setDelegate:self];
    [cell load];
    return cell;
}

// 设置为默认
-(WXUITableViewCell*)tableViewDefaultSiteCell{
    static NSString *identifier = @"DefaultSiteCell";
    UserDefaultSiteCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[UserDefaultSiteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = @"设置为默认地址";
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.delegate = self;
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        switch (row) {
            case AddressEdit_Row_Name:
                cell = [self tableViewForAddressNameCell];
                break;
            case AddressEdit_Row_Phone:
                cell = [self tableViewForAddressPhoneCell];
                break;
            case AddressEdit_Row_Area:
                cell = [self tableViewForAddressAreaCell];
                break;
            case AddressEdit_Row_Info:
                cell = [self tableViewForAddressInfoCell];
                break;
            default:
                break;
        }
    }else{
        cell = [self tableViewDefaultSiteCell];
    }

    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == AddressEdit_Row_Area){
        [self newAddressAreaBtnClicked];
    }
}

#pragma mark picker
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(component == PROVINCE_COMPONENT){
        return [[LocalAreaModel shareLocalArea].provinceArr count];
    }else if (component == CITY_COMPONENT){
        return [self.cityList count];
    }else{
        return [self.disList count];
    }
}

#pragma mark Picker Delegate Methods
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(component == PROVINCE_COMPONENT){
        AreaEntity *proEntity = [[LocalAreaModel shareLocalArea].provinceArr objectAtIndex:row];
        [LocalAreaModel shareLocalArea].selectedProvince = proEntity.areaName;
        self.proEnt = proEntity;
        
        NSArray *cityArray = [[LocalAreaModel shareLocalArea] searchCityArrayWithProvinceID:proEntity.areaID];
        AreaEntity *cityEntity = [cityArray objectAtIndex:0];
        self.cityList = cityArray;
        self.cityEnt = cityEntity;
        
        NSArray *disArr = [[LocalAreaModel shareLocalArea] searchDistricArrayWithCityID:cityEntity.areaID];
        AreaEntity *disEntity = [disArr objectAtIndex:0];
        self.disList = disArr;
        self.disEnt = disEntity;
        
        [picker selectRow:0 inComponent:CITY_COMPONENT animated:YES];
        [picker reloadComponent:CITY_COMPONENT];
        [picker selectRow:0 inComponent:DISTRICT_COMPONENT animated:YES];
        [picker reloadComponent:DISTRICT_COMPONENT];
    }else if (component == CITY_COMPONENT){
        AreaEntity *cityEntit = [self.cityList objectAtIndex:row];
        self.cityEnt = cityEntit;
        
        self.disList = [[LocalAreaModel shareLocalArea] searchDistricArrayWithCityID:cityEntit.areaID];
        self.disEnt = [self.disList objectAtIndex:0];
        
        [picker selectRow:0 inComponent:DISTRICT_COMPONENT animated:YES];
        [picker reloadComponent:DISTRICT_COMPONENT];
    }else{
        AreaEntity *proEntity = nil;
        if(!self.proEnt){
            proEntity = [[LocalAreaModel shareLocalArea].provinceArr objectAtIndex:0];
            [LocalAreaModel shareLocalArea].selectedProvince = proEntity.areaName;
            self.proEnt = proEntity;
        }
        if(!self.cityEnt){
            NSArray *cityArray = [[LocalAreaModel shareLocalArea] searchCityArrayWithProvinceID:proEntity.areaID];
            AreaEntity *cityEntity = [cityArray objectAtIndex:0];
            self.cityEnt = cityEntity;
        }
        self.disEnt = [self.disList objectAtIndex:row];
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:AddressEdit_Row_Area inSection:0];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if(component == PROVINCE_COMPONENT){
        return 80;
    }else if (component == CITY_COMPONENT){
        return 100;
    }else{
        return 115;
    }
}

-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *myView = nil;
    CGFloat labelHeight = 30;
    if(component == PROVINCE_COMPONENT){
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 78, labelHeight)];
        myView.textAlignment = NSTextAlignmentCenter;
        AreaEntity *proEntity = [[LocalAreaModel shareLocalArea].provinceArr objectAtIndex:row];
        myView.text = proEntity.areaName;
        myView.font = WXFont(14.0);
        [myView setBackgroundColor:[UIColor clearColor]];
    }else if (component == CITY_COMPONENT) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 95, labelHeight)];
        myView.textAlignment = NSTextAlignmentCenter;
        AreaEntity *ent = [self.cityList objectAtIndex:row];
        myView.text = ent.areaName;
        myView.font = [UIFont systemFontOfSize:14];
        myView.backgroundColor = [UIColor clearColor];
    }
    else {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 110, labelHeight)];
        myView.textAlignment = NSTextAlignmentCenter;
        AreaEntity *proEntity = [self.disList objectAtIndex:row];
        myView.text = proEntity.areaName;
        myView.font = [UIFont systemFontOfSize:14];
        myView.backgroundColor = [UIColor clearColor];
    }
    
    return myView;
}

#pragma mark btn
-(void)newAddressAreaBtnClicked{
    [self.view endEditing:YES];
    
    showPicker = !showPicker;
    if(showPicker){
        [self showPickerView];
    }else{
        [self unShowPickerView];
    }
}

#pragma mark  cell
-(void)textFiledValueDidChanged:(NSString *)text{
    showPicker = NO;
    [self unShowPickerView];
    self.userName = text;
}

-(void)textFiledPhoneValueDidChanged:(NSString *)text{
    showPicker = NO;
    [self unShowPickerView];
    self.userPhone = text;
}

-(void)textViewValueDidChanged:(NSString*)text{
    showPicker = NO;
    [self unShowPickerView];
    self.infoStr = text;
}

#pragma mark submit
-(void)submitUserInfoData{
    
    if(self.userName.length != 0 && self.userPhone.length != 0 && (self.proEnt.areaName.length != 0 || _entity)){
        if(![self checkUserPhoneWithString:self.userPhone]){
            return;
        }
        if (self.infoStr.length == 0 ) {
            [UtilTool showAlertView:@"请填写详细地址"];
            return;
        }
        if(_address_type == UserArea_Type_Insert){  
            [NewUserAddressModel shareUserAddress].address_type = UserAddress_Type_Insert;
            [[NewUserAddressModel shareUserAddress] insertUserAddressWithName:self.userName withAdd:self.infoStr withPhone:self.userPhone proID:self.proEnt.areaID cityID:self.cityEnt.areaID disID:self.disEnt.areaID proName:self.proEnt.areaName cityName:self.cityEnt.areaName disName:self.disEnt.areaName is_defult:defultSite];
        }else{
            [NewUserAddressModel shareUserAddress].address_type = UserAddress_Type_Change;
            if(self.proEnt.areaName.length == 0){
                [[NewUserAddressModel shareUserAddress] modifyUserAddressWithName:self.userName withAdd:self.infoStr withPhone:self.userPhone proID:_entity.proID cityID:_entity.cityID disID:_entity.disID proName:_entity.proName cityName:_entity.cityName disName:_entity.disName addressID:_entity.address_id is_default:defultSite];
            }else{
                [[NewUserAddressModel shareUserAddress] modifyUserAddressWithName:self.userName withAdd:self.infoStr withPhone:self.userPhone proID:self.proEnt.areaID cityID:self.cityEnt.areaID disID:self.disEnt.areaID proName:self.proEnt.areaName cityName:self.cityEnt.areaName disName:self.disEnt.areaName addressID:_entity.address_id is_default:defultSite];
            }
        }
        
        
        [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
    }else{
        [UtilTool showAlertView:@"信息不完整"];
    }
}

-(BOOL)checkUserPhoneWithString:(NSString*)phone{
    NSString *phoneStr = [UtilTool callPhoneNumberRemovePreWith:phone];
    if(![UtilTool determineNumberTrue:phoneStr]){
        [UtilTool showAlertView:@"您添加的号码格式不正确"];
        return NO;
    }
    return YES;
}

#pragma mark picker
-(void)showPickerView{
    [shellView setHidden:NO];
    [shellView setAlpha:0.1];
    [UIView animateWithDuration:0.4 animations:^{
        CGRect rect = picker.frame;
        rect.origin.y = IPHONE_SCREEN_HEIGHT-pickerViewHeight+25;
        rect.size.height = pickerViewHeight;
        [picker setFrame:rect];
    }];
}

-(void)unShowPickerView{
    [shellView setHidden:YES];
    [shellView setAlpha:1.0];
    [UIView animateWithDuration:0.4 animations:^{
        CGRect rect = picker.frame;
        rect.origin.y = IPHONE_SCREEN_HEIGHT;
        rect.size.height = 0;
        [picker setFrame:rect];
    }];
}

#pragma mark inserDate
-(void)insertAddressSucceed{
    [self unShowWaitView];
    [self.wxNavigationController popViewControllerAnimated:YES completion:^{
    }];
}

-(void)insertAddressFailed:(NSNotification*)notification{
    [self unShowWaitView];
    NSString *message = notification.object;
    if(!message){
        message = @"添加收货信息失败,请重试";
    }
    [UtilTool showAlertView:message];
}

#pragma mark modify
-(void)modifyAddressSucceed{
    [self unShowWaitView];
    [self.wxNavigationController popViewControllerAnimated:YES completion:^{
    }];
}

-(void)modifyAddressFailed:(NSNotification*)notification{
    [self unShowWaitView];
    NSString *message = notification.object;
    if(!message){
        message = @"修改收货信息失败,请重试";
    }
    [UtilTool showAlertView:message];
}

#pragma mark touch
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    showPicker = NO;
    [self unShowPickerView];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    showPicker = NO;
    [self unShowPickerView];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeNotification];
}

#pragma mark defaultSizeCell
- (void)keyPadToneSetting:(WXUISwitch *)s{
    defultSite = s.on;
}

@end
