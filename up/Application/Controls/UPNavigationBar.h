//
//  UPNavigationBar.h
//  up
//
//  Created by joy.long on 13-12-3.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UPNavigationBar : UIView

+ (UPNavigationBar *)NavigationBarConfig:(UIViewController *)viewController title:(NSString *)title leftImage:(UIImage *)leftImage leftTitle:(NSString *)leftTitle leftSelector:(SEL)leftSelector rightImage:(UIImage *)rightImage rightTitle:(NSString *)rightTitle rightSelector:(SEL)rightSelector isLightBackground:(BOOL)isLightBackground;

+ (UPNavigationBar *)NavigationBarConfigWithBackButton:(UIViewController *)viewController title:(NSString *)title isLightBackground:(BOOL)isLightBackground leftSelector:(SEL)leftSelector;
@end
