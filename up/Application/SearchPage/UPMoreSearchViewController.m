//
//  UPMoreSearchViewController.m
//  up
//
//  Created by joy.long on 13-11-5.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPMoreSearchViewController.h"
#import "CommonDefine.h"
#import "UPNetworkHelper.h"

@interface UPMoreSearchViewController ()<UITableViewDataSource, UITableViewDelegate, UPNetworkHelperDelegate> {
    NSInteger _allPositionCount;
    NSInteger _cellCount;
    NSInteger _currentPage;
    NSMutableArray *_allPositions;
    BOOL _isExistNextPage;
    NSMutableArray *_hotPositions;
    NSInteger _hotPositionCount;
    UITableView *_tableView;
    
    UISegmentedControl *_segmentedControl;
    
}

@end

@implementation UPMoreSearchViewController

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

    [UPNetworkHelper sharedInstance].delegate = self;
    _allPositions = [[NSMutableArray alloc] init];
    _hotPositions = [[NSMutableArray alloc] init];
    
    self.view.backgroundColor = [UIColor whiteColor];

    NSArray *segmentedArray = [[NSArray alloc] initWithObjects:@"Top 10",@"所有职业", nil];
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    [segmentedArray release];
    
    [_segmentedControl setFrame:CGRectMake(50, 20, 220, 30)];
    [_segmentedControl setTintColor:BaseColor];
    [_segmentedControl addTarget:self action:@selector(changeTable:) forControlEvents:UIControlEventValueChanged];
    _segmentedControl.selectedSegmentIndex = 2;
    [_segmentedControl setSelectedSegmentIndex:0];
    [_segmentedControl setSegmentedControlStyle:UISegmentedControlStyleBordered];
    [_segmentedControl setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_segmentedControl];
//    [_segmentedControl release];
    
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _segmentedControl.frame.size.height + 20, 320, ScreenHeight - _segmentedControl.frame.size.height - 20)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
//    [_tableView release];
    _cellCount = 10;
    [[UPNetworkHelper sharedInstance] postSearchHot]; // 完全不需要传值
    
}

- (void)changeTable:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
//        [_tableView reloadData];
//        _cellCount = 10;
//        [[UPNetworkHelper sharedInstance] postSearchHot]; // 完全不需要传值
    } else {
        if (_allPositionCount == 0) {
            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInteger:1],@"page", nil];
            [[UPNetworkHelper sharedInstance] postSearchPositionWithDictionary:dict];
            [dict release];
        }
//        _cellCount = _allPositionCount;
    }
    [_tableView reloadData];
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
    }
}

- (void)requestFail:(NSError *)error withTag:(NSNumber *)tag {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AllPositionsCell"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AllPositionsCell"] autorelease];
    }
    if (_segmentedControl.selectedSegmentIndex != 0) {
        if ([_allPositions count] > 0) {
            cell.textLabel.text = [[_allPositions objectAtIndex:indexPath.row] objectForKey:@"position"];
        }
    } else {
        if ([_hotPositions count] > 0) {
            cell.textLabel.text = [[_hotPositions objectAtIndex:indexPath.row] objectForKey:@"position"];
        }
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _cellCount;
}
@end
