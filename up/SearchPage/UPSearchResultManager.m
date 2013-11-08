//
//  UPSearchResultManager.m
//  up
//
//  Created by joy.long on 13-10-31.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPSearchResultManager.h"
#import "AFNetworking.h"

@interface UPSearchResultManager() {
    FMDatabase *_db;
    AFHTTPRequestOperationManager *_manager;
    NSMutableArray *_positions;
}

@property (nonatomic, copy) NSString *keyword;
@property (nonatomic) NSInteger positionCount;
@end

@implementation UPSearchResultManager
@synthesize keyword = _keyword;
@synthesize positionCount = _positionCount;

+ (UPSearchResultManager *)sharedInstance {
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
        _db = [[FMDatabase alloc] initWithPath:defaultDBPath];
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

- (NSArray *)getSearchData:(NSString *)searchText {
    if (_manager == nil) {
        _manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:Url_Server_base]];
    }
    NSDictionary *parameters = @{Url_Parameter_Search_Suggest_Post : searchText};
    _positions = [[NSMutableArray alloc] init];
    
    [_manager POST:Url_Search_Suggest_Post parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _keyword = searchText;
        NSLog(@"JSON: %@", responseObject);
        _positionCount = [[[responseObject objectForKey:@"d"] objectForKey:@"count"] integerValue];
        
        [_positions addObjectsFromArray:[[responseObject objectForKey:@"d"] objectForKey:@"positions"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    return _positions;
}

- (void)dealloc {
    if ([_db open]) {
        [_db close];
    }
    [_db release];
    [_manager release];
    
    [super dealloc];
}
@end
