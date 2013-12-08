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
#import "UPAlertTipLabel.h"
#import "UPNavigationBar.h"

#define Title_NavigationBar @"输入邮箱"

#define Text_Please_Input_Email @"请输入邮箱地址，登陆或注册新用户"
#define Text_Email_PlaceHolder @"电子邮箱"
#define Text_Next_Step @"下一步"

#define Error_Email_Should_Not_Be_Empty @"邮箱不能为空"
#define Error_Email_Format_Is_Wrong @"邮箱格式不对"

#define Image_TextFiled_Error_Tip @"icn_errorinfo.png"

@interface UPFirstPageLoginOrEnrollViewController()<UPNetworkHelperDelegate> {
    UPAlertTipLabel *_alertLabel;
    
    UIImageView *_image;
    NSString *_alertMessage;
    
    UPNetworkHelper *_networkHelper;
}

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
    
    [UPNavigationBar NavigationBarConfigWithBackButton:self title:Title_NavigationBar isLightBackground:YES leftSelector:@selector(onClickBackButton:)];
   
    NSLog(@"self.message.frame ： %@", NSStringFromCGRect(self.messageLabel.frame));
    self.messageLabel.text = Text_Please_Input_Email;
    [self.textFieldName setPlaceholder:Text_Email_PlaceHolder];
    
    UIImageView *rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:Image_TextFiled_Error_Tip]];
    [rightImageView setUserInteractionEnabled:YES];
    [self.textFieldName setRightView:rightImageView];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAlertTip:)];
    [self.textFieldName.rightView addGestureRecognizer:gesture];
    
    [self.nextStepButton setTitle:Text_Next_Step forState:UIControlStateNormal];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _networkHelper = [[UPNetworkHelper alloc] init];
    _networkHelper.delegate = self;
}

- (void)onClickBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Validate Email and Show Error Tip
- (NSString *)_getLocalErrorTipMessage:(NSString *)inputText {
    if (inputText.length == 0) {
        return Error_Email_Should_Not_Be_Empty;
    } else if (![UPCommonHelper isValidateEmail:inputText]) {
        return Error_Email_Format_Is_Wrong;
    }
    return nil;
}

- (NSString *)_getRemoteErrorTipMessage:(NSInteger)errorCode {
    if (errorCode == 415) {
        return Error_Email_Format_Is_Wrong;
    } else if (errorCode == 407) {
        return @"无效的密码样式";
    } else {
        return nil;
    }
}
- (void)_showErrorTextFieldUI:(BOOL)isError {
    if (isError) {
        self.textFieldName.layer.borderColor = [[UIColor redColor] CGColor];
        self.textFieldName.rightViewMode = UITextFieldViewModeAlways;
    } else {
        self.textFieldName.layer.borderColor = [[UIColor blackColor] CGColor];
        self.textFieldName.rightViewMode = UITextFieldViewModeNever;
    }
}

- (BOOL)validateInput:(NSString *)inputText {
    NSString *errorStr = [self _getLocalErrorTipMessage:inputText];
    if (errorStr.length > 0) {
        [self _showErrorTextFieldUI:YES];
        [self _showAlertTip:errorStr];
        return NO;
    }
    return YES;
}

- (void)onClickNextStepButton:(id)sender {
    
    NSString *emailStr = self.textFieldName.text;
    if ([self validateInput:emailStr]) {
        [_networkHelper postEmailCheckWithString:emailStr];
        [self.indicatorView setHidden:NO];
        [self.indicatorView startAnimating];
        self.textFieldName.clearButtonMode = UITextFieldViewModeNever;
        
    } else {
        
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    [self _showErrorTextFieldUI:NO];
    return YES;
}

- (void)showAlertTip:(UITapGestureRecognizer *)gesture {
    [self _showAlertTip:_alertMessage];
}

- (void)_showAlertTip:(NSString *)title {
    CGPoint point = CGPointMake(300, 95);
    _alertMessage = [NSString stringWithFormat:@"%@%@%@", @"  ",title,@"  "];
    @autoreleasepool {
        UPAlertTipLabel *alert = [[UPAlertTipLabel alloc] initWithFrame:CGRectMake(10, 100, 300, 100)];
        [alert updateTitle:_alertMessage Point:point isAssignBottom:YES];
        [self.view addSubview:alert];
    }
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
    NSString *errorStr = [self _getRemoteErrorTipMessage:responseCode];
    if (errorStr.length > 0) {
        // 格式不对
        [self _showAlertTip:errorStr];
    } else {
        UPSecondPageLoginOrEnrollViewController *nextController = [[UPSecondPageLoginOrEnrollViewController alloc] init];
        nextController.emailStr = self.textFieldName.text;
        if (responseCode == 404) { // 未注册
            nextController.isEnrollProcess = YES;
        } else { // 已经注册
            nextController.isEnrollProcess = NO;
        }
        [self.navigationController pushViewController:nextController animated:YES];
    }
}

- (void)requestSuccessWithFailMessage:(NSString *)message withTag:(NSNumber *)tag {
    
}

@end
