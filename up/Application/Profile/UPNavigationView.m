//
//  UPNavigationView.m
//  up
//
//  Created by joy.long on 13-12-13.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPNavigationView.h"
#import "UIImageView+AFNetworking.h"
#import "UPProcessingLineView.h"
#import <QuartzCore/QuartzCore.h>

@interface UPNavigationView() <UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray *_keyArray;
    NSMutableDictionary *_keyDict;
}

@end
@implementation UPNavigationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = GrayColor;
        
        _keyArray = [NSMutableArray arrayWithObjects:@"MyCourse",@"SearchPosition",@"AllPosition",@"AllCourse", nil];
        _keyDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                    @"我的课程",@"MyCourse",
                    @"搜索职位",@"SearchPosition",
                    @"全部职位",@"AllPosition",
                    @"全部课程",@"AllCourse",
                    nil];
        UIImageView *_logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 40, 60, 60)];
        NSString *urlStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserProfile_avatar"];
        [_logoImage setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"Thumbnail_64.png"]];
        [self addSubview:_logoImage];
        _logoImage.layer.masksToBounds = YES;
        _logoImage.layer.cornerRadius = 30;
        
        UILabel *_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 45, 200, 30)];
        [_titleLabel setFont:[UIFont systemFontOfSize:17]];
        [_titleLabel setTextColor:WhiteColor];
        [_titleLabel setText:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserProfile_name"]];
        [self addSubview:_titleLabel];
        
        UPProcessingLineView *lineView = [[UPProcessingLineView alloc] initWithFrame:CGRectMake(95, 85, 125, 15)];
        [lineView updateLevel:0.5];
        [self addSubview:lineView];
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH - 50, SCREEN_HEIGHT - 120)];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView setBackgroundColor:ClearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:tableView];
    }
    return self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[_keyArray objectAtIndex:indexPath.row] isEqualToString:@"SearchPosition"]) {
        if (self.superview.tag == 1111) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPopFromProfileToHome object:nil];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_keyArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NavigationViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NavigationViewCell"];
        [cell setBackgroundColor:ClearColor];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        UILabel *_label = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, SCREEN_WIDTH - 120 - 30, 80)];
        [_label setFont:[UIFont systemFontOfSize:17]];
        [_label setBackgroundColor:ClearColor];
        [_label setTag:8789];
        [_label setTextColor:ColorWithWhiteAlpha(1.0f, 0.3f)];
        [cell addSubview:_label];
    }
    [((UILabel *)[cell viewWithTag:8789]) setText:[_keyDict objectForKey:[_keyArray objectAtIndex:indexPath.row]]];
    
    return cell;
}
@end
