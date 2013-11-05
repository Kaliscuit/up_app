//
//  UPSearchViewController.m
//  up
//
//  Created by joy.long on 13-11-5.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPSearchViewController.h"
#import "UPSearchResultManager.h"
#import "AFNetworking.h"
#import "CommonDefine.h"
#import "UPCommonInitMethod.h"

#define SearchBarWidth (240.0f)
#define SearchBarHeight (50.0f)


#define SearchBarInitFrame CGRectMake(30, 250, 258, 45)
#define SearchBarEditFrame CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height, ScreenWidth, SearchBarHeight)

#define isClassEqual(x, y) ([[x class] isEqual:[y class]])?YES:NO

typedef enum {
    EnrollmentSearchBarStatusInit = 0,
    EnrollmentSearchBarStatusEdit = 1
}EnrollmentSearchBarStatus;

@interface UPSearchViewController ()<UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate> {
    UISearchBar *_searchBar;
    UILabel *_searchBarTipLabel;
    UIButton *_accountButton;
    AFHTTPRequestOperationManager *_manager;
    UISearchDisplayController *_displayController;
    
    NSInteger _positionCount;
    NSMutableArray *_positions;
    NSMutableArray *_searchKeywords;
    NSString *_keyword;
    
    UPSearchResultManager *_searchResultManager;
    
    UIPageControl *_pageControl;
    UIScrollView *_scrollView;

}
@property (nonatomic, assign) EnrollmentSearchBarStatus searchBarStatus;
@end

@implementation UPSearchViewController
@synthesize searchBarStatus = _searchBarStatus;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    SAFE_RELEASE(_searchBar);
    SAFE_RELEASE(_searchBarTipLabel);
    SAFE_RELEASE(_accountButton);
    SAFE_RELEASE(_positions);
    SAFE_RELEASE(_searchKeywords);
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //    UPSearchResultManager *a = [[UPSearchResultManager alloc] init];
    //    [a defaultDB];
    //    [a release];
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    self.view.backgroundColor = BaseColor;
    
    _searchBarTipLabel = [[UILabel alloc] init];
    [UPCommonInitMethod initLabel:_searchBarTipLabel withFrame:CGRectMake(36, 223, 150, 25) withText:@"我的梦想职业" withTextColor:[UIColor whiteColor] withBackgroundColor:[UIColor clearColor] withFont:[UIFont systemFontOfSize:20]];
    [self.view addSubview:_searchBarTipLabel];
    
    _accountButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [UPCommonInitMethod initButton:_accountButton withFrame:CGRectMake(36.0f, (ScreenHeight - 90.0f), 100.0f, 40.0f) withTitle:@"未登录" withTitleColor:[UIColor colorWithWhite:179.0f/255.0f alpha:1.0] withBackgroundColor:[UIColor whiteColor] withAction:@selector(onClickAccountButton:)];
    [UPCommonInitMethod initButtonWithRadius:_accountButton withCornerRadius:20.0f];
    [_accountButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 25, 0, 0)];
    [self.view addSubview:_accountButton];
    
    [self initSearchBar];
    [self initSearchDisplayController];
    [self initSearchRequest];
    
    _positions = [[NSMutableArray alloc] init];
    _searchKeywords = [[NSMutableArray alloc] init];
    
    _pageControl = [[UIPageControl alloc] init];
    _scrollView = [[UIScrollView alloc] init];
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}

- (void)onClickAccountButton:(UIButton *)sendere {
    NSLog(@"点击登录按钮");
}

- (void)initSearchBar {
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(30, 250, 258, 45)];
    [_searchBar setSearchBarStyle:UISearchBarStyleMinimal];
    [_searchBar setPlaceholder:@"请输入感兴趣的职位"];
    [_searchBar setTintColor:[UIColor redColor]]; // 光标颜色
    _searchBar.backgroundColor = [UIColor clearColor];
    [_searchBar setOpaque:NO];
    [_searchBar setKeyboardType:UIKeyboardTypeDefault];
    [_searchBar setAutoresizesSubviews:YES];
	[self.view addSubview:_searchBar];
    _searchBar.delegate = self;
    [_searchBar release];
}

