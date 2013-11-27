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
#import <QuartzCore/QuartzCore.h>
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
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.view.backgroundColor = RGBCOLOR(235.0f, 235.0f, 2241.0f);
    
    _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 300, 30)];
    [_messageLabel setBackgroundColor:ClearColor];
    [_messageLabel setFont:[UIFont systemFontOfSize:14]];
    [_messageLabel setTextColor:BlackColor];
    [self.view addSubview:_messageLabel];
   
    _textFieldName = [[UPTextField alloc] initWithFrame:CGRectMake(0, 57, 320, 40)];
    [_textFieldName setBackgroundColor:WhiteColor];
    _textFieldName.tag = Tag_TextField_Name;
    _textFieldName.layer.borderWidth = 0.5f;
    _textFieldName.layer.borderColor = [RGBCOLOR(200.0f, 199.0f, 204.0f) CGColor];
    _textFieldName.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textFieldName.autocapitalizationType = NO;
    _textFieldName.delegate = self;
    [_textFieldName setKeyboardType:UIKeyboardTypeEmailAddress];
    [self.view addSubview:_textFieldName];
    
    _nextStepButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextStepButton setFrame:CGRectMake(0, 147, 320, 50)];
    [_nextStepButton setBackgroundColor:BaseColor];
    [_nextStepButton setTitleColor:WhiteColor forState:UIControlStateNormal];
    [_nextStepButton addTarget:self action:@selector(onClickNextStepButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextStepButton];
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_indicatorView setCenter:CGPointMake(300, 77)];
    [_indicatorView setHidesWhenStopped:YES];
    [_indicatorView setHidden:YES];
    [self.view addSubview:_indicatorView];

    
    [self updateUIPosition];

    
    [_textFieldName performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.5];
}
- (void)updateUIPosition {
    if (_isEnrollProcess) {
        _textFieldPassword = [[UPTextField alloc] initWithFrame:CGRectMake(0.0f, 96.5f, 320.0f, 40.0f)];
        [_textFieldPassword setBackgroundColor:WhiteColor];
        _textFieldPassword.layer.borderWidth = 0.5f;
        _textFieldPassword.tag = Tag_TextField_Password;
        _textFieldPassword.layer.borderColor = [RGBCOLOR(200.0f, 199.0f, 204.0f) CGColor];
        _textFieldPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textFieldPassword.autocapitalizationType = NO;
        _textFieldPassword.delegate = self;
        [_textFieldPassword setKeyboardType:UIKeyboardTypeEmailAddress];
        [self.view addSubview:_textFieldPassword];
        
        if ([UPCommonHelper isLongScreen]) {
            [_textFieldPassword setFrame:CGRectMake(0, 120.0f, 320.0f, 40.0f)];
        }
    } else {
        if (![UPCommonHelper isLongScreen]) {
            [_nextStepButton setFrame:CGRectMake(0, 120, 320, 50)];
        }
    }
    if ([UPCommonHelper isLongScreen]) {
        [_messageLabel setFrame:CGRectMake(10, 45, 300, 30)];
        [_textFieldName setFrame:CGRectMake(0, 80, 320, 40)];
        [_nextStepButton setFrame:CGRectMake(0, 200, 320, 50)];
        [_indicatorView setCenter:CGPointMake(300, 100)];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self performSelector:@selector(onClickNextStepButton:) withObject:nil];
    return YES;
}

- (void)onClickNextStepButton:(id)sender {
    
}

- (void)dealloc {
   
    _messageLabel = nil;

    _textFieldName = nil;
    
    _textFieldPassword = nil;
    
    _nextStepButton = nil;
    
    _indicatorView = nil;
    
    _isEnrollProcess = NO;
}
@end
