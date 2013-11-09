//
//  UPIndexScrollViewController.m
//  up
//
//  Created by joy.long on 13-11-5.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPIndexScrollViewController.h"
#import "CommonDefine.h"
#import "CommonNotification.h"
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

@interface UPIndexScrollViewController ()<UIScrollViewDelegate> {
    UIPageControl *_pageControl;
    UIScrollView *_scrollView;
    NSArray *_viewControllers;
    NSInteger _maxPages;
    
    BOOL _pageControlUsed;
}

@end

@implementation UPIndexScrollViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    SAFE_RELEASE(_pageControl);
    SAFE_RELEASE(_scrollView);
    SAFE_RELEASE(_viewControllers);
    [super dealloc];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (_pageControl.currentPage > 0) {
        return UIStatusBarStyleDefault;
    }
    return UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    _maxPages = 2;
    _viewControllers = [[NSArray alloc] initWithObjects:@"UPSearchViewController", @"UPMoreSearchViewController", nil];
	_pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, (ScreenHeight - 25), 320, 18)];
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = _maxPages;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(ScreenWidth * _maxPages, ScreenHeight);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    _scrollView.delegate = self;
    
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
    
    [self.view addSubview:_scrollView];
    [self.view addSubview:_pageControl];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentEnrollmentOrLoginViewController:) name:NotificationPopEnrollmentOrLoginViewController object:nil];
}

- (void)loadScrollViewWithPage:(int)page {
    if (page < 0 || page >= _maxPages) {
        return;
    }
    UIViewController *viewController = [[objc_getClass([[_viewControllers objectAtIndex:page] UTF8String]) alloc] init];
    
    if (viewController.view.superview == nil) {
        CGRect frame = _scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        (viewController).view.frame = frame;
        [_scrollView addSubview:(viewController).view];
    }
//    [viewController release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (page != _pageControl.currentPage) {
        _pageControl.currentPage = page;
        if (page == 1) {
            [_pageControl setPageIndicatorTintColor:[UIColor grayColor]];
            [_pageControl setCurrentPageIndicatorTintColor:BaseColor];
        } else {
            [_pageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
            [_pageControl setPageIndicatorTintColor:nil];
        }
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

#pragma mark - Notification
- (void)presentEnrollmentOrLoginViewController:(NSNotification *)notification {
    id class = objc_getClass("UPFirstPageLoginOrEnrollViewController");
    id enrollmentViewController = [[class alloc] init];
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;//可更改为其他方式
    transition.subtype = kCATransitionFromTop;//可更改为其他方式
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    transition.delegate = self;
    [self.navigationController pushViewController:enrollmentViewController animated:YES];
    [enrollmentViewController release];
}
@end
