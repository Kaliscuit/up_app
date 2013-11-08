//
//  UPCommonInitMethod.m
//  up
//
//  Created by joy.long on 13-11-5.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPCommonInitMethod.h"

@implementation UPCommonInitMethod

+ (void)initLabel:(UILabel *)label withFrame:(CGRect)rect withText:(NSString *)text withTextColor:(UIColor *)textColor withBackgroundColor:(UIColor *)backgourndColor withFont:(UIFont *)font {
    if (NSStringFromCGRect(rect).length > 0) {
        [label setFrame:rect];
    }
    if (text.length > 0) {
        [label setText:text];
    }
    if (textColor) {
        [label setTextColor:textColor];
    }
    if (backgourndColor) {
        [label setBackgroundColor:backgourndColor];
    }
    if (font) {
        [label setFont:font];
    }
}

+ (void)initButton:(UIButton *)button withFrame:(CGRect)rect withTitle:(NSString *)title withTitleColor:(UIColor *)titleColor withBackgroundColor:(UIColor *)backgroundColor {
    if (NSStringFromCGRect(rect).length > 0) {
        button.frame = rect;
    }
    if (title.length > 0) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    if (titleColor) {
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    }
    if (backgroundColor) {
        [button setBackgroundColor:backgroundColor];
    }
}

+ (void)initButtonWithRadius:(UIButton *)button withCornerRadius:(float)cornerRadius {
    button.layer.masksToBounds = YES;
    if (cornerRadius > 0.0f) {
        button.layer.cornerRadius = cornerRadius;
    }
}
@end
