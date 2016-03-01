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
@end

@implementation ClassIfyHistoryModel

- (NSMutableArray*)entityArr{
    if (!_entityArr) {
        _entityArr = [NSMutableArray array];
    }
    return _entityArr;
}

 static ClassIfyHistoryModel *model ;
+ (instancetype)classIfyhistoryModelClass{
    if (model == nil) {
        model = [[ClassIfyHistoryModel alloc]init];
    }
    return model;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_entityArr forKey:@"_entityArr"];
}


- (void)classifyHistoryModelWithSaveEntity:(SearchResultEntity*)entity{
    [self.entityArr addObject:entity];
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        _entityArr = [aDecoder decodeObjectForKey:@"_entityArr"];
    }
    return self;
}

+ (NSArray*)classifyHistoryModelWithReadEntityArray{
    return [ClassIfyHistoryModel classIfyhistoryModelClass].entityArr;
}

- (void)deleteClassifyRecordWith:(NSInteger)goodID{
    NSArray *entityArr = [NSArray arrayWithArray:self.entityArr];
    for (SearchResultEntity *entity in entityArr) {
        if (entity.goodsID == goodID) {
            [self.entityArr removeObject:entity];
        }
    }
}

@end
