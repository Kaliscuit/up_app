//
//  UPAppDelegate.h
//  up
//
//  Created by joy.long on 13-10-28.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPIndexScrollViewController.h"

@interface UPAppDelegate : UIResponder <UIApplicationDelegate>

@property (retain, nonatomic) UIWindow *window;
@property (nonatomic, retain) UPIndexScrollViewController *indexScrollViewController;
@property (nonatomic, retain) UINavigationController *indexScrollNavigationController;
@end
