//
//  UPCourseTableViewCell.m
//  up
//
//  Created by joy.long on 13-12-7.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPCourseTableViewCell.h"

@interface UPCourseTableViewCell()

@end
@implementation UPCourseTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, 320, 80);
        self.backgroundColor = WhiteColor;
        
        _logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        [_logoImage setBackgroundColor:ClearColor];
        [self addSubview:_logoImage];
        
        _courseTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 15, SCREEN_WIDTH - 80, 26)];
        [_courseTitleLabel setTextColor:RGBCOLOR(51.0f, 51.0f, 51.0f)];
        [_courseTitleLabel setFont:[UIFont systemFontOfSize:17.0f]];
        [_courseTitleLabel setBackgroundColor:ClearColor];
        [self addSubview:_courseTitleLabel];
        
        _courseDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 41, SCREEN_WIDTH - 80, 24)];
        [_courseDetailLabel setTextColor:RGBCOLOR(153.0f, 153.0f, 153.0f)];
        [_courseDetailLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [_courseDetailLabel setBackgroundColor:ClearColor];
        [self addSubview:_courseDetailLabel];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 0.5, SCREEN_WIDTH, 0.5)];
        [view setBackgroundColor:GrayColor];
        [self addSubview:view];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIsDetailHighlight:(BOOL)isDetailHighlight {
    _isDetailHighlight = isDetailHighlight;
    if (isDetailHighlight) {
        [_courseDetailLabel setTextColor:RGBCOLOR(243.0f, 156.0f, 18.0f)];
    } else {
        [_courseDetailLabel setTextColor:RGBCOLOR(153.0f, 153.0f, 153.0f)];
    }
}

- (void)dealloc {
    _courseDetailLabel = nil;
    _courseTitleLabel = nil;
    _logoImage = nil;
}
@end
