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
#define SearchBarEditFrame CGRectMake(0, 0, ScreenWidth, SearchBarHeight)

typedef enum {
    EnrollmentSearchBarStatusInit = 0,
    EnrollmentSearchBarStatusEdit = 1
}EnrollmentSearchBarStatus;

@interface UPEnrollmentViewController ()<UISearchBarDelegate, UISearchDisplayDelegate> {
    UISearchBar *_searchBar;
    UITapGestureRecognizer *_closeSearchTapGesture;
    UITableView *_tableView;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%s", __PRETTY_FUNCTION__);
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initSearchBar];
    [self initTableView];
}

- (void)initSearchBar {
    _searchBar = [[UISearchBar alloc] initWithFrame:SearchBarInitFrame];
    [_searchBar setSearchBarStyle:UISearchBarStyleDefault];
    [_searchBar setPlaceholder:@"请输入感兴趣的职位"];
//    [_searchBar setShowsSearchResultsButton:YES];
    [_searchBar setTintColor:[UIColor redColor]]; // 光标颜色
    _searchBar.backgroundColor = [UIColor greenColor];
    [_searchBar setKeyboardType:UIKeyboardTypeDefault];
    [_searchBar setAutoresizesSubviews:YES];
    //    [[_searchBar.subviews objectAtIndex:0] removeFromSuperview];
	[self.view addSubview:_searchBar];
    _searchBar.delegate = self;
    [_searchBar release];
}

- (void)initTableView {
//    _searchBar.
}
#pragma mark - 点击搜索框之外的区域结束搜索
- (void)closeSearch:(UITapGestureRecognizer *)gesture {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if ([_searchBar becomeFirstResponder]) {
        [_searchBar resignFirstResponder];
    }
}

#pragma mark - SearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    self.searchBarStatus = EnrollmentSearchBarStatusEdit;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    self.searchBarStatus = EnrollmentSearchBarStatusInit;
}

#pragma mark - 搜索框状态变化
- (void)setSearchBarStatus:(EnrollmentSearchBarStatus)searchBarStatus {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (searchBarStatus == EnrollmentSearchBarStatusInit) {
        [UIView beginAnimations:@"EnrollmentSearchBarChangeToEditStatus" context:nil];
        [UIView setAnimationDuration:0.2f];
//        _searchBar.frame = CGRectMake((ScreenWidth - SearchBarWidth) / 2, 0, SearchBarWidth, SearchBarHeight);
        _searchBar.frame = SearchBarInitFrame;
        [UIView commitAnimations];
        
        if ([[self.view gestureRecognizers] containsObject:_closeSearchTapGesture]) {
            [self.view removeGestureRecognizer:_closeSearchTapGesture];
        }
        
        [_searchBar setShowsCancelButton:NO animated:YES];
        
    } else if (searchBarStatus == EnrollmentSearchBarStatusEdit){
        [UIView beginAnimations:@"EnrollmentSearchBarChangeToInitStatus" context:nil];
        [UIView setAnimationDuration:0.2f];
        _searchBar.frame = SearchBarEditFrame;
        [UIView commitAnimations];
        
        _closeSearchTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSearch:)];
        _closeSearchTapGesture.numberOfTapsRequired = 1;
        [_closeSearchTapGesture setCancelsTouchesInView:NO];
        [self.view addGestureRecognizer:_closeSearchTapGesture];
        [_closeSearchTapGesture release];
        
        [_searchBar setShowsCancelButton:YES animated:YES];
    } else {
        // LOG
    }
}

#pragma mark - 搜索框数据显示
- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    
}

- (void) searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller {
    
}
- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    
}

// called when the table is created destroyed, shown or hidden. configure as necessary.
- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView {
    
}
- (void)searchDisplayController:(UISearchDisplayController *)controller willUnloadSearchResultsTableView:(UITableView *)tableView {
    
}

// called when table is shown/hidden
- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView {
    
}
- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView {
    
}
- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView {
    
}
- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView {
    
}

// return YES to reload table. called when search string/option changes. convenience methods on top UISearchBar delegate methods
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    return NO;
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    return NO;
}

@end
