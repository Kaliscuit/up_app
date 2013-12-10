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
        [self setBackgroundColor:BaseColor];
        
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setFrame:CGRectMake(0, 20, Width_Label, Height_Label)];
        [self addSubview:_leftButton];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(Width_Label, 20, SCREEN_WIDTH - 2 * Width_Label, Height_Label)];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_titleLabel];
        
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setFrame:CGRectMake(320 - Width_Label, 20, Width_Label, Height_Label)];
        [self addSubview:_rightButton];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 63.5f, SCREEN_WIDTH, 0.5f)];
        [lineView setBackgroundColor:GrayColor];
        [self addSubview:lineView];
    }
    return self;
}

+ (UPNavigationBar *)NavigationBarConfig:(UIViewController *)viewController title:(NSString *)title leftImage:(UIImage *)leftImage leftTitle:(NSString *)leftTitle leftSelector:(SEL)leftSelector rightImage:(UIImage *)rightImage rightTitle:(NSString *)rightTitle rightSelector:(SEL)rightSelector isLightBackground:(BOOL)isLightBackground {
    
    [viewController.navigationController setNavigationBarHidden:YES];
    viewController.navigationItem.hidesBackButton = YES;
    
    UPNavigationBar *navigationBar = [[UPNavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    
    if (isLightBackground) {
        [navigationBar.rightButton setTitleColor:BaseGreenColor forState:UIControlStateNormal];
        navigationBar.titleLabel.textColor = BlackColor;
        [navigationBar setBackgroundColor:WhiteColor];
    } else {
        navigationBar.titleLabel.textColor = WhiteColor;
        [navigationBar setBackgroundColor:BaseColor];
    }
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
        if (rightImage) {
            [navigationBar.rightButton setImage:rightImage forState:UIControlStateNormal];
            [navigationBar.rightButton addTarget:viewController action:rightSelector forControlEvents:UIControlEventTouchUpInside];
        } else if (rightTitle) {
            [navigationBar.rightButton setTitle:rightTitle forState:UIControlStateNormal];
            [navigationBar.rightButton addTarget:viewController action:rightSelector forControlEvents:UIControlEventTouchUpInside];
        }
    }
    [navigationBar removeExistedNavigationBar:viewController];
    
    [viewController.view addSubview:navigationBar];
    return navigationBar;
}

+ (UPNavigationBar *)NavigationBarConfigWithBackButton:(UIViewController *)viewController title:(NSString *)title isLightBackground:(BOOL)isLightBackground leftSelector:(SEL)leftSelector {
    if (isLightBackground) {
        return [UPNavigationBar NavigationBarConfig:viewController title:title leftImage:[UIImage imageNamed:@"icn_back.png"] leftTitle:nil leftSelector:leftSelector rightImage:nil rightTitle:nil rightSelector:nil isLightBackground:isLightBackground];
    } else {
        return [UPNavigationBar NavigationBarConfig:viewController title:title leftImage:[UIImage imageNamed:@"icn_back_white.png"] leftTitle:nil leftSelector:leftSelector rightImage:nil rightTitle:nil rightSelector:nil isLightBackground:isLightBackground];
    }
}

+ (UPNavigationBar *)NavigationBarConfigInProfile:(UIViewController *)viewController title:(NSString *)title leftSelector:(SEL)leftSelector rightSelector:(SEL)rightSelector {
    return [UPNavigationBar NavigationBarConfig:viewController title:title leftImage:[UIImage imageNamed:@"icn_nav_white.png"] leftTitle:nil leftSelector:leftSelector rightImage:[UIImage imageNamed:@"icn_setting_white.png"] rightTitle:nil rightSelector:rightSelector isLightBackground:NO];
}

+ (UPNavigationBar *)NavigationBarConfigWithBackButtonAndRightTitle:(UIViewController *)viewController title:(NSString *)title leftSelector:(SEL)leftSelector rightTitle:(NSString *)rightTitle rightSelector:(SEL)rightSelector {
    return [UPNavigationBar NavigationBarConfig:viewController title:title leftImage:[UIImage imageNamed:@"icn_back.png"] leftTitle:nil leftSelector:leftSelector rightImage:nil rightTitle:rightTitle rightSelector:rightSelector isLightBackground:YES];
}

- (void)removeExistedNavigationBar:(UIViewController *)viewController {
    for (UIView * sender in viewController.navigationController.navigationBar.subviews) {
        if ([sender isKindOfClass:[UPNavigationBar class]]) {
            [sender removeFromSuperview];
            break;
        }
    }
}
@end
