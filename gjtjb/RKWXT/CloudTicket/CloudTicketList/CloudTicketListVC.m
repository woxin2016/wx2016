//
//  CloudTicketListVC.m
//  RKWXT
//
//  Created by SHB on 16/4/6.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "CloudTicketListVC.h"
#import "DLTabedSlideView.h"
#import "DLFixedTabbarView.h"

#import "WeekCTListVC.h"
#import "MonthCTListVC.h"
#import "AllCTListVC.h"

#import "RechargeCloudTicketVC.h"

enum{
    CloudTicketList_Week = 0,
    CloudTicketList_Month,
    CloudTicketList_All,
    
    CloudTicketList_Invalid,
};

@interface CloudTicketListVC()<DLTabedSlideViewDelegate>{
    DLTabedSlideView *tabedSlideView;
    NSInteger showNumber;
}

@end

@implementation CloudTicketListVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"我的云票"];
    [self.view addSubview:[self rightBtn]];
    
    tabedSlideView = [[DLTabedSlideView alloc] init];
    tabedSlideView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    [tabedSlideView setDelegate:self];
    
    [tabedSlideView setBaseViewController:self];
    [tabedSlideView setTabItemNormalColor:WXColorWithInteger(0x646464)];
    [tabedSlideView setTabItemSelectedColor:WXColorWithInteger(0xdd2726)];
    [tabedSlideView setTabbarTrackColor:[UIColor redColor]];
    [tabedSlideView setTabbarBottomSpacing:3.0];
    
    DLTabedbarItem *item1 = [DLTabedbarItem itemWithTitle:@"7天" image:nil selectedImage:nil];
    DLTabedbarItem *item2 = [DLTabedbarItem itemWithTitle:@"30天" image:nil selectedImage:nil];
    DLTabedbarItem *item3 = [DLTabedbarItem itemWithTitle:@"全部" image:nil selectedImage:nil];
    
    [tabedSlideView setTabbarItems:@[item1,item2,item3]];
    [tabedSlideView buildTabbar];
    
    showNumber = [tabedSlideView.tabbarItems count];
    
    tabedSlideView.selectedIndex = _selectedNum;
    [self addSubview:tabedSlideView];
}

-(WXUIButton*)rightBtn{
    CGFloat btnWidth = 60;
    CGFloat btnHeight = 16;
    WXUIButton *rightBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(self.bounds.size.width-btnWidth - 10, 40, btnWidth, btnHeight);
    [rightBtn setBackgroundColor:[UIColor clearColor]];
    [rightBtn setTitle:@"充值" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:WXFont(13.0)];
    [rightBtn addTarget:self action:@selector(gotoRechargeCTVC) forControlEvents:UIControlEventTouchUpInside];
    
    return rightBtn;
}

-(NSInteger)numberOfTabsInDLTabedSlideView:(DLTabedSlideView *)sender{
    return showNumber;
}

-(UIViewController*)DLTabedSlideView:(DLTabedSlideView *)sender controllerAt:(NSInteger)index{
    switch (index) {
        case CloudTicketList_Week:
        {
            WeekCTListVC *listAll = [[WeekCTListVC alloc] init];
            return listAll;
        }
            break;
        case CloudTicketList_Month:
        {
            MonthCTListVC *listAll = [[MonthCTListVC alloc] init];
            return listAll;
        }
            break;
        case CloudTicketList_All:
        {
            AllCTListVC *listAll = [[AllCTListVC alloc] init];
            return listAll;
        }
            break;
        default:
            break;
    }
    return nil;
}

-(void)gotoRechargeCTVC{
    RechargeCloudTicketVC *cloudTicketVC = [[RechargeCloudTicketVC alloc] init];
    [self.wxNavigationController pushViewController:cloudTicketVC];
}

@end
