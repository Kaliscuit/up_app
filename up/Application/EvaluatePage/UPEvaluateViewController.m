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
#import "UPNetworkHelper.h"

@interface UPEvaluateViewController ()<UPNetworkHelperDelegate> {
    UILabel *_titleLabel;
    NSArray *_surveyArray;
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UPNetworkHelper sharedInstance].delegate = self;
    NSLog(@"fffsssssaaaa-->%ld", (long)_positionID);
    [[UPNetworkHelper sharedInstance] postPositionSelectWithID:_positionID];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = BaseColor;
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.hidesBackButton = NO;
    self.navigationController.view.backgroundColor = BaseColor;
    self.navigationItem.backBarButtonItem.title = @"重新选择";
    self.title = @"技能评估";
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 35, 280, 30)];
    [_titleLabel setFont:[UIFont systemFontOfSize:18]];
    [_titleLabel setText:_positionTitle];
    [_titleLabel setTextColor:BlackColor];
    [_titleLabel setBackgroundColor:ClearColor];
    [self.view addSubview:_titleLabel];
    
    UILabel *nextDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 120, 280, 80)];
    [nextDetailLabel setTextAlignment:NSTextAlignmentCenter];
    [nextDetailLabel setText:@"为了让培训课程更加量身，请完成一个小小的测试"];
    [nextDetailLabel setNumberOfLines:0];
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

- (void)onClickBeginEvaluateButton:(id)sender {
    NSLog(@"开始评估");
    if (_surveyArray == nil) {
        NSLog(@"没有数据不能开始评估");
    }
    
    
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"重新选择";
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(backEvaluateBeginController);
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    
    self.navigationController.navigationBar.translucent = NO;
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
