//
//  ClassifyHistoryModel.m
//  RKWXT
//
//  Created by SHB on 15/10/21.
//  Copyright © 2015年 roderick. All rights reserved.
//

#import "ClassifyHistoryModel.h"
#import "ClassifySql.h"
#import "ClassifySqlEntity.h"

@interface ClassifyHistoryModel(){
    ClassifySql *fmdb;
    NSMutableArray *_listArr;
}
@end

@implementation ClassifyHistoryModel
@synthesize listArr = _listArr;

-(id)init{
    self = [super init];
    if(self){
        _listArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)loadClassifyHistoryList{
    fmdb = [[ClassifySql alloc] init];
    [fmdb createOrOpendb];
    [fmdb createTable];
    [_listArr removeAllObjects];
    NSArray *arr = [fmdb selectAll];
    for(int i = [arr count]-1; i >= 0; i--){
        ClassifySql *entity = [arr objectAtIndex:i];
        if(entity){
            [_listArr addObject:entity];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_Name_ClassifyHistoryLoadSucceed object:nil];
}

-(void)deleteClassifyRecordWith:(NSString *)recordName{
    if(!fmdb){
        fmdb = [[ClassifySql alloc] init];
    }
    [fmdb createOrOpendb];
    [fmdb createTable];
    
    BOOL succeed = [fmdb deleteClassifyHistoryList:recordName];
    if(succeed){
        for(ClassifySqlEntity *entity in _listArr){
            if(entity.recordName == recordName){
                [_listArr removeObject:entity];
                break;
            }
        }
    }
}

-(void)deleteAll{
    if(!fmdb){
        fmdb = [[ClassifySql alloc] init];
    }
    [fmdb createOrOpendb];
    [fmdb createTable];
    BOOL succeed = [fmdb deleteAll];
    if(succeed){
        [_listArr removeAllObjects];
    }
}

- (NSMutableArray*)listNewArr{
    if (!_listNewArr) {
        _listNewArr = [NSMutableArray array];
    }
    return _listNewArr;
}

static ClassifyHistoryModel * model = nil;
+ (instancetype)HistoryModel{
    if (!model) {
        model = [[ClassifyHistoryModel alloc]init];
    }
    return model;
}

- (void)loadClassifyHistoryNewList{
    self.listNewArr = [NSMutableArray arrayWithContentsOfFile:[self setPath]];
    [[NSNotificationCenter defaultCenter] postNotificationName:D_Notification_Name_ClassifyHistoryLoadSucceed object:nil];
}

- (void)addSearchText:(NSString *)text{
    
    NSArray *array  = [NSArray arrayWithContentsOfFile:[self setPath]];
    self.listNewArr = [NSMutableArray arrayWithArray:array];
    NSArray *stArray  =[NSArray arrayWithArray:self.listNewArr];
    for (NSString *str in stArray) {
        if ([str isEqualToString:text]) {
            [self.listNewArr removeObject:str];
        }
    }
    [self.listNewArr insertObject:text atIndex:0];
    
    [self.listNewArr writeToFile:[self setPath] atomically:YES];
}

// 删除单条数据
- (void)deleteClassDataWithName:(NSString*)name{
  NSArray *array  = [NSArray arrayWithContentsOfFile:[self setPath]];
    self.listNewArr = [NSMutableArray arrayWithArray:array];
    for (NSString *str in array) {
        if ([str isEqualToString:name]) {
            [self.listNewArr removeObject:str];
        }
    }
    
    [self.listNewArr writeToFile:[self setPath] atomically:YES];
}


- (NSString*)setPath{
    NSString *homePath = NSHomeDirectory();
    //拼接路径
    NSString *docPath = [homePath stringByAppendingPathComponent:@"Documents"];
    NSLog(@"%@",docPath);
    return [docPath stringByAppendingPathComponent:@"search.text"];
    
}

- (void)delerteAllText{
    [self.listNewArr removeAllObjects];
    [self.listNewArr writeToFile:[self setPath] atomically:YES];
}
@end
