//
//  CallHistoryModel.h
//  Woxin2.0
//
//  Created by le ting on 7/29/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CallHistoryEntity.h"
#import "WXTDatabase.h"

typedef enum{
    AddCallRecord = 1,
    DelSimpleCallRecord = 2,
    QueryCallRecord = 3,
}CallRecordHandle;

@interface CallRecord : NSObject<WXTDataBaseDelegate>
@property (nonatomic, copy) WXTDatabase * database;
@property (nonatomic, assign) CallRecordHandle callHandle;
@property (nonatomic,readonly)NSArray *callHistoryList;
@property (nonatomic, assign) NSInteger recordId;
@property (nonatomic, strong) NSString * wxtPath;
+ (CallRecord*)sharedCallRecord;
- (void)loadAllCallRecord;
//- (void)removeCallRecorder;

#pragma mark - 通话历史记录
- (BOOL)addRecord:(NSString*)phoneNumber recordType:(E_CallHistoryType)recordType
        startTime:(NSString*)startTime duration:(NSInteger)duration;
- (void)addSingleCallRecord:(CallHistoryEntity*)record;
-(void)addCallRecordCount:(CallHistoryEntity*)callHistory;
//删除通话记录
- (BOOL)deleteCallRecord:(NSInteger)recordUID;

- (NSArray*)recordForPhoneNumber:(NSString*)phoneNumber;
- (NSArray*)recordForPhoneNumbers:(NSArray*)phoneNumbers;
@end
