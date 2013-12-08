//
//  UPCourseClassViewController.m
//  up
//
//  Created by joy.long on 13-12-7.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPCourseClassViewController.h"
#import "UPNavigationBar.h"
#import "UPCourseTableViewCell.h"
#import "UPCourseDetailViewController.h"

@interface UPCourseClassViewController ()<UITableViewDelegate, UITableViewDataSource> {
    NSArray *_array;
    NSArray *_titleArray;
}

@end

@implementation UPCourseClassViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UPNavigationBar NavigationBarConfigWithBackButton:self title:self.navigationTitle isLightBackground:NO leftSelector:@selector(onClickBackButton:)];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:RGBCOLOR(236.0f, 240.0f, 241.0f)];
    
    _array = [NSArray arrayWithObjects:@"icn_course_C++",@"icn_course_exam",@"icn_course_html5",@"icn_course_JS",@"icn_course_php",@"icn_course_ruby", nil];
    _titleArray = [NSArray arrayWithObjects:@"考试专区",@"HTML/CSS系列",@"JavaScript系列",@"PHP系列",@"Ruby系列",@"C++系列", nil];
    
    
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

- (void)onClickBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
//    cell.courseDetailLabel.text = [_detailArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UPCourseTableViewCell *cell = (UPCourseTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    UPCourseDetailViewController *detailViewController = [[UPCourseDetailViewController alloc] init];
    detailViewController.navigationTitle = cell.courseTitleLabel.text;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0f;
}
@end
