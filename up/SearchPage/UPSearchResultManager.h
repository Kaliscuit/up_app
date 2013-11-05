//
//  UPSearchResultManager.h
//  up
//
//  Created by joy.long on 13-10-31.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface UPSearchResultManager : NSObject

- (FMDatabase *)defaultDB;

- (NSArray *)getSearchData:(NSString *)searchStr;

+ (UPSearchResultManager *)sharedInstance;
@end
