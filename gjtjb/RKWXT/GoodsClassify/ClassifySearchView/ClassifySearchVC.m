//
//  ClassifySearchVC.m
//  RKWXT
//
//  Created by SHB on 15/10/20.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "ClassifySearchVC.h"
#import "WXDropListView.h"
#import "WXUITextField.h"
#import "ClassifySrarchListCell.h"
#import "ClassifyHistoryCell.h"

#import "ClassifyHistoryModel.h"
#import "ClassifyInsertData.h"
#import "ClassifySqlEntity.h"

#import "CLassifySearchModel.h"
#import "SearchResultEntity.h"

#import "WXGoodsInfoVC.h"
//#import "NewGoodsInfoVC.h"
#import "CLassifySearchListVC.h"
#import "DropdownMenu.h"
#import "DropdownView.h"




#define Size self.bounds.size
enum{
    CLassify_Search_Goods = 0,
    CLassify_Search_Store,
    
    CLassify_Search_Invalid,
};

@interface ClassifySearchVC()<UIAlertViewDelegate,WXDropListViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,CLassifySearchModelDelegate,ClassifyHistoryCellDelegate,CLassifySearchListVCDelelgae,DropdownViewDeleate>{
    WXUIButton *dropListBtn;
    WXDropListView *_dropListView;
    WXUITextField *_textField;
    DropdownMenu *_menu;
    
    UITableView *_tableView;
    BOOL showHistory;
    
    NSArray *searchListArr;
    NSArray *historyListArr;
    
    ClassifyHistoryModel *_historyModel;
    CLassifySearchModel *_searchModel;
}
@end

@implementation ClassifySearchVC
static NSString* g_dropItemList[CLassify_Search_Invalid] ={
    @"商品",
    @"店铺",
};

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCSTNavigationViewHidden:YES animated:NO];
    if(_historyModel){
        [self addOBS];
        [_historyModel loadClassifyHistoryList];
    }
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setBackgroundColor:[UIColor whiteColor]];
    [self createNavigationBar];
    showHistory = YES;
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 66, Size.width, Size.height-66);
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    _tableView.tableFooterView = [self tableViewFootView];
    [self addSubview:_tableView];
   
    
    [self addOBS];
    _historyModel = [[ClassifyHistoryModel alloc] init];
    [_historyModel loadClassifyHistoryNewList];
    
    _searchModel = [[CLassifySearchModel alloc] init];
    [_searchModel setDelegate:self];
}

-(void)addOBS{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(loadClassifyHistoryListSucceed) name:D_Notification_Name_ClassifyHistoryLoadSucceed object:nil];
    [defaultCenter addObserver:self selector:@selector(delClassifyHistoryOneRecordSucceed) name:D_Notification_Name_ClassifyHistoryDelOnRecordSucceed object:nil];
}

- (UIView*)tableViewFootView{
    CGFloat width = self.view.frame.size.width;
    UIView *tableFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 100)];
    tableFootView.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20,65, width - 40,35)];
    [btn setTitle:@"清除搜索记录" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#484848"] forState:UIControlStateNormal];
    [btn setContentMode:UIViewContentModeCenter];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setBorderRadian:1 width:1 color:[UIColor colorWithRed:194/255.0 green:193/255.0 blue:194/255.0 alpha:1.0]];
    [btn addTarget:self action:@selector(clearData) forControlEvents:UIControlEventTouchDown];
    [tableFootView addSubview:btn];
    
    return tableFootView;
}

