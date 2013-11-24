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
#define SearchBarEditFrame CGRectMake(10, 24, 248, 30)

#define isClassEqual(x, y) ([[x class] isEqual:[y class]])?YES:NO

@interface UPIndexView()<UPNetworkHelperDelegate,UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
    
    UITableView         *_searchSuggestResultTableView;     // 搜索建议的tableView
    UITableView         *_searchPositionResultTableView;    // 搜索某个关键字的tableView
    
    NSMutableArray      *_searchSuggestResultArray;         // 存放搜索建议的结果
    NSMutableArray      *_searchPositionResultArray;        // 存放搜索职位的结果
    
    UILabel             *_searchBarBeforeLabel;             // 搜索框上面的label
    UIButton            *_accountButton;                    // 账号按钮
    UPSearchBar         *_searchBar;                        // 搜索条
    
    UIButton            *_cancelButton;                     // 搜索条展现之后的取消按钮
    
    NSInteger           _searchPositionCount;               // 搜索职位的总条数
    NSInteger           _currentPage;                       // 搜索职位分页的当前页数
    BOOL                _hadNext;                           // 搜索职位后网络请求返回是否还有下一页
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
        
        [self _initData];
        [self _initUI];
        [self _initNotification]; // 有可能需要先初始化某些控件，于是在_initUI之后调用
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _searchBar = nil;
    _accountButton = nil;
    _cancelButton = nil;
    _searchBarBeforeLabel = nil;
    _searchPositionResultTableView  = nil;
    _searchSuggestResultTableView = nil;
}

#pragma mark - Private Init
- (void)_initData {
    _searchPositionCount = 0;
    _searchSuggestResultArray = [[NSMutableArray alloc] init];
    _searchPositionResultArray = [[NSMutableArray alloc] init];
}

- (void)_initNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserName:) name:@"Nickname" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldValueChanged:) name:UITextFieldTextDidChangeNotification object:_searchBar];
}

- (void)_initUI {
    _searchBarBeforeLabel = [[UILabel alloc] init];
    [_searchBarBeforeLabel setFrame:CGRectMake(36, 223, 150, 25)];
    [_searchBarBeforeLabel setText:@"我的梦想职业"];
    [_searchBarBeforeLabel setTextColor:WhiteColor];
    [_searchBarBeforeLabel setBackgroundColor:ClearColor ];
    [_searchBarBeforeLabel setFont:[UIFont systemFontOfSize:20]];
    [self addSubview:_searchBarBeforeLabel];
   
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
    [_cancelButton setFrame:CGRectMake(265, 24, 45, 30)];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:WhiteColor forState:UIControlStateNormal];
    [_cancelButton setHidden:YES];
    [_cancelButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_cancelButton addTarget:self action:@selector(onClickCancelSearchButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancelButton];
    
    _searchSuggestResultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT - 60 - 116)];
    [_searchSuggestResultTableView setBackgroundColor:ColorWithWhiteAlpha(255.0f, 0.5)];
    [_searchSuggestResultTableView setHidden:YES];
    _searchSuggestResultTableView.delegate = self;
    _searchSuggestResultTableView.bounces = NO;
    _searchSuggestResultTableView.dataSource =self;
    [self addSubview:_searchSuggestResultTableView];
    
    _searchPositionResultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT - 60)];
    [_searchPositionResultTableView setBackgroundColor:ColorWithWhiteAlpha(255.0f, 0.5)];
    [_searchPositionResultTableView setHidden:YES];
    _searchPositionResultTableView.delegate = self;
    _searchPositionResultTableView.dataSource =self;
    [self addSubview:_searchPositionResultTableView];
    
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
        [_searchSuggestResultArray removeAllObjects];
        [_searchSuggestResultTableView reloadData];
    }
    else {
        if ([UPNetworkHelper sharedInstance].delegate != self) {
            [UPNetworkHelper sharedInstance].delegate = self;
        }
        [[UPNetworkHelper sharedInstance] postSearchSuggestWithKeyword:_searchBar.text];
    }
}

