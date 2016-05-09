//
//  ShowPopWebViewController.m
//  Itserv_oa
//
//  Created by admin on 15/3/23.
//  Copyright (c) 2015年 xiexianhui. All rights reserved.
//

#import "ShowPopWebViewController.h"
#import "SaveData.h"

@interface ShowPopWebViewController ()<UIDocumentInteractionControllerDelegate>
{
    UIWebView *_webViewPop;
}
@property (strong, nonatomic) UIDocumentInteractionController *documentInteractionController;

@end

@implementation ShowPopWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isAddTap = NO;
        _isRightBtn = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [SaveData saveAttachmentFileName:_strTopTitle fileData:_dataFile];
    [self btnReplaceRightWithImgNameArr:@[@"contenttoolbar_hd_share_light",@"contenttoolbar_hd_share"] title:nil];
    
    self.strTitle = _strTopTitle;
    _webViewPop = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.view addSubview:_webViewPop];
    _webViewPop.width = ScreenWidth;
    _webViewPop.top = _heightTop;
    _webViewPop.height = ScreenHeight - _heightTop;
    _webViewPop.scalesPageToFit = YES;
    
    NSString *filePath = kSaveFilePath(_strTopTitle);
    
    
    ///编码可以解决 .txt 中文显示乱码问题
    NSStringEncoding *useEncodeing = nil;
    //带编码头的如utf-8等，这里会识别出来
    NSString *body = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    //识别不到，按GBK编码再解码一次.这里不能先按GB18030解码，否则会出现整个文档无换行bug。
    if (!body) {
        body = [NSString stringWithContentsOfFile:filePath encoding:0x80000632 error:nil];
    }
    //还是识别不到，按GB18030编码再解码一次.
    if (!body) {
        body = [NSString stringWithContentsOfFile:filePath encoding:0x80000631 error:nil];
    }
    
    //展现
    if (body) {
        [_webViewPop loadHTMLString:body baseURL: nil];
    }else {
        NSString *urlString = [[NSBundle mainBundle] pathForAuxiliaryExecutable:filePath];
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *requestUrl = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl];
        [_webViewPop loadRequest:request];
    }
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark 用其他app打开
- (void)btnRightClicked:(UIButton *)sender
{
    NSURL *URL = nil;

    NSString *strFileName = self.strTitle;
    NSString *filePath = kSaveFilePath(strFileName);
    URL = [NSURL fileURLWithPath:filePath];
    if (URL) {
        // Initialize Document Interaction Controller
        self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:URL];
        
        // Configure Document Interaction Controller
        [self.documentInteractionController setDelegate:self];
        
        // Present Open In Menu
        [self.documentInteractionController presentOpenInMenuFromRect:CGRectMake(0, 0, 0, 0) inView:self.view animated:YES];
    }
}

#pragma mark Document Interaction Controller Delegate Methods
- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller {
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
