//
//  UPNetworkHelper.h
//  up
//
//  Created by joy.long on 13-11-9.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"

#define Tag_Email_Check 7777711
#define Tag_Login 7777712
#define Tag_Enroll 7777713
#define Tag_Nickname 7777714
#define Tag_Profile 7777715

@protocol UPNetworkHelperDelegate <NSObject>

- (void)requestSuccess:(NSDictionary *)responseObject withTag:(NSNumber *)tag;
- (void)requestFail:(NSError *)error withTag:(NSNumber *)tag;
@end
@interface UPNetworkHelper : NSObject {
    AFHTTPRequestOperationManager *_manager;
}

@property (nonatomic, retain) id<UPNetworkHelperDelegate> delegate;

+ (UPNetworkHelper *)sharedInstance;

- (void)postEmailCheckWithDictionary:(NSDictionary *)dict;
- (void)postLoginWithDictionary:(NSDictionary *)dict;
- (void)postEnrollWithDictionary:(NSDictionary *)dict;
- (void)postNicknameWithDictionary:(NSDictionary *)dict;
- (void)postProfileWithDictionary:(NSDictionary *)dict;
@end
