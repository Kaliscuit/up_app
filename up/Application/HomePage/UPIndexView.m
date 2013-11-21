//
//  UPIndexView.m
//  up
//
//  Created by joy.long on 13-11-15.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPIndexView.h"
#import "UPNetworkHelper.h"
#import "UPSearchBar.h"
#import <QuartzCore/QuartzCore.h>

#define SearchBarWidth (240.0f)
#define SearchBarHeight (50.0f)


#define SearchBarInitFrame CGRectMake(35, 250, 248, 30)
#define SearchBarEditFrame CGRectMake(10, 20, 248, 30)

#define isClassEqual(x, y) ([[x class] isEqual:[y class]])?YES:NO

@interface UPIndexView()<UPNetworkHelperDelegate,UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
    
    UITableView *_searchResultTableView;
    UITableView *_keySearchResultTableView;
    
    UILabel *_searchBarTipLabel;
    UIButton *_accountButton;
    
    NSInteger _positionCount;
    NSMutableArray *_searchResultArray;
    NSMutableArray *_searchKeywords;
    NSString *_keyword;
    
    UPSearchBar *_searchBar;
    
    UIButton *_cancelButton;
    
    NSMutableArray *_keySearchResultArray;
    NSInteger _keySearchCount;
    BOOL _hadNext;
    NSInteger _currentPage;
    
    BOOL _isSearchKeyword;
}

@end
@implementation UPIndexView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"%s", __PRETTY_FUNCTION__);
        
        self.backgroundColor = BaseColor;
        
        [UPNetworkHelper sharedInstance].delegate = self;
        
        [self initUI];
        
        _searchResultArray = [[NSMutableArray alloc] init];
        _searchKeywords = [[NSMutableArray alloc] init];
        _keySearchResultArray = [[NSMutableArray alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserName:) name:@"Nickname" object:nil];
    }
    return self;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _searchBar = nil;
    _searchBarTipLabel = nil;
    _keySearchResultTableView  = nil;
    _searchResultTableView = nil;
    SAFE_RELEASE(_keySearchResultArray);
    SAFE_RELEASE(_searchResultArray);
    SAFE_RELEASE(_searchKeywords);
    [super dealloc];
}


- (void)initUI {
    _searchBarTipLabel = [[UILabel alloc] init];
    [_searchBarTipLabel setFrame:CGRectMake(36, 223, 150, 25)];
    [_searchBarTipLabel setText:@"我的梦想职业"];
    [_searchBarTipLabel setTextColor:WhiteColor];
    [_searchBarTipLabel setBackgroundColor:ClearColor ];
    [_searchBarTipLabel setFont:[UIFont systemFontOfSize:20]];
    [self addSubview:_searchBarTipLabel];
    [_searchBarTipLabel release];
    
    _accountButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_accountButton setFrame:CGRectMake(36.0f, (SCREEN_HEIGHT - 90.0f), 100.0f, 40.0f)];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"]) {
        [self _updateUserName:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"]];
    } else {
        [self _updateUserName:nil];
    }
    [_accountButton setBackgroundColor:WhiteColor];
    [_accountButton addTarget:self action:@selector(onClickAccountButton:) forControlEvents:UIControlEventTouchUpInside];
    _accountButton.layer.masksToBounds = YES;
    _accountButton.layer.cornerRadius = 20.0f;
    [_accountButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [self addSubview:_accountButton];
    
    _searchBar = [[UPSearchBar alloc] initWithFrame:SearchBarInitFrame];
    [_searchBar.layer setMasksToBounds:YES];
    [_searchBar.layer setCornerRadius:5.0f];
    _searchBar.delegate = self;
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    [_searchBar setBackgroundColor:WhiteColor];
    [self addSubview:_searchBar];
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelButton setFrame:CGRectMake(265, 20, 45, 30)];
    [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:WhiteColor forState:UIControlStateNormal];
    [_cancelButton setHidden:YES];
    [_cancelButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_cancelButton addTarget:self action:@selector(onClickCancelSearchButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancelButton];
    
    _searchResultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT - 60 - 216)];
    [_searchResultTableView setBackgroundColor:ColorWithWhiteAlpha(255.0f, 0.5)];
    [_searchResultTableView setHidden:YES];
    _searchResultTableView.delegate = self;
    _searchResultTableView.bounces = NO;
    _searchResultTableView.dataSource =self;
    [self addSubview:_searchResultTableView];
    
    
    _keySearchResultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT - 60)];
    [_keySearchResultTableView setBackgroundColor:ColorWithWhiteAlpha(255.0f, 0.5)];
    [_keySearchResultTableView setHidden:YES];
    _keySearchResultTableView.delegate = self;
    _keySearchResultTableView.dataSource =self;
    [self addSubview:_keySearchResultTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldValueChanged:) name:UITextFieldTextDidChangeNotification object:_searchBar];
    
    _keySearchCount = 0;
}



