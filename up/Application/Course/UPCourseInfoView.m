//
//  UPCourseInfoView.m
//  up
//
//  Created by joy.long on 13-12-7.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPCourseInfoView.h"

@interface UPCourseInfoView() {
    UILabel *_titleLabel;
    UILabel *_detailLabel;
    UIImageView *arrayImage;
    
}

@end
@implementation UPCourseInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title detailTitle:(NSString *)detaiLTitle {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:WhiteColor];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width / 2, 60)];
        [_titleLabel setText:title];
        [self addSubview:_titleLabel];
        
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 2, 0, self.frame.size.width / 2 - 20, 60)];
        [_detailLabel setText:detaiLTitle];
        [_detailLabel setTextAlignment:NSTextAlignmentRight];
        [_detailLabel setTextColor:BaseColor];
        [self addSubview:_detailLabel];
        
        arrayImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icn_home_arrow"]];
        [arrayImage setFrame:CGRectMake(self.frame.size.width - 20, 18, 20, 24)];
        [self addSubview:arrayImage];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5)];
        [lineView setBackgroundColor:LineColor];
        [self addSubview:lineView];
    }
    return self;
}

@end
