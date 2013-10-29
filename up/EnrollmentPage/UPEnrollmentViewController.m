//
//  UPEnrollmentViewController.m
//  up
//
//  Created by joy.long on 13-10-28.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPEnrollmentViewController.h"

#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define SearchBarWidth (160.0f)
#define SearchBarHeight (50.0f)

@interface UPEnrollmentViewController ()<UISearchBarDelegate, UISearchDisplayDelegate>
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) UITableView *tableView;
@end

@implementation UPEnrollmentViewController
@synthesize searchBar = _searchBar;
@synthesize tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//- (id)init {
//    self = [super init];
//    if (self) {
//        
//    }
//    return self;
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _searchBar  = [[UISearchBar alloc] init];
    [_searchBar setBackgroundColor:[UIColor clearColor]];
    [_searchBar setBarStyle:UIBarStyleBlack];
//    [_searchBar setFrame:CGRectMake((ScreenWidth - SearchBarWidth) / 2.0 , (ScreenHeight - SearchBarHeight) / 2 ,SearchBarWidth, SearchBarHeight)];
    [self.searchBar setPlaceholder:@"Search"];// 搜索框的占位符
    [self.searchBar setPrompt:@"Prompt"];// 顶部提示文本,相当于控件的Title
//    [self.searchBar setBarStyle:UIBarMetricsDefault];// 搜索框样式
    [self.searchBar setTintColor:[UIColor blackColor]];// 搜索框的颜色，当设置此属性时，barStyle将失效
    [self.searchBar setTranslucent:YES];// 设置是否透明
    [self.searchBar setBackgroundImage:[UIImage imageNamed:@"image0"]];// 设置背景图片
    [self.searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"image3"] forState:UIControlStateNormal];// 设置搜索框中文本框的背景
    [self.searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"image0"] forState:UIControlStateHighlighted];
    [self.searchBar setSearchFieldBackgroundPositionAdjustment:UIOffsetMake(30, 30)];// 设置搜索框中文本框的背景的偏移量
//    [self.searchBar setSearchFieldBackgroundImage:nil forState:UIControlStateNormal];
    [self.searchBar setSearchResultsButtonSelected:NO];// 设置搜索结果按钮是否选中
    [self.searchBar setShowsSearchResultsButton:YES];// 是否显示搜索结果按钮
    
    [self.searchBar setSearchTextPositionAdjustment:UIOffsetMake(30, 0)];// 设置搜索框中文本框的文本偏移量
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [view setBackgroundColor:[UIColor redColor]];
    [self.searchBar setInputAccessoryView:view];// 提供一个遮盖视图
    [self.searchBar setKeyboardType:UIKeyboardTypeEmailAddress];// 设置键盘样式
    
    // 设置搜索框下边的分栏条
    [self.searchBar setShowsScopeBar:YES];// 是否显示分栏条
    [self.searchBar setScopeButtonTitles:[NSArray arrayWithObjects:@"Singer",@"Song",@"Album", nil]];// 分栏条，栏目
    [self.searchBar setScopeBarBackgroundImage:[UIImage imageNamed:@"image3"]];// 分栏条的背景颜色
    [self.searchBar setSelectedScopeButtonIndex:1];// 分栏条默认选中的按钮的下标
    
    
    [self.searchBar setShowsBookmarkButton:YES];// 是否显示右侧的“书图标”
    
    [self.searchBar setShowsCancelButton:YES];// 是否显示取消按钮
    [self.searchBar setShowsCancelButton:YES animated:YES];
    
    // 是否提供自动修正功能（这个方法一般都不用的）
    [self.searchBar setSpellCheckingType:UITextSpellCheckingTypeYes];// 设置自动检查的类型
    [self.searchBar setAutocorrectionType:UITextAutocorrectionTypeDefault];// 是否提供自动修正功能，一般设置为UITextAutocorrectionTypeDefault
    
    self.searchBar.delegate = self;// 设置代理
    [self.searchBar sizeToFit];
//    myTableView.contentInset = UIEdgeInsetsMake(CGRectGetHeight(self.searchBar.bounds), 0, 0, 0);
    
    
    
    [self.view addSubview:_searchBar];
//    [_searchBar release];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
