//
//  BaseInfoVC.m
//  RKWXT
//
//  Created by SHB on 15/5/30.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "BaseInfoVC.h"
#import "BaseInfoDef.h"
#import "PersonalInfoModel.h"
#import "PersonalInfoEntity.h"
#import "WXImageClipOBJ.h"
#import "UserHeaderImgModel.h"
#import "WXService.h"

#import "UserHeaderModel.h"
#import "UpdataPicture.h"

#define Size self.bounds.size

@interface BaseInfoVC ()<UITableViewDataSource,UITableViewDelegate,PersonDatePickerDelegate,PersonalInfoModelDelegate,WXImageClipOBJDelegate,PersonalNickNameCellDelegate,PersonalSexCellDelegate>{
    UITableView *_tableView;
    PersonalInfoModel *_model;
    WXImageClipOBJ *_imageClipOBJ;
    
    UIImage *headerImg;
    UpdataPicture *updataPicture;
}
@property (nonatomic,assign) NSInteger bSex; //1男 2女
@property (nonatomic,strong) NSString *nickNameStr;
@property (nonatomic,strong) NSString *dateStr;
@end

@implementation BaseInfoVC

static NSString *_nameListArray[BaseInfo_Invalid]={
    @"头像",
    @"昵称",
    @"性别",
    @"出生日期"
};

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCSTTitle:@"个人资料"];
    [[UserHeaderModel shareUserHeaderModel] loadUserHeaderImageWith];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, Size.width, Size.height);
    [_tableView setBackgroundColor:WXColorWithInteger(0xf8f8f8)];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[self tableForFootView]];
    
    _model = [[PersonalInfoModel alloc] init];
    [_model setDelegate:self];
    [self loadPersonalInfo];
    
    _imageClipOBJ = [[WXImageClipOBJ alloc] init];
    [_imageClipOBJ setDelegate:self];
    [_imageClipOBJ setClipImageType:E_ImageType_Personal_Img];
    [_imageClipOBJ setParentVC:self];
    
    updataPicture = [[UpdataPicture alloc] init];
}

-(WXUIView*)tableForFootView{
    WXUIView *footView = [[WXUIView alloc] init];
    
    CGFloat yOffset = 40;
    CGFloat btnHeight = 40;
    WXUIButton *submitBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(30, yOffset, IPHONE_SCREEN_WIDTH-2*30, btnHeight);
    [submitBtn setBackgroundColor:WXColorWithInteger(AllBaseColor)];
    [submitBtn setBorderRadian:6.0 width:0.1 color:WXColorWithInteger(AllBaseColor)];
    [submitBtn setTitle:@"保存信息" forState:UIControlStateNormal];
    [submitBtn setTitle:@"保存信息" forState:UIControlStateSelected];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:submitBtn];
    
    yOffset += btnHeight;
    CGRect rect = CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, yOffset);
    [footView setFrame:rect];
    return footView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return T_Base_Invalid;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger number = 0;
    switch (section) {
        case T_Base_UserInfo:
            number = BaseInfo_Invalid;
            break;
        default:
            break;
    }
    return number;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0.0;
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = BaseInfoForCommonCellHeight;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(section == T_Base_UserInfo && row == BaseInfo_Userhead){
        height = BaseInfoForUserHeadHeight;
    }
    return height;
}

//头像
-(BaseInfoHeadCell*)tableViewForBaseInfoHeadImgCell:(NSInteger)row{
    static NSString *identifier = @"headCell";
    BaseInfoHeadCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[BaseInfoHeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_HasNext];
    [cell.textLabel setText:_nameListArray[row]];
    [cell.textLabel setFont:WXFont(15.0)];
    [cell setImg:headerImg];
    [cell setCellInfo:[UserHeaderModel shareUserHeaderModel].userHeaderImg];
    [cell load];
    return cell;
}

//昵称
-(PersonalNickNameCell*)tableViewForNickNameCell{
    static NSString *identifier = @"nickNameCell";
    PersonalNickNameCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[PersonalNickNameCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setDelegate:self];
    [cell setCellInfo:self.nickNameStr];
    [cell load];
    return cell;
}

//性别
-(PersonalSexCell*)tableViewForSexCell{
    static NSString *identifier = @"sexCell";
    PersonalSexCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[PersonalSexCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setDelegate:self];
    [cell setCellInfo:[NSString stringWithFormat:@"%ld",(long)self.bSex]];
    [cell load];
    return cell;
}