- (void)onClickCancelSearchButton:(UIButton *)sender {
    [UIView beginAnimations:@"SearchBarEndEdit" context:nil];
    [UIView setAnimationDuration:0.3];
    [_searchBarBeforeLabel setHidden:NO];
    
    [_searchBar resignFirstResponder];
    [_searchSuggestResultTableView setHidden:YES];
    [_searchPositionResultTableView setHidden:YES];
    [_searchBar setFrame:SearchBarInitFrame];
    [UIView commitAnimations];
    [_cancelButton setHidden:YES];
    [_accountButton setHidden:NO];
    [_searchBar updateStatus:UPSearchBarStatusInit];
}

- (BOOL)isSearchBarEditStatus {
    CGRect rect = SearchBarEditFrame;
    if (_searchBar.frame.origin.y == rect.origin.y) {
        return YES;
    }
    return NO;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([self isSearchBarEditStatus]) {
        [self isShowSearchPositionTableView:NO];
    } else {
        [_searchBarBeforeLabel setHidden:YES];
        [_accountButton setHidden:YES];
        [_cancelButton setHidden:NO];
        [_searchBar updateStatus:UPSearchBarStatusBeginSearch];
        [_searchSuggestResultTableView setHidden:NO];
        _searchSuggestResultTableView.alpha = 0.0f;
        [UIView beginAnimations:@"SearchBarBeginEdit" context:nil];
        [UIView setAnimationDuration:0.3];
//        [UIView setAnimationDidStopSelector:@selector(searchBarBeginEdit)];
//        _searchSuggestResultTableView.alpha = 1.0f;
        [_searchBar setFrame:SearchBarEditFrame];
        [UIView commitAnimations];
        [self performSelector:@selector(searchBarBeginEdit) withObject:Nil afterDelay:0.35f];
//
//        
//        [UIView animateWithDuration:0.3f animations:^{
//            _searchBar.frame = SearchBarInitFrame;
//        } completion:^(BOOL finished) {
//            [_searchBar setFrame:SearchBarEditFrame];
//            [_searchSuggestResultTableView setHidden:NO];
//        }];
    }
    return YES;
}

- (void)searchBarBeginEdit {
    _searchSuggestResultTableView.alpha = 1.0f;
//    [_searchSuggestResultTableView setHidden:NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [UPNetworkHelper sharedInstance].delegate = self;
    
    [[UPNetworkHelper sharedInstance] postSearchPositionWithKeyword:textField.text WithPage:1];
    [self isShowSearchPositionTableView:YES];
    return YES;
}

- (void)isShowSearchPositionTableView:(BOOL)isShow {
    [_searchPositionResultTableView setHidden:!isShow];
    [_searchSuggestResultTableView setHidden:isShow];
}

