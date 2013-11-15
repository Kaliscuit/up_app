//
//  UPUserItem.h
//  up
//
//  Created by joy.long on 13-11-14.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UPUserItem : NSObject

@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *avatarUrl;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *updateDate;

+ (UPUserItem *)sharedInstance;

@end
