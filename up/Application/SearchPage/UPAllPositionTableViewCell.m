//
//  UPAllPositionTableViewCell.m
//  up
//
//  Created by joy.long on 13-11-29.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPAllPositionTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

#define Tag_Hot_Image_View 78655
#define Tag_Title_Label 78755

@implementation UPAllPositionTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0, SCREEN_WIDTH - 100.0f, self.frame.size.height)];
        [titleLabel setTag:Tag_Title_Label];
        [titleLabel setBackgroundColor:ClearColor];
        [titleLabel setTextColor:BlackColor];
        [titleLabel setTextAlignment:NSTextAlignmentLeft];
        [titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [titleLabel setAdjustsFontSizeToFitWidth:YES];
        [self addSubview:titleLabel];
        
        UIImageView *hotImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, (self.frame.size.height - 16.0f) / 2, 45.0f, 16.0f)];
        [hotImageView setBackgroundColor:RGBCOLOR(231.0f, 76.0f, 60.0f)];
        hotImageView.layer.masksToBounds = YES;
        hotImageView.layer.cornerRadius = 8.0f;
        [hotImageView setTag:Tag_Hot_Image_View];
        [self addSubview:hotImageView];
        
        UILabel *hotLable = [[UILabel alloc] initWithFrame:hotImageView.bounds];
        [hotLable setText:@"热门"];
        [hotLable setBackgroundColor:ClearColor];
        [hotLable setTextColor:WhiteColor];
        [hotLable setTextAlignment:NSTextAlignmentCenter];
        [hotLable setFont:[UIFont systemFontOfSize:12.0f]];
        [hotImageView addSubview:hotLable];
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x, self.frame.size.height - 0.5, SCREEN_WIDTH - titleLabel.frame.origin.x, 0.5f)];
        [lineView setBackgroundColor:GrayColor];
        [self addSubview:lineView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitle:(NSString *)title {
    _title = title;
    ((UILabel *)[self viewWithTag:Tag_Title_Label]).text = title;
}

- (void)setIsHot:(BOOL)isHot {
    _isHot = isHot;
    [self viewWithTag:Tag_Hot_Image_View].hidden = !isHot;
}
@end
