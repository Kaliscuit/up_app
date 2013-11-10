//
//  UPLoginOrEnrollViewControllerBase.h
//  up
//
//  Created by joy.long on 13-11-7.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPTextField.h"
@interface UPLoginOrEnrollViewControllerBase : UIViewController<UITextFieldDelegate>

@property (nonatomic, retain) UPTextField *textField;
@property (nonatomic, retain) UIActivityIndicatorView *indicatorView;
@property (nonatomic, retain) UILabel *messageLabel;
@property (nonatomic, retain) UIButton *nextStepButton;

@end
