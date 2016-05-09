//
//  ScreenMacro.h
//  CBExtension
//
//  Created by ly on 13-7-14.
//  Copyright (c) 2013年 Lei Yan. All rights reserved.
//
/******* 屏幕宽度和高度配置 *****/
#ifndef ProjectStructure_Extension_ScreenMacro_h
#define ProjectStructure_Extension_ScreenMacro_h

#define SIsIos7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#define ScreenScale()     [[UIScreen mainScreen] scale]

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

#define ScreenHeight (SIsIos7?[UIScreen mainScreen].bounds.size.height:([UIScreen mainScreen].bounds.size.height-20))//屏幕高度，去状态栏高度20

#endif
