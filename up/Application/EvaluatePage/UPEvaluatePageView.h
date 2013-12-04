//
//  UPEvaluatePageView.h
//  up
//
//  Created by joy.long on 13-11-10.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UPEvaluatePageResultDelegate <NSObject>
- (void)evaluatePageResult:(NSString *)questionID AnswerID:(NSString *)answerIDStr;
@end

@interface UPEvaluatePageView : UIView

@property (nonatomic, assign) id<UPEvaluatePageResultDelegate> delegate;

- (void)updateDataWithDictionary:(NSDictionary *)dict;

@end
