//
//  UPEvaluateResultViewController.m
//  up
//
//  Created by joy.long on 13-12-1.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPEvaluateResultViewController.h"
#import "UPLineView.h"

@interface UPEvaluateResultViewController ()<UIScrollViewDelegate>

@end

@implementation UPEvaluateResultViewController

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
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:BaseColor];
    
    UIButton *evaluateAgainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [evaluateAgainButton setTitle:@"重新评估" forState:UIControlStateNormal];
    [evaluateAgainButton setTitleColor:ColorWithWhiteAlpha(1.0f, 0.8f) forState:UIControlStateNormal];
    [evaluateAgainButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [evaluateAgainButton addTarget:self action:@selector(onClickEvaluateAgainButton:) forControlEvents:UIControlEventTouchUpInside];
    [evaluateAgainButton setFrame:CGRectMake(10, 30, 70, 34)];
    [self.view addSubview:evaluateAgainButton];
    
    UILabel *navigationLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 20, 210, 44)];
    [navigationLabel setTextAlignment:NSTextAlignmentCenter];
    [navigationLabel setTextColor:WhiteColor];
    [navigationLabel setFont:[UIFont systemFontOfSize:18]];
    [navigationLabel setText:@"评估结果"];
    [self.view addSubview:navigationLabel];
    
    UILabel *beatOtherLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 60, 210, 50)];
    [beatOtherLabel setTextAlignment:NSTextAlignmentCenter];
    [beatOtherLabel setTextColor:WhiteColor];
    [beatOtherLabel setFont:[UIFont systemFontOfSize:18]];
    [beatOtherLabel setText:@"您的能力值战胜了"];
    [self.view addSubview:beatOtherLabel];
    
    NSDictionary *attribute = @{NSFontAttributeName : [UIFont fontWithName:HelveticaNeueUltraLight size:54]};
    CGSize size = [@"100%" sizeWithAttributes:attribute];
    
    UILabel *beatOtherNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - size.width) / 2, 120, size.width, size.height)];
    [beatOtherNumberLabel setBackgroundColor:ClearColor];
    [beatOtherNumberLabel setTextAlignment:NSTextAlignmentCenter];
    [beatOtherNumberLabel setTextColor:WhiteColor];
    [beatOtherNumberLabel setFont:[UIFont fontWithName:HelveticaNeueUltraLight size:54]];
    [beatOtherNumberLabel setText:@"98%"];
    [self.view addSubview:beatOtherNumberLabel];
    
    UILabel *beatOtherReminderLabel = [[UILabel alloc] initWithFrame:CGRectMake(beatOtherNumberLabel.frame.origin.x + beatOtherNumberLabel.frame.size.width, beatOtherNumberLabel.frame.origin.y + beatOtherNumberLabel.frame.size.height - 16, 90, 16)];
    [beatOtherReminderLabel setTextAlignment:NSTextAlignmentLeft];
    [beatOtherReminderLabel setTextColor:WhiteColor];
    [beatOtherReminderLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [beatOtherReminderLabel setText:@"的人"];
    [self.view addSubview:beatOtherReminderLabel];
//    UIButton *jumpEvaluationButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [jumpEvaluationButton setFrame:CGRectMake(SCREEN_WIDTH - 70.0f, 35.0f, 70.0f, 24.0f)];
//    [jumpEvaluationButton setTitle:@"跳过评估" forState:UIControlStateNormal];
//    [jumpEvaluationButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
//    [jumpEvaluationButton addTarget:self action:@selector(onClickJumpEvaluationButton:) forControlEvents:UIControlEventTouchUpInside];
//    [jumpEvaluationButton setTitleColor:ColorWithWhiteAlpha(1.0f, 0.6f) forState:UIControlStateNormal];
//    [self.view addSubview:jumpEvaluationButton];
    
    UIView *abilitiesAnalysisView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 330.0f, 320.0f, 330.0f)];
    [abilitiesAnalysisView setBackgroundColor:WhiteColor];
    
    UIImageView *backgroundAbilitiesAnalysisImageView = [[UIImageView alloc] initWithFrame:abilitiesAnalysisView.bounds];
    [backgroundAbilitiesAnalysisImageView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"grid_repeat.png"]]];
    [abilitiesAnalysisView addSubview:backgroundAbilitiesAnalysisImageView];
    
    UILabel *abilitiesTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 30)];
    [abilitiesTipLabel setText:@"各项技能值分析"];
    [abilitiesTipLabel setBackgroundColor:ClearColor];
    [abilitiesTipLabel setTextColor:ColorWithWhiteAlpha(0, 0.5)];
    [abilitiesTipLabel setTextAlignment:NSTextAlignmentCenter];
    [abilitiesTipLabel setFont:[UIFont systemFontOfSize:20]];
    [abilitiesAnalysisView addSubview:abilitiesTipLabel];
    
    [self.view addSubview:abilitiesAnalysisView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, 320, abilitiesAnalysisView.frame.size.height - 50)];
//    [scrollView setBackgroundColor:[UIColor yellowColor]];
    scrollView.minimumZoomScale = 1.0;
    scrollView.maximumZoomScale = 2.0;
    [abilitiesAnalysisView addSubview:scrollView];
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    
    [scrollView setContentSize:CGSizeMake(100 + 55 * 6, scrollView.frame.size.height)];
    for (int i = 0; i < 7; i++) {
        if (i == 2) {
            UPLineView *lineView = [[UPLineView alloc] initWithFrame:CGRectMake(135, 30, 50, 200)];
            lineView.max = 100;
            lineView.current = 80;
            lineView.lineColor = BlueColor;
            [scrollView addSubview:lineView];
            [lineView refreshLineView];
        } else if(i < 2){
            UPLineView *lineView = [[UPLineView alloc] initWithFrame:CGRectMake(15 + 55 * i, 130, 25, 100)];
            
            lineView.max = 100;
            lineView.current = 80;
            lineView.lineColor = BlueColor;
            [scrollView addSubview:lineView];
            [lineView refreshLineView];
        } else if (i > 2) {
            UPLineView *lineView = [[UPLineView alloc] initWithFrame:CGRectMake(160 + 55 * (i - 2), 130, 25, 100)];
            
            lineView.max = 100;
            lineView.current = 80;
            lineView.lineColor = BlueColor;
            [scrollView addSubview:lineView];
            [lineView refreshLineView];
        }
        
    }
    
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect zoomRect=CGRectMake(119, 42, 208, 166);
    [scrollView zoomToRect:zoomRect animated:YES];

}
//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
//    
//}

- (void)onClickEvaluateAgainButton:(id)sender {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
