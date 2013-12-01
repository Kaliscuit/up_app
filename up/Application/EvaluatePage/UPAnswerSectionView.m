//
//  UPAnswerSectionView.m
//  up
//
//  Created by joy.long on 13-12-1.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPAnswerSectionView.h"

@interface UPAnswerSectionView() {
    UILabel *_titleLabel;
}

@end

@implementation UPAnswerSectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BaseColor;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0.5)];
        [lineView setBackgroundColor:ColorWithWhiteAlpha(255.0f, 0.5f)];
        [self addSubview:lineView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.0f, 0.5f, 280.0f, self.frame.size.height - 0.5f)];
        [_titleLabel setTextColor:WhiteColor];
        [self addSubview:_titleLabel];
        
    }
    return self;
}

- (void)dealloc {
    _titleLabel = nil;
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        [_titleLabel setTextColor:BlackColor];
        self.backgroundColor = WhiteColor;
    } else {
        [_titleLabel setTextColor:WhiteColor];
        self.backgroundColor = BaseColor;
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = _title;
}
@end
