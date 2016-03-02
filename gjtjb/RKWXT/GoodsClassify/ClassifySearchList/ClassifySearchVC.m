//
//  ClassifySearchVC.m
//  RKWXT
//
//  Created by app on 16/2/29.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "ClassifySearchVC.h"
#import "CoverSearchView.h"
#import "CLassifySearchModel.h"
#import "ClassifySrarchListCell.h"
#import "ClassifyHistoryCell.h"
#import "WXGoodsInfoVC.h"
#import "SearchResultEntity.h"
#import "ClassIfyHistoryModel.h"

#define Size self.bounds.size

@interface ClassifySearchVC ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,CLassifySearchModelDelegate>
@property (nonatomic,strong)WXUITextField *textField;
@property (nonatomic,strong)UIButton *titleBtn;
@property (nonatomic,assign,getter=isSwitch)BOOL titSwitch;  // 0 : 商店     1 ：商品
@property (nonatomic,strong)NSArray *titleArr;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UILabel *searchLabel;
@property (nonatomic,strong)CoverSearchView *coverView;
@property (nonatomic,strong)CLassifySearchModel *searchModer;
@property (nonatomic,assign,getter=isSwitchSource)BOOL switchSource;//0:搜索历史  1:搜索数据
@end

@implementation ClassifySearchVC

- (NSArray*)titleArr{
    if (!_titleArr) {
        _titleArr = @[@"商品",@"商家"];
    }
    return _titleArr;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   [self setCSTNavigationViewHidden:YES animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationBar];
    self.switchSource = NO;
    
    CGFloat labelH = 44;
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 66 + labelH, Size.width, Size.height-66 - labelH)];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView = tableView;
   
    self.searchModer = [[CLassifySearchModel alloc]init];
    self.searchModer.delegate = self;
    self.searchModer.searchType = Search_Type_Goods;
    
    self.searchLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 66, Size.width, labelH)];
    self.searchLabel.text = [NSString stringWithFormat:@"搜索历史（%d条）",self.searchModer.historyArr.count];
    self.searchLabel.textColor = [UIColor grayColor];
    self.searchLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:self.searchLabel];
    
    UIView *didView = [[UIView alloc]initWithFrame:CGRectMake(5,labelH - 0.5, Size.width, 0.5)];
    didView.backgroundColor = [UIColor grayColor];
    didView.alpha = 0.7;
    [self.searchLabel addSubview:didView];
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
    WXUILabel *leftLine = [[WXUILabel alloc] init];
    leftLine.frame = CGRectMake(xOffset, yOffset+btnHeight/2-2, 0.5, 6);
    [leftLine setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:leftLine];
    
    CGFloat rightBtnWidth = 40;
    WXUILabel *downLine = [[WXUILabel alloc] init];
    downLine.frame = CGRectMake(xOffset, leftLine.frame.origin.y+leftLine.frame.size.height+1, Size.width-2*10-rightBtnWidth-xOffset, 0.5);
    [downLine setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:downLine];
    
    CGFloat dropListBtnWidth = 50;
    xOffset += 1;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"商品" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(xOffset, yOffset, dropListBtnWidth, btnHeight);
    [btn setImage:[UIImage imageNamed:@"ClassifySearchBtnImg.png"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn addTarget:self action:@selector(clickTitleBtn:) forControlEvents:UIControlEventTouchDown];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 45, 0, 0)];
    [self addSubview:btn];
     self.titleBtn = btn;
    
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
    [_textField setPlaceHolder:@"搜索" color:WXColorWithInteger(0xffffff)];
    [self addSubview:_textField];
    
    [self isBtnTitle:btn];
    
    WXUILabel *rightLine = [[WXUILabel alloc] init];
    rightLine.frame = CGRectMake(_textField.frame.origin.x+_textField.frame.size.width-0.5, yOffset+btnHeight/2-2, 0.5, 6);
    [rightLine setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:rightLine];
}

#pragma mark ----------  系统方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = 0;
    if (self.isSwitch) {  //商品
        count = [self tableViewSources];
    }else{  //商店
       count = [self tableViewSources];
    }
    return count;
}

