//
//  UPCommonInitMethod.h
//  up
//
//  Created by joy.long on 13-11-5.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface UPCommonInitMethod : NSObject

+ (void)initLabel:(UILabel *)label withFrame:(CGRect)rect withText:(NSString *)text withTextColor:(UIColor *)textColor withBackgroundColor:(UIColor *)backgourndColor withFont:(UIFont *)font;

+ (void)initButton:(UIButton *)button withFrame:(CGRect)rect withTitle:(NSString *)title withTitleColor:(UIColor *)titleColor withBackgroundColor:(UIColor *)backgroundColor;

+ (void)initButtonWithRadius:(UIButton *)button withCornerRadius:(float)cornerRadius;
@end