#pragma mark - 网络请求
- (void)requestSuccess:(NSDictionary *)responseObject withTag:(NSNumber *)tag {
    if ([tag integerValue] == Tag_Search_Suggest) {
        if (_searchBar.text.length == 0) {
            return;
        }
        if ([_searchSuggestResultArray count] > 0) {
            [_searchSuggestResultArray removeAllObjects];
        }
        [_searchSuggestResultArray addObjectsFromArray:[[responseObject objectForKey:@"d"] objectForKey:@"suggestions"]];
        
        [_searchSuggestResultTableView reloadData];
    } else if ([tag integerValue] == Tag_Search_Position) {
        NSDictionary *dict = [responseObject objectForKey:@"d"];
        [_searchPositionResultArray addObjectsFromArray:[dict objectForKey:@"result"]];
        _searchPositionCount += [[dict objectForKey:@"count"] integerValue];
        _currentPage = [[dict objectForKey:@"page"] integerValue];
        _hadNext = [[dict objectForKey:@"next"] boolValue];
        
        [_searchPositionResultTableView reloadData];
    } else if ([tag integerValue] == Tag_Position_Profile) {
        NSDictionary *responseDict = [[responseObject objectForKey:@"d"] objectForKey:@"profile"];
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[responseDict objectForKey:@"position"],@"positionTitle",[responseDict objectForKey:@"position_desc"],@"position_desc",[responseDict objectForKey:@"rank"],@"rank",[responseDict objectForKey:@"hot"],@"isShowHotImage", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DetailJob" object:nil userInfo:dict];
      
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
    if ([tableView isEqual:_searchSuggestResultTableView]) {
        UITableViewCell *cell = [_searchSuggestResultTableView cellForRowAtIndexPath:indexPath];
        NSString *str = ((UILabel *)[cell viewWithTag:17888]).text;
        if (str.length == 0) {
            return;
        }
        NSLog(@"点击搜索职位 ：%@", str);
        _searchBar.text = str;
        [[UPNetworkHelper sharedInstance] postSearchSuggestWithKeyword:_searchBar.text];
        [[UPNetworkHelper sharedInstance] postSearchPositionWithKeyword:_searchBar.text WithPage:0];
        [_searchBar resignFirstResponder];
        
        [self isShowSearchPositionTableView:YES];
    } else if ([tableView isEqual:_searchPositionResultTableView]) {
        
        [UPNetworkHelper sharedInstance].delegate = self;
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[[_searchPositionResultArray objectAtIndex:indexPath.row] objectForKey:@"id"],@"pid", nil];
        [[UPNetworkHelper sharedInstance] postPositionProfileWithDictionary:dict];
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_searchSuggestResultTableView]) {
        UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icn_finder.png"]];
            [icon setFrame:CGRectMake(15, (cell.frame.size.height - 15) / 2, 15, 15)];
            [icon setTag:16666];
            [cell addSubview:icon];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(icon.frame.origin.x + icon.frame.size.width+15, 0, cell.frame.size.width - icon.frame.origin.x - icon.frame.size.width, cell.frame.size.height)];
            [label setBackgroundColor:ClearColor];
            [label setTag:17888];
            
            [cell addSubview:label];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (indexPath.row < [_searchSuggestResultArray count]) {
            ((UILabel *)[cell viewWithTag:17888]).text = [_searchSuggestResultArray objectAtIndex:indexPath.row];
        } else {
            [[cell viewWithTag:16666] setHidden:YES];
        }
        
        return cell;
    } else if ([tableView isEqual:_searchPositionResultTableView]) {
        UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"keySearchCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"keySearchCell"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UIImageView *icon = [[UIImageView alloc] init];
            [icon setFrame:CGRectMake(15, (cell.frame.size.height - 15) / 2, 15, 15)];
            icon.layer.masksToBounds = YES;
            [icon setBackgroundColor:GrayColor];
            icon.layer.cornerRadius = 5.0f;
            [cell addSubview:icon];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(icon.frame.origin.x + icon.frame.size.width+15, 0, cell.frame.size.width - icon.frame.origin.x - icon.frame.size.width, cell.frame.size.height)];
            [label setBackgroundColor:ClearColor];
            [label setTag:17888];
            
            [cell addSubview:label];
            
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (_hadNext && indexPath.row == (_searchPositionCount - 10)) {
            [UPNetworkHelper sharedInstance].delegate = self;
            [[UPNetworkHelper sharedInstance] postSearchPositionWithKeyword:_searchBar.text WithPage:(_currentPage + 1)];

        }
        if ([_searchPositionResultArray objectAtIndex:indexPath.row]) {
            ((UILabel *)[cell viewWithTag:17888]).text = [[_searchPositionResultArray objectAtIndex:indexPath.row] objectForKey:@"position"];
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
    if ([tableView isEqual:_searchSuggestResultTableView]) {
        if ([_searchSuggestResultArray count] > 10) {
            return 10;
        }
        return 10;
        return [_searchSuggestResultArray count];
    } else if ([tableView isEqual:_searchPositionResultTableView]) {
        return _searchPositionCount;
    }
    return 0;
}

@end
