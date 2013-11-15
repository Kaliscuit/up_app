//
//  UPUserItem.m
//  up
//
//  Created by joy.long on 13-11-14.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPUserItem.h"

@implementation UPUserItem

+ (UPUserItem *)sharedInstance {
    static UPUserItem *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[UPUserItem alloc] init];
    });
    return _sharedInstance;
}

@end

