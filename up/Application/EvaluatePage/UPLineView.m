//
//  UPLineView.m
//  up
//
//  Created by joy.long on 13-11-30.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPLineView.h"

@implementation UPLineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor greenColor]];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [imageView setTag:7385];
        [self addSubview:imageView];
    }
    return self;
}

- (void)refreshLineView {
    UIImageView *view = (UIImageView *)[self viewWithTag:7385];
    [view setBackgroundColor:self.lineColor];
    
    CGFloat rate = self.current / self.max;
    if (self.isHorizonal) {
        if (self.isFillFromRight) {
            [view setFrame:CGRectMake((1 - rate) * self.frame.size.width, 0, rate * self.frame.size.width, self.frame.size.height)];
        } else {
            [view setFrame:CGRectMake(0, 0, rate * self.frame.size.width, self.frame.size.height)];
        }
    } else {
        if (self.isFillFromTop) {
            [view setFrame:CGRectMake(0, 0, self.frame.size.width, rate * self.frame.size.height)];
        } else {
            [view setFrame:CGRectMake(0, (1 - rate) * self.frame.size.height, self.frame.size.width, rate * self.frame.size.height)];
        }
    }
}

@end
