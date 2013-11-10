//
//  UPSearchBar.h
//  up
//
//  Created by joy.long on 13-10-29.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    UPSearchBarStatusInit,
    UPSearchBarStatusBeginSearch,
}UPSearchBarStatus;

@interface UPSearchBar : UITextField {
    UIImageView *_leftIcon;
    UPSearchBarStatus _status;
}

- (void)updateStatus:(UPSearchBarStatus)status;
@end
