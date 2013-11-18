//
//  UPLoginOrEnrollViewControllerBase.h
//  up
//
//  Created by joy.long on 13-11-7.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPTextField.h"

#define Tag_TextField_Name 1111
#define Tag_TextField_Password 2222
@interface UPLoginOrEnrollViewControllerBase : UIViewController<UITextFieldDelegate>

@property (nonatomic, retain) UPTextField *textFieldName;
@property (nonatomic, retain) UIActivityIndicatorView *indicatorView;
@property (nonatomic, retain) UILabel *messageLabel;
@property (nonatomic, retain) UIButton *nextStepButton;
@property (nonatomic, retain) UPTextField *textFieldPassword;
@property (nonatomic) BOOL isEnrollProcess;
@end