- (void)initSearchDisplayController {
    _displayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _displayController.delegate = self;
    _displayController.searchResultsDelegate = self;
    _displayController.searchResultsDataSource = self;
}

- (void)initSearchRequest {
    _manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:Url_Server_base]];
}

#pragma mark - SearchBarDelegate
// return NO to not become first responder
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}

// called when text starts editing
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    self.searchBarStatus = EnrollmentSearchBarStatusEdit;
}
// return NO to not resign first responder
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    return YES;
}
// called when text ends editing
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    //    self.searchBarStatus = EnrollmentSearchBarStatusInit;
    
}


// called when text changes (including clear)
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        return;
    }

    if ([_positions count] > 0) {
        [_positions removeAllObjects];
    }
    [_positions addObjectsFromArray:[[UPSearchResultManager sharedInstance] getSearchData:searchText]];
    
//    NSDictionary *parameters = @{Parameter_Search_Suggest_Post : searchText};
//    
//    [_manager POST:Url_Search_Suggest_Post parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        _keyword = searchText;
//        NSLog(@"JSON: %@", responseObject);
//        if ([responseObject objectForKey:@"c"] == nil || [[responseObject objectForKey:@"c"] integerValue] != 200) {
//            NSLog(@"Block 返回成功，但是收到的Code码不对---失败");
//            return;
//        }
//        _positionCount = [[[responseObject objectForKey:@"d"] objectForKey:@"count"] integerValue];
//        if ([[responseObject objectForKey:@"d"] objectForKey:@"positions"]) {
//            
//        }
//        [_positions addObjectsFromArray:[[responseObject objectForKey:@"d"] objectForKey:@"positions"]];
//        [_displayController.searchResultsTableView reloadData];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
//    
}

// called before text changes
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return YES;
}

// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"显示第一个职位");
    //    self.searchBarStatus = EnrollentSearchBarStatusInit;
}

// called when cancel button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    //    [_displayController setActive:NO animated:NO];
    //    [_searchBar resignFirstResponder];
    //    self.searchBarStatus = EnrollmentSearchBarStatusInit;
}

#pragma mark - 搜索框状态变化
- (void)setSearchBarStatus:(EnrollmentSearchBarStatus)searchBarStatus {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (searchBarStatus == EnrollmentSearchBarStatusInit) {
        [_searchBar setShowsCancelButton:NO animated:YES];
        [_searchBar resignFirstResponder];
        [UIView beginAnimations:@"EnrollmentSearchBarChangeToEditStatus" context:nil];
        [UIView setAnimationDuration:0.2f];
        //        _searchBar.frame = CGRectMake((ScreenWidth - SearchBarWidth) / 2, 0, SearchBarWidth, SearchBarHeight);
        _searchBar.frame = SearchBarInitFrame;
        [UIView commitAnimations];
        
        
    } else if (searchBarStatus == EnrollmentSearchBarStatusEdit){
        [UIView beginAnimations:@"EnrollmentSearchBarChangeToInitStatus" context:nil];
        [UIView setAnimationDuration:0.2f];
        _searchBar.frame = SearchBarEditFrame;
        [UIView commitAnimations];
        
        [_searchBar setShowsCancelButton:YES animated:YES];
    } else {
        // LOG
    }
}

#pragma mark - SearchDisplayControllerDelegate
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
    if(_positions == nil) {
        [tableView setHidden:YES];
    }
}
- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView {
    if (_positions == nil) {
        [tableView setHidden:YES];
    }
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
    return YES;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if ([_positions objectAtIndex:indexPath.row]) {
        //        NSString *text = [[_positions objectAtIndex:indexPath.row] objectForKey:@"name"];
        //        NSMutableAttributedString *mutable = [[NSMutableAttributedString alloc] initWithString:text];
        //        [mutable addAttribute: NSForegroundColorAttributeName value:BaseColor range:[text rangeOfString:_keyword]];
        //        cell.textLabel.attributedText = mutable;
        //        cell.textLabel.text = [[_positions objectAtIndex:indexPath.row] objectForKey:@"name"];
    }
    
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_positionCount > 15) {
        return 15;
    }
    return _positionCount;
}
@end
