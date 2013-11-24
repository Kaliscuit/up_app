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

@interface UPEvaluateProcessViewController ()<UIScrollViewDelegate> {
    UIScrollView *_scrollView;
    SMPageControl *_pageControl;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = BaseColor;
    _pageNumber = 10;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [_scrollView setContentSize:CGSizeMake((_pageNumber * SCREEN_WIDTH), _scrollView.frame.size.height)];
    [self.view addSubview:_scrollView];
    _scrollView.delegate = self;
    
     _pageControl = [[SMPageControl alloc] initWithFrame:CGRectMake(0, 280, 320, 40)];
    [_pageControl setNumberOfPages:10];
    [_pageControl setCurrentPage:1];
    [_pageControl setCurrentPageIndicatorImage:[UIImage imageNamed:@"icn_indicator_active.png"]];
    [self.view addSubview:_pageControl];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 320, 50)];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button setTitle:@"评估完成" forState:UIControlStateNormal];
    [button setTitleColor:BlackColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onClickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

- (void)onClickButton:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"探索之路结束了" message:@"你看到的这个屏都没做呢\n不要再看了，嘿，说你哟" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (page != _pageControl.currentPage) {
        _pageControl.currentPage = page;
//        if (page == 1) {
//            [_pageControl setPageIndicatorTintColor:[UIColor grayColor]];
//            [_pageControl setCurrentPageIndicatorTintColor:BaseColor];
//        } else {
//            [_pageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
//            [_pageControl setPageIndicatorTintColor:nil];
//        }
//        if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
//            [self setNeedsStatusBarAppearanceUpdate];
//        }
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
