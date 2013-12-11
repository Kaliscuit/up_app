//
//  UPSettingViewController.m
//  up
//
//  Created by joy.long on 13-12-10.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPSettingViewController.h"
#import "UIImageView+AFNetworking.h"
typedef enum {
    CellStylePhoto,
    CellStyleLabel,
    CellStylePassword,
    CellStyleSwitch,
    CellStyleWord,
}CellStyle;

#define Color_Cell_Title RGBCOLOR(61.0f, 61.0f, 61.0f)
#define Tag_Cell_Title_Label        87678
#define Tag_Cell_Detail_Label       866332
@interface UPSettingViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation UPSettingViewController

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
    self.view.backgroundColor = BaseLightBackgroundColor;
    [UPNavigationBar NavigationBarConfigWithBackButtonAndRightTitle:self title:@"设置" leftSelector:@selector(onClickBackButton:) rightTitle:@"完成" rightSelector:@selector(onClickFinishButton:)];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    [tableView setBackgroundColor:BaseLightBackgroundColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    [headerView setBackgroundColor:BaseLightBackgroundColor];
    tableView.tableHeaderView = headerView;
    
    
     UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40.0f)];
    UILabel *_label = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 110, 40.0f)];
    _label.numberOfLines = 2;
    [_label setText:[NSString stringWithFormat:@"UP %@ \n Ⓒ UP 2013-2014", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]];
    [_label setTextAlignment:NSTextAlignmentCenter];
    [_label setFont:[UIFont systemFontOfSize:10.0f]];
    [_label setTextColor:RGBCOLOR(153.0f, 153.0f, 153.0f)];
    [view addSubview:_label];
    tableView.tableFooterView = view;
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

- (void)onClickFinishButton:(id)sender {
    
}

- (UITableViewCell *)cellForStyle:(CellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    UILabel *_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 60)];
    [_titleLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
    [_titleLabel setTextColor:Color_Cell_Title];
    [_titleLabel setTag:Tag_Cell_Title_Label];
    [cell addSubview:_titleLabel];
    if (style == CellStyleWord) {
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    } else if (style == CellStyleSwitch){
        [_titleLabel setFrame:CGRectMake(20, 0, 100, 50)];
        UISwitch *onOff = [[UISwitch alloc] init];
        [onOff setCenter:CGPointMake(280, 25)];
        [onOff setOn:YES];
        [onOff setTag:38835];
        [cell addSubview:onOff];
        
    } else if (style == CellStyleLabel){
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, SCREEN_WIDTH - 120, 60)];
        [detailLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [detailLabel setTextColor:Color_Cell_Title];
        [detailLabel setTag:Tag_Cell_Detail_Label];
        [cell addSubview:detailLabel];
        
    } else if (style == CellStylePassword) {
        [_titleLabel setFrame:CGRectMake(20, 0, 100, 50)];
        
        UITextField *detailTextField = [[UITextField alloc] initWithFrame:CGRectMake(120, 0, SCREEN_WIDTH - 120, 50)];
        [detailTextField setSecureTextEntry:YES];
        [detailTextField setText:@"XXXXXXX"];
        [detailTextField setUserInteractionEnabled:NO];
        [detailTextField setFont:[UIFont systemFontOfSize:15.0f]];
        [detailTextField setTextColor:Color_Cell_Title];
        [detailTextField setTag:Tag_Cell_Detail_Label];
        [cell addSubview:detailTextField];
    } else if (style == CellStylePhoto) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(120, 0, 60, 60)];
        [imageView setTag:2823];
        [cell addSubview:imageView];
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCellPhoto"];
        if (cell == nil) {
            cell = [self cellForStyle:CellStylePhoto reuseIdentifier:@"SettingCellPhoto"];
        }
        ((UILabel *)[cell viewWithTag:Tag_Cell_Title_Label]).text = @"头像";
        NSString *urlStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserProfile_avatar"];
        [((UIImageView *)[cell viewWithTag:2823]) setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"Thumbnail_128.png"]];
    } else if ([indexPath isEqual:[NSIndexPath indexPathForRow:1 inSection:0]]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCellLabel"];
        if (cell == nil) {
            cell = [self cellForStyle:CellStyleLabel reuseIdentifier:@"SettingCellLabel"];
        }
        ((UILabel *)[cell viewWithTag:Tag_Cell_Title_Label]).text = @"用户名";
        ((UILabel *)[cell viewWithTag:Tag_Cell_Detail_Label]).text = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserProfile_name"];
    } else if ([indexPath isEqual:[NSIndexPath indexPathForRow:2 inSection:0]]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCellLabel"];
        if (cell == nil) {
            cell = [self cellForStyle:CellStyleLabel reuseIdentifier:@"SettingCellLabel"];
        }
        ((UILabel *)[cell viewWithTag:Tag_Cell_Title_Label]).text = @"邮箱";
        ((UILabel *)[cell viewWithTag:Tag_Cell_Detail_Label]).text = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserProfile_email"];
    } else if ([indexPath isEqual:[NSIndexPath indexPathForRow:3 inSection:0]]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CellStylePassword"];
        if (cell == nil) {
            cell = [self cellForStyle:CellStylePassword reuseIdentifier:@"CellStylePassword"];
        }
        ((UILabel *)[cell viewWithTag:Tag_Cell_Title_Label]).text = @"密码";
    } else if ([indexPath isEqual:[NSIndexPath indexPathForRow:0 inSection:1]]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCellSwitch"];
        if (cell == nil) {
            cell = [self cellForStyle:CellStyleSwitch reuseIdentifier:@"SettingCellSwitch"];
        }
        ((UILabel *)[cell viewWithTag:Tag_Cell_Title_Label]).text = @"推送";
    } else if ([indexPath isEqual:[NSIndexPath indexPathForRow:1 inSection:1]]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCellSwitch"];
        if (cell == nil) {
            cell = [self cellForStyle:CellStyleSwitch reuseIdentifier:@"SettingCellSwitch"];
        }
        ((UILabel *)[cell viewWithTag:Tag_Cell_Title_Label]).text = @"提醒音效";
    } else if ([indexPath isEqual:[NSIndexPath indexPathForRow:0 inSection:2]]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCellWord"];
        if (cell == nil) {
            cell = [self cellForStyle:CellStyleWord reuseIdentifier:@"SettingCellWord"];
        }
        ((UILabel *)[cell viewWithTag:Tag_Cell_Title_Label]).text = @"发送反馈";
    } else if ([indexPath isEqual:[NSIndexPath indexPathForRow:1 inSection:2]]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCellWord"];
        if (cell == nil) {
            cell = [self cellForStyle:CellStyleWord reuseIdentifier:@"SettingCellWord"];
        }
        ((UILabel *)[cell viewWithTag:Tag_Cell_Title_Label]).text = @"注销登录";
    }
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    } else {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.0f;
    }
    return 20.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 60.0f;
    } else {
        return 50.0f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    [view setBackgroundColor:BaseLightBackgroundColor];
    return view;
}
@end
