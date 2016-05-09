//
//  ShowWebViewController.m
//  Itserv_oa
//
//  Created by xiexianhui on 14-6-4.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import "ShowWebViewController.h"

@interface ShowWebViewController ()<UIDocumentInteractionControllerDelegate>
{
    IBOutlet UIWebView *_webView;
    IBOutlet NSString *_strMIMEType;//文件类型
    BOOL _isRoot;//如果YES就返回

}
@property (nonatomic, retain) NSString *strWebFileUrl;
@property (strong, nonatomic) UIDocumentInteractionController *documentInteractionController;

@end

@implementation ShowWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isAddTap = NO;
        _isRightBtn = YES;
        _isRoot = YES;
    }
    return self;
}

#pragma mark 返回按钮
- (void)btnBackClicked:(UIButton *)sender
{
    if (_isRoot) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
		
        [_webView goBack];
        _isRoot = YES;
    }
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self btnReplaceRightWithImgNameArr:@[@"contenttoolbar_hd_share_light",@"contenttoolbar_hd_share"] title:nil];
    

    
    self.strTitle = _strTopTitle;
    
    _webView.top = _heightTop;
    _webView.height = ScreenHeight - _heightTop;
    _webView.scalesPageToFit = YES;
    if (_isDownFileUrl) {
		
        NSArray *arr = [_strTopTitle componentsSeparatedByString:@"."];
        NSString *strFileType = [arr lastObject];
        self.strUrl = [NSString stringWithFormat:@"%@%@",[AppDelegate getAppDelegate].strMailIP,_strUrl];
        
        if ([strFileType rangeOfString:@"txt"].location != NSNotFound) {//是txt
            _strMIMEType = [[NSString alloc] initWithFormat:@"text/%@",strFileType];
            
            [self.theRequest netRequestFile:self.strUrl];
        } else {
            
			
                NSURL *url = [NSURL URLWithString:_strUrl];
                [_webView loadRequest:[NSURLRequest requestWithURL:url]];
                [self.theRequest netRequestDownFile:_strUrl withFileName:_strTopTitle];
			
        }
    } else {
        _btnRight.hidden = YES;
        
        NSString *str = [@"\\" stringEncodeWithURLString:@"\\"];
        self.strUrl = [self.strUrl stringByReplacingOccurrencesOfString:@"\\" withString:str];
        self.strUrl = [NSString stringWithFormat:@"%@%@",[AppDelegate getAppDelegate].strIp,_strUrl];
        
        NSURL *url = [NSURL URLWithString:_strUrl];
        
        [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
    [SBPublicAlert showMBProgressHUD:@"加载中" andWhereView:self.view states:NO];

    // Do any additional setup after loading the view from its nib.
}

- (void)netRequest:(int)tag Finished:(NSDictionary *)model
{
	[SBPublicAlert hideMBprogressHUD:self.view];
    if (tag == ReadFile) {
		
        NSData *data = model[@"data"];
        [_webView loadData:data MIMEType:_strMIMEType textEncodingName:@"GBK" baseURL:nil];
    } else if (tag == DownFile) {
        if (_isDownFileUrl) {
            _isRoot = YES;
        } else {
            _isRoot = NO;
        }

        //文件下载成功
        [SBPublicAlert showMBProgressHUD:@"下载成功,可以用其他软件打开" andWhereView:self.view hiddenTime:kHiddenAlertTime];
		
    }
}

- (void)netRequest:(int)tag Failed:(NSDictionary *)model
{
	
    [SBPublicAlert showMBProgressHUD:@"下载失败" andWhereView:self.view hiddenTime:kHiddenAlertTime];
}



- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SBPublicAlert hideMBprogressHUD:self.view];
    
//    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
//    // Disable callout
//    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SBPublicAlert hideMBprogressHUD:self.view];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [self sendDownFile:request.URL.absoluteString];
    }
    return YES;
}

#pragma mark 在网页上点击下载文件
- (void)sendDownFile:(NSString *)strUrl
{
	if ([strUrl rangeOfString:@"$FILE"].location != NSNotFound) {//当是文件，就可以用其他软件打开
		_btnRight.hidden = NO;
		self.strWebFileUrl = strUrl;
		NSArray *arr = [strUrl componentsSeparatedByString:@"/"];
		//文件名称
		NSString *strFileName = [[arr lastObject] stringDecodingUrlEncoding];
		[self.theRequest netRequestDownFile:strUrl withFileName:strFileName];
	}
	
}

- (void)loadWord:(NSString *)strUrl {
    NSURLResponse *respnose = nil;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&respnose error:NULL];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
     NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [docPath.lastObject stringByAppendingString:@"word.doc"];
    [data writeToFile:filePath atomically:NO];
    
    [(UIWebView *)_webView loadData:data MIMEType:@"application/doc"
                   textEncodingName:@"utf-8" baseURL:nil];
    
//    NDHTMLtoPDF *pdfViewController = [NDHTMLtoPDF createPDFWithURL:[NSURL URLWithString:strUrl] pathForPDF:[@"~/Documents/blocksDemo.pdf" stringByExpandingTildeInPath] pageSize:self.view.bounds.size margins:UIEdgeInsetsZero successBlock:^(NDHTMLtoPDF *htmlToPDF) {
//            NSLog(@"HTMLtoPDF did succeed (%@ / %@)", htmlToPDF, htmlToPDF.PDFpath);
//        NSData *pdfData = [NSData dataWithContentsOfFile:htmlToPDF.PDFpath];
//        [(UIWebView *)_webView loadData:pdfData MIMEType:@"application/doc"
//                        textEncodingName:@"utf-8" baseURL:nil];
//    } errorBlock:^(NDHTMLtoPDF *htmlToPDF) {
//            NSLog(@"HTMLtoPDF did fail (%@)", htmlToPDF);
//    }];
//    pdfViewController.delegate = self;
//    [self.navigationController pushViewController:pdfViewController animated:NO];
//    QLPreviewController *previewController = [[QLPreviewController alloc] init];
//    previewController.dataSource = self;
//    [self.navigationController pushViewController:previewController animated:NO];
    //        NSLog(@"%@", respnose.MIMEType);
    // 在iOS开发中,如果不是特殊要求,所有的文本编码都是用UTF8
    // 先用UTF8解释接收到的二进制数据流
//    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
//    [_webView loadData:data MIMEType:respnose.MIMEType textEncodingName:@"UTF-8" baseURL:nil];
}

#pragma mark 用其他app打开
- (void)btnRightClicked:(UIButton *)sender
{
    NSURL *URL = nil;
    if (_isDownFileUrl) {//邮件附件
        NSString *strFileName = self.strTitle;//[self.strTitle stringEncodeWithURLString:self.strTitle];
        NSString *filePath = kSaveFilePath(strFileName);
        URL = [NSURL fileURLWithPath:filePath];
    } else {//正文
        NSArray *arr = [self.strWebFileUrl componentsSeparatedByString:@"/"];
        //文件名称
        NSString *strFileName = [[arr lastObject] stringDecodingUrlEncoding];
        NSString *filePath = kSaveFilePath(strFileName);
        URL = [NSURL fileURLWithPath:filePath];
    }
    if (URL) {
        // Initialize Document Interaction Controller
        self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:URL];
        
        // Configure Document Interaction Controller
        [self.documentInteractionController setDelegate:self];
        
        // Present Open In Menu
        [self.documentInteractionController presentOpenInMenuFromRect:CGRectMake(0, 0, 0, 0) inView:self.view animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
