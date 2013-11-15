//
//  UPSearchTableViewCell.h
//  up
//
//  Created by joy.long on 13-11-15.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    UPSearchTableViewCellTypeHotTop,
    UPSearchTableViewCellTypeAllPosition,
} UPSearchTableViewCellType;

@interface UPSearchTableViewCell : UITableViewCell

@property (nonatomic) UPSearchTableViewCellType type;
@end
