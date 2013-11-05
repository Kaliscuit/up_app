//
//  UPMoreSearchViewController.m
//  up
//
//  Created by joy.long on 13-11-5.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPMoreSearchViewController.h"
#import "CommonDefine.h"
@interface UPMoreSearchViewController ()<UITableViewDataSource, UITableViewDelegate>

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
    self.view.backgroundColor = [UIColor whiteColor];

    NSArray *segmentedArray = [[NSArray alloc] initWithObjects:@"Top 10",@"所有职业", nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    [segmentedControl setFrame:CGRectMake(50, 20, 220, 30)];
    [segmentedControl setTintColor:BaseColor];
    [segmentedControl addTarget:self action:@selector(changeTable:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex = 2;
    [segmentedControl setSelectedSegmentIndex:0];
    [segmentedControl setSegmentedControlStyle:UISegmentedControlStyleBordered];
    [segmentedControl setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:segmentedControl];
    [segmentedControl release];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, segmentedControl.frame.size.height + 20, 320, ScreenHeight - segmentedControl.frame.size.height - 20)];
    [self.view addSubview:tableView];
    [tableView release];
    
}

- (void)changeTable:(id)sender {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//
//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleDefault;
//}


@end
