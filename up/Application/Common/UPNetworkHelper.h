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
#define Tag_Search_Suggest 7777716
#define Tag_Search_Position 7777717
#define Tag_Search_Hot 7777718
#define Tag_Position_Profile 7777719
#define Tag_Position_Select 7777720
@protocol UPNetworkHelperDelegate <NSObject>

- (void)requestSuccess:(NSDictionary *)responseObject withTag:(NSNumber *)tag;
- (void)requestFail:(NSError *)error withTag:(NSNumber *)tag;
- (void)requestSuccessWithFailMessage:(NSString *)message withTag:(NSNumber *)tag;
@end
@interface UPNetworkHelper : NSObject {
    AFHTTPRequestOperationManager *_manager;
}

@property (nonatomic, assign) id<UPNetworkHelperDelegate> delegate;

+ (BOOL)isHaveNetwork;

- (void)postLoginWithDictionary:(NSDictionary *)dict;
- (void)postEnrollWithDictionary:(NSDictionary *)dict;
- (void)postNicknameWithDictionary:(NSDictionary *)dict;
- (void)postProfileWithDictionary:(NSDictionary *)dict;


- (void)postSearchHot;
- (void)postPositionProfileWithDictionary:(NSDictionary *)dict;

- (void)postEmailCheckWithString:(NSString *)email;
- (void)postSearchPositionWithKeyword:(NSString *)keyword WithPage:(NSInteger)page;
- (void)postSearchSuggestWithKeyword:(NSString *)keyword;
- (void)postPositionSelectWithID:(NSInteger)positionID;
@end
