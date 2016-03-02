//
//  CoverSearchView.m
//  RKWXT
//
//  Created by app on 16/2/29.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "CoverSearchView.h"

@interface CoverSearchView ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,assign)CGRect originListRect;
@property (nonatomic,strong)UIView *clipeView;
@property (nonatomic,strong)WXUITableView *tableView;
@property (nonatomic,strong)UIButton *bjView;
@end

@implementation CoverSearchView

- (instancetype)initWithFrame:(CGRect)frame dropListFrame:(CGRect)dropListFrame{
    if (self = [super initWithFrame:frame]) {
        self.bjView = [[UIButton alloc]initWithFrame:frame];
        self.bjView.backgroundColor = [UIColor blackColor];
        self.bjView.alpha = 0.5;
        [self.bjView addTarget:self action:@selector(clickSelfTap) forControlEvents:UIControlStateNormal];
        [self addSubview:self.bjView];
        
        self.originListRect = dropListFrame;
        self.clipeView  = [[UIView alloc]initWithFrame:CGRectMake(dropListFrame.origin.x, dropListFrame.origin.y, 0, 0)];
        self.clipeView.clipsToBounds = YES;
        
        
        WXUITableView *tableView = [[WXUITableView alloc]initWithFrame:self.clipeView.frame style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.layer.cornerRadius = 5;
        tableView.backgroundColor = [UIColor whiteColor];
        self.tableView = tableView;
        [self addSubview:tableView];
        [self addSubview:self.clipeView];
        
    }
    return self;
}

- (void)clickCellBlock:(MYBlock)block{
    self.block = block;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
    }
    cell.textLabel.text = self.array[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self currentRowHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = self.array[indexPath.row];
    self.block (str);
    [self clickSelfTap];
}



- (CGFloat)currentRowHeight{
    NSInteger count = [self.array count];
    CGFloat height = 0.0;
    if (count > 0) {
        height = self.originListRect.size.height / count;
    }
    return height;
}


- (void)clickSelfTap{
    [self removeFromSuperview];
}

-(void)setArray:(NSArray *)array{
    _array = array;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.clipeView  = [[UIView alloc]initWithFrame:self.originListRect];
        self.tableView.frame = self.clipeView.frame;
        
    }];
}



@end
