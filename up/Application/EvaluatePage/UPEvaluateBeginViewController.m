//
//  UPEvaluateBeginViewController.m
//  up
//
//  Created by joy.long on 13-11-10.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPEvaluateBeginViewController.h"
#import "CommonDefine.h"
#import "UPEvaluateProcessViewController.h"
#import "UPNavigationBar.h"

@interface UPEvaluateBeginViewController ()<UPNetworkHelperDelegate> {
    UILabel *_titleLabel;
    NSArray *_surveyArray;
    
    UPNetworkHelper *_networkHelper;
}

@end

@implementation UPEvaluateBeginViewController

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
    self.navigationController.navigationBarHidden = YES;
    
    NSLog(@"fffsssssaaaa-->%ld", (long)_positionID);
    [_networkHelper postPositionSelectWithID:_positionID];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = BaseColor;
    
    _networkHelper = [[UPNetworkHelper alloc] init];
    _networkHelper.delegate = self;
    
//    [UPNavigationBar NavigationBarConfig:self title:@"技能评估" leftImage:[UIImage imageNamed:@"icn_back_white.png"] leftTitle:nil leftSelector:@selector(onClickBackButton:) rightImage:nil rightTitle:@"跳过评估" rightSelector:@selector(onClickJumpEvaluationButton:)];
//
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backButton setImage:[UIImage imageNamed:@"icn_back_white.png"] forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(onClickBackButton:) forControlEvents:UIControlEventTouchUpInside];
//    [backButton setFrame:CGRectMake(0, 20, 44, 44)];
//    [self.view addSubview:backButton];
//    
//    UILabel *navigationLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 20, 210, 44)];
//    [navigationLabel setTextAlignment:NSTextAlignmentCenter];
//    [navigationLabel setTextColor:WhiteColor];
//    [navigationLabel setFont:[UIFont systemFontOfSize:22]];
//    [navigationLabel setText:@"技能评估"];
//    [self.view addSubview:navigationLabel];
//    
//    UIButton *jumpEvaluationButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [jumpEvaluationButton setFrame:CGRectMake(SCREEN_WIDTH - 70.0f, 35.0f, 70.0f, 24.0f)];
//    [jumpEvaluationButton setTitle:@"跳过评估" forState:UIControlStateNormal];
//    [jumpEvaluationButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
//    [jumpEvaluationButton addTarget:self action:@selector(onClickJumpEvaluationButton:) forControlEvents:UIControlEventTouchUpInside];
//    [jumpEvaluationButton setTitleColor:ColorWithWhiteAlpha(1.0f, 0.6f) forState:UIControlStateNormal];
//    [self.view addSubview:jumpEvaluationButton];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icn_evaluation_target.png"]];
    [imageView setFrame:CGRectMake(0, 130, 320, 214)];
    [self.view addSubview:imageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 280, 320, 30)];
    [_titleLabel setFont:[UIFont systemFontOfSize:22]];
    [_titleLabel setText:_positionTitle];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel setTextColor:WhiteColor];
    [_titleLabel setBackgroundColor:ClearColor];
    [self.view addSubview:_titleLabel];
    
    UILabel *nextDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 10, 280, 50)];
    [nextDetailLabel setTextAlignment:NSTextAlignmentCenter];
    [nextDetailLabel setText:@"为了让培训课程更加量身\n请完成一个小小的测试"];
    [nextDetailLabel setFont:[UIFont systemFontOfSize:16]];
    [nextDetailLabel setNumberOfLines:2];
    [nextDetailLabel setBackgroundColor:ClearColor];
    [nextDetailLabel setTextColor:WhiteColor];
    [self.view addSubview:nextDetailLabel];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 140) / 2, nextDetailLabel.frame.origin.y + nextDetailLabel.frame.size.height + 60, 140, 60)];
    [button setBackgroundColor:BaseGreenColor];
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:30.0f];
    [button setTitle:@"开始评估" forState:UIControlStateNormal];
    [button setTitleColor:WhiteColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onClickBeginEvaluateButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)onClickJumpEvaluationButton:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"卖萌" message:@"不要逃过评估啦" delegate:self cancelButtonTitle:@"好吧，我不跳过" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)onClickBackButton : (id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onClickBeginEvaluateButton:(id)sender {
    NSLog(@"开始评估");
    if (_surveyArray == nil) {
        NSLog(@"没有数据不能开始评估");
    }
    
    UPEvaluateProcessViewController *evaluateProcessViewController = [[UPEvaluateProcessViewController alloc] init];
    evaluateProcessViewController.dataArray = _surveyArray;
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

- (void)requestSuccess:(NSDictionary *)responseObject withTag:(NSNumber *)tag {
    if ([tag integerValue] == Tag_Position_Select) {
        NSLog(@"ddddssss--->%@", [[[responseObject objectForKey:@"d"] objectForKey:@"survey"] class]);
        _surveyArray = [[NSArray alloc] initWithArray:[[responseObject objectForKey:@"d"] objectForKey:@"survey"]];
    }
}

- (void)requestSuccessWithFailMessage:(NSString *)message withTag:(NSNumber *)tag {
    
}

- (void)requestFail:(NSError *)error withTag:(NSNumber *)tag {
    
}

@end

