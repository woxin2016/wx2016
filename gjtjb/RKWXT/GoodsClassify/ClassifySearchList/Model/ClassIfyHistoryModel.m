//
//  ClassIfyHistoryModel.m
//  RKWXT
//
//  Created by app on 16/2/29.
//  Copyright (c) 2016年 roderick. All rights reserved.
//

#import "ClassIfyHistoryModel.h"
#import "SearchResultEntity.h"

@interface ClassIfyHistoryModel ()
@property (nonatomic,strong)NSMutableArray *entityArr;
@end

@implementation ClassIfyHistoryModel

static ClassIfyHistoryModel *model ;
+ (instancetype)classIfyhistoryModelClass{
    if (model == nil) {
        model = [[ClassIfyHistoryModel alloc]init];
    }
    return model;
}


- (NSMutableArray*)entityArr{
    if (!_entityArr) {
        _entityArr = [NSMutableArray array];
    }
    return _entityArr;
}


- (void)classifyHistoryModelWithSaveEntity:(SearchResultEntity*)entity{
    self.entityArr = [NSMutableArray arrayWithContentsOfFile:[ClassIfyHistoryModel sourePathFile]];
    [self.entityArr addObject:entity];
    [self.entityArr writeToFile:[ClassIfyHistoryModel sourePathFile] atomically:YES];
}


+ (NSArray*)classifyHistoryModelWithReadEntityArray{
    return [ClassIfyHistoryModel classIfyhistoryModelClass].entityArr;
}

- (void)deleteClassifyRecordWith:(NSInteger)goodID{
    NSArray *entityArr = [NSArray arrayWithContentsOfFile:[ClassIfyHistoryModel sourePathFile]];
    for (SearchResultEntity *entity in entityArr) {
        if (entity.goodsID == goodID) {
            [self.entityArr removeObject:entity];
        }
    }
    [self.entityArr writeToFile:[ClassIfyHistoryModel sourePathFile] atomically:YES];
}




// 路径
+ (NSString*)sourePathFile{
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *docPath = [paths lastObject];
    NSString *file = [docPath stringByAppendingPathComponent:@"data.plist"];
    return file;
}

@end
