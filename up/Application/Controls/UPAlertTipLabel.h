//
//  UPAlertTipLabel.h
//  up
//
//  Created by joy.long on 13-11-16.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UPAlertTipLabel : UIView {
    CGSize _labelSize;
    UILabel *_label;
}

@property (nonatomic, assign) CGPoint point;
@property (nonatomic, assign) BOOL isAssignBottom;
@property (nonatomic, copy) NSString *title;

- (void)updateTitle:(NSString *)title Point:(CGPoint )point isAssignBottom:(BOOL)isAssignBottom;
@end
