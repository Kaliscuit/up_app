//
//  UPTimeLineTableViewCell.m
//  up
//
//  Created by joy.long on 13-12-12.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPTimeLineTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation UPTimeLineTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = BaseLightBackgroundColor;
        UIView *_rightBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(62, 15, 245, 40)];
        [_rightBackgroundView setBackgroundColor:WhiteColor];
        _rightBackgroundView.layer.masksToBounds = YES;
        _rightBackgroundView.layer.cornerRadius = 4.0f;
        [self addSubview:_rightBackgroundView];
        
        _smallImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        [_smallImage setImage:[UIImage imageNamed:@"icn_timespot.png"]];
        [_smallImage setCenter:CGPointMake(50, 35)];
        [self addSubview:_smallImage];
        
        CGSize timeFontSize = [@"15:30" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]}];
        _leftTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 50, timeFontSize.height)];
        [_leftTimeLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_leftTimeLabel setTextAlignment:NSTextAlignmentCenter];
        [_leftTimeLabel setTextColor:RGBCOLOR(102.0f, 102.0f, 102.0f)];
        [self addSubview:_leftTimeLabel];

        CGSize dateFontSize = [@"周三" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9.0f]}];
        _leftDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25+_leftTimeLabel.frame.size.height, 30, dateFontSize.height)];
        [_leftDateLabel setFont:[UIFont systemFontOfSize:9.0f]];
        [_leftDateLabel setTextAlignment:NSTextAlignmentRight];
        [_leftDateLabel setTextColor:RGBCOLOR(102.0f, 102.0f, 102.0f)];
        [self addSubview:_leftDateLabel];
        
        _rightContentLabel = [[UILabel alloc] initWithFrame:CGRectInset(_rightBackgroundView.bounds, 10, 0)];
        [_rightContentLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_rightContentLabel setTextColor:RGBCOLOR(102.0f, 102.0f, 102.0f)];
        [_rightBackgroundView addSubview:_rightContentLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
