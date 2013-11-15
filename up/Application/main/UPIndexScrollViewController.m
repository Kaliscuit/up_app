//
//  UPIndexScrollViewController.m
//  up
//
//  Created by joy.long on 13-11-5.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPIndexScrollViewController.h"
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>
#import "UPCommonHelper.h"
#import "UPDetailJobViewController.h"

@interface UPIndexScrollViewController ()<UIScrollViewDelegate> {
    UIPageControl *_pageControl;
    UIScrollView *_scrollView;
    NSArray *_viewArray;
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
    [self removeNotification];
    SAFE_RELEASE(_pageControl);
    SAFE_RELEASE(_scrollView);
    SAFE_RELEASE(_viewArray);
    [super dealloc];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (_pageControl.currentPage > 0 || ![UPCommonHelper isIOS7]) {
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
    if (![UPCommonHelper isIOS7]) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = WhiteColor;
    _maxPages = 2;
    _viewArray = [[NSArray alloc] initWithObjects:@"UPIndexView", @"UPMoreSearchResultView", nil];
	_pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, (SCREEN_HEIGHT - 25), 320, 18)];
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = _maxPages;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * _maxPages, SCREEN_HEIGHT);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
    
    [self.view addSubview:_scrollView];
    [self.view addSubview:_pageControl];
    
    [self addNotification];
}
#pragma mark - Notification
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentEnrollmentOrLoginViewController:) name:NotificationPopEnrollmentOrLoginViewController object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentEvaluateViewController:) name:@"Test" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentDetailJobViewController:) name:@"DetailJob" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentJobTypeViewController:) name:@"JobType" object:nil];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)presentDetailJobViewController:(NSNotification *)notify {
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"返回";
    temporaryBarButtonItem.tintColor = [UIColor redColor];
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(back:);
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    [temporaryBarButtonItem release];
    
    NSDictionary *dict = [notify userInfo];
    UPDetailJobViewController *detailJobViewController = [[UPDetailJobViewController alloc] init];
    detailJobViewController.positionTitle = [dict objectForKey:@"positionTitle"];
    detailJobViewController.positionDescription = [dict objectForKey:@"positionDesc"];
    detailJobViewController.rankNumber = 1;
    
    [self.navigationController pushViewController:detailJobViewController animated:YES];
    [detailJobViewController release];
}

- (void)presentJobTypeViewController:(NSNotification *)notification {
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"返回";
    temporaryBarButtonItem.tintColor = [UIColor redColor];
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(back:);
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    [temporaryBarButtonItem release];
    
    id class = objc_getClass("UPJobTypeViewController");
    id enrollmentViewController = [[class alloc] init];
    [self.navigationController pushViewController:enrollmentViewController animated:YES];
    [enrollmentViewController release];

}

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

- (void)presentEvaluateViewController:(NSNotification *)notification {
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"取消评审";
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(back:);
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    [temporaryBarButtonItem release];
    
    id class = objc_getClass("UPEvaluateViewController");
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



- (void)loadScrollViewWithPage:(int)page {
    if (page < 0 || page >= _maxPages) {
        return;
    }
    UIView *viewArrayObject = [[[objc_getClass([[_viewArray objectAtIndex:page] UTF8String]) alloc] init] autorelease];
    
    if (viewArrayObject.superview == nil) {
        CGRect frame = _scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        (viewArrayObject).frame = frame;
        [_scrollView addSubview:viewArrayObject];
    }
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
            [_pageControl setPageIndicatorTintColor:GrayColor];
            [_pageControl setCurrentPageIndicatorTintColor:BaseColor];
        } else {
            [_pageControl setCurrentPageIndicatorTintColor:WhiteColor];
            [_pageControl setPageIndicatorTintColor:nil];
        }
        if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
            [self setNeedsStatusBarAppearanceUpdate];
        }
    }
}



- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
