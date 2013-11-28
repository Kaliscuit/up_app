//
//  UPTopPositionTableViewCell.m
//  up
//
//  Created by joy.long on 13-11-28.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPTopPositionTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

#define Image_Frame_Height 25.0f
#define Image_Frame_Width 25.0f

@implementation UPTopPositionTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(20.0f, (self.frame.size.height - Image_Frame_Height) / 2, Image_Frame_Width, Image_Frame_Height)];
        [image setBackgroundColor:RGBCOLOR(243.0f, 156.0f, 18.0f)];
        image.layer.masksToBounds = YES;
        image.layer.cornerRadius = 13.0f;
        [self addSubview:image];
        
        UILabel *label = [[UILabel alloc] initWithFrame:image.frame];
        [label setTag:88887];
        [label setBackgroundColor:ClearColor];
        [label setTextColor:WhiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [label setFont:[UIFont systemFontOfSize:12.0f]];
        [label setAdjustsFontSizeToFitWidth:YES];
        [self addSubview:label];
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(image.frame.origin.x + image.frame.size.width + 10, 0, 240.0f, self.frame.size.height)];
        [titlelabel setBackgroundColor:ClearColor];
        [titlelabel setTextColor:BlackColor];
        [titlelabel setTag:88888];
        [titlelabel setFont:[UIFont systemFontOfSize:16.0f]];
        
        [self addSubview:titlelabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(titlelabel.frame.origin.x, self.frame.size.height - 0.5, SCREEN_WIDTH - titlelabel.frame.origin.x, 0.5f)];
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

- (void)setHotNumberStr:(NSString *)hotNumberStr {
    _hotNumberStr = hotNumberStr;
    ((UILabel *)[self viewWithTag:88887]).text = hotNumberStr;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    ((UILabel *)[self viewWithTag:88888]).text = title;
}
@end
