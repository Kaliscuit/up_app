//
//  UPEvaluatePageView.m
//  up
//
//  Created by joy.long on 13-11-10.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPEvaluatePageView.h"
#import "CommonDefine.h"
#import <QuartzCore/QuartzCore.h>
#import "UPQuestionSectionButton.h"
#import "CommonDefine.h"
#define Show_View_Width 260.0f
@interface UPEvaluatePageView() {
    UILabel *_indexLabel;
    UILabel *_questionTitleLable;
}

@end
@implementation UPEvaluatePageView

- (void)dealloc {
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BaseColor;
        _indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 30, 10, 10)];
        [_indexLabel setBackgroundColor:ClearColor];
        [_indexLabel setTextColor:WhiteColor];
        [self addSubview: _indexLabel];
        
        _questionTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(_indexLabel.frame.origin.x + _indexLabel.frame.size.width, _indexLabel.frame.origin.y, SCREEN_WIDTH - _indexLabel.frame.origin.x * 2 - _indexLabel.frame.size.width, 80)];
        [_questionTitleLable setBackgroundColor:ClearColor];
        [_questionTitleLable setTextColor:WhiteColor];
        [self addSubview:_questionTitleLable];
        
        UPQuestionSectionButton *sectionButton = [[UPQuestionSectionButton alloc] initWithFrame:CGRectMake(5, _questionTitleLable.frame.origin.y + _questionTitleLable.frame.size.height, 310, 30)];
        [sectionButton updateIndexButton:1];
        [self addSubview:sectionButton];
        [sectionButton release];
        
    }
    return self;
}

- (void)updateQuestion:(NSString *)questionTitle atIndex:(NSInteger)index SectionA:(NSString *)sectionAString SectionB:(NSString *)sectionBString SectionC:(NSString *)sectionCString SectionD:(NSString *)sectionDString {
    
}

@end
