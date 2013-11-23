//
//  UPRotatePieView.m
//  up
//
//  Created by joy.long on 13-11-19.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPRotatePieView.h"
#import <QuartzCore/QuartzCore.h>

#define K_EPSINON        (1e-127)
#define IS_ZERO_FLOAT(X) (X < K_EPSINON && X > -K_EPSINON)

#define K_FRICTION              15.0f   // 摩擦系数
#define K_MAX_SPEED             30.0f
#define K_POINTER_ANGLE         (M_PI / 2)

@interface UPRotatePieView() {
    NSArray *_colorArray;
}

@end

@implementation UPRotatePieView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _colorArray = [[NSArray alloc] initWithObjects:
                       RGBCOLOR(87.0f, 147.0f, 243.0f),
                       RGBCOLOR(221.0f, 77.0f, 121.0f),
                       RGBCOLOR(189.0f, 59.0f, 71.0f),
                       RGBCOLOR(211.0f, 68.0f, 68.0f),
                       RGBCOLOR(253.0f, 156.0f, 53.0f),
                       RGBCOLOR(254.0f, 196.0f, 74.0f),
                       RGBCOLOR(212.0f, 223.0f, 90.0f),
                       RGBCOLOR(99.0f, 223.0f, 90.0f),
                       RGBCOLOR(14.0f, 188.0f, 178.0f),
                       RGBCOLOR(85.0f, 120.0f, 194.0f),
                       nil];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSInteger count = [_itemArray count];
    float sum = 0.0f;
    for (int i = 0; i < count; i++) {
        sum += [[[_itemArray objectAtIndex:i] objectForKey:@"Value"] floatValue];
    }
    
    _mThetaArray = [[NSMutableArray alloc] initWithCapacity:count];
    
    float frac = 2.0 * M_PI / sum;
    
    int centerX = rect.size.width / 2.0;
    int centerY = rect.size.height / 2.0;
    int radius  = (centerX > centerY ? centerX : centerY);
    
    float startAngle = _mZeroAngle;
    float endAngle   = _mZeroAngle;
    for (int i = 0; i < count; ++i) {
        startAngle = endAngle;
        endAngle  += [[[_itemArray objectAtIndex:i] objectForKey:@"Value"] floatValue] * frac;
        [_mThetaArray addObject:[NSNumber numberWithFloat:endAngle]];
        [[_colorArray objectAtIndex:i] setFill];
        CGContextMoveToPoint(context, centerX, centerY);
        CGContextAddArc(context, centerX, centerY, radius, startAngle, endAngle, 0);
        CGContextClosePath(context);
        CGContextFillPath(context);
    }
}

- (void)dealloc {
    [_mThetaArray release];
    _mThetaArray = nil;
    
    [_colorArray release];
    _colorArray = nil;
    
    [_itemArray release];
    _itemArray = nil;
    
    [super dealloc];
}

- (float)thetaForX:(float)x andY:(float)y {
    if (IS_ZERO_FLOAT(y)) {
        if (x < 0) {
            return M_PI;
        } else {
            return 0;
        }
    }
    
    float theta = atan(y / x);
    if (x < 0 && y > 0) {
        theta = M_PI + theta;
    } else if (x < 0 && y < 0) {
        theta = M_PI + theta;
    } else if (x > 0 && y < 0) {
        theta = 2 * M_PI + theta;
    }
    return theta;
}

/* 计算将当前以相对角度为单位的触摸点旋转到绝对角度为newTheta的位置所需要旋转到的角度(*_*!真尼玛拗口) */
- (float)rotationThetaForNewTheta:(float)newTheta {
    float rotationTheta;
    if (mRelativeTheta > (3 * M_PI / 2) && (newTheta < M_PI / 2)) {
        rotationTheta = newTheta + (2 * M_PI - mRelativeTheta);
    } else {
        rotationTheta = newTheta - mRelativeTheta + M_PI;
    }
    return rotationTheta;
}

- (float)thetaForTouch:(UITouch *)touch onView:view {
    CGPoint location = [touch locationInView:view];
    float xOffset    = self.bounds.size.width / 2;
    float yOffset    = self.bounds.size.height / 2;
    float centeredX  = location.x - xOffset; // 可能负数
    float centeredY  = location.y - yOffset; // 可能负数
    
    return [self thetaForX:centeredX andY:centeredY];
}

#pragma mark -
#pragma mark Private & handle rotation
- (void)timerStop {
    [mDecelerateTimer invalidate];
    mDecelerateTimer = nil;
    mDragSpeed = 0;
    isAnimating = NO;
    
    return;
}

- (void)animationDidStop:(NSString*)str finished:(NSNumber*)flag context:(void*)context {
    _isAutoRotation = NO;
}

