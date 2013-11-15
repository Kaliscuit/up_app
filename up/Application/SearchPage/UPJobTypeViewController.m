//
//  UPJobTypeViewController.m
//  up
//
//  Created by joy.long on 13-11-15.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPJobTypeViewController.h"

@interface UPJobTypeViewController ()

@end

@implementation UPJobTypeViewController

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

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(onClickYesBarItem:)];
    self.navigationItem.rightBarButtonItem =item;
    
    self.title = @"类别";
    [self.navigationController setNavigationBarHidden:NO];
    [self.view setBackgroundColor:[UIColor whiteColor]];
	// Do any additional setup after loading the view.
}

- (void)onClickYesBarItem:(id)sender {
    NSLog(@"确定");
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
