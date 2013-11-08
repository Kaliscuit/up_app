//
//  UPSecondPageLoginOrEnrollViewController.m
//  up
//
//  Created by joy.long on 13-11-8.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPSecondPageLoginOrEnrollViewController.h"
#import "CommonDefine.h"
#import "AFHTTPRequestOperationManager.h"
#import "UPOptionalUsernameViewController.h"

@interface UPSecondPageLoginOrEnrollViewController ()

@end

@implementation UPSecondPageLoginOrEnrollViewController
@synthesize emailStr = _emailStr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.backBarButtonItem.title = @"返回";
    [self.textField setPlaceholder:@"密码"];
    self.textField.secureTextEntry = YES;
    if (_isEnroll) {
        self.title = @"注册";
        [self.nextStepButton setTitle:@"创建账户" forState:UIControlStateNormal];
        
        NSString *string = [NSString stringWithFormat:@"用%@创建新的账户",self.emailStr];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        NSRange range=[string rangeOfString:self.emailStr];
        [attributedString addAttribute:NSForegroundColorAttributeName value:BaseColor range:range];
        [self.messageLabel setAttributedText:attributedString];
        [attributedString release];
    } else {
        self.title = @"登录";
        [self.nextStepButton setTitle:@"登录" forState:UIControlStateNormal];
        
        NSString *string = [NSString stringWithFormat:@"你正在以%@登录",self.emailStr];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        NSRange range=[string rangeOfString:self.emailStr];
        [attributedString addAttribute:NSForegroundColorAttributeName value:BaseColor range:range];
        [self.messageLabel setAttributedText:attributedString];
        [attributedString release];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onClickNextStepButton:(id)sender {
    if (![self isValidPassword]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"密码位数小于8位" message:@"小于8位" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        [alert release];
        return;
    }
    if (_isEnroll) {
        [self enrollAccount];
    } else {
        [self loginAccount];
    }
}

- (BOOL)isValidPassword {
    if (self.textField.text.length >= 8) {
        return YES;
    }
    return NO;
}
- (void)loginAccount {
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:self.emailStr,@"email",self.textField.text,@"password", nil];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:Url_Server_base]];
    [manager POST:Url_Login_Post parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"登录成功");
        // 看有没有name
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [dict release];
}

- (void)enrollAccount {
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:self.emailStr,@"email",self.textField.text,@"password", nil];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:Url_Server_base]];
    [manager POST:Url_Enroll_Post parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"ppppp-->YES: %@", responseObject);

        NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSHTTPCookie *cookie = [[cookieJar cookies] lastObject];
        NSLog(@"cookie :%@", cookie);
        
        NSMutableDictionary* cookieDictionary = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"v2up"]];
        NSLog(@"ppppp-->dictiron : %@", cookieDictionary);
        if ([[cookieDictionary allValues] count] == 0) {
            [cookieDictionary setValue:cookie.properties forKey:@"v2up"];
            [[NSUserDefaults standardUserDefaults] setObject:cookieDictionary forKey:@"v2up"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }

        NSLog(@"ppppppp-->sessionCookies:%@", [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"v2up"]);
        [self createNickname];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // 失败未处理
    }];
    [dict release];
}

- (void)createNickname {
    UPOptionalUsernameViewController *nicknameController = [[UPOptionalUsernameViewController alloc] init];
    [self.navigationController pushViewController:nicknameController animated:YES];
    [nicknameController release];
}
@end
