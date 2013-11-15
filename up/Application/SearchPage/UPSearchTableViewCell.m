//
//  UPSearchTableViewCell.m
//  up
//
//  Created by joy.long on 13-11-15.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPSearchTableViewCell.h"

@interface UPSearchTableViewCell() {
    UIImageView *_trendImage;
    NSInteger _trendNumber;
    
}

@end
@implementation UPSearchTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (_type == UPSearchTableViewCellTypeHotTop) {
            
        } else if (_type == UPSearchTableViewCellTypeAllPosition) {
            
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
