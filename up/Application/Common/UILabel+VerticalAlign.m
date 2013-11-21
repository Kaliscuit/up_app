//
//  UILabel+VerticalAlign.m
//  up
//
//  Created by joy.long on 13-11-19.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UILabel+VerticalAlign.h"

@implementation UILabel (VerticalAlign)
- (void)alignTop {
    CGSize fontSize =[self.text sizeWithFont:self.font];
    NSLog(@"fontSize : %@", NSStringFromCGSize(fontSize));
    double finalHeight = fontSize.height *self.numberOfLines;
    NSLog(@"finalHeight : %f", finalHeight);
    double finalWidth =self.frame.size.width;//expected width of label
    NSLog(@"finalWidth:%f", finalWidth);
    CGSize theStringSize =[self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];
    NSLog(@"theStringSIZE ; %@", NSStringFromCGSize(theStringSize));
    int newLinesToPad =(finalHeight - theStringSize.height)/ fontSize.height;
    NSLog(@"newlinetOPad:%d", newLinesToPad);
    for(int i=0; i<newLinesToPad; i++)
        self.text =[self.text stringByAppendingString:@"\n "];
}

-(void)alignBottom {
    CGSize fontSize =[self.text sizeWithFont:self.font];
    double finalHeight = fontSize.height *self.numberOfLines;
    double finalWidth =self.frame.size.width;//expected width of label
    CGSize theStringSize =[self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];
    int newLinesToPad =(finalHeight - theStringSize.height)/ fontSize.height;
    for(int i=0; i<newLinesToPad; i++)
        self.text =[NSString stringWithFormat:@" \n%@",self.text];
}
@end