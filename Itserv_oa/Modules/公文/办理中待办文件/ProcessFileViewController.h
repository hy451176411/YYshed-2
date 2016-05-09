//
//  ProcessFileViewController.h
//  Itserv_oa
//
//  Created by xiexianhui on 14-6-2.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProcessFileViewController : BaseViewController

@property (nonatomic, retain) NSString *strTitleSuper;
@property (nonatomic, assign) int type;//1是处理中文件  2是待办文件
@property (nonatomic, retain) NSDictionary *dic;
@end