- (WXUITableViewCell*)tableViewForSearchListCellAt:(NSInteger)row{
    ClassifySrarchListCell *cell = [ClassifySrarchListCell classIfySrarchListCellWithTabelview:self.tableView];
    cell.entity = self.searchModer.searchResultArr[row];
    return cell;
}
-(WXUITableViewCell *)tableViewForHistoryListCellAt:(NSInteger)row{
    ClassifyHistoryCell *cell = [ClassifyHistoryCell classIfyHistoryCellWithTabelview:self.tableView];
   cell.entity = self.searchModer.historyArr[row];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WXUITableViewCell *cell = nil;
    NSInteger row = indexPath.row;
    if (self.isSwitchSource) { //搜索数据
        cell = [self tableViewForSearchListCellAt:row];
    }else{
        cell = [self tableViewForHistoryListCellAt:row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger goodsID = 0;
    SearchResultEntity *entity = nil;
    if (self.switchSource) { //搜索数据
        entity = [self.searchModer.searchResultArr objectAtIndex:indexPath.row];
        goodsID = entity.goodsID;
    }else{
        entity = [self.searchModer.historyArr objectAtIndex:indexPath.row];
        goodsID = entity.goodsID;
    }
    
    [[ClassIfyHistoryModel classIfyhistoryModelClass] classifyHistoryModelWithSaveEntity:entity];
    
    //去详情页面
    WXGoodsInfoVC *goodsInfoVC = [[WXGoodsInfoVC alloc] init];
    [goodsInfoVC setGoodsId:goodsID];
    [self.wxNavigationController pushViewController:goodsInfoVC];
}

-(UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    SearchResultEntity *entity = [self.searchModer.historyArr objectAtIndex:row];
    [[ClassIfyHistoryModel classIfyhistoryModelClass] deleteClassifyRecordWith:entity.goodsID];
    [self.tableView reloadData];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self.searchModer classifySearchWith:self.textField.text];
}

#pragma mark  ------------  其他
- (void)clickTitleBtn:(UIButton*)btn{
  
    [self.textField becomeFirstResponder];
    
    CGFloat X = btn.frame.size.width + btn.frame.origin.x;
    CGFloat Y = btn.frame.size.height + btn.frame.origin.y;
    CGRect rect = CGRectMake(X,Y, 90, 60);
    self.coverView = [[CoverSearchView alloc]initWithFrame:self.view.bounds dropListFrame:rect];
    self.coverView.array =self.titleArr;
    [self.view addSubview:self.coverView];
    __block typeof(self) blockSelf = self;
    [self.coverView clickCellBlock:^(NSString *str) {
        [blockSelf.titleBtn setTitle:str forState:UIControlStateNormal];
        [blockSelf isBtnTitle:btn];
    }];
    
    
   
}

- (void)isBtnTitle:(UIButton*)btn{
    if ([btn.titleLabel.text isEqualToString:@"商品"]) {
        self.titSwitch = YES;
        self.searchModer.searchType = Search_Type_Goods;
    }else{
        self.titSwitch = NO;
        self.searchModer.searchType = Search_Type_Shop;
    }
}

- (NSInteger)tableViewSources{
    NSInteger count = 0;
    if (self.isSwitchSource) { // 正在搜索的数据
        count = [self.searchModer.searchResultArr  count];
    }else{ // 历史记录
        count = [self.searchModer.historyArr  count];
    }
    return count;
}


- (void)setLabelTextWithTextField:(NSString*)textField{
    NSString *str = nil;
    if ([textField isEqualToString:@""]) { // 没有输入字符
        str =[NSString stringWithFormat:@"搜索历史 共有(%d条)",self.searchModer.historyArr.count];
       self.switchSource = NO;
    }else{ //输入了
         str = [NSString stringWithFormat:@"搜索结果 共有(%d条)",self.searchModer.searchResultArr.count];
        self.switchSource = YES;
    }
    self.searchLabel.text = str;
}

- (void)textFieldDone:(UITextField*)textField{
    [self.searchModer classifySearchWith:self.textField.text];
    [self setLabelTextWithTextField:self.textField.text];
}

- (void)changeInputTextfield{
    [self.searchModer classifySearchWith:self.textField.text];
    [self setLabelTextWithTextField:self.textField.text];
}


#pragma mark ------ 其他的代理方法
- (void)classifySearchResultSucceed{
    [self setLabelTextWithTextField:self.textField.text];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)classifySearchResultClearSource{
    [self setLabelTextWithTextField:self.textField.text];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}



- (void)backToLastPage{
    [self.wxNavigationController popViewControllerAnimated:YES completion:^{
    }];
}


@end
