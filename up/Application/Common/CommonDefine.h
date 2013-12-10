//
//  CommonDefine.h
//  up
//
//  Created by joy.long on 13-11-5.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#ifndef up_CommonDefine_h
#define up_CommonDefine_h

#define Offset_Y_In_IOS7_StatusBar (20.0f)

#define BaseColor [UIColor colorWithRed:41.0f/255.0f green:128.0f/255.0f blue:185.0f/255.0f alpha:1.0]
#define BaseGreenColor [UIColor colorWithRed:46.0f/255.0f green:204.0f/255.0f blue:113.0f/255.0f alpha:1.0]
#define LineColor RGBCOLOR(240.0f, 240.0f, 240.0f)
#define BaseLightBackgroundColor RGBCOLOR(239.0f, 239.0f, 244.0f)

#define ClearColor [UIColor clearColor]
#define WhiteColor [UIColor whiteColor]
#define GrayColor [UIColor grayColor]
#define BlackColor [UIColor blackColor]
#define BlueColor [UIColor blueColor]
#define RedColor [UIColor redColor]

#define HelveticaNeueUltraLight @"HelveticaNeue-UltraLight"

#define DefaultAvatarURLPrefix @"http://static.v2up.me/avatar/00/00/00000000-0000-0000-0000-000000000001_"

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
#define ColorWithWhite(w) [UIColor colorWithWhite:(w) alpha:1.0]
#define ColorWithWhiteAlpha(w,a) [UIColor colorWithWhite:(w) alpha:(a)]
#endif
