//
//  XNBCartInfoCell.m
//  RKWXT
//
//  Created by app on 16/5/4.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "XNBCartInfoCell.h"
#import "XNBBalanceEntity.h"

#define ClickBtnH (60)

@interface XNBCartInfoCell ()
{
    UIView *_bottonView;
    NSArray *infoArr;
    
    NSMutableArray *_labelArray;
    NSMutableArray *_label1array;
    NSMutableArray *_btnArray;
}
@end

@implementation XNBCartInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _label1array = [NSMutableArray array];
        _labelArray = [NSMutableArray array];
        _btnArray = [NSMutableArray array];
    }
    return self;
}

-(void)setCellInfo:(id)cellInfo{
    
    [_btnArray removeAllObjects];
    [_label1array removeAllObjects];
    [_labelArray removeAllObjects];
    
    [_bottonView removeFromSuperview];
    _bottonView = [[UIView alloc]initWithFrame:self.bounds];
    _bottonView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_bottonView];
    infoArr = cellInfo;
    
    NSArray *array = cellInfo;
    if (array.count == 0) return;
    
    int row = 3;
    CGFloat margin = 8;
    CGFloat btnW = (self.width - margin * 4) / row;
    CGFloat btnH = ClickBtnH;
    for (int i = 0; i < array.count; i++) {
        XNBBalanceEntity *entity = array[i];
        
        CGFloat rowX = i % row;
        CGFloat colY = i / row;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(margin + (rowX * (btnW + margin)), margin + (colY * (8 + btnH)), btnW, btnH);
        btn.tag = i;
        [btn setBorderRadian:10 width:1.0 color:[UIColor colorWithHexString:@"f74f35"]];
        [btn addTarget:self action:@selector(clickCartBtn:) forControlEvents:UIControlEventTouchDown];
        
        CGFloat labelH = 20;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0,10, btnW, labelH)];
        label.font = [UIFont systemFontOfSize:16];
        label.text = [NSString stringWithFormat:@"%d",entity.monery];
        label.textColor = [UIColor colorWithHexString:@"f74f35"];
        label.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:label];
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, label.bottom , btnW,20)];
        label1.font = [UIFont systemFontOfSize:9];
        label1.text = [NSString stringWithFormat:@"售价:%d云票+￥%d",entity.xnb,entity.rmb];
        label1.textColor = [UIColor blackColor];
        label1.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:label1];
        
        [_bottonView addSubview:btn];
        [_labelArray addObject:label];
        [_label1array addObject:label1];
        [_btnArray addObject:btn];
        
        if (i == 0) {
            [self clickCartBtn:btn];
        }
    }
}

- (void)clickCartBtn:(UIButton*)btn{
    [self setLabelTitleColorWithTag:btn.tag];
    
    if (_delegate && [_delegate respondsToSelector:@selector(clickBtnCartInfoWithIndex:)]) {
        [_delegate clickBtnCartInfoWithIndex:btn.tag];
    }
}

- (void)setLabelTitleColorWithTag:(NSInteger)tag{
    for (UILabel *label in _labelArray) {
        label.textColor = [UIColor colorWithHexString:@"f74f35"];
    }
    UILabel *label = _labelArray[tag];
    label.textColor = [UIColor whiteColor];

    for (UILabel *label in _label1array) {
        label.textColor = [UIColor blackColor];
    }
    UILabel *label1 = _label1array[tag];
    label1.textColor = [UIColor whiteColor];
    
    for (UIButton *btn in _btnArray) {
        btn.backgroundColor = [UIColor whiteColor];
    }
    
    UIButton *btn = _btnArray[tag];
    btn.backgroundColor = [UIColor colorWithHexString:@"f74f35"];
}

+ (CGFloat)cellHeightOfInfo:(id)cellInfo{
    NSArray *arr = cellInfo;
    int col = (arr.count / 3) + 1;
    CGFloat Height = col * ClickBtnH;
    Height += 8 + 8;
    Height += (col -1) * 8;
    return Height;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
}


@end
