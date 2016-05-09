//
//  SendtoView.h
//  Itserv_oa
//
//  Created by xiexianhui on 14-6-7.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendtoView : UIView
{
    UILabel *_labelSendName;//收件人名称
//    UILabel *_labelSendEmail;//收件人地址
}

- (void)loadData:(NSDictionary *)dic;
@end
