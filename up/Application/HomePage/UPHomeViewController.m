//
//  UPHomeViewController.m
//  up
//
//  Created by joy.long on 13-11-30.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPHomeViewController.h"

#import "UPSearchBar.h"
#import <QuartzCore/QuartzCore.h>
#import "UPDetailJobViewController.h"
#import "UPEvaluateBeginViewController.h"
#import <objc/runtime.h>

#import "UPSearchView.h"

#define SearchBarWidth (240.0f)
#define SearchBarHeight (50.0f)

#define SearchBarInitFrame CGRectMake(35, 250, 248, 40)
#define SearchBarEditFrame CGRectMake(10, 24, 248, 30)

@interface UPHomeViewController ()<UPNetworkHelperDelegate,UITextFieldDelegate> {
    
    UILabel             *_searchBarBeforeLabel;             // 搜索框上面的label
    UIButton            *_accountButton;                    // 账号按钮
    UPSearchBar         *_searchBar;                        // 搜索条
    NSMutableArray      *_top10DataArray;                   // 预存Top 10的数据
    UPNetworkHelper     *_networkHelper;
    
    UIView *_accountView;
    UIImageView *_accountImageView;
    UILabel *_accountLabel;
}
@end

@implementation UPHomeViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = BaseColor;
    
    _top10DataArray = [[NSMutableArray alloc] init];
    
    _networkHelper = [[UPNetworkHelper alloc] init];
    _networkHelper.delegate = self;
    [_networkHelper postSearchHot];
    
    [self _initUI];
    [self _initNotification]; // 有可能需要先初始化某些控件，于是在_initUI之后调用
    [self addNotification];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _searchBar = nil;
    _accountButton = nil;
    _searchBarBeforeLabel = nil;
    _top10DataArray = nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Init
- (void)_initNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserName:) name:NotificationUpdateUsername object:nil];
}

- (void)_initUI {
    _searchBarBeforeLabel = [[UILabel alloc] init];
    [_searchBarBeforeLabel setFrame:CGRectMake(36, 223, 150, 25)];
    [_searchBarBeforeLabel setText:@"寻找梦想职业"];
    [_searchBarBeforeLabel setTextColor:WhiteColor];
    [_searchBarBeforeLabel setBackgroundColor:ClearColor ];
    [_searchBarBeforeLabel setFont:[UIFont systemFontOfSize:20]];
    [self.view addSubview:_searchBarBeforeLabel];
    
    _accountImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icn_user_white_highlight.png"]];
    [_accountImageView setFrame:CGRectMake(0, 0, 25, 25)];
    _accountView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 35, 30, 25, 25)];
    [_accountView addSubview:_accountImageView];
    
    _accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_accountLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [_accountLabel setBackgroundColor:ClearColor];
    [_accountLabel setTextAlignment:NSTextAlignmentRight];
    [_accountLabel setTextColor:WhiteColor];
    [_accountView addSubview:_accountLabel];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickAccountView:)];
    [_accountView addGestureRecognizer:gesture];
    [self.view addSubview:_accountView];
    
    _accountButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_accountButton setFrame:CGRectMake(36.0f, (SCREEN_HEIGHT - 90.0f), 100.0f, 40.0f)];
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icn_user_default.png"]];
    [icon setTag:33566];
    [icon setFrame:CGRectMake(10.0f, (_accountButton.frame.size.height - 25) / 2, 25.0f, 25.0f)];
    [_accountButton addSubview:icon];
    
//    [_accountButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
//    [_accountButton setBackgroundColor:WhiteColor];
//    [_accountButton addTarget:self action:@selector(onClickAccountButton:) forControlEvents:UIControlEventTouchUpInside];
//    _accountButton.layer.masksToBounds = YES;
//    _accountButton.layer.cornerRadius = 20.0f;
//    [_accountButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
//    [self.view addSubview:_accountButton];
//    
    
    _searchBar = [[UPSearchBar alloc] initWithFrame:SearchBarInitFrame];
    [_searchBar.layer setMasksToBounds:YES];
    [_searchBar.layer setCornerRadius:5.0f];
    _searchBar.delegate = self;
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    [_searchBar setBackgroundColor:WhiteColor];
    [self.view addSubview:_searchBar];
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:UserDefault_UserName]) {
        [self _updateUserName:[[NSUserDefaults standardUserDefaults] valueForKey:UserDefault_UserName]];
    } else {
        [self _updateUserName:nil];
    }
    
}

#pragma mark - Notification
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentEnrollmentOrLoginViewController:) name:NotificationPopEnrollmentOrLoginViewController object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentEvaluateViewController:) name:NotificationPopEvaluateViewController object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentDetailJobViewController:) name:NotificationPopDetailJobViewController object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentJobTypeViewController:) name:NotificationPopJobTypeViewController object:nil];
}

