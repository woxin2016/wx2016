//
//  Sql_JpushData.m
//  RKWXT
//
//  Created by SHB on 15/7/2.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#import "Sql_JpushData.h"
#import "T_Sqlite.h"

@implementation Sql_JpushData{
    T_Sqlite *fmdb;
}

-(BOOL)insertData:(NSString *)content withAbs:(NSString *)abstract withImg:(NSString *)mesImg withPushID:(NSString *)pushID{
    NSString *sql1 = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@' , '%@' , '%@' , '%@' , '%@' ,'%@') VALUES ('%@' , '%@' , '%@' , '%@' , '%@','notRed')",@"JPUSHMESSAGE",JPushContent,JPushAbs,JPushImg,JPushTime,JPushID,JPushToView,content,abstract,mesImg,[self jpushTime],pushID];
    fmdb = [[T_Sqlite alloc]init];
    [fmdb createOrOpendb];
    [fmdb createTable];
    BOOL succeed = [fmdb execSql:sql1];
    return succeed;
}

- (void)openData{
    fmdb = [[T_Sqlite alloc]init];
    [fmdb createOrOpendb];
    [fmdb createTable];
}

- (void)changeToView:(NSInteger)push_id{
    
    fmdb = [[T_Sqlite alloc]init];
    [fmdb createOrOpendb];
    [fmdb createTable];
    
    [fmdb changeToView:push_id];
}


-(NSString*)jpushTime{
    NSInteger time = [UtilTool timeChange];
    return [NSString stringWithFormat:@"%ld",(long)time];
}

@end
