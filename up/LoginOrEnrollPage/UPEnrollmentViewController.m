//
//  UPEnrollmentViewController.m
//  up
//
//  Created by joy.long on 13-10-30.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPEnrollmentViewController.h"

@interface UPEnrollmentViewController (){
    
}

@end

@implementation UPEnrollmentViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    UPSearchResultManager *a = [[UPSearchResultManager alloc] init];
//    [a defaultDB];
//    [a release];
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
