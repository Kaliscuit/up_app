//
//  UPProfileViewController.m
//  up
//
//  Created by joy.long on 13-12-9.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPProfileViewController.h"
#import "UPSettingViewController.h"
#import "UIImageView+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>

#import "UPProfileIntroduceView.h"
#import "UPProfileTimelineView.h"
#import "UPNavigationView.h"

@interface UPProfileViewController ()<UPNetworkHelperDelegate> {
    UIView *_profileBackgourndView;
    UPNavigationBar *_navigationBar;
    UITapGestureRecognizer *_gesture;
    
    UPNetworkHelper *_networkHelper;
    UPProfileIntroduceView *_introduceView;
    UPProfileTimelineView *_timelineView;
    UPNavigationView *_navigationView;
    
    UIImage *_screenshot;
    UIImageView *_fakeImageView;
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
    [self.view setTag:1111];
    
    _navigationView = [[UPNavigationView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_navigationView];
    
    _profileBackgourndView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_profileBackgourndView];
    
    [_profileBackgourndView setBackgroundColor:BaseColor];
    
    _navigationBar = [UPNavigationBar NavigationBarConfigInProfile:self title:@"个人简介" leftSelector:@selector(onClickLeftButton:) rightSelector:@selector(onClickRightButton:)];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 63.5f, SCREEN_WIDTH, 0.5f)];
    [lineView setBackgroundColor:RGBCOLOR(84.0f, 153.0f, 199.0f)];
    [_profileBackgourndView addSubview:lineView];
    
    _introduceView = [[UPProfileIntroduceView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 153)];
    [_profileBackgourndView addSubview:_introduceView];
    
    _timelineView = [[UPProfileTimelineView alloc] initWithFrame:CGRectMake(0, 217, SCREEN_WIDTH, SCREEN_HEIGHT - 217)];
    [_profileBackgourndView addSubview:_timelineView];
    
    UIView *veticalLineView = [[UIView alloc] initWithFrame:CGRectMake(49, 139, 2, SCREEN_HEIGHT - 139)];
    [veticalLineView setBackgroundColor:ColorWithWhiteAlpha(0.0f, 0.1)];
    [_profileBackgourndView addSubview:veticalLineView];
    
    [self getScreenShot];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToHomePage) name:NotificationPopFromProfileToHome object:nil];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)jumpToHomePage {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)getScreenShot {
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 2.0f);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    _fakeImageView = [[UIImageView alloc] initWithImage:UIGraphicsGetImageFromCurrentImageContext()];
    UIGraphicsEndImageContext();
    [_fakeImageView setFrame:self.view.frame];
    [self.view addSubview:_fakeImageView];
    
    _gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetProfileView:)];
    [_fakeImageView addGestureRecognizer:_gesture];
    
    [_fakeImageView setUserInteractionEnabled:YES];
    [_fakeImageView setHidden:YES];
}

- (void)onClickLeftButton:(id)sender {
    if (_fakeImageView == nil) {
        [self getScreenShot];
    }
    [_fakeImageView setHidden:NO];
    [UIView animateWithDuration:0.3f animations:^{
        [_navigationBar setHidden:YES];
        [_profileBackgourndView setHidden:YES];
        [_fakeImageView setFrame:CGRectMake(SCREEN_WIDTH - 50, 124, 320 * 320 / 568, 320)];
    }];
}

- (void)resetProfileView:(UITapGestureRecognizer *)gesture {
    [UIView animateWithDuration:0.3f animations:^{
        [_fakeImageView setFrame:self.view.frame];
    } completion:^(BOOL finished) {
        [_navigationBar setHidden:NO];
        [_profileBackgourndView setHidden:NO];
        [_fakeImageView removeGestureRecognizer:_gesture];
        [_fakeImageView removeFromSuperview];
        _fakeImageView = nil;
        _gesture = nil;
    }];
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
