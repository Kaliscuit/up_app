//
//  UPFirstPageLoginOrEnrollViewController.m
//  up
//
//  Created by joy.long on 13-11-8.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPFirstPageLoginOrEnrollViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "UPSecondPageLoginOrEnrollViewController.h"
#import "UPCommonHelper.h"
#import "UPNetworkHelper.h"

@interface UPFirstPageLoginOrEnrollViewController()<UPNetworkHelperDelegate>

@end

@implementation UPFirstPageLoginOrEnrollViewController

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
    self.navigationItem.hidesBackButton = YES;
    self.title  =@"输入邮箱";
    self.messageLabel.text = @"请输入邮箱地址，登陆或注册新用户";
    [self.textFieldName setPlaceholder:@"电子邮箱"];
    [self.nextStepButton setTitle:@"下一步" forState:UIControlStateNormal];
    
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
    if (self.textFieldName.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"邮箱不能为空" message:@"不能为空" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        [alert release];
        return;
    }
    BOOL isEmail = [UPCommonHelper isValidateEmail:self.textFieldName.text];
    if (!isEmail) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"邮箱格式错误" message:@"格式错误" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        [alert release];
        return;
    }
    [self.indicatorView setHidden:NO];
    [self.indicatorView startAnimating];
    
    self.textFieldName.clearButtonMode = UITextFieldViewModeNever;
    
    NSString *emailStr = self.textFieldName.text;
    
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:emailStr,@"email", nil];
    [UPNetworkHelper sharedInstance].delegate = self;
    [[UPNetworkHelper sharedInstance] postEmailCheckWithDictionary:dict];
    [dict release];
    
}

#pragma mark - AFNetworkHelperDelegate
- (void)requestFail:(NSDictionary *)responseObject withTag:(NSNumber *)tag{
    // 弹警告框
    self.textFieldName.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.indicatorView stopAnimating];
}

- (void)requestSuccess:(NSDictionary *)responseObject withTag:(NSNumber *)tag{
    if ([tag integerValue] != Tag_Email_Check) {
        return;
    }
    self.textFieldName.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.indicatorView stopAnimating];

    NSInteger responseCode = [[responseObject objectForKey:@"c"] integerValue];
    if (responseCode == 415) {
        // 格式不对
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"邮箱格式错误" message:@"格式错误" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        [alert release];
    } else {
        UPSecondPageLoginOrEnrollViewController *nextController = [[UPSecondPageLoginOrEnrollViewController alloc] init];
        nextController.emailStr = self.textFieldName.text;
        if (responseCode == 404) { // 未注册
            nextController.isEnrollProcess = YES;
        } else { // 已经注册
            nextController.isEnrollProcess = NO;
        }
        [self.navigationController pushViewController:nextController animated:YES];
        [nextController release];
    }

}

- (void)requestSuccessWithFailMessage:(NSString *)message withTag:(NSNumber *)tag {
    
}
@end