#pragma mark - 注册登陆之后如果没有选择职位则回到首页
- (void)updateUserName:(NSNotification *)notify {
    [self _updateUserName:[[notify userInfo] objectForKey:@"Nickname"]];
}

- (void)_updateUserName:(NSString *)userName {
    if (userName.length > 0) {
        [_accountButton setImage:[UIImage imageNamed:@"icn_user_default_highlight.png"] forState:UIControlStateNormal];
        [_accountButton setTitle:userName forState:UIControlStateNormal];
        [_accountButton setTitleColor:RGBCOLOR(10.0f, 95.0f, 255.0f) forState:UIControlStateNormal];
        [_accountButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    } else {
        [_accountButton setTitleColor:ColorWithWhite(179.0f) forState:UIControlStateNormal];
        [_accountButton setTitle:@"未登录" forState:UIControlStateNormal];
        [_accountButton setImage:[UIImage imageNamed:@"icn_user_default.png"] forState:UIControlStateNormal];
        [_accountButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        
    }
    
}

- (void)onClickAccountButton:(UIButton *)sender {
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"] == nil) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPopEnrollmentOrLoginViewController object:nil];
    }
}

#pragma mark - 开始搜索
- (void)textFieldValueChanged:(NSNotification *)notify {
    if (_searchBar.text.length == 0) {
        [_searchResultArray removeAllObjects];
    }
    else {
        _isSearchKeyword = NO;
        if ([UPNetworkHelper sharedInstance].delegate != self) {
            [UPNetworkHelper sharedInstance].delegate = self;
        }
        [[UPNetworkHelper sharedInstance] postSearchSuggestWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:_searchBar.text,@"keyword", nil]];
    }
}

- (void)onClickCancelSearchButton:(UIButton *)sender {
    [UIView beginAnimations:@"SearchBarEndEdit" context:nil];
    [UIView setAnimationDuration:0.3];
    [_searchBarTipLabel setHidden:NO];
    
    [_searchBar resignFirstResponder];
    [_searchResultTableView setHidden:YES];
    [_keySearchResultTableView setHidden:YES];
    [_searchBar setFrame:SearchBarInitFrame];
    [UIView commitAnimations];
    [_cancelButton setHidden:YES];
    
    [_searchBar updateStatus:UPSearchBarStatusInit];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [UIView beginAnimations:@"SearchBarBeginEdit" context:nil];
    [UIView setAnimationDuration:0.3];
    [_searchBar setFrame:SearchBarEditFrame];
    [_searchResultTableView setHidden:NO];
    [UIView commitAnimations];
    [_cancelButton setHidden:NO];
    [_searchBarTipLabel setHidden:YES];
    
    [_searchBar updateStatus:UPSearchBarStatusBeginSearch];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [UPNetworkHelper sharedInstance].delegate = self;
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:textField.text,@"keyword", nil];
    [[UPNetworkHelper sharedInstance] postSearchPositionWithDictionary:dict];
    [dict release];
    
    [_keySearchResultTableView setHidden:NO];
    return YES;
}

#pragma mark - 网络请求
- (void)requestSuccess:(NSDictionary *)responseObject withTag:(NSNumber *)tag {
    if ([tag integerValue] == Tag_Search_Suggest) {
        if ([_searchResultArray count] > 0) {
            [_searchResultArray removeAllObjects];
        }
        [_searchResultArray addObjectsFromArray:[[responseObject objectForKey:@"d"] objectForKey:@"suggestions"]];
        
        [_searchResultTableView reloadData];
    } else if ([tag integerValue] == Tag_Search_Position) {
        NSDictionary *dict = [responseObject objectForKey:@"d"];
        [_keySearchResultArray addObjectsFromArray:[dict objectForKey:@"result"]];
        _keySearchCount += [[dict objectForKey:@"count"] integerValue];
        _currentPage = [[dict objectForKey:@"page"] integerValue];
        _hadNext = [[dict objectForKey:@"next"] boolValue];
        NSLog(@"count : %d", _keySearchCount);
        
        [_keySearchResultTableView reloadData];
    } else if ([tag integerValue] == Tag_Position_Profile) {
        NSDictionary *responseDict = [[responseObject objectForKey:@"d"] objectForKey:@"profile"];
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[responseDict objectForKey:@"position"],@"positionTitle",[responseDict objectForKey:@"position_desc"],@"position_desc",[responseDict objectForKey:@"rank"],@"rank",[responseDict objectForKey:@"hot"],@"isShowHotImage", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DetailJob" object:nil userInfo:dict];
        [dict release];
    }
}

