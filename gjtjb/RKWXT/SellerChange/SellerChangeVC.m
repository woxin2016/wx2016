//
//  SellerChangeVC.m
//  RKWXT
//
//  Created by SHB on 16/3/29.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "SellerChangeVC.h"
#import "SellerChangeInfoCell.h"
#import "MJRefresh.h"
#import "SellerChangeModel.h"
#import "SellerListEntity.h"
#import "NewWXTLiDB.h"
#import "APService.h"

#define Size self.bounds.size
#define kSearchBarHeight (40)
#define EveryLoadNumber  (10)

@interface SellerChangeVC()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,SellerChangeInfoCellDelegate,SellerChangeModelDelegate>{
    UITableView *_tableView;
    WXUISearchBar *_searchBar;
    UISearchDisplayController *_searchDisplayController;
    
    NSMutableArray *sellerArr;
    NSInteger _sellerID;
    BOOL isSearching;
    
    SellerChangeModel *_sellerModel;
}

@end

@implementation SellerChangeVC

-(id)init{
    self = [super init];
    if(self){
        _sellerModel = [[SellerChangeModel alloc] init];
        [_sellerModel setDelegate:self];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setCSTTitle:@"商家选择"];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, kSearchBarHeight, Size.width, Size.height-kSearchBarHeight);
    [_tableView setBackgroundColor:WXColorWithInteger(0xffffff)];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self addSubview:_tableView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    _searchBar = [[WXUISearchBar alloc] initWithFrame:CGRectMake(0, 0, Size.width, kSearchBarHeight)];
    [_searchBar setPlaceholder:@"搜索商家"];
    [_searchBar sizeToFit];
    _searchBar.delegate = self;
    [self addSubview:_searchBar];
    
    _searchDisplayController = [[UISearchDisplayController alloc]
                                initWithSearchBar:_searchBar contentsController:self];
    [_searchDisplayController setSearchResultsDelegate:self];
    [_searchDisplayController setSearchResultsDataSource:self];
    [_searchDisplayController setDelegate:self];
    [_searchDisplayController.searchResultsTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [self createRightTopBtn];
    [self setupRefresh];
    
    [_sellerModel loadSellerListArr:0 length:EveryLoadNumber withText:@""];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

-(void)createRightTopBtn{
    WXUIButton *rightBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 6, 40, 40);
    [rightBtn setBackgroundColor:[UIColor clearColor]];
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [rightBtn setTitleColor:WXColorWithInteger(0xffffff) forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:WXFont(15.0)];
    [rightBtn addTarget:self action:@selector(storeUserSelectSeller) forControlEvents:UIControlEventTouchUpInside];
    [self setRightNavigationItem:rightBtn];
}

//集成刷新控件
-(void)setupRefresh{
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    
    _tableView.footerPullToRefreshText = @"上拉加载";
    _tableView.footerReleaseToRefreshText = @"松开加载";
    _tableView.footerRefreshingText = @"加载中";
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

#pragma mark tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [sellerArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SellerChangeInfoCellHeight;
}

-(WXUITableViewCell*)tableViewForSellerInfoCellAtRow:(NSInteger)row tableView:(UITableView*)tableView{
    static NSString *identifier = @"sellerInfoCell";
    SellerChangeInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[SellerChangeInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if([sellerArr count] > 0){
        [cell setCellInfo:[sellerArr objectAtIndex:row]];
    }
    [cell setSellerID:_sellerID];
    [cell setDelegate:self];
    [cell load];
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    cell = [self tableViewForSellerInfoCellAtRow:row tableView:tableView];
    return cell;
}

#pragma mark sellerChangeBtn
-(void)sellerChangeBtnClicked:(NSInteger)sellerID{
    _sellerID = sellerID;
    if(!isSearching){
        [_tableView reloadData];
    }else{
        [_searchDisplayController.searchResultsTableView reloadData];
    }
}

#pragma mark UISearchDisplayDelegate
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
    return YES;
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{
    UIView *topView = controller.searchBar.subviews[0];
    for (UIView *subView in topView.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            UIButton *cancelButton = (UIButton*)subView;
            [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
    isSearching = NO;
    [_sellerModel loadSellerListArr:0 length:EveryLoadNumber withText:@""];
    [self showWaitViewMode:E_WaiteView_Mode_BaseViewBlock title:@""];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    isSearching = YES;
    [_sellerModel loadSellerListArr:0 length:10 withText:searchString];
    return YES;
}

#pragma mark refresh
-(void)footerRefreshing{
    [_sellerModel loadSellerListArr:[sellerArr count] length:EveryLoadNumber withText:@""];
}

#pragma sellerListDelegate
-(void)loadSellerListArrSucceed{
    [self unShowWaitView];
    [_tableView footerEndRefreshing];
    [sellerArr removeAllObjects];
    
    sellerArr = [NSMutableArray arrayWithArray:_sellerModel.sellerArr];
    if(!isSearching){
        [_tableView reloadData];
    }else{
        [_searchDisplayController.searchResultsTableView setContentOffset:CGPointMake(0, 0) animated:YES];
        [_searchDisplayController.searchResultsTableView reloadData];
    }
}

-(void)loadSellerListArrFailed:(NSString *)errorMsg{
    [self unShowWaitView];
    [_tableView footerEndRefreshing];
    
    NSString *msg = errorMsg;
    if(!errorMsg){
        msg = @"获取数据失败";
    }
    [UtilTool showTipView:msg];
}

#pragma mark storeUserSeller
-(void)storeUserSelectSeller{
    if(_sellerID == 0){
        [UtilTool showTipView:@"请先选择要切换的商家"];
        return;
    }
    SellerListEntity *entity = nil;
    for(SellerListEntity *ent in sellerArr){
        if(ent.sellerID == _sellerID){
            entity = ent;
        }
    }
    
    //切换商家后保存最新数据
    WXTUserOBJ *userDefault = [WXTUserOBJ sharedUserOBJ];
    [userDefault setSellerID:[NSString stringWithFormat:@"%ld",(long)entity.sellerID]]; //用户所属商家id
    [userDefault setSellerName:entity.sellerName]; //用户所属商家
    [userDefault setShopID:[NSString stringWithFormat:@"%ld",(long)entity.shopID]]; //用户所在店铺id
    [userDefault setShopName:entity.shopName]; //用户所在店铺
    
    //切换商家后重新获取数据
    [[NewWXTLiDB sharedWXLibDB] loadData];
    NSSet *set1 = [NSSet setWithObjects:[NSString stringWithFormat:@"%@",userDefault.user], [NSString stringWithFormat:@"seller_%@",userDefault.sellerID], nil];
    [APService setTags:set1 alias:nil callbackSelector:nil object:nil];
    
    //切换商家通知后台
    [_sellerModel setUserChangeSeller];
    
    //返回上一页面发出通知更新数据
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_Name_UserChangeSeller object:nil];
    [self.wxNavigationController popViewControllerAnimated:YES completion:^{
    }];
}

@end
