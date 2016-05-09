//
//  SwitchingAddressViewController.h
//  Itserv_oa
//
//  Created by xiexianhui on 14-7-22.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UpdateAddress)(NSDictionary *dicAddress);

@interface SwitchingAddressViewController : BaseViewController

@property (nonatomic, assign) BOOL isJava;
@property (nonatomic, copy) UpdateAddress updateAddress;
@end
