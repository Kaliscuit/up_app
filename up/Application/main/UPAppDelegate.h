//
//  UPAppDelegate.h
//  up
//
//  Created by joy.long on 13-10-28.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPHomeViewController.h"

@interface UPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UPHomeViewController *homeViewController;
@property (nonatomic, strong) UINavigationController *homeNavigationController;
@end