-(void)createNavigationBar{
    WXUIImageView *imgView = [[WXUIImageView alloc] init];
    imgView.frame = CGRectMake(0, 0, Size.width, 66);
    [imgView setBackgroundColor:WXColorWithInteger(0xdd2726)];
    [self addSubview:imgView];
    
    CGFloat xOffset = 15;
    CGFloat yOffset = 40;
    UIImage *img = [UIImage imageNamed:@"T_BackWhite.png"];
    WXTUIButton *backBtn = [WXTUIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(xOffset, yOffset, img.size.width, img.size.height);
    [backBtn setImage:img forState:UIControlStateNormal];
    [backBtn setBackgroundColor:[UIColor clearColor]];
    [backBtn addTarget:self action:@selector(backToLastPage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    
    [self createDropListViewBtn:xOffset+img.size.width with:yOffset];
}


-(void)createDropListViewBtn:(CGFloat)xGap with:(CGFloat)yGap{
    CGFloat xOffset = xGap+20;
    CGFloat yOffset = yGap;
    CGFloat btnHeight = 20;
    
    CGFloat width = self.view.frame.size.width - 2 * xOffset;
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(xOffset, yGap - 5, width, 25)];
    backView.backgroundColor = [UIColor colorWithHexString:@"f74f35"];
    [backView setBorderRadian:5 width:0 color:[UIColor clearColor]];
    [self addSubview:backView];
    
    CGFloat rightBtnWidth = 40;
    CGFloat dropListBtnWidth = 50;
    xOffset += 1;
    dropListBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    dropListBtn.frame = CGRectMake(xOffset, yOffset, dropListBtnWidth, btnHeight);
    [dropListBtn setBackgroundColor:[UIColor clearColor]];
    [dropListBtn setTitleColor:WXColorWithInteger(0xffffff) forState:UIControlStateNormal];
    [dropListBtn.titleLabel setFont:WXFont(13.0)];
    [dropListBtn setTitle:@"商品" forState:UIControlStateNormal];
    [dropListBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 5, 15)];
    [dropListBtn setImage:[UIImage imageNamed:@"searchGoods.png"] forState:UIControlStateNormal];
    [dropListBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];
    [dropListBtn addTarget:self action:@selector(clickDownView) forControlEvents:UIControlEventTouchDown];
    [self addSubview:dropListBtn];
    
//    _dropListView = [self createDropListViewWith:dropListBtn];
//    [_dropListView unshow:NO];
//    [self.view addSubview:_dropListView];

    
    xOffset += dropListBtnWidth+8;
    _textField = [[WXUITextField alloc] initWithFrame:CGRectMake(xOffset, yOffset-3, Size.width-xOffset-rightBtnWidth-2*10, btnHeight)];
    [_textField setDelegate:self];
    [_textField setReturnKeyType:UIReturnKeySearch];
    [_textField addTarget:self action:@selector(textFieldDone:)  forControlEvents:UIControlEventEditingDidEndOnExit];
    [_textField addTarget:self action:@selector(changeInputTextfield) forControlEvents:UIControlEventEditingChanged];
    [_textField setFont:WXFont(13.0)];
    [_textField becomeFirstResponder];
    [_textField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_textField setTextColor:[UIColor whiteColor]];
    [_textField setTintColor:[UIColor whiteColor]];
    [self addSubview:_textField];
    
    
    WXUIButton *searchBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
    CGFloat btnX = _textField.frame.origin.x+_textField.frame.size.width-0.5 + 6;
    searchBtn.frame = CGRectMake(btnX + 10, yOffset, dropListBtnWidth, btnHeight);
    [searchBtn setBackgroundColor:[UIColor clearColor]];
    [searchBtn setTitleColor:WXColorWithInteger(0xffffff) forState:UIControlStateNormal];
    [searchBtn.titleLabel setFont:WXFont(13.0)];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 5, 10)];
    [searchBtn addTarget:self action:@selector(clickSearchBtn) forControlEvents:UIControlEventTouchDown];
    [self addSubview:searchBtn];
}

//下拉菜单
- (WXDropListView*)createDropListViewWith:(WXUIButton*)btn{
    NSInteger row = CLassify_Search_Invalid;
    CGFloat width = 100;
    CGFloat height = 40;
    CGRect rect = CGRectMake(90, 60, width, row*height);
    WXDropListView *dropListView = [[WXDropListView alloc] initWithFrame:CGRectMake(0, 0, Size.width, Size.height+100) menuButton:btn dropListFrame:rect];
    [dropListView setDelegate:self];
    [dropListView setFont:[UIFont systemFontOfSize:15.0]];
    [dropListView setDropDirection:E_DropDirection_Right];
    
    NSMutableArray *itemArray = [NSMutableArray array];
    for (int i = 0; i < CLassify_Search_Invalid; i++) {
        WXDropListItem *item = [[WXDropListItem alloc] init];
        [item setTitle:g_dropItemList[i]];
        [itemArray addObject:item];
    }
    [dropListView setDataList:itemArray];
    return dropListView;
}

- (void)clickDownView{
    _menu = [self createDropListView:dropListBtn];
//    [self.view addSubview:_menu];
}

//新的下拉菜单
- (DropdownMenu*)createDropListView:(WXUIButton*)btn{
    DropdownMenu *down = [[DropdownMenu alloc]init];
    [down show:btn];
    
    NSMutableArray *itemArray = [NSMutableArray array];
    for (int i = 0; i < CLassify_Search_Invalid; i++) {
        [itemArray addObject:g_dropItemList[i]];
    }
    NSArray *iconArr = @[@"searchGoodsIcon.png",@"searchShopIcon.png"];
    DropdownView *downView = [[DropdownView alloc]initWithFrame:CGRectMake(0, 0, 100, 70) sourceData:itemArray imgArray:iconArr];
    downView.delegate = self;
    down.content = downView;
    
    return down;
}


