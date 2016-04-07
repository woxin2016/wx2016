//
//  WeekCTListVC.m
//  RKWXT
//
//  Created by SHB on 16/4/6.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "WeekCTListVC.h"
#import "UserCloudTicketCell.h"
#import "UserCloudTicketModel.h"

@interface WeekCTListVC()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    NSArray *weekCTArr;
}

@end

@implementation WeekCTListVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addOBS];
    weekCTArr = [UserCloudTicketModel sharedUserCloudTicket].weekCTListArr;
    if(_tableView){
        [_tableView reloadData];
    }
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    CGSize size = self.bounds.size;
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 1, size.width, size.height);
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

-(void)addOBS{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(loadCloudTicketSucceed) name:K_Notification_Name_LoadUserCloudTicketSucceed object:nil];
    [notificationCenter addObserver:self selector:@selector(loadCloudTicketFailed:) name:K_Notification_Name_LoadUserCloudTicketFailed object:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [weekCTArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UserCloudTicketCellHeight;
}

-(WXUITableViewCell *)tableViewUserWeekCTCell:(NSInteger)row{
    static NSString *identifier = @"Cell";
    UserCloudTicketCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[UserCloudTicketCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setCellInfo:[weekCTArr objectAtIndex:row]];
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    cell = [self tableViewUserWeekCTCell:row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark userCTNotification
-(void)loadCloudTicketSucceed{
    [self unShowWaitView];
    weekCTArr = [UserCloudTicketModel sharedUserCloudTicket].weekCTListArr;
    [_tableView reloadData];
}

-(void)loadCloudTicketFailed:(NSNotification*)notification{
    [self unShowWaitView];
    NSString *message = notification.object;
    if(!message){
        message = @"获取数据失败";
    }
    [UtilTool showAlertView:message];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
