//
//  ScanZcodeVC.h
//  Itserv_oa
//
//  Created by mac on 16/5/30.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@protocol ScanZcodeVCDelegate<NSObject>

@optional
- (void)passValue:(NSString*)value;

@end

@interface ScanZcodeVC : UIViewController<AVCaptureMetadataOutputObjectsDelegate>
//@property (strong, nonatomic) IBOutlet UIButton *startBtn;
//- (IBAction)startStopReading:(id)sender;
//@property (strong, nonatomic) IBOutlet UILabel *lblStatus;
@property (strong, nonatomic) IBOutlet UIView *viewPreview;
@property (strong, nonatomic) UIView *boxView;
@property (nonatomic) BOOL isReading;
@property (strong, nonatomic) CALayer *scanLayer;
@property (nonatomic, assign) id<ScanZcodeVCDelegate> delegate;
-(BOOL)startReading;
-(void)stopReading;
- (IBAction)back:(id)sender;

//捕捉会话
@property (nonatomic, strong) AVCaptureSession *captureSession;
//展示layer
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@end
