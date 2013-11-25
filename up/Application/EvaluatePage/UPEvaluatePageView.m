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
    NSDictionary *_dataDict;
}

@end
@implementation UPEvaluatePageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BaseColor;
        
        _indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 30, 10, 10)];
        [_indexLabel setBackgroundColor:ClearColor];
        [_indexLabel setTextColor:WhiteColor];
        [self addSubview: _indexLabel];
        
        _questionTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(_indexLabel.frame.origin.x + _indexLabel.frame.size.width, _indexLabel.frame.origin.y, SCREEN_WIDTH - _indexLabel.frame.origin.x * 2 - _indexLabel.frame.size.width, 40)];
        [_questionTitleLable setBackgroundColor:ClearColor];
        [_questionTitleLable setTextColor:WhiteColor];
       
        [self addSubview:_questionTitleLable];
        
        
    }
    return self;
}

- (void)updateDataWithDictionary:(NSDictionary *)dict {
    _dataDict = dict;
    _questionTitleLable.text = [[dict objectForKey:@"question"] objectForKey:@"question"];
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
            UIButton *_button = [UIButton buttonWithType:UIButtonTypeCustom];
            [_button setTitleColor:WhiteColor forState:UIControlStateNormal];
            [_button setFrame:CGRectMake(40, _questionTitleLable.frame.origin.y + _questionTitleLable.frame.size.height + i*40, 240, 40)];
            NSLog(@"Button Frame : %@", NSStringFromCGRect(_button.frame));
            [_button setImage:[UIImage imageNamed:@"icn_check_white.png"] forState:UIControlStateSelected];
            [_button setTag:7777+i];
            [_button setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
            [_button setTitle:[index stringByAppendingString:[[optionArr objectAtIndex:i] objectForKey:@"option"]] forState:UIControlStateNormal];
            [_button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
            _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [_button addTarget:self action:@selector(onClickSection:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_button];
        }
    }
}

- (void)onClickSection:(UIButton *)sender {
    [self hideAllButtonSelectedStatus];
    sender.selected = YES;
}

- (void)hideAllButtonSelectedStatus {
    for (int i = 0; i < [[_dataDict objectForKey:@"options"] count]; i++) {
        ((UIButton *)[self viewWithTag:7777+i]).selected = NO;
    }
}

@end
