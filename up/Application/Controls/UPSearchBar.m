//
//  UPSearchBar.m
//  up
//
//  Created by joy.long on 13-10-29.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPSearchBar.h"
#import "UPCommonHelper.h"

@interface UPSearchBar()

@end

@implementation UPSearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _leftIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icn_finder.png"]];
        self.leftView = _leftIcon;
        [self setLeftViewMode:UITextFieldViewModeAlways];
    }
    return self;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    [super editingRectForBounds:bounds];
    return CGRectInset(bounds, 30, 5);
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    [super placeholderRectForBounds:bounds];
    return CGRectInset(bounds, 30, 8);
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    [super textRectForBounds:bounds];
    return CGRectInset(bounds, 30, 5);
}

- (void)drawPlaceholderInRect:(CGRect)rect {
    [[self placeholder] drawInRect:rect withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14.0f],NSFontAttributeName, nil]];
}

- (void)updateStatus:(UPSearchBarStatus)status {
    if (status == UPSearchBarStatusInit) {
        self.placeholder = @"";
//        [self setLeftViewMode:UITextFieldViewModeAlways];
        [self setClearButtonMode:UITextFieldViewModeNever];
    } else if (status == UPSearchBarStatusBeginSearch) {
        self.placeholder = @"请输入感兴趣的职位";
//        [self setLeftViewMode:UITextFieldViewModeNever];
        [self setClearButtonMode:UITextFieldViewModeWhileEditing];
    } else {
        
    }
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    [super leftViewRectForBounds:bounds];
    return CGRectMake(10, (self.frame.size.height - 13) / 2, 13, 13);
}
@end

