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
#import "UPJobDetailView.h"

#define SearchBarWidth (240.0f)
#define SearchBarHeight (50.0f)


#define SearchBarInitFrame CGRectMake(35, 250, 248, 30)
#define SearchBarEditFrame CGRectMake(10, 20, 248, 30)

#define isClassEqual(x, y) ([[x class] isEqual:[y class]])?YES:NO

@interface UPIndexView()<UPNetworkHelperDelegate,UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
    
    UITableView *_searchResultTableView;
    
    UILabel *_searchBarTipLabel;
    UIButton *_accountButton;
    UISearchDisplayController *_displayController;
    
    NSInteger _positionCount;
    NSMutableArray *_searchResultArray;
    NSMutableArray *_searchKeywords;
    NSString *_keyword;
    
    UPSearchBar *_searchBar;
    
    UIButton *_cancelButton;
    
    UPJobDetailView *_detailView;
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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserName:) name:@"Nickname" object:nil];
    }
    return self;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    SAFE_RELEASE(_searchBar);
    //    SAFE_RELEASE(_searchBarTipLabel);
    SAFE_RELEASE(_searchResultArray);
    SAFE_RELEASE(_searchKeywords);
    SAFE_RELEASE(_displayController);
    [super dealloc];
}

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
    
    _searchResultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_HEIGHT, SCREEN_HEIGHT - 60 - 216)];
    [_searchResultTableView setBackgroundColor:ColorWithWhiteAlpha(255.0f, 0.5)];
    [_searchResultTableView setHidden:YES];
    _searchResultTableView.delegate = self;
    _searchResultTableView.bounces = NO;
    _searchResultTableView.dataSource =self;
    [self addSubview:_searchResultTableView];
    
    _detailView = [[UPJobDetailView alloc] initWithFrame:CGRectMake(_searchResultTableView.frame.origin.x, 50.0f, 320, self.frame.size.height - _searchResultTableView.frame.origin.y)];
    [_detailView setHidden:YES];
    [self addSubview:_detailView];
    
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button addTarget:self action:@selector(getProfile) forControlEvents:UIControlEventTouchUpInside];
//    
//    //    [button addTarget:self action:@selector(beginEvaluate) forControlEvents:UIControlEventTouchUpInside];
//    [button setTitle:@"评估" forState:UIControlStateNormal];
//    [button setFrame:CGRectMake(0, 400, 100, 100)];
//    [button setBackgroundColor:[UIColor redColor]];
//    [self addSubview:button];
//    [button release];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldValueChanged:) name:UITextFieldTextDidChangeNotification object:_searchBar];
}

//- (void)getProfile {
//    [UPNetworkHelper sharedInstance].delegate = self;
//    [[UPNetworkHelper sharedInstance] postProfileWithDictionary:nil];
//}

//- (void)beginEvaluate {
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"Test" object:nil];
//}


- (void)textFieldValueChanged:(NSNotification *)notify {
    if (_searchBar.text.length == 0) {
        [_searchResultArray removeAllObjects];
    }
    else {
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
    return YES;
}
- (void)requestSuccess:(NSDictionary *)responseObject withTag:(NSNumber *)tag {
    NSLog(@"search response : %@", responseObject);
    if ([tag integerValue] == Tag_Search_Suggest) {
        if ([_searchResultArray count] > 0) {
            [_searchResultArray removeAllObjects];
        }
        [_searchResultArray addObjectsFromArray:[[responseObject objectForKey:@"d"] objectForKey:@"suggestions"]];
        
        [_searchResultTableView reloadData];
    } else if ([tag integerValue] == Tag_Search_Position) {
//        NSString *title = [responseObject objectForKey:@""]
        [_detailView setHidden:NO];
        [_detailView updateInformation:@"IOS工程师" introduce:@"你好" requireAbility:@"你好" JobRankNumber:[NSNumber numberWithInt:15]];
        //        [_detailView setBackgroundColor:[UIColor redColor]];
    } else if ([tag integerValue] == Tag_Profile) {
        
    }
}

- (void)requestFail:(NSError *)error withTag:(NSNumber *)tag {
    if ([tag integerValue] == Tag_Search_Suggest) {
        
    } else if ([tag integerValue] == Tag_Search_Position) {
        
    }
}

- (void)requestSuccessWithFailMessage:(NSString *)message withTag:(NSNumber *)tag {
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [_searchResultTableView cellForRowAtIndexPath:indexPath];
    NSString *str = ((UILabel *)[cell viewWithTag:17888]).text;
    NSLog(@"点击搜索职位 ：%@", str);
    _searchBar.text = str;
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:_searchBar.text,@"keyword", nil];
    [[UPNetworkHelper sharedInstance] postSearchPositionWithDictionary:dict];
    [dict release];
    [_searchBar resignFirstResponder];
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
        }
        if ([_searchResultArray objectAtIndex:indexPath.row]) {
            //            NSString *text = [[_positions objectAtIndex:indexPath.row] objectForKey:@"name"];
            //        NSMutableAttributedString *mutable = [[NSMutableAttributedString alloc] initWithString:text];
            //        [mutable addAttribute: NSForegroundColorAttributeName value:BaseColor range:[text rangeOfString:_keyword]];
            //        cell.textLabel.attributedText = mutable;
            ((UILabel *)[cell viewWithTag:17888]).text = [_searchResultArray objectAtIndex:indexPath.row];
        }
        
        return cell;
    }
    return nil;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([tableView isEqual:_searchResultTableView]) {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:_searchResultTableView]) {
        if ([_searchResultArray count] > 10) {
            return 10;
        }
        return [_searchResultArray count];
    }
    return 0;
}

@end
