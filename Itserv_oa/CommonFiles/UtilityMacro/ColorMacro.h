//
//  ColorMacro.h
//  CBExtension
//
//  Created by  ly on 13-5-28.
//  Copyright (c) 2013年 Lei Yan. All rights reserved.
//

#ifndef ProjectStructure_ColorMacro_h
#define ProjectStructure_ColorMacro_h

#ifdef RGBAlphaColor
#undef RGBAlphaColor
#endif

#ifdef OpaqueRGBColor
#undef OpaqueRGBColor
#endif

#define RGBAlphaColor(r, g, b, a) \
            [UIColor colorWithRed:(r/255.0)\
                            green:(g/255.0)\
                             blue:(b/255.0)\
                            alpha:(a)]

//16进制颜色值
#define RGBFromColor(rgbValue) \
            [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                        green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                        blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define OpaqueRGBColor(r, g, b) RGBAlphaColor((r), (g), (b), 1.0)


#define WhiteColor  [UIColor whiteColor]
#define RedColor    [UIColor redColor]
#define GreenColor  [UIColor greenColor]
#define BlackColor  [UIColor blackColor]
#define ClearColor  [UIColor clearColor]
#define GrayColor  [UIColor grayColor]
#define LightGrayColor  [UIColor lightGrayColor]
#define ClickedColor [UIColor colorWithWhite:0.4 alpha:0.3]//点击效果的颜色

/****** 默认的颜色 ******/
#define DefaultBlackTextColor [UIColor colorWithRed:72.0/255 green:71.0/255 blue:71.0/255 alpha:1.0]//默认字体颜色
#define DefaultGrayTextColor [UIColor colorWithRed:136.0/255 green:136.0/255 blue:136.0/255 alpha:1.0]
#define DefaultGreenTextColor [UIColor colorWithRed:117.0/255 green:166.0/255 blue:25.0/255 alpha:1.0]
#define DefaultBlueTextColor [UIColor colorWithRed:19.0/255 green:104.0/255 blue:164.0/255 alpha:1.0]

#define DefaultBgColor [UIColor colorWithRed:255*1.0/255 green:247*1.0/255 blue:233*1.0/255 alpha:1.0]//默认背景颜色
#define TestColor [UIColor redColor]//测试颜色

#endif
