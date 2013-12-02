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
#import "UPAlertTipLabel.h"

@interface UPSecondPageLoginOrEnrollViewController ()<UPNetworkHelperDelegate> {
    NSString *_alertMessageUserName;
    NSString *_alertMessagePassword;
    
    UPNetworkHelper *_networkHelper;
}

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
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icn_errorinfo.png"]];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAlertMessage:)];
    [image addGestureRecognizer:gesture];
    [image setUserInteractionEnabled:YES];
    self.textFieldName.rightView = image;
    
    if (self.isEnrollProcess) {
        [self.textFieldName setPlaceholder:@"用户名"];
        self.textFieldName.secureTextEntry = NO;
        [self.textFieldPassword setPlaceholder:@"密码"];
        
        self.textFieldPassword.secureTextEntry = YES;
        self.title = @"注册";
        [self.nextStepButton setTitle:@"创建账户" forState:UIControlStateNormal];
    
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icn_errorinfo.png"]];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAlertMessage:)];
        [image addGestureRecognizer:gesture];
        [image setUserInteractionEnabled:YES];
        self.textFieldPassword.rightView = image;
        
        NSString *string = [NSString stringWithFormat:@"用%@创建新的账户",self.emailStr];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        NSRange range=[string rangeOfString:self.emailStr];
        [attributedString addAttribute:NSForegroundColorAttributeName value:BaseGreenColor range:range];
        [self.messageLabel setAttributedText:attributedString];
    } else {
        [self.textFieldName setPlaceholder:@"密码"];
        self.textFieldName.secureTextEntry = YES;
        
        
        self.title = @"登录";
        [self.nextStepButton setTitle:@"登录" forState:UIControlStateNormal];
        
        NSString *string = [NSString stringWithFormat:@"你正在以%@登录",self.emailStr];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        NSRange range=[string rangeOfString:self.emailStr];
        [attributedString addAttribute:NSForegroundColorAttributeName value:BaseGreenColor range:range];
        [self.messageLabel setAttributedText:attributedString];
    }
}

- (void)showAlertMessage:(UITapGestureRecognizer *)gesture {
    NSInteger viewTag = gesture.view.superview.tag;
    CGFloat pointX = gesture.view.superview.frame.origin.x + gesture.view.superview.frame.size.width - 20;
    CGFloat pointY = gesture.view.superview.frame.origin.y + 15;
    if (viewTag == Tag_TextField_Name) { // self.textFieldName
        [self _showAlertMessage:CGPointMake(pointX, pointY) title:_alertMessageUserName isAssignBottom:YES];
    } else if (viewTag == Tag_TextField_Password) { // self.textFieldPassword
        if (self.isEnrollProcess) {
            pointY = gesture.view.superview.frame.origin.y + 45;
        }
        [self _showAlertMessage:CGPointMake(pointX, pointY) title:_alertMessagePassword isAssignBottom:NO];
    }
    
}

- (void)_showAlertMessage:(CGPoint)point title:(NSString *)title isAssignBottom:(BOOL)isAssignBottom {
    if (isAssignBottom) {
        _alertMessageUserName = [NSString stringWithFormat:@"%@%@%@", @"  ",title,@"  "];
//        _alertMessageUserName = title;
    } else {
        _alertMessagePassword = [NSString stringWithFormat:@"%@%@%@", @"  ",title,@"  "];
//        _alertMessagePassword =   title;
    }
    
    UPAlertTipLabel *alert = [[UPAlertTipLabel alloc] initWithFrame:CGRectMake(10, 30, 300, 100)];
    [alert updateTitle:title Point:point isAssignBottom:isAssignBottom];
    [self.view addSubview:alert];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    _networkHelper = [[UPNetworkHelper alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onClickNextStepButton:(id)sender {
    if (![self isValidUsername]) {
        self.textFieldName.layer.borderColor = [[UIColor redColor] CGColor];
        self.textFieldName.rightViewMode = UITextFieldViewModeAlways;
        [self _showAlertMessage:CGPointMake(300, 95) title:@"用户名不能为空" isAssignBottom:YES];
        [self.textFieldName becomeFirstResponder];
        return;
    }
    if (![self isValidPassword]) {
        if (self.isEnrollProcess) {
            self.textFieldPassword.layer.borderColor = [[UIColor redColor] CGColor];
            self.textFieldPassword.rightViewMode = UITextFieldViewModeAlways;
            [self _showAlertMessage:CGPointMake(300, 165) title:@"密码位数不能小于8位" isAssignBottom:NO];
        } else {
            self.textFieldName.rightViewMode = UITextFieldViewModeAlways;
            self.textFieldName.layer.borderColor = [[UIColor redColor] CGColor];
            [self _showAlertMessage:CGPointMake(300, 95) title:@"密码位数不能小于8位" isAssignBottom:YES];
        }
        [self.textFieldPassword becomeFirstResponder];
        
        return;
    }
    
    if (self.isEnrollProcess) {
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:self.emailStr,@"email",self.textFieldName.text,@"name",self.textFieldPassword,@"password", nil];
        [_networkHelper postEnrollWithDictionary:dict];
    } else {
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:self.emailStr,@"email",self.textFieldName.text,@"password", nil];
        [_networkHelper postLoginWithDictionary:dict];
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

- (BOOL)isValidUsername {
    if (self.isEnrollProcess) {
        if (self.textFieldName.text.length > 0) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return YES;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.textFieldName.rightViewMode == UITextFieldViewModeAlways) {
        self.textFieldName.layer.borderColor = [RGBCOLOR(200.0f, 199.0f, 204.0f) CGColor];
        self.textFieldName.rightViewMode = UITextFieldViewModeNever;
    }
    if (self.textFieldPassword.rightViewMode == UITextFieldViewModeAlways) {
        self.textFieldPassword.layer.borderColor = [RGBCOLOR(200.0f, 199.0f, 204.0f) CGColor];
        self.textFieldPassword.rightViewMode = UITextFieldViewModeNever;
    }
    return YES;
}

- (void)requestSuccess:(NSDictionary *)responseObject withTag:(NSNumber *)tag{
    if([[responseObject objectForKey:@"c"] integerValue] == 403) {
        self.textFieldName.layer.borderColor = [[UIColor redColor] CGColor];
        self.textFieldName.rightViewMode = UITextFieldViewModeAlways;
        [self _showAlertMessage:CGPointMake(300, 95) title:@"邮箱或密码错误" isAssignBottom:YES];
        return;
    }
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
    
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSLog(@"登陆或注册-->cookieJar : %@", [cookieJar cookies]);
    
    if ([tag integerValue]== Tag_Login) { // 登录成功
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[userProfile objectForKey:@"name"],@"Nickname", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateUsername object:nil userInfo:dict];
    } else if ([tag integerValue]== Tag_Enroll){ // 注册成功
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateUsername object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.textFieldName.text,@"Nickname", nil]];
    } else {
        NSLog(@"登陆注册第二阶段出错");
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:user.userid forKey:@"UserID"];
    [[NSUserDefaults standardUserDefaults] setValue:user.name forKey:@"UserName"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)requestFail:(NSError *)error withTag:(NSNumber *)tag{
    if ([tag integerValue]== Tag_Login) { // 登录失败
        
    } else if([tag integerValue] == Tag_Enroll){ // 注册失败
        
    }
}

- (void)requestSuccessWithFailMessage:(NSString *)message withTag:(NSNumber *)tag {
    NSLog(@"messge : %@", message);
}

@end