- (void)tapStopped {
    int tapAreaIndex;
    
    for (tapAreaIndex = 0; tapAreaIndex < [_mThetaArray count]; tapAreaIndex++) {
        if (mRelativeTheta < [[_mThetaArray objectAtIndex:tapAreaIndex] floatValue]) {
            break;
        }
    }
    
    if (tapAreaIndex == 0) {
        mRelativeTheta = [[_mThetaArray objectAtIndex:0] floatValue] / 2;
    } else {
        mRelativeTheta = [[_mThetaArray objectAtIndex:tapAreaIndex] floatValue]
        - (([[_mThetaArray objectAtIndex:tapAreaIndex] floatValue]
            - [[_mThetaArray objectAtIndex:tapAreaIndex - 1] floatValue]) / 2);
    }
    
    _isAutoRotation = YES;
    [UIView beginAnimations:@"tap stopped" context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    self.transform = CGAffineTransformMakeRotation([self rotationThetaForNewTheta:K_POINTER_ANGLE]);
    [UIView commitAnimations];
    
    return;
}

- (void)decelerate {
    if (mDragSpeed > 0) {
        mDragSpeed -= (K_FRICTION / 100);
        
        if (mDragSpeed < 0.01) {
            [self timerStop];
        }
        
        mAbsoluteTheta += (mDragSpeed / 100);
        if ((M_PI * 2) < mAbsoluteTheta) {
            mAbsoluteTheta -= (M_PI * 2);
        }
    } else if (mDragSpeed < 0){
        mDragSpeed += (K_FRICTION /100);
        if (mDragSpeed > -0.01) {
            [self timerStop];
        }
        
        mAbsoluteTheta += (mDragSpeed / 100);
        if (0 > mAbsoluteTheta) {
            mAbsoluteTheta = (M_PI * 2) + mAbsoluteTheta;
        }
    }
    
    isAnimating = YES;
    [UIView beginAnimations:@"pie rotation" context:nil];
    [UIView setAnimationDuration:0.01];
    self.transform = CGAffineTransformMakeRotation([self rotationThetaForNewTheta:mAbsoluteTheta]);
    
    [UIView commitAnimations];
    
    return;
}

#pragma mark -
#pragma mark Responder
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_isAutoRotation) {
        return;
    }
    
    isTapStopped = IS_ZERO_FLOAT(mDragSpeed);
    
    // 停止计时器
    if ([mDecelerateTimer isValid]) {
        [self timerStop];
    }
    
    UITouch *touch   = [touches anyObject];
    // 点击后，先算绝对偏转角度，算相对这个控件的父类上的位置
    mAbsoluteTheta   = [self thetaForTouch:touch onView:self.superview];
    // 计算相对偏转角度
    mRelativeTheta   = [self thetaForTouch:touch onView:self];
    
    mDragBeforeDate  = [[NSDate date] retain];
    mDragBeforeTheta = 0.0f;
    return;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_isAutoRotation) {
        return;
    }
    
    isAnimating = YES;
    UITouch *touch = [touches anyObject];
    
    // 取得当前触点的theta值
    mAbsoluteTheta = [self thetaForTouch:touch onView:self.superview];
    
    // 计算速度
    NSTimeInterval dragInterval = [mDragBeforeDate timeIntervalSinceNow];
    
    /*由于theta大于2*PI后自动归零,因此此处需判断是否是在0度前后拖动 */
    if (fabsf(mAbsoluteTheta - mDragBeforeTheta) > M_PI) {    // 应判断是否#约等于#2PI.
        if (mAbsoluteTheta > mDragBeforeTheta) {  // 反方向转动
            mDragSpeed = (mAbsoluteTheta - (mDragBeforeTheta + 2 * M_PI)) / fabs(dragInterval);
        } else {        // 正向转动
            mDragSpeed = ((mAbsoluteTheta + 2 * M_PI) - mDragBeforeTheta) / fabs(dragInterval);
        }
    } else {
        mDragSpeed = (mAbsoluteTheta - mDragBeforeTheta) / fabs(dragInterval);
    }
    [_mInfoTextView setText:
     [NSString stringWithFormat:
      @"relative theta   = %.2f\nabsolute theta   = %.2f\nrotation theta   = %.2f\nspeed = %f",
      mRelativeTheta, mAbsoluteTheta, [self rotationThetaForNewTheta:mAbsoluteTheta], mDragSpeed]];
    [UIView beginAnimations:@"pie rotation" context:nil];
    [UIView setAnimationDuration:1];
    self.transform = CGAffineTransformMakeRotation([self rotationThetaForNewTheta:mAbsoluteTheta]);
    
    [UIView commitAnimations];
    isAnimating = NO;
    
    mDragBeforeTheta = mAbsoluteTheta;
    mDragBeforeDate = [[NSDate date] retain];
    
    return;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_isAutoRotation) {
        return;
    }
    
    if (IS_ZERO_FLOAT(mDragSpeed)) {
        if (isTapStopped) {
            [self tapStopped];
            
            return;
        } else {
            return;
        }
    } else if ((fabsf(mDragSpeed) > K_MAX_SPEED)) {
        mDragSpeed = (mDragSpeed > 0) ? K_MAX_SPEED : -K_MAX_SPEED;
    }
    NSTimer * timer = [NSTimer timerWithTimeInterval:0.01
											  target:self
											selector:@selector(decelerate)
											userInfo:nil
											 repeats:YES];
	[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    mDecelerateTimer = timer;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
}
@end
