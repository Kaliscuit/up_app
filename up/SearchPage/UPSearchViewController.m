//
//  UPSearchViewController.m
//  up
//
//  Created by joy.long on 13-11-5.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPSearchViewController.h"
#import "UPSearchResultManager.h"
#import "CommonDefine.h"
#import "UPCommonInitMethod.h"
#import "UPNetworkHelper.h"
#import "CommonNotification.h"

#define SearchBarWidth (240.0f)
#define SearchBarHeight (50.0f)


#define SearchBarInitFrame CGRectMake(30, 250, 258, 30)
#define SearchBarEditFrame CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height, ScreenWidth, SearchBarHeight)

#define isClassEqual(x, y) ([[x class] isEqual:[y class]])?YES:NO

@interface UPSearchViewController ()<UPNetworkHelperDelegate,UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate> {
    UISearchBar *_searchBar;
    UILabel *_searchBarTipLabel;
    UIButton *_accountButton;
    UISearchDisplayController *_displayController;
    
    NSInteger _positionCount;
    NSMutableArray *_positions;
    NSMutableArray *_searchKeywords;
    NSString *_keyword;
    
    UPSearchResultManager *_searchResultManager;
}
@end

@implementation UPSearchViewController
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
    SAFE_RELEASE(_searchBar);
    SAFE_RELEASE(_searchBarTipLabel);
    SAFE_RELEASE(_positions);
    SAFE_RELEASE(_searchKeywords);
    SAFE_RELEASE(_displayController);
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
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    self.view.backgroundColor = BaseColor;
    
    [self initUI];

    _positions = [[NSMutableArray alloc] init];
    _searchKeywords = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserName:) name:@"Nickname" object:nil];
}

- (void)updateUserName:(NSNotification *)notify {
    [_accountButton setImage:[UIImage imageNamed:@"icn_user_default_highlight.png"] forState:UIControlStateNormal];
    [_accountButton setTitle:[[notify userInfo] objectForKey:@"Nickname"] forState:UIControlStateNormal];
    [_accountButton setTitleColor:[UIColor colorWithRed:10.0f/255.0f green:95.0f/255.0f blue:255.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [_accountButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [_accountButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
}

- (void)onClickAccountButton:(UIButton *)sender {
    NSLog(@"点击登录按钮");
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPopEnrollmentOrLoginViewController object:nil];
}

- (void)initUI {
    _searchBarTipLabel = [[UILabel alloc] init];
    [UPCommonInitMethod initLabel:_searchBarTipLabel withFrame:CGRectMake(36, 223, 150, 25) withText:@"我的梦想职业" withTextColor:[UIColor whiteColor] withBackgroundColor:[UIColor clearColor] withFont:[UIFont systemFontOfSize:20]];
    [self.view addSubview:_searchBarTipLabel];
    
    UIButton *fakeSearchBar = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [fakeSearchBar setFrame:SearchBarInitFrame];
    [fakeSearchBar setImage:[UIImage imageNamed:@"icn_finder.png"] forState:UIControlStateNormal];
    [fakeSearchBar setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [fakeSearchBar addTarget:self action:@selector(beginSearch) forControlEvents:UIControlEventTouchDown];
    [fakeSearchBar setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:fakeSearchBar];
    [fakeSearchBar release];
    
    _accountButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_accountButton setFrame:CGRectMake(36.0f, (ScreenHeight - 90.0f), 100.0f, 40.0f)];
    // TODO: 判断是否是已登录
    [_accountButton setTitle:@"未登录" forState:UIControlStateNormal];
    
    [_accountButton setTitleColor:[UIColor colorWithWhite:179.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [_accountButton setBackgroundColor:[UIColor whiteColor]];
    [_accountButton addTarget:self action:@selector(onClickAccountButton:) forControlEvents:UIControlEventTouchUpInside];
    [_accountButton setImage:[UIImage imageNamed:@"icn_user_default.png"] forState:UIControlStateNormal];
    [_accountButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [UPCommonInitMethod initButtonWithRadius:_accountButton withCornerRadius:20.0f];
    [_accountButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [self.view addSubview:_accountButton];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:SearchBarEditFrame];
    if ([self respondsToSelector:@selector(setSearchBarStyle:)]) {
        [_searchBar setSearchBarStyle:UISearchBarStyleMinimal];
    }
    
//    [_searchBar setPlaceholder:@"请输入感兴趣的职位"];
    [_searchBar setTintColor:[UIColor redColor]]; // 光标颜色
    _searchBar.backgroundColor = [UIColor clearColor];
    [_searchBar setOpaque:NO];
    [_searchBar setKeyboardType:UIKeyboardTypeDefault];
    [_searchBar setAutoresizesSubviews:YES];
	[self.view addSubview:_searchBar];
    _searchBar.delegate = self;
    
    _displayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _displayController.delegate = self;
    _displayController.searchResultsDelegate = self;
    _displayController.searchResultsDataSource = self;
    
}

- (void)requestSuccess:(NSDictionary *)responseObject withTag:(NSNumber *)tag {

    NSLog(@"kkkkkkk0000>   %@", responseObject);
}

- (void)requestFail:(NSError *)error withTag:(NSNumber *)tag {
    
}

- (void)beginSearch {
    [_searchBar becomeFirstResponder];
}
#pragma mark - SearchBarDelegate
// return NO to not become first responder
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}

// called when text starts editing
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    NSLog(@"%s", __PRETTY_FUNCTION__);
//    self.searchBarStatus = EnrollmentSearchBarStatusEdit;
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
    if (_positions) {
        [_displayController.searchResultsTableView reloadData];
    } else {
        [_displayController.searchResultsTableView performSelector:@selector(reloadData) withObject:nil afterDelay:1.0];
    }
    

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
//- (void)setSearchBarStatus:(EnrollmentSearchBarStatus)searchBarStatus {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    if (searchBarStatus == EnrollmentSearchBarStatusInit) {
//        [_searchBar setShowsCancelButton:NO animated:YES];
//        [_searchBar resignFirstResponder];
//        [UIView beginAnimations:@"EnrollmentSearchBarChangeToEditStatus" context:nil];
//        [UIView setAnimationDuration:0.2f];
//        //        _searchBar.frame = CGRectMake((ScreenWidth - SearchBarWidth) / 2, 0, SearchBarWidth, SearchBarHeight);
//        _searchBar.frame = SearchBarInitFrame;
//        [UIView commitAnimations];
//        
//        
//    } else if (searchBarStatus == EnrollmentSearchBarStatusEdit){
//        [UIView beginAnimations:@"EnrollmentSearchBarChangeToInitStatus" context:nil];
//        [UIView setAnimationDuration:0.2f];
//        _searchBar.frame = SearchBarEditFrame;
//        [UIView commitAnimations];
//        
//        [_searchBar setShowsCancelButton:YES animated:YES];
//    } else {
//        // LOG
//    }
//}

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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
    }
    if ([_positions objectAtIndex:indexPath.row]) {
//            NSString *text = [[_positions objectAtIndex:indexPath.row] objectForKey:@"name"];
        //        NSMutableAttributedString *mutable = [[NSMutableAttributedString alloc] initWithString:text];
        //        [mutable addAttribute: NSForegroundColorAttributeName value:BaseColor range:[text rangeOfString:_keyword]];
        //        cell.textLabel.attributedText = mutable;
              cell.textLabel.text = [[_positions objectAtIndex:indexPath.row] objectForKey:@"name"];
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
