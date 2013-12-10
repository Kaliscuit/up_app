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
#import "UIImageView+AFNetworking.h"
#import "UPSearchView.h"


#define SearchBarWidth (240.0f)
#define SearchBarHeight (50.0f)

#define SearchBarInitFrame CGRectMake(35, 250, 248, 40)
#define SearchBarEditFrame CGRectMake(10, 24, 248, 30)

#define Text_Search_Dream_Job       @"寻找梦想职业"
#define Text_Browse_All_Course      @"浏览全部课程"

#define Class_Name_All_Course       "UPAllCourseViewController"
#define Class_Name_Profile          "UPProfileViewController"

typedef enum {
    AccountImageTypeUnlogin,
    AccountImageTypeDefaultLogin,
    AccountImageTypeUserCustom,
}AccountImageType;

@interface UPHomeViewController ()<UPNetworkHelperDelegate,UITextFieldDelegate> {
    
    UILabel             *_searchBarBeforeLabel;             // 搜索框上面的label
    UPSearchBar         *_searchBar;                        // 搜索条
    NSMutableArray      *_top10DataArray;                   // 预存Top 10的数据
    UPNetworkHelper     *_networkHelper;
    
    UIView              *_accountView;
    UIImageView         *_accountImageView;
    UILabel             *_accountLabel;
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
    if ([[NSUserDefaults standardUserDefaults] valueForKey:UserDefault_UserName] && [[NSUserDefaults standardUserDefaults] objectForKey:@"Cookie"]) {
        NSHTTPCookie *cookie = [[NSHTTPCookie alloc] initWithProperties:[[NSUserDefaults standardUserDefaults] objectForKey:@"Cookie"]];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        [self _updateUserName:[[NSUserDefaults standardUserDefaults] valueForKey:UserDefault_UserName]];
    } else {
        [self _updateUserName:nil];
    }
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
    [_searchBarBeforeLabel setFrame:CGRectMake(0, 223, SCREEN_WIDTH, 25)];
    [_searchBarBeforeLabel setText:Text_Search_Dream_Job];
    [_searchBarBeforeLabel setTextColor:WhiteColor];
    [_searchBarBeforeLabel setTextAlignment:NSTextAlignmentCenter];
    [_searchBarBeforeLabel setBackgroundColor:ClearColor ];
    [_searchBarBeforeLabel setFont:[UIFont systemFontOfSize:20]];
    [self.view addSubview:_searchBarBeforeLabel];
    
    _accountImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icn_user_white_highlight.png"]];
    [_accountImageView setUserInteractionEnabled:YES];
    _accountImageView.layer.masksToBounds = YES;
    _accountImageView.layer.cornerRadius = 11.0f;
    [_accountImageView setFrame:CGRectMake(SCREEN_WIDTH - 35, 30, 25, 25)];
    [self.view addSubview:_accountImageView];
    
    _accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 150, 30, 110, 25)];
    [_accountLabel setUserInteractionEnabled:YES];
    [_accountLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [_accountLabel setBackgroundColor:ClearColor];
    [_accountLabel setTextAlignment:NSTextAlignmentRight];
    [_accountLabel setTextColor:WhiteColor];
    [self.view addSubview:_accountLabel];
    
    UITapGestureRecognizer *gestureLabel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickAccountView:)];
    [_accountLabel addGestureRecognizer:gestureLabel];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickAccountView:)];
    [_accountImageView addGestureRecognizer:gesture];
    
    UIButton *allCourseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [allCourseButton setFrame:CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44)];
    [allCourseButton setBackgroundColor:RGBCOLOR(32.0f, 116.0f, 169.0f)];
    [allCourseButton setTitleColor:WhiteColor forState:UIControlStateNormal];
    [allCourseButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [allCourseButton setTitle:Text_Browse_All_Course forState:UIControlStateNormal];
    [allCourseButton addTarget:self action:@selector(presentAllCourseViewController:) forControlEvents:UIControlEventTouchUpInside];
    [allCourseButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    UIImageView *array = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icn_home_arrow.png"]];
    [array setFrame:CGRectMake(200, 16, 7, 12)];
    [allCourseButton addSubview:array];
    [self.view addSubview:allCourseButton];
    
    
    _searchBar = [[UPSearchBar alloc] initWithFrame:SearchBarInitFrame];
    [_searchBar.layer setMasksToBounds:YES];
    [_searchBar.layer setCornerRadius:5.0f];
    _searchBar.delegate = self;
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    [_searchBar setBackgroundColor:WhiteColor];
    [self.view addSubview:_searchBar];
    
}

#pragma mark - Notification
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentEnrollmentOrLoginViewController:) name:NotificationPopEnrollmentOrLoginViewController object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentEvaluateViewController:) name:NotificationPopEvaluateViewController object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentDetailJobViewController:) name:NotificationPopDetailJobViewController object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentJobTypeViewController:) name:NotificationPopJobTypeViewController object:nil];
}

- (void)presentAllCourseViewController:(id)sender {
    id class = objc_getClass(Class_Name_All_Course);
    id allCourseViewController = [[class alloc] init];
    [self.navigationController pushViewController:allCourseViewController animated:YES];
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
    description = [description stringByReplacingOccurrencesOfString:@"-" withString:@"\u25cf"];
    detailJobViewController.positionDescription = description;
    
    [self.navigationController pushViewController:detailJobViewController animated:YES];
    
}

- (void)presentJobTypeViewController:(NSNotification *)notification {
    id class = objc_getClass("UPJobTypeViewController");
    id enrollmentViewController = [[class alloc] init];
    [self.navigationController pushViewController:enrollmentViewController animated:YES];
}

- (void)presentEnrollmentOrLoginViewController:(NSNotification *)notification {
    id class = objc_getClass("UPFirstPageLoginOrEnrollViewController");
    id enrollmentViewController = [[class alloc] init];
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
        [self _updaetLoginedAccountImage:YES];
        _accountLabel.text = userName;
    } else {
        [self _updaetLoginedAccountImage:NO];
        _accountLabel.text = nil;
    }
}

- (void)_updaetLoginedAccountImage:(BOOL)isLogined {
    if (isLogined) {
        NSString *url = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserAvatarUrl"];
        if ([url hasPrefix:DefaultAvatarURLPrefix]) {
            [_accountImageView setImage:[UIImage imageNamed:@"Thumbnail_64.png"]];
        } else {
            [_accountImageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"icn_user_white_highlight.png"]];
        }
    } else {
            [_accountImageView setImage:[UIImage imageNamed:@"icn_user_white.png"]];
    }
}

- (void)onClickAccountView:(id)sender {
    if ([[NSUserDefaults standardUserDefaults] valueForKey:UserDefault_UserName] == nil) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPopEnrollmentOrLoginViewController object:nil];
    } else {
        id class = objc_getClass(Class_Name_Profile);
        id profileViewController = [[class alloc] init];
        [self.navigationController pushViewController:profileViewController animated:YES];
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
