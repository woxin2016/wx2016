//
//  ClassifyHistoryCell.h
//  RKWXT
//
//  Created by SHB on 15/10/21.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "WXUITableViewCell.h"

#define AlertRecordName @"历史搜索"

@protocol ClassifyHistoryCellDelegate <NSObject>
- (void)classifyHistoryDeleAll;
@end

@interface ClassifyHistoryCell : WXUITableViewCell
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,strong) WXUIButton *_deleAllBtn;
@property (nonatomic,weak)id<ClassifyHistoryCellDelegate> delegate;
@end

