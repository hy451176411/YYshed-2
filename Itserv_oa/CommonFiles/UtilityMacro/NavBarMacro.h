//
//  NavBarMacro.h
//  CloudClassroom
//
//  Created by xiu on 13-9-29.
//  Copyright (c) 2013年 zhangfeng. All rights reserved.
//

#ifndef CloudClassroom_NavBarMacro_h
#define CloudClassroom_NavBarMacro_h

//判断是否是ios7
#define IsIos7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)


#pragma mark - 导航条配置
//#define Use_Custom_Nav //是否自定义导航条
#define NavBarHeight (IsIos7?64:44)//导航条高度
#define NavBarBackNormal @"nav_back_normal"//导航条左侧按钮的normal状态图片,带尖角
#define NavBarBackClicked @"nav_back_press"//导航条左侧按钮的Clicked状态图片,带尖角
#define NavBarBackNormalSpecial @"nav_back_normalSpecial"//导航条左侧按钮的normal状态图片,不带尖角
#define NavBarBackClickedSpecial @"nav_back_pressSpecial"//导航条左侧按钮的Clicked状态图片,不带尖角
#define NavBarBackImgNameNormal @"nav_back_img_normal"
#define NavBarBackImgNameClicked @"nav_back_img_press"

#define NavBarRightNormal @"nav_right_normal"//导航条右侧按钮的normal状态图片
#define NavBarRightClicked @"nav_right_press"//导航条右侧按钮的Clicked状态图片
#define NavBarRightImgNameNormal @""
#define NavBarRightImgNameClicked @""
#define NavBarBg_640_88 @"nav_bg_640_88"//导航条背景图片
#define NavBarBg_320_44 @"nav_bg_320_44"//导航条背景图片


#pragma mark - toolbar配置
#define ToolBarHeight (DevicePhone ? 50 : 90)
#define ToolBarBg @""
typedef enum
{
    MyBarType0 = 800,
    MyBarType1,
    MyBarType2,
    MyBarType3,
    MyBarType4,
    MyBarType5
}MyBarType;



//全局导航条所需的
typedef enum _SideBarShowDirection
{
    SideBarShowDirectionNone = 0,
    SideBarShowDirectionLeft = 1,
    SideBarShowDirectionRight = 2
}SideBarShowDirection;
#define ContentOffset 130
#define ContentMinOffset 60
#define MoveAnimationDuration  0.3


#pragma mark - 设置导航条的标题
#define SetNavTitle(title)\
{ \
UILabel *tmpLabelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)]; \
[tmpLabelTitle setBackgroundColor:[UIColor clearColor]]; \
[tmpLabelTitle setFont:[UIFont boldSystemFontOfSize:20.0]]; \
[tmpLabelTitle setTextColor:[UIColor whiteColor]]; \
[tmpLabelTitle setText:title]; \
tmpLabelTitle.numberOfLines = 0;\
tmpLabelTitle.textAlignment = UITextAlignmentCenter;\
tmpLabelTitle.lineBreakMode = UILineBreakModeMiddleTruncation;\
[self.navigationItem setTitleView:tmpLabelTitle]; \
[tmpLabelTitle release];\
}

#define SetNavTitleImg(imgName)\
{ \
UIImageView *tmpImgViewTitle = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,44,44)];\
tmpImgViewTitle.image = [UIImage imageNamed:imgName];\
self.navigationItem.titleView = tmpImgViewTitle;\
[tmpImgViewTitle release];\
}

#define SetNavTitleImgAndSize(imgName,width,height)\
{ \
UIImageView *tmpImgViewTitle = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,width,height)];\
tmpImgViewTitle.image = [UIImage imageNamed:imgName];\
self.navigationItem.titleView = tmpImgViewTitle;\
[tmpImgViewTitle release];\
}


#pragma mark - 设置导航条左边按钮的标题
#define LeftBarItem(title)\
{\
if([title length] == 0)\
{\
self.navigationItem.hidesBackButton = YES;\
}\
else\
{\
UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];\
btn.titleLabel.font = [UIFont boldSystemFontOfSize:13];\
CGSize size = [title sizeWithFont:[UIFont boldSystemFontOfSize:13]];\
btn.frame = CGRectMake(35, 7, size.width+20, 30);\
BtnSetImg(btn, NavBarBackNormal, NavBarBackClicked, NavBarBackClicked);\
[btn setTitle:title forState:UIControlStateNormal];\
[btn setTitleColor:[UIColor colorWithRed:89.0/255 green:42.0/255 blue:13.0/255 alpha:1.0] forState:UIControlStateNormal];\
[btn addTarget:self action:@selector(leftBarClicked:) forControlEvents:UIControlEventTouchUpInside];\
UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:btn];\
self.navigationItem.leftBarButtonItem = backButton;\
[backButton release];\
}\
}


