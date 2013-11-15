//
//  UPTextField.m
//  up
//
//  Created by joy.long on 13-11-7.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPTextField.h"
#import "UPCommonHelper.h"

@implementation UPTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    [super placeholderRectForBounds:bounds];
    if (![UPCommonHelper isIOS7]) {
        return CGRectMake(bounds.origin.x + 10, 10, bounds.size.width, bounds.size.height);
    }
    return CGRectInset(bounds, 10, 0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    [super editingRectForBounds:bounds];
    if (![UPCommonHelper isIOS7]) {
        return CGRectMake(bounds.origin.x + 10, 10, bounds.size.width, bounds.size.height);
    }
    return CGRectInset(bounds, 10, 0);
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    [super editingRectForBounds:bounds];
    if (![UPCommonHelper isIOS7]) {
        return CGRectMake(bounds.origin.x + 10, 10, bounds.size.width, bounds.size.height);
    }
    return CGRectInset(bounds, 10, 0);
}
@end
