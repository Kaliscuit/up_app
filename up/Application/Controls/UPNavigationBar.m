//
//  UPNavigationBar.m
//  up
//
//  Created by joy.long on 13-12-3.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPNavigationBar.h"

#define Width_Label 50.0f
#define Height_Label 44.0f

@interface UPNavigationBar()
    @property(nonatomic, strong) UIButton *leftButton;
    @property(nonatomic, strong) UILabel *titleLabel;
    @property(nonatomic, strong) UIButton *rightButton;


@end
@implementation UPNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setFrame:CGRectMake(0, 0, Width_Label, Height_Label)];
        [self addSubview:_leftButton];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(Width_Label, 0, SCREEN_WIDTH - 2 * Width_Label, Height_Label)];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_titleLabel];
        
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setFrame:CGRectMake(320 - Width_Label, 0, Width_Label, Height_Label)];
        [self addSubview:_rightButton];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5f, SCREEN_WIDTH, 0.5f)];
        [lineView setBackgroundColor:GrayColor];
        [self addSubview:lineView];
    }
    return self;
}

+ (UPNavigationBar *)NavigationBarConfig:(UIViewController *)viewController title:(NSString *)title leftImage:(UIImage *)leftImage leftTitle:(NSString *)leftTitle leftSelector:(SEL)leftSelector rightImage:(UIImage *)rightImage rightTitle:(NSString *)rightTitle rightSelector:(SEL)rightSelector {
    UPNavigationBar *navigationBar = [[UPNavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    if (title.length > 0) {
        navigationBar.titleLabel.text = title;
    }
    if (leftSelector) {
        if (leftImage) {
            [navigationBar.leftButton setImage:leftImage forState:UIControlStateNormal];
            [navigationBar.leftButton addTarget:viewController action:leftSelector forControlEvents:UIControlEventTouchUpInside];
        } else if (leftTitle) {
            [navigationBar.leftButton setTitle:leftTitle forState:UIControlStateNormal];
            [navigationBar.leftButton addTarget:viewController action:leftSelector forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    if (rightSelector) {
        if (leftImage) {
            [navigationBar.rightButton setImage:rightImage forState:UIControlStateNormal];
            [navigationBar.rightButton addTarget:viewController action:rightSelector forControlEvents:UIControlEventTouchUpInside];
        } else if (leftTitle) {
            [navigationBar.rightButton setTitle:rightTitle forState:UIControlStateNormal];
            [navigationBar.rightButton addTarget:viewController action:rightSelector forControlEvents:UIControlEventTouchUpInside];
        }
    }
    [viewController.navigationController.navigationBar addSubview:navigationBar];
    return navigationBar;
}
@end