- (void)presentDetailJobViewController:(NSNotification *)notify {
    NSDictionary *dict = [notify userInfo];
    UPDetailJobViewController *detailJobViewController = [[UPDetailJobViewController alloc] init];
    detailJobViewController.isShowHotImage = [[dict objectForKey:@"hot"] boolValue];
    detailJobViewController.positionTitle = [dict objectForKey:@"position"];
    detailJobViewController.rankNumber = [[dict objectForKey:@"rank"] integerValue];
    detailJobViewController.requirements = [dict objectForKey:@"requirements"];
    detailJobViewController.positionID = [[dict objectForKey:@"id"] integerValue];
    
    NSString *description = [dict objectForKey:@"position_desc"];
    description = [description stringByReplacingOccurrencesOfString:@"-" withString:@"\u25cf "];
    detailJobViewController.positionDescription = description;
    
    [self.navigationController pushViewController:detailJobViewController animated:YES];
    
}

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backTo:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)presentJobTypeViewController:(NSNotification *)notification {
    id class = objc_getClass("UPJobTypeViewController");
    id enrollmentViewController = [[class alloc] init];
    [self.navigationController pushViewController:enrollmentViewController animated:YES];
}

- (void)presentEnrollmentOrLoginViewController:(NSNotification *)notification {
    id class = objc_getClass("UPFirstPageLoginOrEnrollViewController");
    id enrollmentViewController = [[class alloc] init];
//    CATransition* transition = [CATransition animation];
//    transition.duration = 0.5;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionMoveIn;//可更改为其他方式
//    transition.subtype = kCATransitionFromTop;//可更改为其他方式
//    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
//    transition.delegate = self;
    [self.navigationController pushViewController:enrollmentViewController animated:YES];
}

- (void)presentEvaluateViewController:(NSNotification *)notification {
    
    NSDictionary *infoDict = [notification userInfo];
    UPEvaluateBeginViewController *evaluateViewController = [[UPEvaluateBeginViewController alloc] init];
    evaluateViewController.positionTitle = [infoDict objectForKey:@"positionTitle"];
    evaluateViewController.positionID = [[infoDict objectForKey:@"pid"] integerValue];
    [self.navigationController pushViewController:evaluateViewController animated:YES];
}

#pragma mark - 注册登陆之后如果没有选择职位则回到首页
- (void)updateUserName:(NSNotification *)notify {
    [self _updateUserName:[[notify userInfo] objectForKey:@"Nickname"]];
}

- (void)_updateUserName:(NSString *)userName {
    if (userName.length > 0) {
        [_accountImageView setImage:[UIImage imageNamed:@"icn_user_white_highlight.png"]];
        CGRect rect = _accountView.frame;
        rect.origin.x = 170.0f;
        rect.size.width = 140.0f;
        _accountView.frame = rect;
        NSLog(@"ffff-->frame: %@", NSStringFromCGRect(rect));
        _accountLabel.frame = CGRectMake(0, 0, 110, _accountView.frame.size.height);
        _accountImageView.frame = CGRectMake(115, 0, 25, 25);
        _accountLabel.text = userName;
    } else {
        [_accountImageView setImage:[UIImage imageNamed:@"icn_user_white.png"]];
        _accountLabel.frame = CGRectMake(0, 0, 0, 0);
        _accountLabel.text = nil;
        _accountView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - _accountImageView.frame.size.width, 30, _accountImageView.frame.size.width, _accountImageView.frame.size.height)];
    }
}

- (void)onClickAccountView:(id)sender {
    if ([[NSUserDefaults standardUserDefaults] valueForKey:UserDefault_UserName] == nil) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPopEnrollmentOrLoginViewController object:nil];
    }
}

#pragma mark - 开始搜索
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    UPSearchView *view = [[UPSearchView alloc] initWithFrame:self.view.frame];
    view.top10Array = _top10DataArray;
    [self.view addSubview:view];
    return NO;
}

- (void)requestSuccess:(NSDictionary *)responseObject withTag:(NSNumber *)tag {
    if ([tag integerValue] == Tag_Search_Hot) {
        if ([[responseObject objectForKey:@"c"] integerValue] == 200) {
            [_top10DataArray addObjectsFromArray:[[responseObject objectForKey:@"d"] objectForKey:@"positions"]];
            NSLog(@"top10DataArray : %@", _top10DataArray);
        }
    }
}

- (void)requestFail:(NSError *)error withTag:(NSNumber *)tag {
    if ([tag integerValue] == Tag_Search_Hot) {
        
    }
}

- (void)requestSuccessWithFailMessage:(NSString *)message withTag:(NSNumber *)tag {
    if ([tag integerValue] == Tag_Search_Hot) {
        
    }
}

@end
