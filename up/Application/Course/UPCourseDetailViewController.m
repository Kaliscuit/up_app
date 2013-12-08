//
//  UPCourseDetailViewController.m
//  up
//
//  Created by joy.long on 13-12-7.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPCourseDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UPCourseInfoView.h"

@interface UPCourseDetailViewController () {
    UILabel *_titleLabel;
    UITextView *_detailLabel;
    
}

@end

@implementation UPCourseDetailViewController

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
    [UPNavigationBar NavigationBarConfigWithBackButton:self title:self.navigationTitle isLightBackground:NO leftSelector:@selector(onClickBackButton:)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:BaseColor];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(20, 44 + 30, 280, SCREEN_HEIGHT - 74 * 2)];
    [backgroundView setBackgroundColor:WhiteColor];
    [self.view addSubview:backgroundView];
    backgroundView.layer.masksToBounds = YES;
    backgroundView.layer.cornerRadius = 5;
    
    UPCourseInfoView *view1 = [[UPCourseInfoView alloc] initWithFrame:CGRectMake(0, 200, 280, 60) title:@"方向" detailTitle:@"网络"];
    [backgroundView addSubview:view1];
    
    UPCourseInfoView *view2 = [[UPCourseInfoView alloc] initWithFrame:CGRectMake(0, 260, 280, 60) title:@"级别" detailTitle:@"中级"];
    [backgroundView addSubview:view2];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onClickBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
