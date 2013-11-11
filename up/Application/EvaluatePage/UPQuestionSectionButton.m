//
//  UPQuestionSectionButton.m
//  up
//
//  Created by joy.long on 13-11-10.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPQuestionSectionButton.h"

@interface UPQuestionSectionButton() {
    UILabel *_indexLabel;
}
@end

@implementation UPQuestionSectionButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        [self setImage:[UIImage imageNamed:@"icn_check_white.png"] forState:UIControlStateSelected];
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    return self;
}

- (void)updateIndexButton:(NSInteger)index {
//    _indexLabel.text = [NSString stringWithFormat:@"%d", index];
    [self setTitle:@"A.接下来我们来测试吧" forState:UIControlStateNormal];
}

@end
