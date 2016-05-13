//  AddressBook.m
//  Woxin2.0
//
//  Created by le ting on 7/10/14.
//  Copyright (c) 2014 le ting. All rights reserved.
//

#import "AddressBook.h"
#import <AddressBook/AddressBook.h>
#import "ServiceMonitor.h"
#import "ServiceCommon.h"

@interface AddressBook()
{
    ABAddressBookRef _addressBookRef;
    NSMutableArray *_contactList;
    NSMutableDictionary *_contactNameDic;
    NSMutableArray *_chineceHeadArr;
    
    BOOL hasSaved;
    
    dispatch_queue_t _loadRecordImageQueue;
}
@end

@implementation AddressBook
@synthesize accessGranted = _accessGranted;
@synthesize contactList = _contactList;
@synthesize count = _count;
@synthesize contactNameDic = _contactNameDic;
@synthesize chineceHeadArr =_chineceHeadArr;

+ (AddressBook*)sharedAddressBook{
    static dispatch_once_t onceToken;
    static AddressBook *sharedAddressBook = nil;
    dispatch_once(&onceToken, ^{
        sharedAddressBook = [[AddressBook alloc] init];
    });
    return sharedAddressBook;
}

- (id)init{
    if(self = [super init]){
        _contactList = [[NSMutableArray alloc] init];
        _contactNameDic = [[NSMutableDictionary alloc] init];
        _chineceHeadArr = [[NSMutableArray alloc] init];
        _loadRecordImageQueue = dispatch_queue_create("loadRecordImageQueue", 0);
        [self registerAddressBookChanged];
		[self addOBS];
    }
    return self;
}

- (void)addOBS{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter addObserver:self selector:@selector(hasLogin:) name:D_Notification_Name_LoginSucceed object:nil];
}

- (void)hasLogin:(NSNotification*)notification{
	[self uploadSysContacters:_contactList];
}

- (void)removeOBS{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadContactInfo{
    [self loadContact];
}

- (ABAddressBookRef)addressBook
{
    //注意:这个函数可能会在多线程上调用,必须要做线程加锁
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(isIOS6 || isIOS7){
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0
            _addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
#endif
        }else{
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_6_0
            _addressBookRef = ABAddressBookCreate();
#endif
        }
    });
    return _addressBookRef;
}

- (void)registerAddressBookChanged{
    ABAddressBookRegisterExternalChangeCallback([self addressBook], MyAddressBookExternalChangeCallback, self);
}

void MyAddressBookExternalChangeCallback (ABAddressBookRef addressBook, CFDictionaryRef info, void *context){
    KFLog_Normal(YES, @"addressBookChanged");
    ABAddressBookRevert(addressBook);
    AddressBook *sharedAddressBook = (__bridge AddressBook*)context;
    [sharedAddressBook loadContactInfo];
}

- (void)unregisterAddressBookChanged{
    ABAddressBookUnregisterExternalChangeCallback([self addressBook], MyAddressBookExternalChangeCallback, self);
}

- (void)loadContact{
	//先删除所有的联系人~
    hasSaved = NO;
	[_contactList removeAllObjects];
    __block NSMutableArray *contactList = _contactList;
    __block AddressBook *selfAddressBook = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		@synchronized(selfAddressBook){
			NSMutableArray *tempArray = [NSMutableArray array];
            NSMutableArray *nameArr = [NSMutableArray array];
			NSArray *allPerson = [[NSArray alloc] initWithArray:[selfAddressBook getAllPeopleContact]];
			NSInteger count = [allPerson count];
			for(int i = 0; i < count; i++){
				ABRecordRef person = (__bridge ABRecordRef)[allPerson objectAtIndex:i];
				ContacterEntity *entity = [ContacterEntity contacterEntityWithABPerson:person];
				if(ABPersonHasImageData(person)){
					NSData *imgDate = (__bridge NSData*)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
					UIImage *icon = [UIImage imageWithData:imgDate scale:1/4];
					[entity setIcon:icon];
				}
				
				if(entity){
					[tempArray addObject:entity];
                    [nameArr addObject:entity.fullName];
				}
                
                if([entity.fullName isEqualToString:@"我信专线"]){
                    hasSaved = YES;
                }
			}
			[contactList removeAllObjects];
			[contactList addObjectsFromArray:tempArray];
            
			[[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:D_Notification_Name_AddressBookHasChanged object:nil userInfo:nil];
            
//            for(id chinese in contactList){
//                [self PYArarray:chinese];
//            }
		}
        dispatch_async(dispatch_get_main_queue(), ^{
            //添加我信专线号码
//            [self addPhonesToContact];
        });
    });
}

