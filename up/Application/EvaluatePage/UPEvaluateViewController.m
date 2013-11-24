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

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.hidesBackButton = NO;
    self.navigationItem.backBarButtonItem.title = @"重新选择";
    [self.view setBackgroundColor:WhiteColor];
    self.title = @"技能评估";
    
    UILabel *titleTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 100, 15)];
    [titleTipLabel setText:@"目标职业"];
    [titleTipLabel setFont:[UIFont systemFontOfSize:14]];
    [titleTipLabel setBackgroundColor:ClearColor];
    [titleTipLabel setTextColor:GrayColor];
    [self.view addSubview:titleTipLabel];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 35, 280, 30)];
    [_titleLabel setFont:[UIFont systemFontOfSize:18]];
    [_titleLabel setText:@"前端工程师"];
    [_titleLabel setTextColor:BlackColor];
    [_titleLabel setBackgroundColor:ClearColor];
    [self.view addSubview:_titleLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, 80, 280, 0.5)];
    [lineView setBackgroundColor:GrayColor];
    [self.view addSubview:lineView];
    
    UILabel *nextTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 100, 20)];
    [nextTipLabel setText:@"下一步"];
    [nextTipLabel setFont:[UIFont systemFontOfSize:14]];
    [nextTipLabel setBackgroundColor:ClearColor];
    [nextTipLabel setTextColor:GrayColor];
    [self.view addSubview:nextTipLabel];
    
    UILabel *nextDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 120, 280, 80)];
    [nextDetailLabel setText:@"接下来我们会推荐一些课程给你学习以及巩固一下领域的知识，所以，先来完成一个简单的能力评估吧"];
    [nextDetailLabel setNumberOfLines:0];
    [nextDetailLabel setBackgroundColor:ClearColor];
    [nextDetailLabel setTextColor:BlackColor];
    [self.view addSubview:nextDetailLabel];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 140) / 2, nextDetailLabel.frame.origin.y + nextDetailLabel.frame.size.height + 60, 140, 60)];
    [button setBackgroundColor:BaseColor];
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:30.0f];
    [button setTitle:@"开始评估" forState:UIControlStateNormal];
    [button setTitleColor:WhiteColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onClickBeginEvaluateButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)onClickBeginEvaluateButton:(id)sender {
    NSLog(@"开始评估");
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"重新选择";
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(backEvaluateBeginController);
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
   
    
    self.navigationController.navigationBar.translucent = NO;
    UPEvaluateProcessViewController *evaluateProcessViewController = [[UPEvaluateProcessViewController alloc] init];
    [self.navigationController pushViewController:evaluateProcessViewController animated:YES];
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
