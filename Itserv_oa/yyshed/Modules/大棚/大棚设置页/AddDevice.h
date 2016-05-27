//
//  Peopleview.h
//  Itserv_oa
//
//  Created by mac on 16/5/20.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYNetRequest.h"
@interface AddDevice : UIView<YYNetRequestDelegate>
- (IBAction)btnClick:(id)sender;
@property (nonatomic, nonatomic) IBOutlet UIView *backgroud;
@property (weak, nonatomic) IBOutlet UITextField *devUuid;

@property (weak, nonatomic) IBOutlet UITextField *alias;
- (IBAction)addDevice:(id)sender;
- (IBAction)zxing:(id)sender;
@property (nonatomic, retain) YYNetRequest *theRequest;
@end
