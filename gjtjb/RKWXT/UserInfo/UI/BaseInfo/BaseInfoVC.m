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

#import "NetworkManager.h"
#include <CFNetwork/CFNetwork.h>
#import "UserHeaderModel.h"
#import "WXRemotionImgBtn.h"

#define FtpUrl @"ftp://wx3.67call.com"
#define UserName @"picuser"
#define UserPwd @"KoYYooop7728###"

enum {
    kSendBufferSize = 32768
};

#define Size self.bounds.size

@interface BaseInfoVC ()<UITableViewDataSource,UITableViewDelegate,PersonaSexSelectDelegate,PersonDatePickerDelegate,PersonNickNameDelegate,PersonalInfoModelDelegate,WXImageClipOBJDelegate,NSStreamDelegate>{
    UITableView *_tableView;
    PersonalInfoModel *_model;
    WXImageClipOBJ *_imageClipOBJ;
    
    UIImage *headerImg;
}
@property (nonatomic,assign) NSInteger bSex; //1男 2女
@property (nonatomic,strong) NSString *nickNameStr;
@property (nonatomic,strong) NSString *dateStr;

@property (nonatomic, assign, readonly ) BOOL              isSending;
@property (nonatomic, strong, readwrite) NSOutputStream *  networkStream;
@property (nonatomic, strong, readwrite) NSInputStream *   fileStream;
@property (nonatomic, assign, readonly ) uint8_t *         buffer;
@property (nonatomic, assign, readwrite) size_t            bufferOffset;
@property (nonatomic, assign, readwrite) size_t            bufferLimit;
@end

@implementation BaseInfoVC
{
    uint8_t                     _buffer[kSendBufferSize];
}

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
    
//    NSString *iconPath = [NSString stringWithFormat:@"%@",[[UserHeaderImgModel shareUserHeaderImgModel] userIconPath]];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    if([fileManager fileExistsAtPath:iconPath]){
//        headerImg = [UIImage imageWithContentsOfFile:iconPath];
//    }
}

