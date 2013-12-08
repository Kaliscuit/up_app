//
//  UPEvaluateProcessViewController.m
//  up
//
//  Created by joy.long on 13-11-11.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPEvaluateProcessViewController.h"
#import "CommonDefine.h"
#import "UPEvaluatePageView.h"
#import "SMPageControl.h"
#import "UPEvaluateResultViewController.h"

@interface UPEvaluateProcessViewController ()<UIScrollViewDelegate, UPEvaluatePageResultDelegate> {
    UIScrollView *_scrollView;
    SMPageControl *_pageControl;
    
    NSInteger _pageNumber;
    
    UILabel *_pageLabel;
    UIButton *_beforeButton;
    UIButton *_nextButton;
    
    UIButton *_finishEvaluationButton;
    
    NSMutableDictionary *_evalueateResultDict;
}

@end

@implementation UPEvaluateProcessViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = BaseColor;
    
    _evalueateResultDict = [[NSMutableDictionary alloc] init];
    
    _pageNumber = [_dataArray count];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    [_scrollView setBackgroundColor:ClearColor];
    [_scrollView setContentSize:CGSizeMake((_pageNumber * SCREEN_WIDTH), _scrollView.frame.size.height)];
    [self.view addSubview:_scrollView];

    _finishEvaluationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_finishEvaluationButton setFrame:CGRectMake(SCREEN_WIDTH - 70.0f, 35.0f, 70.0f, 24.0f)];
    [_finishEvaluationButton setTitle:@"跳过评估" forState:UIControlStateNormal];
    [_finishEvaluationButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [_finishEvaluationButton addTarget:self action:@selector(onClickFinishEvaluationButton:) forControlEvents:UIControlEventTouchUpInside];
    [_finishEvaluationButton setTitleColor:ColorWithWhiteAlpha(1.0f, 0.6f) forState:UIControlStateNormal];
    [self.view addSubview:_finishEvaluationButton];
    
    _pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 320, 30)];
    [_pageLabel setTextAlignment:NSTextAlignmentCenter];
    [_pageLabel setTextColor:ColorWithWhiteAlpha(1.0f, 0.8)];
    [_pageLabel setBackgroundColor:ClearColor];
    [_pageLabel setText:@"1"];
    [_pageLabel setFont:[UIFont fontWithName:HelveticaNeueUltraLight size:24]];
    [self.view addSubview:_pageLabel];
    
    @autoreleasepool {
        for (int i = 0; i < _pageNumber; i++) {
            UPEvaluatePageView *pageView = [[UPEvaluatePageView alloc] initWithFrame:CGRectMake(i * SCREEN_WIDTH, 100.0f, SCREEN_WIDTH, self.view.frame.size.height - 80 - 70 - 20)];
            pageView.delegate = self;
            [pageView updateDataWithDictionary:[_dataArray objectAtIndex:i]];
            [_scrollView addSubview:pageView];
        }
    }
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 70.0f, 320, 70)];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0.5)];
    [lineView setBackgroundColor:ColorWithWhiteAlpha(1.0f, 0.6)];
    [bottomView addSubview:lineView];
    [self.view addSubview:bottomView];
    
     _pageControl = [[SMPageControl alloc] initWithFrame:bottomView.bounds];
    [_pageControl setTintColor:ColorWithWhiteAlpha(1.0f, 0.5)];
    [_pageControl setIndicatorMargin:3.0f];
    [_pageControl setNumberOfPages:10];
    [_pageControl setCurrentPage:0];
    [_pageControl setPageIndicatorImage:[UIImage imageNamed:@"icn_indicator_normal.png"]];
    [_pageControl setCurrentPageIndicatorImage:[UIImage imageNamed:@"icn_indicator_active.png"]];
    [bottomView addSubview:_pageControl];
    
    _beforeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_beforeButton setFrame:CGRectMake(0, 0, 70, bottomView.frame.size.height)];
    [_beforeButton setBackgroundColor:ClearColor];
    [_beforeButton setHidden:YES];
    [_beforeButton addTarget:self action:@selector(scrollToLastPage:) forControlEvents:UIControlEventTouchUpInside];
    [_beforeButton setTitle:@"上一题" forState:UIControlStateNormal];
    [_beforeButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [bottomView addSubview:_beforeButton];
    
    _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextButton setFrame:CGRectMake(bottomView.frame.size.width - 70, 0, 70, bottomView.frame.size.height)];
    [_nextButton addTarget:self action:@selector(scrollToNextPage:) forControlEvents:UIControlEventTouchUpInside];
    [_nextButton setBackgroundColor:ClearColor];
    [_nextButton setTitle:@"下一题" forState:UIControlStateNormal];
    [_nextButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [bottomView addSubview:_nextButton];
}

- (void)evaluatePageResult:(NSString *)questionID AnswerID:(NSString *)answerIDStr {
    [_evalueateResultDict setObject:answerIDStr forKey:questionID];
}

- (void)scrollToLastPage:(id)sender {
    [_scrollView setContentOffset:CGPointMake((_pageControl.currentPage - 1) * SCREEN_WIDTH, 0) animated:YES];
}

- (void)scrollToNextPage:(id)sender {
    [_scrollView setContentOffset:CGPointMake((_pageControl.currentPage + 1) * SCREEN_WIDTH, 0) animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (page != _pageControl.currentPage) {
        _pageControl.currentPage = page;
        _pageLabel.text = [NSString stringWithFormat:@"%d", page + 1];
        if (page == 0) {
            [_beforeButton setHidden:YES];
        } else if(page == 9) {
            [_finishEvaluationButton setTitle:@"完成评估" forState:UIControlStateNormal];
            [_nextButton setHidden:YES];
        } else {
            [_finishEvaluationButton setTitle:@"跳过评估" forState:UIControlStateNormal];
            [_beforeButton setHidden:NO];
            [_nextButton setHidden:NO];
        }
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onClickFinishEvaluationButton:(id)sender {
    if ([_finishEvaluationButton.titleLabel.text isEqualToString:@"完成评估"]) {
        [self pushEvaluationResultViewController];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"卖萌" message:@"不要逃过评估啦" delegate:self cancelButtonTitle:@"好吧，我不跳过" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)pushEvaluationResultViewController {
    UPEvaluateResultViewController *resultViewController = [[UPEvaluateResultViewController alloc] init];
    [self.navigationController pushViewController:resultViewController animated:YES];
}

@end
