//
//  UPMoreSearchResultView.m
//  up
//
//  Created by joy.long on 13-11-15.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPMoreSearchResultView.h"
#import "UPNetworkHelper.h"
#import "UPSearchBar.h"
#import <QuartzCore/QuartzCore.h>

@interface UPMoreSearchResultView ()<UITableViewDataSource, UITableViewDelegate, UPNetworkHelperDelegate> {
    NSInteger _allPositionCount;
    NSInteger _cellCount;
    NSInteger _currentPage;
    NSMutableArray *_allPositions;
    BOOL _isExistNextPage;
    NSMutableArray *_hotPositions;
    NSInteger _hotPositionCount;
    UITableView *_tableView;
    
    UISegmentedControl *_segmentedControl;
    
    UPSearchBar *_searchBar;
    UIButton *_kindButton;
    UIView *_searchView;
}
@end

@implementation UPMoreSearchResultView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [UPNetworkHelper sharedInstance].delegate = self;
        _allPositions = [[NSMutableArray alloc] init];
        _hotPositions = [[NSMutableArray alloc] init];
        
        self.backgroundColor = WhiteColor;
        
        UIView *segmentedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
        [segmentedBackgroundView setBackgroundColor:RGBCOLOR(235.0f, 235.0f, 241.0f)];
        

        NSArray *segmentedArray = [[NSArray alloc] initWithObjects:@"Top 10",@"所有职业", nil];
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedArray];
        [segmentedArray release];
        [_segmentedControl setFrame:CGRectMake(50, 25, 220, 30)];
        [_segmentedControl setTintColor:BaseColor];
        [_segmentedControl addTarget:self action:@selector(changeTable:) forControlEvents:UIControlEventValueChanged];
        _segmentedControl.selectedSegmentIndex = 2;
        [_segmentedControl setSelectedSegmentIndex:0];
        [_segmentedControl setSegmentedControlStyle:UISegmentedControlStyleBordered];
        [_segmentedControl setBackgroundColor:RGBCOLOR(235.0f, 235.0f, 241.0f)];
//        [self addSubview:_segmentedControl];
        //    [_segmentedControl release];
        [segmentedBackgroundView addSubview:_segmentedControl];
        [self addSubview:segmentedBackgroundView];
        [segmentedBackgroundView release];
        
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 320, 40)];
        [_searchView setBackgroundColor:RGBCOLOR(189.0f, 189.0f, 195.0f)];
        _searchBar = [[UPSearchBar alloc] initWithFrame:CGRectMake(10, 5, 250, 30)];
        [_searchView addSubview:_searchBar];
        [_searchBar setBackgroundColor:WhiteColor];
        [_searchBar setPlaceholder:@"搜索你感兴趣的职位"];
        _kindButton = [[UIButton alloc] initWithFrame:CGRectMake(260, 0, 60, 40)];
        [_kindButton setTitle:@"分类" forState:UIControlStateNormal];
        [_kindButton addTarget:self action:@selector(onClickKindButton:) forControlEvents:UIControlEventTouchUpInside];
        [_kindButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_searchView addSubview:_kindButton];
    
        _searchBar.layer.masksToBounds = YES;
        _searchBar.layer.cornerRadius = 5.0f;
        _searchView.hidden = YES;
        [self addSubview:_searchView];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, SCREEN_HEIGHT - _segmentedControl.frame.size.height - 20)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        //    [_tableView release];
        _cellCount = 10;
        [[UPNetworkHelper sharedInstance] postSearchHot]; // 完全不需要传值
    }
    return self;
}

- (void)changeTable:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        CGRect rect = _tableView.frame;
        rect.origin.y -= 40;
        _tableView.frame = rect;
    } else {
        if (_allPositionCount == 0) {
            [self requestSearchPositionWithPage:1];
            [self requestSearchPositionWithPage:2];
        }
        CGRect rect = _tableView.frame;
        rect.origin.y += 40;
        _tableView.frame = rect;
        [_searchView setHidden:NO];
    }
    [_tableView reloadData];
}

