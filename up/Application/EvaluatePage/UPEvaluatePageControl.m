//
//  UPEvaluatePageControl.m
//  up
//
//  Created by joy.long on 13-11-12.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPEvaluatePageControl.h"
#import <objc/runtime.h>

@interface UPEvaluatePageControl() {
    UILabel *_label;
}

@end
@implementation UPEvaluatePageControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *array = [NSArray arrayWithArray:self.subviews];
        NSLog(@"array ;%@", array);
        NSLog(@"self.subviews : %@", self.subviews);
//        UIImage *image = [UIImage imageNamed:@"icn_user_default_highlight"];
//        object_setInstanceVariable(self, "_currentPageImage", (void*)image);
//        self.inputView.backgroundColor = [UIColor redColor];
//        _label = [UILabel alloc] initWithFrame:, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>
    }
    return self;
}

@end
