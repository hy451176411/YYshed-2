//
//  ButtonMacro.h
//  ProjectStructure
//
//  Created by zhangfeng on 13-10-12.
//  Copyright (c) 2013年 zhangfeng. All rights reserved.
//

#ifndef ProjectStructure_ButtonMacro_h
#define ProjectStructure_ButtonMacro_h

#define BtnSetImg(button,normal,highlight,click)\
{\
[button setBackgroundImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];\
[button setBackgroundImage:[UIImage imageNamed:highlight] forState:UIControlStateHighlighted];\
[button setBackgroundImage:[UIImage imageNamed:click] forState:UIControlStateSelected];\
}

#define BtnAddClickEventWithTarget(btn,target,sel)\
{\
[btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];\
}

#define BtnAddClickEvent(btn,sel)\
{\
[btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];\
}

#endif
