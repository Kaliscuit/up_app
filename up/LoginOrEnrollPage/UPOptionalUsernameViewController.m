//
//  UPOptionalUsernameViewController.m
//  up
//
//  Created by joy.long on 13-11-9.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPOptionalUsernameViewController.h"
#import "CommonURL.h"
#import "AFHTTPRequestOperationManager.h"
@interface UPOptionalUsernameViewController ()

@end

@implementation UPOptionalUsernameViewController

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
    [self.navigationItem setHidesBackButton:YES];
    self.title = @"昵称";
    [self.messageLabel setText:@"欢迎加入Up大家庭,您还需要创建一个昵称"];
    [self.textField setPlaceholder:@"请输入昵称"];
    [self.nextStepButton setTitle:@"开始学习" forState:UIControlStateNormal];
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
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:self.textField.text,@"name", nil];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:Url_Server_base]];
    [manager POST:Url_Nickname_Post parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"UserName --success : %@", responseObject);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserName" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.textField.text,@"UserName", nil]];
        [self.navigationController popToRootViewControllerAnimated:YES];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error : %@", [error userInfo]);
    }];
    [dict release];
}

@end
