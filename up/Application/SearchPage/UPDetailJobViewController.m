//
//  UPDetailJobViewController.m
//  up
//
//  Created by joy.long on 13-11-15.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPDetailJobViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UPRotatePieView.h"
#import "UILabel+VerticalAlign.h"
#import "UPNavigationBar.h"

@interface UPDetailJobViewController () {
    
    UIScrollView *_scrollView;
    UIImageView *_hotImageView;
    
    UIButton *_button;
    UILabel *_titleLabel;
    UILabel *_rankLabel;
    
    UILabel *_positionIntroduceLabel;
    UILabel *_positionRequireLabel;
}

@end

@implementation UPDetailJobViewController

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
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [UPNavigationBar NavigationBarConfig:self title:@"职位详情" leftImage:[UIImage imageNamed:@"icn_back.png"] leftTitle:nil leftSelector:@selector(onClickBackButton:) rightImage:nil rightTitle:nil rightSelector:nil];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, 320, SCREEN_HEIGHT - 64)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    _hotImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15.0f, 74.0f, 25.0f, 25.0f)];
    [_hotImageView setBackgroundColor:RGBCOLOR(251.0f, 114.0f, 80.0f)];
    [_hotImageView setHidden:!self.isShowHotImage];
    
    UILabel *hotLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 74.0f, _hotImageView.frame.size.width, _hotImageView.frame.size.height)];
    [hotLabel setBackgroundColor:ClearColor];
    [hotLabel setTextColor:WhiteColor];
    [hotLabel setText:@"热"];
    [hotLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [_hotImageView addSubview:hotLabel];
    [self.view addSubview:_hotImageView];
    

    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 74.0f, 290.0f, 25.0f)];
    [_titleLabel setBackgroundColor:ClearColor];
    [_titleLabel setTextColor:RGBCOLOR(40.0f, 56.0f, 64.0f)];
    [_titleLabel setFont:[UIFont boldSystemFontOfSize:20.0f]];
    [_titleLabel setNumberOfLines:2];
    [self.view addSubview:_titleLabel];
    
    NSString *titleWithBlank = nil;
    if (self.isShowHotImage) {
        titleWithBlank = [NSString stringWithFormat:@"      %@", self.positionTitle];
    } else {
        titleWithBlank = self.positionTitle;
    }
    
    CGSize titleSize = [titleWithBlank boundingRectWithSize:CGSizeMake(_titleLabel.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:NSFontAttributeName,_titleLabel.font, nil] context:nil].size;
    
    if (titleSize.height > _titleLabel.frame.size.height) {
        CGRect rect = _titleLabel.frame;
        rect.size.height = 50.0f;
        [_titleLabel setFrame:rect];
    }
    [_titleLabel setText:titleWithBlank];
    
    _rankLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 10.0f, 290.0f, 15.0f)];
    [_rankLabel setTextColor:RGBCOLOR(126.0f, 210.0f, 236.0f)];
    [_rankLabel setFont:[UIFont systemFontOfSize:11.0f]];
    _rankLabel.text = [NSString stringWithFormat:@"当前排名: %ld", (long)self.rankNumber];
    [_rankLabel setBackgroundColor:ClearColor];
    [self.view addSubview:_rankLabel];
    
    _positionIntroduceLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, _rankLabel.frame.origin.y + _rankLabel.frame.size.height, 290.0f, 100.0f)];
    [_positionIntroduceLabel setBackgroundColor:ClearColor];
    [_positionIntroduceLabel setTextColor:RGBCOLOR(40.0f, 56.0f, 64.0f)];
    [_positionIntroduceLabel setText:self.positionDescription];
    [_positionIntroduceLabel setTextAlignment:NSTextAlignmentNatural];
    [_positionIntroduceLabel setFont:[UIFont systemFontOfSize:15.0]];
    [_positionIntroduceLabel setNumberOfLines:5];
    [_positionIntroduceLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [_positionIntroduceLabel alignTop];
    [self.view addSubview:_positionIntroduceLabel];
    
    UIView *positionRequireView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, _positionIntroduceLabel.frame.origin.y + _positionIntroduceLabel.frame.size.height + 8.0f, SCREEN_WIDTH, 20.0f)];
    positionRequireView.layer.borderWidth = 0.5f;
    positionRequireView.layer.borderColor = [RGBCOLOR(200.0f, 199.0f, 204.0f) CGColor];
    [positionRequireView setBackgroundColor:RGBCOLOR(247.0f, 247.0f, 247.0f)];
    
    UILabel *positionRequireTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 0.0f, SCREEN_WIDTH - 15.0f, 20.0f)];
    [positionRequireTipLabel setBackgroundColor:ClearColor];
    [positionRequireTipLabel setTextColor:RGBCOLOR(51.0f, 51.0f, 51.0f)];
    [positionRequireTipLabel setText:@"技能需求"];
    [positionRequireTipLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [positionRequireView addSubview:positionRequireTipLabel];
    [self.view addSubview:positionRequireView];
    
    UIView *rotateView = [[UIView alloc] initWithFrame:CGRectMake(0, positionRequireView.frame.origin.y + positionRequireView.frame.size.height, 320.0f, 300.0f)];
    UPRotatePieView* pieView = [[UPRotatePieView alloc] initWithFrame:CGRectMake(70.0f, 40.0f, 180.0f, 180.0f)];
    [pieView setBackgroundColor:ClearColor];
    [rotateView addSubview:pieView];
    pieView.itemArray = [NSMutableArray arrayWithObjects:
                         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:10],@"Value", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:10],@"Value", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:10],@"Value", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:10],@"Value", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:10],@"Value", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:10],@"Value", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:10],@"Value", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:10],@"Value", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:10],@"Value", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:10],@"Value", nil],
                         nil];
    pieView.mInfoTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 350, 300, 80)];
    pieView.mInfoTextView.backgroundColor = [UIColor clearColor];
    [pieView.mInfoTextView setText:@"ceshi"];
    pieView.mInfoTextView.editable = NO;
    pieView.mInfoTextView.userInteractionEnabled = NO;
    [self.view addSubview:rotateView];
    [self.view addSubview:pieView.mInfoTextView];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button setBackgroundColor:BaseGreenColor];
    [_button setTitle:@"应聘此职位" forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(onClickSelectJobButton:) forControlEvents:UIControlEventTouchUpInside];
    [_button setTitleColor:WhiteColor forState:UIControlStateNormal];
    [_button setFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
    [self.view addSubview:_button];
}

- (void)onClickBackButton:(id)sender {
    NSLog(@"back button");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onClickSelectJobButton:(UIButton *)sender {
    NSLog(@"应聘该职位");
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPopEvaluateViewController object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:_positionID],@"pid",_positionTitle,@"positionTitle", nil]];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"没登陆" message:@"没登陆" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:Nil, nil];
        [alert show];
    }
}



- (void)back:(id)sender {
    NSLog(@"1111");
}


@end

