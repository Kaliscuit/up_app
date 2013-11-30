//
//  UPEvaluateResultView.m
//  up
//
//  Created by joy.long on 13-11-30.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPEvaluateResultView.h"

@implementation UPEvaluateResultView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 200.0f, SCREEN_HEIGHT, 200.0f)];
        scrollView.pagingEnabled = YES;
        scrollView.bounces = NO;
        [scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * 2, 200.0f)];
        [self addSubview:scrollView];
        
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

@end
