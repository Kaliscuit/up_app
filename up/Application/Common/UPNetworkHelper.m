//
//  UPNetworkHelper.m
//  up
//
//  Created by joy.long on 13-11-9.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPNetworkHelper.h"
#import "CommonURL.h"
@implementation UPNetworkHelper

+ (UPNetworkHelper *)sharedInstance {
    static UPNetworkHelper *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[UPNetworkHelper alloc] init];
    });
    return _sharedInstance;
}

- (id)init {
    self = [super init];
    if (self != nil) {
        _manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:Url_Server_base]];
    }
    return self;
}

- (void)_postURLWithTag:(NSString *)url tag:(int)tag Dictionary:(NSDictionary *)dict{
    NSLog(@"ppppddddd-->dict: %@", dict);
#ifndef TRUE
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        NSLog(@"Cookie ---- %@", cookie);
    }
    NSArray *cookieArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"http://api.dev.v2up.me/usre/check-email"]];
    NSDictionary *cookieDict = [NSHTTPCookie requestHeaderFieldsWithCookies:cookieArray];
    NSLog(@"pppppppppppppppp-->d : %@", cookieDict);
    
    
    NSString *valueStr = [NSString stringWithFormat:@"email=%@&password=%@",@"nihao@qqwer.com",@"1111111111"];
    NSData *postData = [valueStr dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//    [request setHTTPBody:postData];

    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://api.dev.v2up.me/user/check-email"]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPShouldHandleCookies:YES];
    [request setAllHTTPHeaderFields:cookieDict];
    [request setHTTPBody:postData];
    
    AFHTTPRequestOperation *operator = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operator setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([self.delegate respondsToSelector:@selector(requestSuccess:withTag:)]) {
            [self.delegate performSelector:@selector(requestSuccess:withTag:) withObject:(NSDictionary *)responseObject withObject:[NSNumber numberWithInteger:tag]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
    [operator start];
#else
    [_manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Class : %@", [responseObject class]);
        if (responseObject == nil) {
            NSLog(@"请求成功，但是返回值为空");
        }
        NSLog(@"返回值 responseObject: %@", responseObject);
        NSLog(@"tag---->%d", tag);
        
        
        NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *cookie in [cookieJar cookies]) {
            NSLog(@"Cookie ---- %@", cookie);
        }
        NSArray *dict = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"http://api.dev.v2up.me/usre/check-email"]];
        NSDictionary *d = [NSHTTPCookie requestHeaderFieldsWithCookies:dict];
        NSLog(@"pppppppppppppppp-->d : %@", d);
        
        if ([self.delegate respondsToSelector:@selector(requestSuccess:withTag:)]) {
            [self.delegate performSelector:@selector(requestSuccess:withTag:) withObject:(NSDictionary *)responseObject withObject:[NSNumber numberWithInteger:tag]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(requestFail:withTag:)]) {
            [self.delegate performSelector:@selector(requestFail:withTag:) withObject:error withObject:[NSNumber numberWithInteger:tag]];
        }
    }];
#endif
}

- (void)postEmailCheckWithDictionary:(NSDictionary *)dict {
    [self _postURLWithTag:Url_Email_Check_Post tag:Tag_Email_Check Dictionary:dict];
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

- (void)postSearchSuggestWithDictionary:(NSDictionary *)dict {
    [self _postURLWithTag:Url_Search_Suggest_Post tag:Tag_Search_Suggest Dictionary:dict];
}

- (void)postSearchPositionWithDictionary:(NSDictionary *)dict {
    [self _postURLWithTag:Url_Search_Position_Post tag:Tag_Search_Position Dictionary:dict];
}

- (void)postSearchHot {
    [self _postURLWithTag:Url_Search_Hot_Post tag:Tag_Search_Hot Dictionary:nil];
}
@end
