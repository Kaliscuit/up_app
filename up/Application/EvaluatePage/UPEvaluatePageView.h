//
//  UPEvaluatePageView.h
//  up
//
//  Created by joy.long on 13-11-10.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UPEvaluatePageView : UIView

@property (nonatomic) NSInteger indexNumber;
@property (nonatomic, copy) NSString *questionStr;
//@property (nonatomic, copy)

- (void)updateQuestion:(NSString *)questionTitle atIndex:(NSInteger)index SectionA:(NSString *)sectionAString SectionB:(NSString *)sectionBString SectionC:(NSString *)sectionCString SectionD:(NSString *)sectionDString;

@end
