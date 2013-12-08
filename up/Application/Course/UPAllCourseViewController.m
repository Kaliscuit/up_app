//
//  UPAllCourseViewController.m
//  up
//
//  Created by joy.long on 13-12-7.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPAllCourseViewController.h"
#import "UPNavigationBar.h"
#import "UPCourseTableViewCell.h"
#import "UPCourseClassViewController.h"

@interface UPAllCourseViewController ()<UITableViewDelegate, UITableViewDataSource> {
    NSArray *_array;
    NSArray *_titleArray;
    NSArray *_detailArray;
}

@end

@implementation UPAllCourseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UPNavigationBar NavigationBarConfigWithBackButton:self title:@"所有课程" isLightBackground:NO leftSelector:@selector(onClickBackButton:)];
}

- (void)onClickBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:RGBCOLOR(236.0f, 240.0f, 241.0f)];
    
    _array = [NSArray arrayWithObjects:@"icn_course_C++",@"icn_course_exam",@"icn_course_html5",@"icn_course_JS",@"icn_course_php",@"icn_course_ruby", nil];
    _titleArray = [NSArray arrayWithObjects:@"考试专区",@"HTML/CSS系列",@"JavaScript系列",@"PHP系列",@"Ruby系列",@"C++系列", nil];
    
    _detailArray = [NSArray arrayWithObjects:@"最新上线软考课程",@"包含10门课程",@"包含10门课程",@"包含10门课程",@"包含10门课程",@"包含10门课程", nil];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT - 44)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView setBackgroundColor:self.view.backgroundColor];
    [self.view addSubview:tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UPCourseTableViewCell *cell = (UPCourseTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSString *title = cell.courseTitleLabel.text;
    UPCourseClassViewController *viewController = [[UPCourseClassViewController alloc] init];
    viewController.navigationTitle = title;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UPCourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AllCourseCell"];
    if (cell == nil) {
        cell = [[UPCourseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AllCourseCell"];
    }
    if (indexPath.row == 0) {
        cell.isDetailHighlight = YES;
    } else {
        cell.isDetailHighlight = NO;
    }
    [cell.logoImage setImage:[UIImage imageNamed:[_array objectAtIndex:indexPath.row]]];
    cell.courseTitleLabel.text = [_titleArray objectAtIndex:indexPath.row];
    cell.courseDetailLabel.text = [_detailArray objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_array count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0f;
}
@end
