//
//  UPProfileViewController.m
//  up
//
//  Created by joy.long on 13-12-9.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPProfileViewController.h"
#import "UPSettingViewController.h"

@interface UPProfileViewController ()<UPNetworkHelperDelegate> {
    UPNetworkHelper *_networkHelper;
}

@end

@implementation UPProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _networkHelper = [[UPNetworkHelper alloc] init];
    _networkHelper.delegate = self;
    [_networkHelper postProfileWithDictionary:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:BaseColor];
    
    [UPNavigationBar NavigationBarConfigInProfile:self title:@"个人简介" leftSelector:@selector(onClickLeftButton:) rightSelector:@selector(onClickRightButton:)];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 63.5f, SCREEN_WIDTH, 0.5f)];
    [lineView setBackgroundColor:RGBCOLOR(84.0f, 153.0f, 199.0f)];
    [self.view addSubview:lineView];
    
}

- (void)onClickLeftButton:(id)sender {
    
}

- (void)onClickRightButton:(id)sender {
    UPSettingViewController *settingViewController = [[UPSettingViewController alloc] init];
    [self.navigationController pushViewController:settingViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestSuccess:(NSDictionary *)responseObject withTag:(NSNumber *)tag {
    if ([tag integerValue] == Tag_Profile) {
        NSLog(@"responseObject : %@", responseObject);
        if ([[[responseObject objectForKey:@"d"] objectForKey:@"profile"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *profileDict = [[responseObject objectForKey:@"d"] objectForKey:@"profile"];
            [self validateAttributeAndStoreInUserDefault:profileDict];
          
        }
    }
}
- (void)validateAttributeAndStoreInUserDefault:(NSDictionary *)profile {
    NSArray *attributes = [NSArray arrayWithObjects:@"__v",@"email",@"name",@"regiester_time",@"uid",@"update_time", nil];
    for (NSInteger i = 0; i < [attributes count]; i++) {
        NSLog(@"class %@", [[profile objectForKey:attributes[i]] class]);
        if ([[profile objectForKey:attributes[i]] isKindOfClass:[NSString class]]) {
            [[NSUserDefaults standardUserDefaults] setObject:[profile objectForKey:attributes[i]] forKey:[NSString stringWithFormat:@"UserProfile_%@", attributes[i]]];
        }
    }
}

- (void)requestFail:(NSError *)error withTag:(NSNumber *)tag {
    
}

- (void)requestSuccessWithFailMessage:(NSString *)message withTag:(NSNumber *)tag {
    
}
@end