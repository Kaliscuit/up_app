//
//  UPJobDetailView.m
//  up
//
//  Created by joy.long on 13-11-10.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPJobDetailView.h"
#import "CommonDefine.h"
#import <QuartzCore/QuartzCore.h>

@interface UPJobDetailView() {
    UIView *_displayView;
    UIButton *_button;
    UILabel *_titleLabel;
    UILabel *_rankLabel;
    
    UILabel *_positionIntroduceLabel;
    UILabel *_positionRequireLabel;
}

@end

@implementation UPJobDetailView

- (void)dealloc {
    [_displayView release];
    _displayView = nil;
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:241.0f/255.0f alpha:1.0];
        _displayView  = [[UIView alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 310.0f, 400.0f)];
        [_displayView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_displayView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 0.0f, 240.0f, 50.0f)];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setTextColor:[UIColor blackColor]];
        [_titleLabel setAdjustsFontSizeToFitWidth:YES];
        [_displayView addSubview:_titleLabel];
        
        _rankLabel = [[UILabel alloc] initWithFrame:CGRectMake(225.0f, 20.0f, 85.0f, 30.0f)];
        [_rankLabel setTextColor:[UIColor blueColor]];
        [_rankLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_rankLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_rankLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 55.0f, 320.0f, 0.5f)];
        [lineView setBackgroundColor:[UIColor grayColor]];
        [_displayView addSubview:lineView];
        [lineView release];
        
        UILabel *positionIntroduceTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 70.0f, 70.0f, 20.0f)];
        [positionIntroduceTipLabel setBackgroundColor:[UIColor clearColor]];
        [positionIntroduceTipLabel setTextColor:[UIColor grayColor]];
        [positionIntroduceTipLabel setText:@"职位简介"];
        [_displayView addSubview:positionIntroduceTipLabel];
        [positionIntroduceTipLabel release];
        
        _positionIntroduceLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 95.0f, _displayView.frame.size.width - 15.0f, 50.0f)];
        [_positionIntroduceLabel setBackgroundColor:[UIColor clearColor]];
        [_positionIntroduceLabel setTextColor:[UIColor grayColor]];
//        [_positionIntroduceLabel setText:@"职位简介"];
        [_displayView addSubview:_positionIntroduceLabel];
//        [_positionIntroduceLabel release];
        
        UILabel *positionRequireTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 155.0f, 70.0f, 20.0f)];
        [positionRequireTipLabel setBackgroundColor:[UIColor clearColor]];
        [positionRequireTipLabel setTextColor:[UIColor grayColor]];
        [positionRequireTipLabel setText:@"技能需求"];
        [_displayView addSubview:positionRequireTipLabel];
        [positionRequireTipLabel release];
        
        _positionRequireLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 180.0f, _displayView.frame.size.width - 15.0f, 50.0f)];
        [_positionRequireLabel setBackgroundColor:[UIColor clearColor]];
        [_positionRequireLabel setTextColor:[UIColor grayColor]];
        [_displayView addSubview:_positionRequireLabel];
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setBackgroundColor:BaseColor];
        [_button setTitle:@"应聘此职位" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(onClickSelectJobButton:) forControlEvents:UIControlEventTouchUpInside];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button setFrame:CGRectMake(0, _displayView.frame.size.height - 30, _displayView.frame.size.width, 50)];
        [_displayView addSubview:_button];
        
    }
    return self;
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
