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
    
    NSInteger _pageNumber;
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
    self.view.backgroundColor = ClearColor;
    _pageNumber = [_dataArray count];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    [_scrollView setBackgroundColor:ClearColor];
    [_scrollView setContentSize:CGSizeMake((_pageNumber * SCREEN_WIDTH), _scrollView.frame.size.height)];
    [self.view addSubview:_scrollView];

    
    @autoreleasepool {
        for (int i = 0; i < _pageNumber; i++) {
            UPEvaluatePageView *pageView = [[UPEvaluatePageView alloc] initWithFrame:CGRectMake(i * SCREEN_WIDTH, self.view.frame.origin.y, SCREEN_WIDTH, self.view.frame.size.height)];
            [pageView updateDataWithDictionary:[_dataArray objectAtIndex:i]];
            [_scrollView addSubview:pageView];
        }
    }
    
     _pageControl = [[SMPageControl alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 66- 50, 320, 40)];
    [_pageControl setNumberOfPages:10];
    [_pageControl setCurrentPage:0];
    [_pageControl setCurrentPageIndicatorImage:[UIImage imageNamed:@"icn_indicator_active.png"]];
    [self.view addSubview:_pageControl];
    
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