#define LeftSpecialBarItem(title)\
{\
if([title length] == 0)\
{\
self.navigationItem.hidesBackButton = YES;\
}\
else\
{\
UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];\
btn.titleLabel.font = [UIFont boldSystemFontOfSize:13];\
CGSize size = [title sizeWithFont:[UIFont boldSystemFontOfSize:13]];\
btn.frame = CGRectMake(35, 7, size.width+20, 30);\
BtnSetImg(btn,navBarBackNormalSpecial,navBarBackClickedSpecial,navBarBackClickedSpecial);\
[btn setTitle:title forState:UIControlStateNormal];\
[btn setTitleColor:[UIColor colorWithRed:89.0/255 green:42.0/255 blue:13.0/255 alpha:1.0] forState:UIControlStateNormal];\
[btn addTarget:self action:@selector(leftBarClicked:) forControlEvents:UIControlEventTouchUpInside];\
UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:btn];\
self.navigationItem.leftBarButtonItem = backButton;\
[backButton release];\
}\
}

#define LeftBarItemWithDefaultImgs()\
{\
LeftBarItemWithImgs(NavBarBackImgNameNormal,NavBarBackImgNameClicked);\
}


#define LeftBarItemWithImgs(normalImgName,clickedImgName)\
{\
UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];\
btn.frame = CGRectMake(0, 8, 43/2, 28);\
\
[btn addTarget:self action:@selector(leftBarClicked:) forControlEvents:UIControlEventTouchUpInside];\
UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:btn];\
self.navigationItem.leftBarButtonItem = backButton;\
BtnSetImg(btn,normalImgName,clickedImgName,clickedImgName);\
[backButton release];\
}


#pragma mark - 设置导航条右边按钮
/*
 #define RightBarItem(A)\
 {\
 UIBarButtonItem *backButton = nil;\
 backButton = [[UIBarButtonItem alloc] initWithTitle:A style:UIBarButtonItemStylePlain target:self action:@selector(rightBarClicked:)];\
 self.navigationItem.rightBarButtonItem = backButton;\
 [backButton release];\
 }
 */
#define RightBarItem(title)\
{\
UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];\
btn.titleLabel.font = [UIFont boldSystemFontOfSize:13];\
CGSize size = [title sizeWithFont:[UIFont boldSystemFontOfSize:13]];\
btn.frame = CGRectMake(0, 7, size.width+20, 30);\
BtnSetImg(btn,NavBarRightNormal,NavBarRightClicked,NavBarRightClicked);\
[btn setTitle:title forState:UIControlStateNormal];\
[btn setTitleColor:[UIColor colorWithRed:89.0/255 green:42.0/255 blue:13.0/255 alpha:1.0] forState:UIControlStateNormal];\
[btn addTarget:self action:@selector(rightBarClicked:) forControlEvents:UIControlEventTouchUpInside];\
UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];\
self.navigationItem.rightBarButtonItem = rightBtn;\
[rightBtn release];\
}

#define RightBarItemWithImgsAndSize(normalImgName,clickedImgName,width,height)\
{\
UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];\
btn.frame = CGRectMake(0, (Nav_Height-height)/2, width, height);\
BtnSetImg(btn,normalImgName,clicked,clicked);\
[btn addTarget:self action:@selector(rightBarClicked:) forControlEvents:UIControlEventTouchUpInside];\
UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];\
self.navigationItem.rightBarButtonItem = rightBtn;\
[rightBtn release];\
}

#define RightBarItemWithImgs(normalImgName,clickedImgName)\
{\
UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];\
btn.frame = CGRectMake(0, 7, 50, 30);\
BtnSetImg(btn,normalImgName,clickedImgName,clickedImgName);\
[btn addTarget:self action:@selector(rightBarClicked:) forControlEvents:UIControlEventTouchUpInside];\
UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];\
self.navigationItem.rightBarButtonItem = rightBtn;\
[rightBtn release];\
}

#pragma mark - push pop
#define PushViewCtrlAnimatedYES(ctrl) [GB_Nav pushViewController:ctrl animated:YES]
#define PushViewCtrlAnimatedNO(ctrl) [GB_Nav pushViewController:ctrl animated:NO]
#define PopViewCtrlAnimatedYES [GB_Nav popViewControllerAnimated:YES];
#define PopViewCtrlAnimatedNO [GB_Nav popViewControllerAnimated:NO];

#endif
