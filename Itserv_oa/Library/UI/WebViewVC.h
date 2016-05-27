//
//  WebViewVC.h
//  Itserv_oa
//
//  Created by mac on 16/5/27.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewVC : UIViewController
@property (nonatomic, nonatomic) IBOutlet UIWebView *webview;
- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *VCTitlte;

@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *titleStr;
@end
