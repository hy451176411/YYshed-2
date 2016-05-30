//
//  ScanZcodeVC.m
//  Itserv_oa
//
//  Created by mac on 16/5/30.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import "ScanZcodeVC.h"

@interface ScanZcodeVC ()

@end

@implementation ScanZcodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
	_captureSession = nil;
	_isReading = NO;
	[self startOrStop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)startReading {
	NSError *error;
	
	//1.初始化捕捉设备（AVCaptureDevice），类型为AVMediaTypeVideo
	AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	
	//2.用captureDevice创建输入流
	AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
	if (!input) {
		NSLog(@"%@", [error localizedDescription]);
		return NO;
	}
	
	//3.创建媒体数据输出流
	AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
	
	//4.实例化捕捉会话
	_captureSession = [[AVCaptureSession alloc] init];
	
	//4.1.将输入流添加到会话
	[_captureSession addInput:input];
	
	//4.2.将媒体输出流添加到会话中
	[_captureSession addOutput:captureMetadataOutput];
	
	//5.创建串行队列，并加媒体输出流添加到队列当中
	dispatch_queue_t dispatchQueue;
	dispatchQueue = dispatch_queue_create("myQueue", NULL);
	//5.1.设置代理
	[captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
	
	//5.2.设置输出媒体数据类型为QRCode
	[captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
	
	//6.实例化预览图层
	_videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
	
	//7.设置预览图层填充方式
	[_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
	
	//8.设置图层的frame
	[_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
	
	//9.将图层添加到预览view的图层上
	[_viewPreview.layer addSublayer:_videoPreviewLayer];
	
	//10.设置扫描范围
	captureMetadataOutput.rectOfInterest = CGRectMake(0.2f, 0.2f, 0.8f, 0.8f);
	
	//10.1.扫描框
	_boxView = [[UIView alloc] initWithFrame:CGRectMake(_viewPreview.bounds.size.width * 0.2f, _viewPreview.bounds.size.height * 0.2f, _viewPreview.bounds.size.width - _viewPreview.bounds.size.width * 0.4f, _viewPreview.bounds.size.height - _viewPreview.bounds.size.height * 0.4f)];
	_boxView.layer.borderColor = [UIColor greenColor].CGColor;
	_boxView.layer.borderWidth = 1.0f;
	
	[_viewPreview addSubview:_boxView];
	
	//10.2.扫描线
	_scanLayer = [[CALayer alloc] init];
	_scanLayer.frame = CGRectMake(0, 0, _boxView.bounds.size.width, 1);
	_scanLayer.backgroundColor = [UIColor brownColor].CGColor;
	
	[_boxView.layer addSublayer:_scanLayer];
	
	NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(moveScanLayer:) userInfo:nil repeats:YES];
	
	[timer fire];
	
	//10.开始扫描
	[_captureSession startRunning];
	
	
	return YES;
}
-(void)stopReading{
	[_captureSession stopRunning];
	_captureSession = nil;
	[_scanLayer removeFromSuperlayer];
	[_videoPreviewLayer removeFromSuperlayer];
}

- (IBAction)back:(id)sender {
	[self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
	//判断是否有数据
	if (metadataObjects != nil && [metadataObjects count] > 0) {
		AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
		//判断回传的数据类型
		if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
			NSLog(@"result = %@",[metadataObj stringValue]);
			
			[self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
			_isReading = NO;
			if (self.delegate && [self.delegate respondsToSelector:@selector(passValue:)]) {
				[_delegate passValue:[metadataObj stringValue]];
			}
			[self dismissViewControllerAnimated:NO completion:nil];
		}
	}
}

- (void)moveScanLayer:(NSTimer *)timer
{
	CGRect frame = _scanLayer.frame;
	if (_boxView.frame.size.height < _scanLayer.frame.origin.y) {
		frame.origin.y = 0;
		_scanLayer.frame = frame;
	}else{
		
		frame.origin.y += 5;
		
		[UIView animateWithDuration:0.1 animations:^{
			_scanLayer.frame = frame;
		}];
	}
}

- (BOOL)shouldAutorotate
{
	return NO;
}
-(void)startOrStop{
	if (!_isReading) {
		if ([self startReading]) {
			//[_startBtn setTitle:@"Stop" forState:UIControlStateNormal];
		}
	}
	else{
		[self stopReading];
		//[_startBtn setTitle:@"Start!" forState:UIControlStateNormal];
	}
	
	_isReading = !_isReading;
}
- (void)startStopReading:(id)sender {
	if (!_isReading) {
		if ([self startReading]) {
			//[_startBtn setTitle:@"Stop" forState:UIControlStateNormal];
		}
	}
	else{
		[self stopReading];
		//[_startBtn setTitle:@"Start!" forState:UIControlStateNormal];
	}
	
	_isReading = !_isReading;
}
@end
