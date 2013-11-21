//
//  UPRotatePieView.h
//  up
//
//  Created by joy.long on 13-11-19.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UPRotatePieView : UIView {
    BOOL                isAnimating;
    BOOL                isTapStopped;
    float               mAbsoluteTheta;
    float               mRelativeTheta;
    
    float               mDragSpeed;
    NSDate             *mDragBeforeDate;
    float               mDragBeforeTheta;
    NSTimer            *mDecelerateTimer;
}

@property (nonatomic, retain) NSMutableArray *itemArray;
@property (nonatomic) float mZeroAngle;
@property (nonatomic, retain) NSMutableArray *mThetaArray;
@property (nonatomic) BOOL isAutoRotation;
@property (nonatomic, retain) UITextView     *mInfoTextView;
@end

