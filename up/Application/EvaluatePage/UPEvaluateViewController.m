//
//  UPEvaluateViewController.m
//  up
//
//  Created by joy.long on 13-11-10.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPEvaluateViewController.h"
#import "CommonDefine.h"
#import "UPEvaluateProcessViewController.h"
@interface UPEvaluateViewController () {
    UILabel *_titleLabel;
}

@end

@implementation UPEvaluateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [_titleLabel release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.hidesBackButton = NO;
    self.navigationItem.backBarButtonItem.title = @"重新选择";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"技能评估";
    
    UILabel *titleTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 100, 15)];
    [titleTipLabel setText:@"目标职业"];
    [titleTipLabel setFont:[UIFont systemFontOfSize:14]];
    [titleTipLabel setBackgroundColor:[UIColor clearColor]];
    [titleTipLabel setTextColor:[UIColor grayColor]];
    [self.view addSubview:titleTipLabel];
    [titleTipLabel release];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 35, 280, 30)];
    [_titleLabel setFont:[UIFont systemFontOfSize:18]];
    [_titleLabel setText:@"前端工程师"];
    [_titleLabel setTextColor:[UIColor blackColor]];
    [_titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_titleLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, 80, 280, 0.5)];
    [lineView setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:lineView];
    [lineView release];
    
    UILabel *nextTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 100, 20)];
    [nextTipLabel setText:@"下一步"];
    [nextTipLabel setFont:[UIFont systemFontOfSize:14]];
    [nextTipLabel setBackgroundColor:[UIColor clearColor]];
    [nextTipLabel setTextColor:[UIColor grayColor]];
    [self.view addSubview:nextTipLabel];
    [nextTipLabel release];
    
    UILabel *nextDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 120, 280, 80)];
    [nextDetailLabel setText:@"接下来我们会推荐一些课程给你学习以及巩固一下领域的知识，所以，先来完成一个简单的能力评估吧"];
    [nextDetailLabel setNumberOfLines:0];
    [nextDetailLabel setBackgroundColor:[UIColor clearColor]];
    [nextDetailLabel setTextColor:[UIColor blackColor]];
    [self.view addSubview:nextDetailLabel];
    [nextDetailLabel release];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((ScreenWidth - 140) / 2, nextDetailLabel.frame.origin.y + nextDetailLabel.frame.size.height + 60, 140, 60)];
    [button setBackgroundColor:BaseColor];
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:30.0f];
    [button setTitle:@"开始评估" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onClickBeginEvaluateButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button release];
}

- (void)onClickBeginEvaluateButton:(id)sender {
    NSLog(@"开始评估");
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"重新选择";
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(backEvaluateBeginController);
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    [temporaryBarButtonItem release];
    
    self.navigationController.navigationBar.translucent = NO;
    UPEvaluateProcessViewController *evaluateProcessViewController = [[UPEvaluateProcessViewController alloc] init];
    [self.navigationController pushViewController:evaluateProcessViewController animated:YES];
    [evaluateProcessViewController release];
}

- (void)backEvaluateBeginController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setPositionTitle:(NSString *)positionTitle {
    _positionTitle = positionTitle;
    [_titleLabel setText:positionTitle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