- (void)requestFail:(NSError *)error withTag:(NSNumber *)tag {
    if ([tag integerValue] == Tag_Search_Suggest) {
        
    } else if ([tag integerValue] == Tag_Search_Position) {
        
    }
}

- (void)requestSuccessWithFailMessage:(NSString *)message withTag:(NSNumber *)tag {
    
}

#pragma mark - TableViewDelegate & TableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_searchResultTableView]) {
        UITableViewCell *cell = [_searchResultTableView cellForRowAtIndexPath:indexPath];
        NSString *str = ((UILabel *)[cell viewWithTag:17888]).text;
        NSLog(@"点击搜索职位 ：%@", str);
        _searchBar.text = str;
        
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:_searchBar.text,@"keyword", nil];
        [[UPNetworkHelper sharedInstance] postSearchPositionWithDictionary:dict];
        [dict release];
        [_searchBar resignFirstResponder];
        
        [_searchResultTableView setHidden:YES];
        [_keySearchResultTableView setHidden:NO];
    } else if ([tableView isEqual:_keySearchResultTableView]) {
        
        [UPNetworkHelper sharedInstance].delegate = self;
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[[_keySearchResultArray objectAtIndex:indexPath.row] objectForKey:@"id"],@"pid", nil];
        [[UPNetworkHelper sharedInstance] postPositionProfileWithDictionary:dict];
        [dict release];
        
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_searchResultTableView]) {
        UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
            UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icn_finder.png"]];
            [icon setFrame:CGRectMake(15, (cell.frame.size.height - 15) / 2, 15, 15)];
            [cell addSubview:icon];
            [icon release];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(icon.frame.origin.x + icon.frame.size.width+15, 0, cell.frame.size.width - icon.frame.origin.x - icon.frame.size.width, cell.frame.size.height)];
            [label setBackgroundColor:ClearColor];
            [label setTag:17888];
            
            [cell addSubview:label];
            [label release];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if ([_searchResultArray objectAtIndex:indexPath.row]) {
            ((UILabel *)[cell viewWithTag:17888]).text = [_searchResultArray objectAtIndex:indexPath.row];
        }
        
        return cell;
    } else if ([tableView isEqual:_keySearchResultTableView]) {
        UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"keySearchCell"];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"keySearchCell"] autorelease];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UIImageView *icon = [[UIImageView alloc] init];
            [icon setFrame:CGRectMake(15, (cell.frame.size.height - 15) / 2, 15, 15)];
            icon.layer.masksToBounds = YES;
            [icon setBackgroundColor:GrayColor];
            icon.layer.cornerRadius = 5.0f;
            [cell addSubview:icon];
            [icon release];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(icon.frame.origin.x + icon.frame.size.width+15, 0, cell.frame.size.width - icon.frame.origin.x - icon.frame.size.width, cell.frame.size.height)];
            [label setBackgroundColor:ClearColor];
            [label setTag:17888];
            
            [cell addSubview:label];
            [label release];
            
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (_hadNext && indexPath.row == (_keySearchCount - 5)) {
            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:_searchBar.text,@"keyword",[NSNumber numberWithInteger:(_currentPage + 1)],@"page" ,nil];
            [UPNetworkHelper sharedInstance].delegate = self;
            [[UPNetworkHelper sharedInstance] postSearchPositionWithDictionary:dict];
            [dict release];
        }
        if ([_keySearchResultArray objectAtIndex:indexPath.row]) {
//            ((UILabel *)[cell viewWithTag:17888]).attributedText = [self getSearchResultAttributedString:[[_keySearchResultArray objectAtIndex:indexPath.row] objectForKey:@"position"]];
            ((UILabel *)[cell viewWithTag:17888]).text = [[_keySearchResultArray objectAtIndex:indexPath.row] objectForKey:@"position"];
            NSLog(@"dddddd---->%@", ((UILabel *)[cell viewWithTag:17888]).text);
        }
        
        return cell;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:_searchResultTableView]) {
        if ([_searchResultArray count] > 10) {
            return 10;
        }
        return [_searchResultArray count];
    } else if ([tableView isEqual:_keySearchResultTableView]) {
        return _keySearchCount;
    }
    return 0;
}

@end
