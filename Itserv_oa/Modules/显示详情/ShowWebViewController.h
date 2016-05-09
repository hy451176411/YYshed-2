//
//  ShowWebViewController.h
//  Itserv_oa
//
//  Created by xiexianhui on 14-6-4.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowWebViewController : BaseViewController<UIWebViewDelegate>
@property (nonatomic, assign) BOOL isDownFileUrl;//是否是文件
@property (nonatomic, retain) NSString *strFileName;
@property (nonatomic, retain) NSString *strTopTitle;
@property (nonatomic, retain) NSString *strUrl;
@end
