//
//  UPAlertTipLabel.m
//  up
//
//  Created by joy.long on 13-11-16.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPAlertTipLabel.h"
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>

@implementation UPAlertTipLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = ClearColor;
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [_label setBackgroundColor:[UIColor clearColor]];
        [_label setFont:[UIFont systemFontOfSize:14]];
        [_label setLineBreakMode:NSLineBreakByCharWrapping];
        [_label setTextAlignment:NSTextAlignmentCenter];
        [_label setTextColor:WhiteColor];
        [self addSubview:_label];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self drawInContext:UIGraphicsGetCurrentContext()];
}

-(void)drawInContext:(CGContextRef)context
{
    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
	CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
	CGContextSetLineWidth(context, 10.0);
	CGContextSetShadowWithColor(context,CGSizeMake(0.0, 5.0),1/3,[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.8].CGColor);
	//CGFloat color1[] = {1.0, 0.0, 0.0, 1.0};
	//CGContextSetFillPattern(context, uncoloredPattern, color1);
	
	CGRect rrect = _label.frame;
    
	CGFloat radius = 2.0f;
    
	CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
	CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
    
    CGFloat pointOriginX = self.point.x - self.frame.origin.x;
    if(self.isAssignBottom) {
        
        CGContextMoveToPoint(context, pointOriginX + 5, maxy);
        CGContextAddLineToPoint(context, pointOriginX, maxy + 5);
        CGContextAddLineToPoint(context, pointOriginX - 5, maxy);
        CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
        CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
        CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
        // Add an arc through 8 to 9
        CGContextAddArcToPoint(context, maxx, maxy, self.point.x + 5, maxy, radius);
        // Close the path
        CGContextClosePath(context);
        // Fill & stroke the path
        // CGContextDrawPath(context, kCGPathFillStroke);
        // CGContextStrokePath(context);
        
    } else {
        
        CGContextMoveToPoint(context, pointOriginX + 5, miny);
        CGContextAddLineToPoint(context, pointOriginX, miny - 5);
        CGContextAddLineToPoint(context, pointOriginX - 5, miny);
        CGContextAddArcToPoint(context, minx, miny, minx, midy, radius);
        CGContextAddArcToPoint(context, minx, maxy, midx, maxy, radius);
        CGContextAddArcToPoint(context, maxx, maxy, maxx, midy, radius);
        // Add an arc through 8 to 9
        CGContextAddArcToPoint(context, maxx, miny, self.point.x + 5, miny, radius);
        // Close the path
        CGContextClosePath(context);
        // Fill & stroke the path
        // CGContextDrawPath(context, kCGPathFillStroke);
        // CGContextStrokePath(context);
        
    }
    CGContextClip(context);
    
	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	CGFloat colors[] =
	{
		0.0, 0.0, 0.0, 0.8,
		0.0, 0.0, 0.0, 0.8,
		0.0, 0.0, 0.0, 0.8,
	};

    CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
	CGColorSpaceRelease(rgb);
	CGContextDrawLinearGradient(context, gradient,CGPointMake(0.0,0.0) ,CGPointMake(0.0,self.frame.size.height), kCGGradientDrawsBeforeStartLocation);
    CGGradientRelease(gradient);
	
	CGContextFillPath(context);
}

- (void)updateTitle:(NSString *)title Point:(CGPoint)point isAssignBottom:(BOOL)isAssignBottom {
    if (title.length > 0) {
        CGSize titleSize = [title boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:NSFontAttributeName,_label.font, nil] context:nil].size;
        [_label setText:title];
        self.point = point;
        self.title = title;
        self.isAssignBottom = isAssignBottom;
        CGFloat viewOriginX = (self.frame.size.width - titleSize.width + 5 > self.point.x - 10) ? self.point.x - 10 : (self.frame.size.width - titleSize.width + 5);
        if (self.point.y > 0) {
            if (isAssignBottom) {
                self.frame = CGRectMake(viewOriginX, self.point.y - 20 - titleSize.height, titleSize.width + 10, titleSize.height + 20);
            } else {
                self.frame = CGRectMake(viewOriginX, self.point.y -20, titleSize.width + 10, titleSize.height + 20);
            }
        }
        if (isAssignBottom) {
            _label.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-10);
            
        } else {
            _label.frame = CGRectMake(0, 10, self.frame.size.width, self.frame.size.height-10);
        }
    }
    [self performSelector:@selector(hideAnimation) withObject:self afterDelay:0.5f];
}
- (void)hideAnimation {
    [UIView beginAnimations:@"hide" context:nil];
    [UIView setAnimationDuration:0.5];
    self.alpha = 0.0f;
    [UIView commitAnimations];
}

@end

