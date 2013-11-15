//
//  UPDetailJobViewController.m
//  up
//
//  Created by joy.long on 13-11-15.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPDetailJobViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface UPDetailJobViewController () {
    UIView *_displayView;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.title = @"职位详情";
    [self.navigationController setNavigationBarHidden:NO];
    [self.view setBackgroundColor:[UIColor whiteColor]];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = RGBCOLOR(235.0f, 235.0f, 241.0f);
    
    _displayView  = [[UIView alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 310.0f, 400.0f)];
    [_displayView setBackgroundColor:WhiteColor];
    [self.view addSubview:_displayView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 0.0f, 240.0f, 50.0f)];
    [_titleLabel setBackgroundColor:ClearColor];
    [_titleLabel setTextColor:BlackColor];
    [_titleLabel setText:self.positionTitle];
    [_titleLabel setAdjustsFontSizeToFitWidth:YES];
    [_displayView addSubview:_titleLabel];
    
    _rankLabel = [[UILabel alloc] initWithFrame:CGRectMake(225.0f, 20.0f, 85.0f, 30.0f)];
    [_rankLabel setTextColor:BlueColor];
    [_rankLabel setText:[NSString stringWithFormat:@"%d", self.rankNumber]];
    [_rankLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [_rankLabel setBackgroundColor:ClearColor];
    [self.view addSubview:_rankLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 55.0f, 320.0f, 0.5f)];
    [lineView setBackgroundColor:GrayColor];
    [_displayView addSubview:lineView];
    [lineView release];
    
    UILabel *positionIntroduceTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 70.0f, 70.0f, 20.0f)];
    [positionIntroduceTipLabel setBackgroundColor:ClearColor];
    [positionIntroduceTipLabel setTextColor:GrayColor];
    [positionIntroduceTipLabel setText:@"职位简介"];
    [_displayView addSubview:positionIntroduceTipLabel];
    [positionIntroduceTipLabel release];
    
    _positionIntroduceLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 95.0f, _displayView.frame.size.width - 15.0f, 50.0f)];
    [_positionIntroduceLabel setBackgroundColor:ClearColor];
    [_positionIntroduceLabel setTextColor:GrayColor];
    [_positionIntroduceLabel setText:self.positionDescription];
    [_displayView addSubview:_positionIntroduceLabel];
    //        [_positionIntroduceLabel release];
    
    UILabel *positionRequireTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 155.0f, 70.0f, 20.0f)];
    [positionRequireTipLabel setBackgroundColor:ClearColor];
    [positionRequireTipLabel setTextColor:GrayColor];
    [positionRequireTipLabel setText:@"技能需求"];
    [_displayView addSubview:positionRequireTipLabel];
    [positionRequireTipLabel release];
    
    _positionRequireLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 180.0f, _displayView.frame.size.width - 15.0f, 50.0f)];
    [_positionRequireLabel setBackgroundColor:ClearColor];
    [_positionRequireLabel setTextColor:GrayColor];
    [_displayView addSubview:_positionRequireLabel];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button setBackgroundColor:BaseColor];
    [_button setTitle:@"应聘此职位" forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(onClickSelectJobButton:) forControlEvents:UIControlEventTouchUpInside];
    [_button setTitleColor:WhiteColor forState:UIControlStateNormal];
    [_button setFrame:CGRectMake(0, _displayView.frame.size.height - 30, _displayView.frame.size.width, 50)];
    [_displayView addSubview:_button];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_displayView release];
    _displayView = nil;
    [super dealloc];
}

- (void)updateInformation:(NSString *)title introduce:(NSString *)introduceStr requireAbility:(NSString *)requireAblityStr JobRankNumber:(NSNumber *)jobRankNumber; {
    [_titleLabel setText:title];
    _rankLabel.text = [NSString stringWithFormat:@"当前排名：%@", jobRankNumber];
    _positionIntroduceLabel.text = introduceStr;
    _positionRequireLabel.text = requireAblityStr;
    
}

- (void)onClickSelectJobButton:(UIButton *)sender {
    NSLog(@"应聘该职位");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Test" object:nil];
}

@end

