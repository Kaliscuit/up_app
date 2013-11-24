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

@property (nonatomic, strong) UPTextField *textFieldName;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, weak) UIButton *nextStepButton;
@property (nonatomic, strong) UPTextField *textFieldPassword;
@property (nonatomic) BOOL isEnrollProcess;
@end
