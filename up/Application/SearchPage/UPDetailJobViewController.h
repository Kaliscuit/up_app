//
//  UPDetailJobViewController.h
//  up
//
//  Created by joy.long on 13-11-15.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UPDetailJobViewController : UIViewController

- (void)updateInformation:(NSString *)title introduce:(NSString *)introduceStr requireAbility:(NSString *)requireAblityStr JobRankNumber:(NSNumber *)jobRankNumber;

@property (nonatomic, copy) NSString *positionTitle;
@property (nonatomic, copy) NSString *positionDescription;
@property (nonatomic) NSInteger rankNumber;
@end
