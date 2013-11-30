//
//  UPLineView.h
//  up
//
//  Created by joy.long on 13-11-30.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UPLineView : UIView

@property (nonatomic) NSInteger max;
@property (nonatomic) NSInteger current;
@property (nonatomic, weak) UIColor *lineColor;
@property (nonatomic) BOOL isHorizonal; // default is NO
@property (nonatomic) BOOL isFillFromRight; // default is NO, when isHorizonal is NO, this property is unused
@property (nonatomic) BOOL isFillFromTop; // default is NO, when isHorizonal is YES, this property is unused
@end
