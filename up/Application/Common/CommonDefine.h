//
//  CommonDefine.h
//  up
//
//  Created by joy.long on 13-11-5.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#ifndef up_CommonDefine_h
#define up_CommonDefine_h

#define BaseColor [UIColor colorWithRed:46.0f/255.0f green:204.0f/255.0f blue:113.0f/255.0f alpha:1.0]
#define ClearColor [UIColor clearColor]
#define WhiteColor [UIColor whiteColor]
#define GrayColor [UIColor grayColor]
#define BlackColor [UIColor blackColor]
#define BlueColor [UIColor blueColor]

#define SAFE_RELEASE(x) {[x release]; x = nil; }

#define isIPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define CurrentSystemVersion ([[UIDevice currentDevice] systemVersion])

#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

#if TARGET_OS_IPHONE
//iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif

#if __has_feature(objc_arc)
//compiling with ARC
#else
// compiling without ARC
#endif

#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define ColorWithWhite(w) [UIColor colorWithWhite:(w)/255.0f alpha:1.0]
#define ColorWithWhiteAlpha(w,a) [UIColor colorWithWhite:(w)/255.0f alpha:(a)]
#endif
