//
//  DBCommon.h
//  RKWXT
//
//  Created by RoderickKennedy on 15/3/25.
//  Copyright (c) 2015年 roderick. All rights reserved.
//

#ifndef RKWXT_DBCommon_h
#define RKWXT_DBCommon_h

#define kWXTDBVersion_Table                 @"db_version"
#define kWXTDBVersionTable                  @"CREATE TABLE IF NOT EXISTS db_version(version INT UNSIGNED Not NULL,datetime INT UNSIGNED Not NULL,PRIMARY KEY (version))"
#define kWXTInsertDBVersion                 @"INSERT INTO db_version(version,datetime) values('%@','%@')"
#define kWXTSelectDBVersion                 @"select version from db_version"

#define kWXTSelectTable                     @"select * from sqlite_master WHERE name = '%@'"

#define kWXTUserSetting_Table               @"user_setting"
#define kWXTUserSettingTable                @"CREATE TABLE IF NOT EXISTS user_setting(LoginID  Varchar(50) Not NULL,LoginPwd varchar(30) Not NULL,Name     varchar(30) NULL,VName     varchar(30) NULL,Phone    varchar(30) Not NULL,sex      TINYINT UNSIGNED DEFAULT 2,birthday Datetime    NULL,qq       BIGINT DEFAULT 0,character_signature varchar(255)  NULL,street   varchar(255) NULL,area     varchar(255) NULL,last_seller_id INT UNSIGNED DEFAULT 0,last_area_id   INT UNSIGNED DEFAULT 0,last_shop_id   INT UNSIGNED DEFAULT 0,synchronous_update_flag  TINYINT UNSIGNED DEFAULT 0,DoMain1      VARCHAR(64) DEFAULT  NULL,DoMain2      VARCHAR(64) DEFAULT  NULL,DoMain3      VARCHAR(64) DEFAULT  NULL,DoMain4      VARCHAR(64) DEFAULT  NULL,DoMain5      VARCHAR(64) DEFAULT  NULL,DoMain6      VARCHAR(64) DEFAULT  NULL,icon_path VARCHAR(256) NULL)"

/////////////////////////////////////////通讯录表/////////////////////////////////////
#define kWXTBook_Table                      @"book"
#define kWXTBookTable                       @"CREATE TABLE IF NOT EXISTS book(RID INT UNSIGNED NOT Null,wo_xin_id BIGINT DEFAULT 0,phone_record_id Varchar(50) NOT NULL DEFAULT 0,create_time INT UNSIGNED DEFAULT 0,modify_time INT UNSIGNED DEFAULT 0,name     Varchar(50) NULL,phone_name  Varchar(50) NULL,sex TINYINT UNSIGNED DEFAULT 0,age      TINYINT UNSIGNED DEFAULT 0,type     TINYINT UNSIGNED DEFAULT 0,synchronous_remark_name_flag  TINYINT UNSIGNED DEFAULT 0,synchronous_friend_flag       TINYINT UNSIGNED DEFAULT 0,birthday Datetime    NULL,blood_type TINYINT UNSIGNED DEFAULT 0,company  Varchar(255) NULL,department Varchar(255) NULL,position Varchar(255) NULL,vocation TINYINT UNSIGNED DEFAULT 0,country  varchar(255) NULL,province varchar(255) NULL,city     Varchar(255) NULL,counties Varchar(255) NULL,township Varchar(255) NULL,village  Varchar(255) NULL,postalcode varchar(10) NULL,street   varchar(255) NULL,id_card   varchar(40)  NULL,education TINYINT UNSIGNED DEFAULT 0,blog     varchar(255) NULL,character_signature varchar(255)  NULL,interest_hobby varchar(255) NULL,remark_name  varchar(24) NULL,remark  TEXT NULL,mobile  VARCHAR(20) NULL,phone   VARCHAR(20) NULL,icon_path VARCHAR(256) NULL,PRIMARY KEY (RID))"
#define kWXTBookTable1                      @"CREATE TABLE IF NOT EXISTS book(cid integer PRIMARY KEY,phone_name Varchar(50) NULL,phone )"
#define kWXTInsertBook                      @"INSERT INTO book(phone_name,phone) values('%@','%@') "

/////////////////////////////////////////通讯录关系表/////////////////////////////////////
#define kWXTBookGroup_Table                 @"book_group"
#define kWXTBookGroupTable                  @"CREATE TABLE IF NOT EXISTS book_group(GroupID  INT UNSIGNED DEFAULT 0,ParentID INT UNSIGNED DEFAULT 0,GroupName Varchar(50) Not Null,PRIMARY KEY (GroupID))"

#define kWXTBookGroupMember                 @"CREATE TABLE book_group_member(RID      INT UNSIGNED Not Null,GroupID INT UNSIGNED Not Null,PRIMARY KEY (RID,GroupID))"

/////////////////////////////////////////通话记录表字,段/////////////////////////////////////
#define kWXTCall_Table                      @"CallRecord"
#define kWXTCall_Column_CID                 @"cid"
#define kWXTCall_Column_Name                @"name"
#define kWXTCall_Column_Telephone           @"telephone"
#define kWXTCall_Column_Date                @"start_time"
#define kWXTCall_Column_Duration            @"duration"
#define kWXTCall_Column_Type                @"type"
#define kWXTCall_Column_Count               @"count"
#define kWXTCallTable                       @"CREATE TABLE IF NOT EXISTS CallRecord (cid INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT,telephone TEXT, start_time text,duration INTEGER,type INTEGER,count INTEGER)"
#define kWXTInsertCallHistory               @"INSERT INTO CallRecord(name,telephone,start_time,duration,type) values('%@','%@','%@','%li','%i')"
#define kWXTQueryCallHistory                @"SELECT * FROM CallRecord ORDER BY start_time DESC"
#define kWXTDelCallHistory                  @"delete from CallRecord where cid=%li"

/////////////////////////////////////////号码归属地/////////////////////////////////////
#define kWXTPlacePath                       [NSString stringWithFormat:@"%@/place.sqlite",DOC_PATH]
#define kWXTPlaceTable                      @"place"
#define kWXTCreateTable                     @"CREATE TABLE IF NOT EXISTS %@ (%@)"
#define kWXTSelectArea                      @"SELECT * FROM %@ WHERE phone=%@ LIMIT 1"
#define kWXTInsertPlace                     @"INSERT INTO place (phone,area) VALUES (?,?)"
#define kWXTSelectCount                     @"SELECT count(*) FROM %@"
#endif
