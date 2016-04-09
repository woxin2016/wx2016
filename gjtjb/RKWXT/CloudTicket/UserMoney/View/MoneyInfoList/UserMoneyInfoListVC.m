//
//  UserMoneyInfoListVC.m
//  RKWXT
//
//  Created by SHB on 16/4/9.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "UserMoneyInfoListVC.h"
#import "DLTabedSlideView.h"
#import "DLFixedTabbarView.h"

#import "WeekMoneyListVC.h"
#import "MonthMoneyListVC.h"
#import "AllMoneyListVC.h"

enum{
    UserMoneyInfoList_Week = 0,
    UserMoneyInfoList_Month,
    UserMoneyInfoList_All,
    
    UserMoneyInfoList_Invalid,
};

@interface UserMoneyInfoListVC()<DLTabedSlideViewDelegate>{
    DLTabedSlideView *tabedSlideView;
    NSInteger showNumber;
}

@end

@implementation UserMoneyInfoListVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"账目明细"];
    
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

-(NSInteger)numberOfTabsInDLTabedSlideView:(DLTabedSlideView *)sender{
    return showNumber;
}

-(UIViewController*)DLTabedSlideView:(DLTabedSlideView *)sender controllerAt:(NSInteger)index{
    switch (index) {
        case UserMoneyInfoList_Week:
        {
            WeekMoneyListVC *listAll = [[WeekMoneyListVC alloc] init];
            return listAll;
        }
            break;
        case UserMoneyInfoList_Month:
        {
            MonthMoneyListVC *listAll = [[MonthMoneyListVC alloc] init];
            return listAll;
        }
            break;
        case UserMoneyInfoList_All:
        {
            AllMoneyListVC *listAll = [[AllMoneyListVC alloc] init];
            return listAll;
        }
            break;
        default:
            break;
    }
    return nil;
}

@end
