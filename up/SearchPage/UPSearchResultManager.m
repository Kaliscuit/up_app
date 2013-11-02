//
//  UPSearchResultManager.m
//  up
//
//  Created by joy.long on 13-10-31.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPSearchResultManager.h"

@interface UPSearchResultManager() {
    FMDatabase *_db;
}
@end

@implementation UPSearchResultManager

- (UPSearchResultManager *)sharedInstance {
    static UPSearchResultManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[UPSearchResultManager alloc] init];
    });
    return _sharedInstance;
}

- (FMDatabase *)defaultDB {
    if (_db == nil) {
        NSString *defaultDBPath = [self _getSandboxDocumentPath];
        _db = [FMDatabase databaseWithPath:defaultDBPath];
    }
    NSAssert(@"_db == nil", @"[UPSearchResultManager defalutDB] _db == nil");
    return _db;
}

- (NSString *)_getSandboxDocumentPath {
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    NSAssert(@"documentDir == nil", @"[UPSearchResultManger _getSandboxDocumentPath] document path for local db is nil");
    return documentDir;
}



@end
