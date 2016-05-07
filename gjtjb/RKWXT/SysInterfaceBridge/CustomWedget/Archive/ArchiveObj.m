//
//  ArchiveObj.m
//  RKWXT
//
//  Created by SHB on 16/5/5.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "ArchiveObj.h"

#define kDataObjKey @"kDataObjKey"

@implementation ArchiveObj
@synthesize data = _data;

#pragma mark - NSCoding 
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_data forKey:kDataObjKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        _data = [aDecoder decodeObjectForKey:kDataObjKey];
    }
    return self;
}

#pragma mark - NSCoping
- (id)copyWithZone:(NSZone *)zone{
    ArchiveObj *copy = [[[self class] allocWithZone:zone] init];
    copy.data = [self.data copyWithZone:zone];
    return copy;
}

@end
