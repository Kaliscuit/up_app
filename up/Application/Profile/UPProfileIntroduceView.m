//
//  UPProfileIntroduceView.m
//  up
//
//  Created by joy.long on 13-12-12.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPProfileIntroduceView.h"
#import "UIImageView+AFNetworking.h"
#import "UPProcessingLineView.h"

@implementation UPProfileIntroduceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 60, 60)];
        NSString *urlStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserProfile_avatar"];
        [avatarImageView setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"Thumbnail_64.png"]];
        avatarImageView.layer.masksToBounds = YES;
        avatarImageView.layer.cornerRadius = 30.0f;
        [self addSubview:avatarImageView];
        
        UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 18, SCREEN_WIDTH - 95, 20)];
        userNameLabel.font = [UIFont systemFontOfSize:17.0f];
        userNameLabel.textColor = WhiteColor;
        userNameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserProfile_name"];
        [self addSubview:userNameLabel];
        
        UIImageView *locationImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icn_location_15.png"]];
        [locationImage setFrame:CGRectMake(95, 41, 15, 15)];
        [self addSubview:locationImage];
        
        UIImageView *targetImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icn_target_15"]];
        [targetImage setFrame:CGRectMake(95, 59, 15, 15)];
        [self addSubview:targetImage];
        
        UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(122, 41, 100, 15)];
        [locationLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [locationLabel setTextColor:ColorWithWhiteAlpha(1.0f, 0.6)];
        [locationLabel setText:@"点击输入你的地址"];
        [self addSubview:locationLabel];
        
        UILabel *targetLabel = [[UILabel alloc] initWithFrame:CGRectMake(122, 59, 100, 15)];
        [targetLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [targetLabel setTextColor:ColorWithWhiteAlpha(1.0f, 0.6)];
        [targetLabel setText:@"目标职位"];
        [self addSubview:targetLabel];
        
        UPProcessingLineView *lineView = [[UPProcessingLineView alloc] initWithFrame:CGRectMake(94, 90, 125, 15)];
        [lineView updateLevel:0.65f];
        [self addSubview:lineView];
        
        UIImageView *starImage = [[UIImageView alloc] initWithFrame:CGRectMake(63, self.frame.size.height - 40, 25, 25)];
        [starImage setImage:[UIImage imageNamed:@"icn_star_25.png"]];
        [self addSubview:starImage];
        
        UILabel *starNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, self.frame.size.height - 40, 58, 25)];
        [starNumberLabel setTextColor:WhiteColor];
        [starNumberLabel setAdjustsFontSizeToFitWidth:YES];
        [starNumberLabel setText:@"316"];
        [starNumberLabel setFont:[UIFont systemFontOfSize:18]];
        [self addSubview:starNumberLabel];
        
        UIImageView *diamondImage = [[UIImageView alloc] initWithFrame:CGRectMake(160, self.frame.size.height - 40, 25, 25)];
        [diamondImage setImage:[UIImage imageNamed:@"icn_diamond_25.png"]];
        [self addSubview:diamondImage];
        
        UILabel *diamondNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(197, self.frame.size.height - 40, 58, 25)];
        [diamondNumberLabel setTextColor:WhiteColor];
        [diamondNumberLabel setAdjustsFontSizeToFitWidth:YES];
        [diamondNumberLabel setText:@"219"];
        [diamondNumberLabel setFont:[UIFont systemFontOfSize:18]];
        [self addSubview:diamondNumberLabel];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