- (void)onClickKindButton:(UIButton *)sender {
    NSLog(@"分类");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"JobType" object:nil];
}

- (void)requestSearchPositionWithPage:(NSInteger)page {
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInteger:page],@"page", nil];
    [[UPNetworkHelper sharedInstance] postSearchPositionWithDictionary:dict];
    [dict release];
}

- (BOOL)isAllPositionShow {
    if (_segmentedControl.selectedSegmentIndex == 0) {
        return NO;
    }
    return YES;
}

- (void)requestSuccess:(NSDictionary *)responseObject withTag:(NSNumber *)tag {
    NSLog(@"ddddd-->responseObject : %@", responseObject);
    if ([tag integerValue] == Tag_Search_Position) {
        
        if ([[responseObject objectForKey:@"c"] integerValue] == 200) {
            NSDictionary *dict = [responseObject objectForKey:@"d"];
            if (_currentPage < [[dict objectForKey:@"page"] integerValue]) {
                _allPositionCount += [[dict objectForKey:@"count"] integerValue];
                [_allPositions addObjectsFromArray:[dict objectForKey:@"result"]];
                _isExistNextPage = [[dict objectForKey:@"next"] boolValue];
                _currentPage = [[dict objectForKey:@"page"] integerValue];
                _cellCount = _allPositionCount;
                [_tableView reloadData];
            }
        }
    } else if ([tag integerValue] == Tag_Search_Hot) {
        if ([[responseObject objectForKey:@"c"] integerValue] == 200) {
            NSDictionary *dict = [responseObject objectForKey:@"d"];
            if ([_hotPositions count] > 0) {
                [_hotPositions removeAllObjects];
            }
            [_hotPositions addObjectsFromArray:[dict objectForKey:@"positions"]];
            _hotPositionCount = [[dict objectForKey:@"count"] integerValue];
            _cellCount = _hotPositionCount;
            [_tableView reloadData];
        }
    } else if ([tag integerValue] == Tag_Position_Profile) {
        NSLog(@"response : %@", responseObject);
        NSDictionary *responseDict = [[responseObject objectForKey:@"d"] objectForKey:@"profile"];
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[responseDict objectForKey:@"position"],@"positionTitle",[responseDict objectForKey:@"position_desc"],@"positionDesc", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DetailJob" object:nil userInfo:dict];
        [dict release];
        
    }
}

- (void)requestFail:(NSError *)error withTag:(NSNumber *)tag {
    
}

- (void)requestSuccessWithFailMessage:(NSString *)message withTag:(NSNumber *)tag {
    
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *objectDict = nil;
    if ([self isAllPositionShow]) {
        objectDict = [_allPositions objectAtIndex:indexPath.row];
    } else {
        objectDict = [_hotPositions objectAtIndex:indexPath.row];
    }
    [UPNetworkHelper sharedInstance].delegate = self;
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[objectDict objectForKey:@"id"],@"pid", nil];
    [[UPNetworkHelper sharedInstance] postPositionProfileWithDictionary:dict];
    [dict release];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AllPositionsCell"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"AllPositionsCell"] autorelease];
        [cell.textLabel setFont:[UIFont systemFontOfSize:13]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if ([self isAllPositionShow] && indexPath.row == _allPositionCount - 6) {
        if (_isExistNextPage) {
            [self requestSearchPositionWithPage:(_currentPage + 1)];
        }
    }
    if ([self isAllPositionShow]) {
    
        if ([_allPositions count] > 0) {
            NSString *text = [[_allPositions objectAtIndex:indexPath.row] objectForKey:@"position"];
            cell.textLabel.text = text;
        }
    } else {
        if ([_hotPositions count] > 0) {
            cell.textLabel.text = [[_hotPositions objectAtIndex:indexPath.row] objectForKey:@"position"];
        }
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self isAllPositionShow]) {
        return _allPositionCount; // 最后一行放加载更多的cell
    } else {
        return _hotPositionCount;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0f;
}
@end