#pragma mark tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(showHistory){
        return [historyListArr count];
    }else{
        return [searchListArr count];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

//search
-(WXUITableViewCell *)tableViewForSearchListCellAt:(NSInteger)row{
    static NSString *identifier = @"searchListCell";
    ClassifySrarchListCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ClassifySrarchListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
        SearchResultEntity *entity = searchListArr[row];
        [cell setCellInfo:entity];
    
    [cell load];
    return cell;
}

//history
-(WXUITableViewCell *)tableViewForHistoryListCellAt:(NSInteger)row{
    static NSString *identifier = @"historyListCell";
    ClassifyHistoryCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    cell.delegate = self;
    if(!cell){
        cell = [[ClassifyHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
        NSString *str  = historyListArr[row];
        cell.textLabel.text = str;
        [cell._deleAllBtn setHidden:YES];
 
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    if(showHistory){
        cell = [self tableViewForHistoryListCellAt:row];
    }else{
        cell = [self tableViewForSearchListCellAt:row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    NSInteger goodsID = 0;
    NSString *name = nil;
    if(!showHistory){
        SearchResultEntity *entity = [searchListArr objectAtIndex:indexPath.row];
        goodsID = entity.goodsID;
        name = entity.goodsName;
        
        //去详情页面
        WXGoodsInfoVC *goodsInfoVC = [[WXGoodsInfoVC alloc] init];
        [goodsInfoVC setGoodsId:goodsID];
        [self.wxNavigationController pushViewController:goodsInfoVC];
        
        [_historyModel addSearchText:name];
    }else{
        NSString *str = historyListArr[indexPath.row];
        CLassifySearchListVC *searchListVC = [[CLassifySearchListVC alloc] init];
        searchListVC.delegate = self;
        [self.wxNavigationController pushViewController:searchListVC];
        [searchListVC searchText:str];
        
    }
    
    
}

#pragma mark delete

-(UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    WXUITableViewCell *cell = (WXUITableViewCell*)[_tableView cellForRowAtIndexPath:indexPath];
    [_historyModel deleteClassDataWithName:cell.textLabel.text];
    historyListArr = _historyModel.listNewArr;
    [_tableView reloadData];
}


#pragma mark dropListDelegate
-(void)menuClickAtIndex:(NSInteger)index{
    if(index == 0){
        [dropListBtn setTitle:@"商品" forState:UIControlStateNormal];
    }else{
        [dropListBtn setTitle:@"店铺" forState:UIControlStateNormal];
    }
}

-(void)changeInputTextfield{
    if(_textField.text.length == 0){
        showHistory = YES;
        historyListArr = _historyModel.listNewArr;
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }else{
        showHistory = NO;
        if ([dropListBtn.titleLabel.text isEqualToString:@"商品"]) {
            _searchModel.searchType = Search_Type_Goods;
        }else{
            _searchModel.searchType = Search_Type_Shop;  // 这里做了改动
        }
        [_searchModel classifySearchWith:_textField.text];
    }
}

-(void)classifySearchResultSucceed{
    searchListArr = _searchModel.searchResultArr;
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark --- drowdownView
- (void)dropdownViewSwitchTitle:(NSString *)title{
    [_menu disMiss];
    [dropListBtn setTitle:title forState:UIControlStateNormal];
}

#pragma mark sql
-(void)loadClassifyHistoryListSucceed{
    historyListArr = _historyModel.listNewArr;
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)delClassifyHistoryOneRecordSucceed{
}

//插入数据
-(void)textFieldDone:(id)sender{
    WXUITextField *textField = sender;
    [textField resignFirstResponder];
    
    if([searchListArr count] > 0){
        CLassifySearchListVC *searchListVC = [[CLassifySearchListVC alloc] init];
        searchListVC.searchList = searchListArr;
        [self.wxNavigationController pushViewController:searchListVC];
    }
    
}

- (void)clickSearchBtn{
    [self.view endEditing:YES];
    
    if (_textField.text.length != 0) {
        // 保存搜索记录
        [_historyModel addSearchText:_textField.text];
        
        CLassifySearchListVC *searchListVC = [[CLassifySearchListVC alloc] init];
        [self.wxNavigationController pushViewController:searchListVC];
        [searchListVC searchText:_textField.text];
    }
    
    
}



-(void)insertHistoryData:(NSString*)recordName andRecordID:(NSInteger)recordID{
    if(recordName.length == 0){
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for(ClassifySqlEntity *entity in historyListArr){
            if([entity.recordName isEqualToString:recordName]){
                [_historyModel deleteClassifyRecordWith:entity.recordName];
                break;
            }
        }
        ClassifyInsertData *insertData = [[ClassifyInsertData alloc] init];
        [insertData insertData:recordName withRecordID:[NSString stringWithFormat:@"%ld",(long)recordID] with:@""];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_historyModel loadClassifyHistoryList];
        });
    });
}

// 删除所有数据   <这里数据库删除表没做到>
- (void)classifyHistoryDeleAll{
    
    [self clearSearchHistoryList];
}

#pragma mark --- 清空数据源
- (void)clearData{
  [self clearSearchHistoryList];
}

#pragma mark clearHistory 暂时不用
-(void)clearSearchHistoryList{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除所有搜索记录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [_historyModel delerteAllText];
    }
    historyListArr = _historyModel.listNewArr;
    [_tableView reloadData];
}

-(void)backToLastPage{
    [self.wxNavigationController popViewControllerAnimated:YES completion:^{
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark --- CLassifySearchListVC
- (void)searchListVCWithGoodsName:(NSString *)goodsName{
    [_historyModel addSearchText:goodsName];
    historyListArr = _historyModel.listNewArr;
    [_tableView reloadData];
}

@end
