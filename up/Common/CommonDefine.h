//
//  CommonDefine.h
//  up
//
//  Created by joy.long on 13-11-5.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#ifndef up_CommonDefine_h
#define up_CommonDefine_h

#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)

#define BaseColor [UIColor colorWithRed:46.0f/255.0f green:204.0f/255.0f blue:113.0f/255.0f alpha:1.0]

#define SAFE_RELEASE(x) {[x release]; x = nil; }

#endif
