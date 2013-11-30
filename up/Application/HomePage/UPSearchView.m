//
//  UPSearchView.m
//  up
//
//  Created by joy.long on 13-11-30.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPSearchView.h"
#import "UPSearchBar.h"
#import "UPNetworkHelper.h"
#import "UPTopPositionTableViewCell.h"

#define SearchBarInitFrame CGRectMake(35, 250, 248, 40)
#define SearchBarEditFrame CGRectMake(10, 24, 248, 30)

@interface UPSearchView()<UPNetworkHelperDelegate,UITextFieldDelegate,UITableViewDataSource, UITableViewDelegate> {
    UPSearchBar         *_searchBar;                        // 搜索条
    UIButton            *_cancelButton;                     // 搜索条展现之后的取消按钮
    
    UITableView         *_searchSuggestResultTableView;     // 搜索建议的tableView
    UITableView         *_searchPositionResultTableView;    // 搜索某个关键字的tableView
    
    NSMutableArray      *_searchSuggestResultArray;         // 存放搜索建议的结果
    NSMutableArray      *_searchPositionResultArray;        // 存放搜索职位的结果

    NSInteger           _searchPositionCount;               // 搜索职位的总条数
    NSInteger           _currentPage;                       // 搜索职位分页的当前页数
    BOOL                _hadNext;                           // 搜索职位后网络请求返回是否还有下一页

}
@end

@implementation UPSearchView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BaseColor;
        
        [self _initData];
        
        _searchBar = [[UPSearchBar alloc] initWithFrame:SearchBarInitFrame];
        [_searchBar.layer setMasksToBounds:YES];
        [_searchBar.layer setCornerRadius:5.0f];
        _searchBar.delegate = self;
        _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
        [_searchBar setBackgroundColor:WhiteColor];
        [_searchBar becomeFirstResponder];
        [self addSubview:_searchBar];
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setFrame:CGRectMake(265, 24, 45, 30)];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:WhiteColor forState:UIControlStateNormal];
        [_cancelButton setAlpha:0.0f];
        [_cancelButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [_cancelButton addTarget:self action:@selector(onClickCancelSearchButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelButton];
        
        _searchSuggestResultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT - 60 - 116)];
        [_searchSuggestResultTableView setBackgroundColor:ColorWithWhiteAlpha(255.0f, 0.5)];
//        [_searchSuggestResultTableView setHidden:YES];
        _searchSuggestResultTableView.delegate = self;
        _searchSuggestResultTableView.bounces = NO;
        _searchSuggestResultTableView.dataSource =self;
        [self addSubview:_searchSuggestResultTableView];
        
        _searchPositionResultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT - 60)];
        [_searchPositionResultTableView setBackgroundColor:ColorWithWhiteAlpha(255.0f, 0.5)];
        [_searchPositionResultTableView setHidden:YES];
        _searchPositionResultTableView.delegate = self;
        _searchPositionResultTableView.dataSource =self;
        [_searchPositionResultTableView setBackgroundColor:WhiteColor];
        [self addSubview:_searchPositionResultTableView];

        [_searchBar updateStatus:UPSearchBarStatusBeginSearch];

        [UIView beginAnimations:@"SearchBarBeginEdit" context:nil];
        [UIView setAnimationDuration:0.3];
        [_cancelButton setAlpha:1.0f];
        [_searchBar setFrame:SearchBarEditFrame];
        [UIView commitAnimations];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldValueChanged:) name:UITextFieldTextDidChangeNotification object:_searchBar];

    }
    return self;
}

- (void)_initData {
    _searchPositionCount = 0;
    _searchSuggestResultArray = [[NSMutableArray alloc] init];
    _searchPositionResultArray = [[NSMutableArray alloc] init];
}
- (void)textFieldValueChanged:(NSNotification *)notify {
    [self isShowSearchPositionTableView:NO];
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

- (void)isShowSearchPositionTableView:(BOOL)isShow {
    [_searchPositionResultTableView setHidden:!isShow];
    [_searchSuggestResultTableView setHidden:isShow];
}


- (void)onClickCancelSearchButton:(id)sender {
    [self removeFromSuperview];
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
        if ([_searchPositionResultArray count] > 0) {
            [_searchPositionResultArray removeAllObjects];
            _searchPositionCount = 0;
        }
        [_searchPositionResultArray addObjectsFromArray:[dict objectForKey:@"result"]];
        _searchPositionCount += [[dict objectForKey:@"count"] integerValue];
        _currentPage = [[dict objectForKey:@"page"] integerValue];
        _hadNext = [[dict objectForKey:@"next"] boolValue];
        
        [_searchPositionResultTableView reloadData];
    } else if ([tag integerValue] == Tag_Position_Profile) {
        NSDictionary *responseDict = [[responseObject objectForKey:@"d"] objectForKey:@"profile"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPopDetailJobViewController object:nil userInfo:responseDict];
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
        //        if ([_searchPositionResultArray count] > 0) {
        //            [_searchPositionResultArray removeAllObjects];
        //        }
        [[UPNetworkHelper sharedInstance] postSearchSuggestWithKeyword:_searchBar.text];
        [[UPNetworkHelper sharedInstance] postSearchPositionWithKeyword:_searchBar.text WithPage:0];
        [_searchBar resignFirstResponder];
        
        [self isShowSearchPositionTableView:YES];
    } else if ([tableView isEqual:_searchPositionResultTableView]) {
        [UPNetworkHelper sharedInstance].delegate = self;
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[[_searchPositionResultArray objectAtIndex:indexPath.row] objectForKey:@"id"],@"pid", nil];
        [[UPNetworkHelper sharedInstance] postPositionProfileWithDictionary:dict];
        
    }
    //    [[UIApplication sharedApplication] performSelector:@selector(endIgnoringInteractionEvents) withObject:nil afterDelay:0.0];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_searchSuggestResultTableView]) {
        if (_searchBar.text.length == 0) {
            UPTopPositionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopPositionsCell"];
            if (cell == nil) {
                cell = [[UPTopPositionTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TopPositionsCell"];
            }
            if ([_top10Array count] > 0) {
                cell.title = [[_top10Array objectAtIndex:indexPath.row] objectForKey:@"position"];
                cell.hotNumberStr = [NSString stringWithFormat:@"%ld", (long)(indexPath.row+1)];
            }
            return cell;
        }
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
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(icon.frame.origin.x + icon.frame.size.width+15, 0, cell.frame.size.width - icon.frame.origin.x - icon.frame.size.width - 30, cell.frame.size.height)];
            [label setBackgroundColor:ClearColor];
            [label setTag:17888];
            
            [cell addSubview:label];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (_hadNext && indexPath.row == (_searchPositionCount - 10)) {
            [UPNetworkHelper sharedInstance].delegate = self;
            [[UPNetworkHelper sharedInstance] postSearchPositionWithKeyword:_searchBar.text WithPage:(_currentPage + 1)];
            
        }
        if (indexPath.row < [_searchPositionResultArray count]) {
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
        if ([_searchSuggestResultArray count] > 12) {
            return 10;
        }
        return 12;

    } else if ([tableView isEqual:_searchPositionResultTableView]) {
        return _searchPositionCount;
       
    }
    return 0;
}

@end
