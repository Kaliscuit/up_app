//
//  UPNetworkHelper.m
//  up
//
//  Created by joy.long on 13-11-9.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UPNetworkHelper.h"
#import "AFNetworkReachabilityManager.h"

@implementation UPNetworkHelper

- (id)init {
    self = [super init];
    if (self != nil) {
        _manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:Url_Server_base]];
    }
    return self;
}

+ (BOOL)isHaveNetwork {
    return [[AFNetworkReachabilityManager sharedManager] isReachable];
}

- (void)_postURLWithTag:(NSString *)url tag:(int)tag Dictionary:(NSDictionary *)parametersDict{
    
    NSMutableURLRequest *request = [_manager.requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:url relativeToURL: _manager.baseURL] absoluteString] parameters:parametersDict];
    
    NSDictionary *headers = [NSHTTPCookie requestHeaderFieldsWithCookies:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    NSLog(@"ddddd-->userAgent : %@", [request valueForHTTPHeaderField:@"User-Agent"]);
    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
    
    NSString *userAgent = [NSString stringWithFormat:@"%@/%@ (%@; %@; %@)",
                           [dict objectForKey:@"CFBundleDisplayName"],
                           [dict objectForKey:@"CFBundleVersion"],
                           [UIDevice currentDevice].model,
                           [UIDevice currentDevice].systemVersion,
                           [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0]
                           ];
    
    [request setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    [request setAllHTTPHeaderFields:headers];
    
    AFHTTPRequestOperation *operation = [_manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Class : %@", [responseObject class]);
        if (responseObject == nil) {
            NSLog(@"请求成功，但是返回值为空");
        }
        NSLog(@"返回值 responseObject: %@", responseObject);
        if ([self isRequestSuccessWithFailCode:responseObject]) {
            if ([self.delegate respondsToSelector:@selector(requestSuccessWithFailMessage:withTag:)]) {
                [self.delegate performSelector:@selector(requestSuccessWithFailMessage:withTag:) withObject:[responseObject objectForKey:@"m"] withObject:[NSNumber numberWithInteger:tag]];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(requestSuccess:withTag:)]) {
                [self.delegate performSelector:@selector(requestSuccess:withTag:) withObject:(NSDictionary *)responseObject withObject:[NSNumber numberWithInteger:tag]];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    [_manager.operationQueue addOperation:operation];
}

- (void)_postEmailCheckWithDictionary:(NSDictionary *)dict {
    [self _postURLWithTag:Url_Email_Check_Post tag:Tag_Email_Check Dictionary:dict];
}

- (void)postEmailCheckWithString:(NSString *)email {
    [self _postEmailCheckWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:email,@"email", nil]];
}
- (void)postLoginWithDictionary:(NSDictionary *)dict {
    [self _postURLWithTag:Url_Login_Post tag:Tag_Login Dictionary:dict];
}

- (void)postEnrollWithDictionary:(NSDictionary *)dict {
    [self _postURLWithTag:Url_Enroll_Post tag:Tag_Enroll Dictionary:dict];
}

- (void)postNicknameWithDictionary:(NSDictionary *)dict {
    [self _postURLWithTag:Url_Nickname_Post tag:Tag_Nickname Dictionary:dict];
}


- (void)postProfileWithDictionary:(NSDictionary *)dict { // 不传字典拿到的是自己的，传字典拿到的是别人的
    [self _postURLWithTag:Url_Profile_Post tag:Tag_Profile Dictionary:dict];

 
}

- (void)postSearchSuggestWithKeyword:(NSString *)keyword {
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:keyword,Parameter_Search_Post_Keyword, nil];
    [self _postSearchSuggestWithDictionary:dict];
}


- (void)postSearchPositionWithKeyword:(NSString *)keyword WithPage:(NSInteger)page{
    NSDictionary *dict = nil;
    if (keyword.length == 0) {
        if (page != 0) {
            dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInteger:page],@"page", nil];
        } else {
            return;
        }
    } else {
        if (page != 0) {
            dict = [[NSDictionary alloc] initWithObjectsAndKeys:keyword,Parameter_Search_Post_Keyword,[NSNumber numberWithInteger:page],@"page", nil];
        } else {
            dict = [[NSDictionary alloc] initWithObjectsAndKeys:keyword,Parameter_Search_Post_Keyword, nil];
        }
    }
    [self _postSearchPositionWithDictionary:dict];
}
- (void)postSearchHot {
    [self _postURLWithTag:Url_Search_Hot_Post tag:Tag_Search_Hot Dictionary:nil];
}

- (void)postPositionProfileWithDictionary:(NSDictionary *)dict {
    [self _postURLWithTag:Url_Position_Profile_Post tag:Tag_Position_Profile Dictionary:dict];
}
- (void)postPositionSelectWithID:(NSInteger)positionID {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:positionID],@"pid", nil];
    [self _postURLWithTag:Url_Position_Select_Post tag:Tag_Position_Select Dictionary:dict];
}

- (BOOL)isRequestSuccessWithFailCode:(id)responseObject {
    return NO;
//    if ([[responseObject objectForKey:@"c"] integerValue] == 200) {
//        return NO;
//    } else {
//        return YES;
//    }
}

- (void)postAPNSWithDictionar:(NSDictionary *)dict {
    [self _postURLWithTag:Url_Ios_Apns_Post tag:Tag_Ios_Apns Dictionary:dict];
}

#pragma mark - private method
- (void)_postSearchSuggestWithDictionary:(NSDictionary *)dict {
    [self _postURLWithTag:Url_Search_Suggest_Post tag:Tag_Search_Suggest Dictionary:dict];
}

- (void)_postSearchPositionWithDictionary:(NSDictionary *)dict {
    [self _postURLWithTag:Url_Search_Position_Post tag:Tag_Search_Position Dictionary:dict];
}
- (void)_postPositionSelectWithDictionary:(NSDictionary *)dict {
    [self _postURLWithTag:Url_Position_Select_Post tag:Tag_Position_Select Dictionary:dict];
}
@end
