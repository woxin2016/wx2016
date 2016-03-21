//
//  DropdownView.m
//  RKWXT
//
//  Created by app on 16/3/21.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "DropdownView.h"

@interface DropdownView ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *titleArray;
    NSArray *imageArr;
    CGRect rect;
}
@end

@implementation DropdownView
-(instancetype)initWithFrame:(CGRect)frame sourceData:(NSArray*)data imgArray:(NSArray*)imgArr{
    if (self = [super initWithFrame:frame]) {
        titleArray = data;
        imageArr = imgArr;
        
        rect = frame;
        _tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        [_tableView setBorderRadian:5 width:0 color:[UIColor clearColor]];
        [self addSubview:_tableView];
        
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])  {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
    }
    cell.imageView.image = [UIImage imageNamed:imageArr[indexPath.row]];
    cell.textLabel.text = titleArray[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor colorWithRed:29/255.0 green:29/255.0 blue:29/255.0 alpha:1.0];
    return cell;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self selectCellText:cell.textLabel.text];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}

- (void)selectCellText:(NSString*)text{
    if (_delegate && [_delegate respondsToSelector:@selector(dropdownViewSwitchTitle:)]) {
        [_delegate dropdownViewSwitchTitle:text];
    }
}



@end
