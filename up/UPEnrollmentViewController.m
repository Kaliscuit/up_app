//
//  UPEnrollmentViewController.m
//  up
//
//  Created by joy.long on 13-10-30.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPEnrollmentViewController.h"

#define SearchBarWidth (240.0f)
#define SearchBarHeight (50.0f)
#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)

#define SearchBarInitFrame CGRectMake((ScreenWidth - SearchBarWidth) / 2, (ScreenHeight - SearchBarHeight) / 2, SearchBarWidth, SearchBarHeight)
#define SearchBarEditFrame CGRectMake((ScreenWidth - SearchBarWidth) / 2, 0, SearchBarWidth, SearchBarHeight)

typedef enum {
    EnrollmentSearchBarStatusInit = 0,
    EnrollmentSearchBarStatusEdit = 1
}EnrollmentSearchBarStatus;

@interface UPEnrollmentViewController ()<UISearchBarDelegate> {
    UISearchBar *_searchBar;
}
@property (nonatomic, assign) EnrollmentSearchBarStatus searchBarStatus;
@end

@implementation UPEnrollmentViewController
@synthesize searchBarStatus = _searchBarStatus;
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
    self.view.backgroundColor = [UIColor whiteColor];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:SearchBarInitFrame];
    [_searchBar setSearchBarStyle:UISearchBarStyleDefault];
    [_searchBar setPlaceholder:@"请输入感兴趣的职位"];
    [_searchBar setShowsSearchResultsButton:YES];
    [_searchBar setTintColor:[UIColor redColor]]; // 光标颜色
    _searchBar.backgroundColor = [UIColor greenColor];
    [_searchBar setKeyboardType:UIKeyboardTypeDefault];
//    [[_searchBar.subviews objectAtIndex:0] removeFromSuperview];
	[self.view addSubview:_searchBar];
    _searchBar.delegate = self;
    [_searchBar release];
    
    UITapGestureRecognizer *closeSearchTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSearch:)];
    closeSearchTapGesture.numberOfTapsRequired = 1;
    [closeSearchTapGesture setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:closeSearchTapGesture];
    [closeSearchTapGesture release];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)closeSearch:(UITapGestureRecognizer *)gesture {
    if ([_searchBar becomeFirstResponder]) {
        [_searchBar resignFirstResponder];
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBarStatus = EnrollmentSearchBarStatusEdit;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    self.searchBarStatus = EnrollmentSearchBarStatusInit;
}

- (void)setSearchBarStatus:(EnrollmentSearchBarStatus)searchBarStatus {
    if (searchBarStatus == EnrollmentSearchBarStatusInit) {
        [UIView beginAnimations:@"EnrollmentSearchBarChangeToEditStatus" context:nil];
        [UIView setAnimationDuration:0.3f];
        _searchBar.frame = SearchBarInitFrame;
        [UIView commitAnimations];
    } else if (searchBarStatus == EnrollmentSearchBarStatusEdit){
        [UIView beginAnimations:@"EnrollmentSearchBarChangeToInitStatus" context:nil];
        [UIView setAnimationDuration:0.3f];
        _searchBar.frame = SearchBarEditFrame;
        [UIView commitAnimations];
    } else {
        // LOG
    }
}
@end
