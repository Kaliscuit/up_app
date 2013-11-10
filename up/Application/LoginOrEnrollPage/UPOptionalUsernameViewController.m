//
//  UPOptionalUsernameViewController.m
//  up
//
//  Created by joy.long on 13-11-9.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPOptionalUsernameViewController.h"
#import "CommonURL.h"
#import "UPNetworkHelper.h"
@interface UPOptionalUsernameViewController ()<UPNetworkHelperDelegate>

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
    [UPNetworkHelper sharedInstance].delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onClickNextStepButton:(id)sender {
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:self.textField.text,@"name", nil];
    [[UPNetworkHelper sharedInstance] postNicknameWithDictionary:dict];
    [dict release];
}

- (void)requestSuccess:(NSDictionary *)responseObject withTag:(NSNumber *)tag {
    if ([tag integerValue] == Tag_Nickname) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Nickname" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.textField.text,@"Nickname", nil]];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

- (void)requestFail:(NSError *)error withTag:(NSNumber *)tag {
    
}
@end
