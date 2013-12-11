//
//  UPProcessingLineView.m
//  up
//
//  Created by joy.long on 13-12-12.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPProcessingLineView.h"
#import <QuartzCore/QuartzCore.h>

#define Frame_Fill_Image_Origin CGRectMake(2.5, 2.5, self.frame.size.width - 10, 10)

@interface UPProcessingLineView(){
    UIImageView *_fillImage;
    UILabel *_label;
}
@end
@implementation UPProcessingLineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = ColorWithWhiteAlpha(0.0f, 0.2f);
        
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 15);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 7.5f;
        
        _fillImage = [[UIImageView alloc] initWithFrame:Frame_Fill_Image_Origin];
        [_fillImage setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bkg_fill_zebra.png"]]];
        _fillImage.layer.masksToBounds = YES;
        _fillImage.layer.cornerRadius = 5.0f;
        [self addSubview:_fillImage];
        
        _label = [[UILabel alloc] initWithFrame:self.bounds];
        [_label setTextAlignment:NSTextAlignmentCenter];
        [_label setTextColor:WhiteColor];
        [_label setFont:[UIFont systemFontOfSize:9]];
        [self addSubview:_label];
        
    }
    return self;
}

- (void)updateLevel:(CGFloat)level {
    CGRect originRect = Frame_Fill_Image_Origin;
    originRect.size.width = level * originRect.size.width;
    [_fillImage setFrame:originRect];
    
    [_label setText:[NSString stringWithFormat:@"%d %%", (NSInteger)(level * 100)]];
}
@end