#pragma mark 将部分号码写入通讯录
-(void)addPhonesToContact{
    if(hasSaved){
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken,^{
            ABAddressBookRef iPhoneAddressBook = ABAddressBookCreate();
            ABRecordRef newPerson = ABPersonCreate();
            CFErrorRef error = NULL;
            ABRecordSetValue(newPerson, kABPersonLastNameProperty, @"我信专线", &error);
            
            ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
            ABMultiValueAddValueAndLabel(multiPhone, @"0755-61665888", kABPersonPhoneMobileLabel, NULL);
            ABMultiValueAddValueAndLabel(multiPhone, @"0755-12345678", kABPersonPhoneMobileLabel, NULL);
            ABMultiValueAddValueAndLabel(multiPhone, @"13538236522", kABPersonPhoneMobileLabel, NULL);
            ABMultiValueAddValueAndLabel(multiPhone, @"0755-5151518", kABPersonPhoneMobileLabel, NULL);
            ABRecordSetValue(newPerson, kABPersonPhoneProperty, multiPhone, &error);
            CFRelease(multiPhone);
            
            ABAddressBookAddRecord(iPhoneAddressBook, newPerson, &error);
            ABAddressBookSave(iPhoneAddressBook, &error);
        });
    });
}

//转换中文对应首字母，并保存键值对
-(void)PYArarray:(id)Chinese{
    ContacterEntity *entity = Chinese;
    NSMutableString *mutStr = [[NSMutableString alloc] init];
    for (int i = 0; i < [entity.fullName length]; i++){
        char cha = pinyinFirstLetter([entity.fullName characterAtIndex:i]);
        NSString *str = [NSString stringWithFormat:@"%c",cha];
        [mutStr appendString:str];
    }
    
    [_contactNameDic setObject:entity forKey:mutStr];   //此处有问题，如果键相同会被之后的覆盖，例如:乐天(lt)和立体(lt)
    if([_chineceHeadArr indexOfObject:mutStr] == NSNotFound){
        [_chineceHeadArr addObject:mutStr];
    }
    [mutStr release];
}

- (void)uploadSysContacters:(NSArray*)contacters{
    for(ContacterEntity *entity in contacters){
		if (!entity.bUpdated){
			if ([entity uploadSysContacter]){
				[entity setBUpdated:YES];
			}
		}
    }
}

- (void)uploadSysContacters{
    if([_contactList count] == 0){
        [self loadContact];
    }else{
        [self uploadSysContacters:_contactList];
    }
}

- (NSArray*)getAllPeopleContact{
    ABAddressBookRef addressBook = [self addressBook];
    if (&ABAddressBookRequestAccessWithCompletion != NULL) { // we're on iOS 6
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            _accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    else { // we're on iOS 5 or older
        _accessGranted = YES;
    }
    
    if(_accessGranted){
        CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
        CFMutableArrayRef peopleMutable = CFArrayCreateMutableCopy(kCFAllocatorDefault,CFArrayGetCount(people),people);
        _count = CFArrayGetCount(people);
        CFArraySortValues(peopleMutable,CFRangeMake(0, CFArrayGetCount(peopleMutable)),
                          (CFComparatorFunction) ABPersonComparePeopleByName,
                          (void*)ABPersonGetSortOrdering);
        
        NSMutableArray  *newArray = [[NSMutableArray alloc] initWithArray:(__bridge NSMutableArray*)peopleMutable];
        CFRelease(people);
        CFRelease(peopleMutable);
        return newArray;
    }else{
        DDLogDebug(@"没有权限访问通讯录");
        return nil;
    }
}

- (ContacterEntity*)contacterEntityForRecordID:(NSInteger)recordID{
    for(ContacterEntity *entity in _contactList){
        if(entity.recordID == recordID){
            return entity;
        }
    }
    return nil;
}

- (ContacterEntity*)contacterEntityForNumber:(NSString*)phone{
    for(ContacterEntity *entity in _contactList){
        NSArray *phoneNumbers = entity.phoneNumbers;
        for(NSString *phoneNumber in phoneNumbers){
            if([phoneNumber isEqualToString:phone]){
                return entity;
            }
        }
    }
    return nil;
}


@end