-(WXUIView*)tableForFootView{
    WXUIView *footView = [[WXUIView alloc] init];
    
    CGFloat yOffset = 40;
    CGFloat btnHeight = 40;
    WXUIButton *submitBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(30, yOffset, IPHONE_SCREEN_WIDTH-2*30, btnHeight);
    [submitBtn setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [submitBtn setBorderRadian:6.0 width:0.1 color:WXColorWithInteger(0xdd2726)];
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
        case T_Base_ManagerInfo:
            number = Manager_Invalid;
            break;
        default:
            break;
    }
    return number;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0.0;
    if(section == T_Base_ManagerInfo){
        height = 15.0;
    }
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
        case BaseInfo_Nickname:
            str = _nickNameStr;
            break;
        case BaseInfo_Usersex:
            str = (_bSex==1?@"男":(_bSex==2?@"女":(_bSex==3?@"保密":@"未知")));
            break;
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

-(WXUITableViewCell*)tableViewForManagerCellAtRow:(NSInteger)row{
    static NSString *identifier = @"managerCell";
    WXUITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[WXUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setDefaultAccessoryView:E_CellDefaultAccessoryViewType_HasNext];
    NSString *nameStr = @"收货地址管理";
    if(row == 1){
        nameStr = @"修改密码";
    }
    [cell.textLabel setText:nameStr];
    [cell.textLabel setFont:WXFont(14.0)];
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
            }else{
                cell = [self tableViewForCommonCellAtRow:row];
            }
//            cell = [self tableViewForCommonCellAtRow:row];
            break;
        case T_Base_ManagerInfo:
            cell = [self tableViewForManagerCellAtRow:row];
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
                PersonNicknameVC *nickNameVC = [[PersonNicknameVC alloc] init];
                [nickNameVC setDelegate:self];
                [self.wxNavigationController pushViewController:nickNameVC];
            }
                break;
            case BaseInfo_Usersex:
            {
                PersonSexVC *sexVC= [[PersonSexVC alloc] init];
                sexVC.sexSelectedIndex = _bSex;
                [sexVC setDelegate:self];
                [self.wxNavigationController pushViewController:sexVC];
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
    if(section == T_Base_ManagerInfo){
        switch (row) {
            case ManagerAddress:
            {
                ManagerAddressVC *addressVC = [[ManagerAddressVC alloc] init];
                [self.wxNavigationController pushViewController:addressVC];
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
    [_model setType:PersonalInfo_Type_Updata];
    [_model updataUserInfoWith:self.bSex withNickName:self.nickNameStr withBirthday:self.dateStr];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

-(void)updataPersonalInfoSucceed{
    [self unShowWaitView];
    [UtilTool showAlertView:@"上传成功"];
    
    WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
    if(self.nickNameStr){
        [userDefault setNickname:self.nickNameStr];
    }
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

#pragma mark 日期选择
-(void)didSelectDate:(NSString *)dateStr{
    self.dateStr = dateStr;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:BaseInfo_Userdate inSection:T_Base_UserInfo];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)didSetPersonNickname:(NSString *)nickName{
    self.nickNameStr = nickName;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:BaseInfo_Nickname inSection:T_Base_UserInfo];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

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
    [self sendDocumentToFTPService];
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

#pragma mark 上传头像
- (uint8_t *)buffer{
    return self->_buffer;
}

- (BOOL)isSending{
    return (self.networkStream != nil);
}

- (void)startSend:(NSString *)filePath{
    BOOL                    success;
    NSURL *                 url;
    url = [[NetworkManager sharedInstance] smartURLForString:FtpUrl];
    success = (url != nil);
    if (success) {
        url = CFBridgingRelease(
                                CFURLCreateCopyAppendingPathComponent(NULL, (__bridge CFURLRef) url, (__bridge CFStringRef) [filePath lastPathComponent], false)
                                );
        success = (url != nil);
    }
    
    if (!success){
    } else {
        self.fileStream = [NSInputStream inputStreamWithFileAtPath:filePath];
        assert(self.fileStream != nil);
        [self.fileStream open];
        self.networkStream = CFBridgingRelease(
                                               CFWriteStreamCreateWithFTPURL(NULL, (__bridge CFURLRef) url)
                                               );
        success = [self.networkStream setProperty:UserName forKey:(id)kCFStreamPropertyFTPUserName];
        success = [self.networkStream setProperty:UserPwd forKey:(id)kCFStreamPropertyFTPPassword];
        self.networkStream.delegate = self;
        [self.networkStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [self.networkStream open];
    }
}

- (void)stopSendWithStatus:(NSString *)statusString{
    if (self.networkStream != nil) {
        [self.networkStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        self.networkStream.delegate = nil;
        [self.networkStream close];
        self.networkStream = nil;
    }
    if (self.fileStream != nil) {
        [self.fileStream close];
        self.fileStream = nil;
    }
    WXTUserOBJ *userObj = [WXTUserOBJ sharedUserOBJ];
    [[UserHeaderModel shareUserHeaderModel] updateUserHeaderSucceed:[NSString stringWithFormat:@"%@userIcon.png",userObj.wxtID]];
    [UtilTool showAlertView:@"上传头像成功"];
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
    assert(aStream == self.networkStream);
    switch (eventCode) {
        case NSStreamEventOpenCompleted: {
            NSLog(@"Opened connection");
        } break;
        case NSStreamEventHasBytesAvailable: {
        } break;
        case NSStreamEventHasSpaceAvailable: {
            NSLog(@"Sending");
            
            if (self.bufferOffset == self.bufferLimit) {
                NSInteger   bytesRead;
                bytesRead = [self.fileStream read:self.buffer maxLength:kSendBufferSize];
                
                if (bytesRead == -1) {
                    [UtilTool showAlertView:@"上传头像失败"];
                } else if (bytesRead == 0) {
                    [self stopSendWithStatus:nil];
                } else {
                    self.bufferOffset = 0;
                    self.bufferLimit  = bytesRead;
                }
            }
            
            if (self.bufferOffset != self.bufferLimit) {
                NSInteger   bytesWritten;
                bytesWritten = [self.networkStream write:&self.buffer[self.bufferOffset] maxLength:self.bufferLimit - self.bufferOffset];
                assert(bytesWritten != 0);
                if (bytesWritten == -1) {
                    [UtilTool showAlertView:@"上传头像失败"];
                } else {
                    self.bufferOffset += bytesWritten;
                }
            }
        } break;
        case NSStreamEventErrorOccurred: {
            [UtilTool showAlertView:@"上传头像失败"];
        } break;
        case NSStreamEventEndEncountered: {
            // ignore
        } break;
        default: {
            assert(NO);
        } break;
    }
}

#pragma mark * Actions
-(void)sendDocumentToFTPService{
    if (!self.isSending ) {
        NSString * filePath;
        filePath = [NSString stringWithFormat:@"%@",[[UserHeaderImgModel shareUserHeaderImgModel] userIconPath]];
        [self startSend:filePath];
    }
}

@end
