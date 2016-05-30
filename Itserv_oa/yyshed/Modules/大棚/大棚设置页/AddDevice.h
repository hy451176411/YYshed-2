//
//  Peopleview.h
//  Itserv_oa
//
//  Created by mac on 16/5/20.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYNetRequest.h"
@protocol AddDeviceDelegate<NSObject>

@optional
- (void)ScanZcode:(NSDictionary*)model;

@end
@interface AddDevice : UIView<YYNetRequestDelegate,UITextFieldDelegate>
- (IBAction)btnClick:(id)sender;
@property (nonatomic, nonatomic) IBOutlet UIView *backgroud;
@property (weak, nonatomic) IBOutlet UITextField *devUuid;
@property (nonatomic, assign) id<AddDeviceDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *alias;
- (IBAction)addDevice:(id)sender;
- (IBAction)zxing:(id)sender;
@property (nonatomic, retain) YYNetRequest *theRequest;
-(void)passValue:(NSString*)value;
@end
