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
#import "UPAnswerSectionView.h"

#define Show_View_Width 260.0f
@interface UPEvaluatePageView() {
    UITextView *_questionTitleView;
    UILabel *_questionTitleLable;
    NSDictionary *_dataDict;
    
    NSString *_questionIDStr;
}

@end
@implementation UPEvaluatePageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BaseColor;
        _questionTitleView = [[UITextView alloc] initWithFrame:CGRectMake(40.0f, 0.0f, 240.0f, 120.0f)];
        [_questionTitleView setTextAlignment:NSTextAlignmentLeft];
        [_questionTitleView setBackgroundColor:ClearColor];
        [_questionTitleView setTextColor:WhiteColor];
        [_questionTitleView setFont:[UIFont systemFontOfSize:20]];
        [_questionTitleView setUserInteractionEnabled:NO];
        [self addSubview:_questionTitleView];
    }
    return self;
}

- (void)updateDataWithDictionary:(NSDictionary *)dict {
    _dataDict = dict;
    _questionTitleView.text = [[dict objectForKey:@"question"] objectForKey:@"question"];
    _questionIDStr = [[dict objectForKey:@"question"] objectForKey:@"id"];
    @autoreleasepool {
        for (int i = 0; i < [[dict objectForKey:@"options"] count]; i++) {
            NSString *index = nil;
            switch (i) {
                case 0:
                    index = @"A. ";
                    break;
                case 1:
                    index = @"B. ";
                    break;
                case 2:
                    index = @"C. ";
                    break;
                case 3:
                    index = @"D. ";
                    break;
                default:
                    break;
            }
            NSArray *optionArr = [dict objectForKey:@"options"];
            UPAnswerSectionView *answerSectionView = [[UPAnswerSectionView alloc] initWithFrame:CGRectMake(0.0f, _questionTitleView.frame.origin.y + _questionTitleView.frame.size.height + 70.0f * i, 320.0f, 70.0f)];
            [answerSectionView setTag:(7656 + i)];
            [answerSectionView addTarget:self action:@selector(onClickAnswerSectionView:) forControlEvents:UIControlEventTouchUpInside];
            [answerSectionView setTitle:[index stringByAppendingString:[[optionArr objectAtIndex:i] objectForKey:@"option"]]];
            [answerSectionView setAnswerIDStr:[[optionArr objectAtIndex:i] objectForKey:@"qid"]];
            [self addSubview:answerSectionView];
            
        }
    }
}

- (void)onClickAnswerSectionView:(UPAnswerSectionView *)sender {
    [self hideAllButtonSelectedStatus];
    sender.selected = YES;
    if ([self.delegate respondsToSelector:@selector(evaluatePageResult:AnswerID:)]) {
        [self.delegate performSelector:@selector(evaluatePageResult:AnswerID:) withObject:_questionIDStr withObject:sender.answerIDStr];
    }
}

- (void)hideAllButtonSelectedStatus {
    for (int i = 0; i < [[_dataDict objectForKey:@"options"] count]; i++) {
        ((UPAnswerSectionView *)[self viewWithTag:7656+i]).selected = NO;
    }
}

@end
