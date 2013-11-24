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
    CGSize fontSize =[self.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:NSFontAttributeName,self.font, nil]];
    
    double finalHeight = fontSize.height *self.numberOfLines;
    
    double finalWidth =self.frame.size.width;//expected width of label
    
    CGSize theStringSize = [self.text boundingRectWithSize:CGSizeMake(finalWidth, finalHeight) options:NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:NSFontAttributeName,self.font, nil] context:nil].size;
    
    int newLinesToPad =(finalHeight - theStringSize.height)/ fontSize.height;
    
    for(int i=0; i<newLinesToPad; i++) {
        self.text =[self.text stringByAppendingString:@"\n "];
    }
}

-(void)alignBottom {
    CGSize fontSize =[self.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:NSFontAttributeName,self.font, nil]];
    double finalHeight = fontSize.height *self.numberOfLines;
    double finalWidth =self.frame.size.width;//expected width of label
    CGSize theStringSize = [self.text boundingRectWithSize:CGSizeMake(finalWidth, finalHeight) options:NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:NSFontAttributeName,self.font, nil] context:nil].size;
    
    int newLinesToPad =(finalHeight - theStringSize.height)/ fontSize.height;
    for(int i=0; i<newLinesToPad; i++) {
        self.text =[NSString stringWithFormat:@" \n%@",self.text];

    }
}
@end