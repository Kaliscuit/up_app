//
//  UPCourseTableViewCell.h
//  up
//
//  Created by joy.long on 13-12-7.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UPCourseTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL isDetailHighlight;
@property (nonatomic, assign) BOOL isHot;
@property (nonatomic, strong) UIImageView *logoImage;
@property (nonatomic, strong) UILabel *courseTitleLabel;
@property (nonatomic, strong) UILabel *courseDetailLabel;

@end
