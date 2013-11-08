//
//  UPLoginOrEnrollViewControllerBase.m
//  up
//
//  Created by joy.long on 13-11-7.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPLoginOrEnrollViewControllerBase.h"
#import "UPTextField.h"
#import "CommonDefine.h"

@implementation UPLoginOrEnrollViewControllerBase

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.view.backgroundColor = [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:241.0f/255.0f alpha:1.0];
    
    _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, 300, 30)];
    [_messageLabel setBackgroundColor:[UIColor clearColor]];
    [_messageLabel setFont:[UIFont systemFontOfSize:16]];
    [_messageLabel setTextColor:[UIColor blackColor]];
    [self.view addSubview:_messageLabel];
    
    
    _textField = [[UPTextField alloc] initWithFrame:CGRectMake(0, 80, 320, 40)];
    [_textField setBackgroundColor:[UIColor whiteColor]];
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.delegate = self;
    [self.view addSubview:_textField];
   
    
    _nextStepButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextStepButton setFrame:CGRectMake(0, 180, 320, 50)];
    [_nextStepButton setBackgroundColor:BaseColor];
    [_nextStepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextStepButton addTarget:self action:@selector(onClickNextStepButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextStepButton];
    
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_indicatorView setCenter:CGPointMake(300, 100)];
    [_indicatorView setHidesWhenStopped:YES];
    [_indicatorView setHidden:YES];
    [self.view addSubview:_indicatorView];
   
    
    [_textField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.5];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self onClickNextStepButton:nil];
    return YES;
}

- (void)onClickNextStepButton:(id)sender {
    
}

- (void)dealloc {
    [_messageLabel release];
    [_textField release];
    [_nextStepButton release];
    [_indicatorView release];
    [super dealloc];
}
@end