//通用
-(BaseInfoCommonCell *)tableViewForCommonCellAtRow:(NSInteger)row{
    static NSString *identifier = @"commonCell";
    BaseInfoCommonCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[BaseInfoCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_HasNext];
    [cell.textLabel setText:_nameListArray[row]];
    [cell.textLabel setFont:WXFont(15.0)];
    NSString *str = [NSString stringWithFormat:@"%ld",(long)row];
    switch (row) {
        case BaseInfo_Userdate:
            str = _dateStr;
            break;
        default:
            break;
    }
    [cell setCellInfo:str];
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (section) {
        case T_Base_UserInfo:
            if(row == BaseInfo_Userhead){
                cell = [self tableViewForBaseInfoHeadImgCell:row];
            }
            if(row == BaseInfo_Nickname){
                cell = [self tableViewForNickNameCell];
            }
            if(row == BaseInfo_Usersex){
                cell = [self tableViewForSexCell];
            }
            if(row == BaseInfo_Userdate){
                cell = [self tableViewForCommonCellAtRow:row];
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
    NSInteger row = indexPath.row;
    if(section == T_Base_UserInfo){
        switch (row) {
            case BaseInfo_Userhead:
            {
                [self changeheadImg:nil];
            }
                break;
            case BaseInfo_Nickname:
            {
//                PersonNicknameVC *nickNameVC = [[PersonNicknameVC alloc] init];
////                [nickNameVC setDelegate:self];
//                [nickNameVC setTransferNickName:^(NSString *nickName) {
//                    self.nickNameStr = nickName;
//                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:BaseInfo_Nickname inSection:T_Base_UserInfo];
//                    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
//                }];
//                [self.wxNavigationController pushViewController:nickNameVC];
            }
                break;
            case BaseInfo_Usersex:
            {
//                PersonSexVC *sexVC= [[PersonSexVC alloc] init];
//                sexVC.sexSelectedIndex = _bSex;
//                [sexVC setDelegate:self];
//                [self.wxNavigationController pushViewController:sexVC];
            }
                break;
            case BaseInfo_Userdate:
            {
                PersonDatePickerVC *datePickerVC = [[PersonDatePickerVC alloc] init];
                [datePickerVC setDelegate:self];
                [datePickerVC setDateString:_dateStr];
                [self.wxNavigationController pushViewController:datePickerVC];
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark update
-(void)submit{
    if(!self.dateStr){
        self.dateStr = @"";
    }
    if(!self.nickNameStr){
        self.nickNameStr = @"";
    }
    if(!self.dateStr){
        self.dateStr = 0;
    }
    if(self.nickNameStr.length > 15){
        [UtilTool showAlertView:@"昵称不能超过15个字符"];
        return;
    }
    NSString *birthday = 0;
    if(self.dateStr.length > 0){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        NSDate *date = [dateFormatter dateFromString:self.dateStr];
        birthday = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    }
    [_model setType:PersonalInfo_Type_Updata];
    [_model updataUserInfoWith:self.bSex withNickName:self.nickNameStr withBirthday:birthday];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

-(void)updataPersonalInfoSucceed{
    [self unShowWaitView];
    [UtilTool showAlertView:@"上传成功"];
}

-(void)updataPersonalInfoFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    if(!errorMsg){
        errorMsg = @"上传信息失败";
    }
    [UtilTool showAlertView:errorMsg];
}

#pragma mark load
-(void)loadPersonalInfo{
    [_model setType:PersonalInfo_Type_Load];
    [_model loadUserInfo];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

-(void)loadPersonalInfoSucceed{
    [self unShowWaitView];
    if([_model.personalInfoArr count] > 0){
        PersonalInfoEntity *entity = [_model.personalInfoArr objectAtIndex:0];
        self.bSex = entity.bsex;
        self.dateStr = entity.birthday;
        self.nickNameStr = entity.userNickName;
        
        WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
        if(self.nickNameStr){
            [userDefault setNickname:self.nickNameStr];
        }
    }
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:T_Base_UserInfo] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)loadPersonalInfoFainled:(NSString *)errorMsg{
    [self unShowWaitView];
    if(!errorMsg){
        errorMsg = @"获取信息失败";
    }
    [UtilTool showAlertView:errorMsg];
}

#pragma mark 选择性别
-(void)didSelectAtIndex:(NSInteger)index{
    self.bSex = index;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:BaseInfo_Usersex inSection:T_Base_UserInfo];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)personalSexButtonClicked:(NSInteger)index{
    self.bSex = index;
}

#pragma mark 日期选择
-(void)didSelectDate:(NSString *)dateStr{
    self.dateStr = dateStr;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:BaseInfo_Userdate inSection:T_Base_UserInfo];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark 昵称
-(void)personalNickNameTextFieldChanged:(PersonalNickNameCell *)cell{
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    if(indexPath){
        NSInteger row = indexPath.row;
        if(row == BaseInfo_Nickname){
            self.nickNameStr = cell.textField.text;
        }
    }
}

//-(void)didSetPersonNickname:(NSString *)nickName{
//    self.nickNameStr = nickName;
//    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:BaseInfo_Nickname inSection:T_Base_UserInfo];
//    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
//}

#pragma mark 头像
-(void)changeheadImg:(id)sender{
    [_imageClipOBJ beginChooseAndClipeImage];
}

-(void)imageClipeFinished:(WXImageClipOBJ *)clipOBJ finalImageData:(NSData *)imageData{
    if(![[UserHeaderImgModel shareUserHeaderImgModel] uploadUserHeaderImgWith:[self dataWithImage:[UIImage imageWithData:imageData]]]){
        return;
    }
    headerImg = [UIImage imageWithData:imageData];
    [[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_Name_UploadUserIcon object:nil];
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:BaseInfo_Userhead inSection:T_Base_UserInfo];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexpath] withRowAnimation:UITableViewRowAnimationFade];
    [updataPicture sendDocumentToFTPService];
}

-(NSData *)dataWithImage:(UIImage *)image{
    NSData *data = nil;
    if (UIImagePNGRepresentation(image) == nil) {
        data = UIImageJPEGRepresentation(image, 1);
    }else{
        data = UIImagePNGRepresentation(image);
    }
    return data;
}

- (void)imageClipeFailed:(WXImageClipOBJ*)clipOBJ{
    [UtilTool showAlertView:nil message:@"图片裁剪失败" delegate:nil tag:0 cancelButtonTitle:@"确定" otherButtonTitles:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
