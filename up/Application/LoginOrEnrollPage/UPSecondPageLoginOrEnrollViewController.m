//
//  UPSecondPageLoginOrEnrollViewController.m
//  up
//
//  Created by joy.long on 13-11-8.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPSecondPageLoginOrEnrollViewController.h"
#import "CommonDefine.h"
#import "UPNetworkHelper.h"
#import "UPUserItem.h"

@interface UPSecondPageLoginOrEnrollViewController ()<UPNetworkHelperDelegate>

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

    if (self.isEnrollProcess) {
        [self.textFieldName setPlaceholder:@"用户名"];
        self.textFieldName.secureTextEntry = NO;
        [self.textFieldPassword setPlaceholder:@"密码"];
        self.textFieldPassword.secureTextEntry = YES;
        self.title = @"注册";
        [self.nextStepButton setTitle:@"创建账户" forState:UIControlStateNormal];
    
        NSString *string = [NSString stringWithFormat:@"用%@创建新的账户",self.emailStr];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        NSRange range=[string rangeOfString:self.emailStr];
        [attributedString addAttribute:NSForegroundColorAttributeName value:BaseColor range:range];
        [self.messageLabel setAttributedText:attributedString];
        [attributedString release];
    } else {
        [self.textFieldName setPlaceholder:@"密码"];
        self.textFieldName.secureTextEntry = YES;
        
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
	
    [UPNetworkHelper sharedInstance].delegate = self;
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
    if (self.isEnrollProcess) {
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:self.emailStr,@"email",self.textFieldName.text,@"name",self.textFieldPassword,@"password", nil];
        [[UPNetworkHelper sharedInstance] postEnrollWithDictionary:dict];
        [dict release];
    } else {

        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:self.emailStr,@"email",self.textFieldName.text,@"password", nil];
        [[UPNetworkHelper sharedInstance] postLoginWithDictionary:dict];
        [dict release];
    }
}

- (BOOL)isValidPassword {
    if (!self.isEnrollProcess && self.textFieldName.text.length >= 8) {
        return YES;
    } else if(self.isEnrollProcess && self.textFieldPassword.text.length >= 8) {
        return YES;
    }
    return NO;
}

- (void)requestSuccess:(NSDictionary *)responseObject withTag:(NSNumber *)tag{
    NSDictionary *userProfile = [[responseObject objectForKey:@"d"] objectForKey:@"profile"];
    
    UPUserItem *user = [UPUserItem sharedInstance];
    user.name = [userProfile objectForKey:@"name"];
    user.userid = [userProfile objectForKey:@"id"];
    user.email = [userProfile objectForKey:@"email"];
    user.avatarUrl = [userProfile objectForKey:@"avatar"];
    user.gender = [userProfile objectForKey:@"gender"];
    user.birthday = [userProfile objectForKey:@"birthday"];
    user.createDate = [userProfile objectForKey:@"create_at"];
    user.updateDate = [userProfile objectForKey:@"update_at"];
    
    if ([tag integerValue]== Tag_Login) { // 登录成功
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[userProfile objectForKey:@"name"],@"Nickname", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Nickname" object:nil userInfo:dict];
        [dict release];
    
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else if ([tag integerValue]== Tag_Enroll){ // 注册成功
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Nickname" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.textFieldName.text,@"Nickname", nil]];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        NSLog(@"登陆注册第二阶段出错");
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:user.userid forKey:@"UserID"];
    [[NSUserDefaults standardUserDefaults] setValue:user.name forKey:@"UserName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)requestFail:(NSError *)error withTag:(NSNumber *)tag{
    if ([tag integerValue]== Tag_Login) { // 登录失败
        
    } else if([tag integerValue] == Tag_Enroll){ // 注册失败
        
    }
}

- (void)requestSuccessWithFailMessage:(NSString *)message withTag:(NSNumber *)tag {
    
}

@end
