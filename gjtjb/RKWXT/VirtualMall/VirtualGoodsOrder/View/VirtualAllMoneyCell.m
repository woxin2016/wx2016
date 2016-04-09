//
//  VirtualAllMoneyCell.m
//  RKWXT
//
//  Created by app on 16/4/8.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "VirtualAllMoneyCell.h"

@implementation VirtualAllMoneyCell

+ (instancetype)VirtualAllMoneyCellWithTabelView:(UITableView*)tableView{
    NSString *identifier = @"VirtualAllMoneyCell";
    VirtualAllMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[VirtualAllMoneyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

@end
