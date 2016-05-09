//
//  EmailContentViewController.m
//  Itserv_oa
//
//  Created by xiexianhui on 14-6-7.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import "EmailContentViewController.h"
#import "SendtoView.h"
#import "Global.h"
#import "AttachmentView.h"
#import "ShowWebViewController.h"
#import "SendEmailViewController.h"

@interface EmailContentViewController ()<AttachmentViewDelegate>
{
    IBOutlet UIScrollView *_scrollViewBg;
    IBOutlet UIView *_viewFrom;
    IBOutlet UILabel *_labelEmailTitle;//主题
    IBOutlet UILabel *_labelSendto;//收件人标签
    
    IBOutlet UILabel *_labelFrom;//发件人
    
    __weak IBOutlet UIImageView *_imgViewFrom;
    
    IBOutlet UILabel *_labelCopyto;//抄送人标签
    
    IBOutlet UILabel *_labelBlindto;//密送人标签
    IBOutlet UILabel *_labelTimeText;//时间标签
    IBOutlet UILabel *_labelTime;//时间显示
    
    IBOutlet UILabel *_labelSendtoName;//收件人
    
    __weak IBOutlet UIImageView *_imgViewSendto;
    
    IBOutlet UILabel *_labelCopytoName;//抄送
    __weak IBOutlet UIImageView *_imgViewCopyto;
    
    IBOutlet UILabel *_labelBlindtoName;//密送
    
    __weak IBOutlet UIImageView *_imgViewBlindto;
    
    IBOutlet UILabel *_labelContent;//邮件内容
    NSMutableArray *_muArrAttachments;//附件
    
    IBOutlet UIButton *_btnReply;//回复按钮
    IBOutlet UIButton *_btnForwarding;//转发
    
    __weak IBOutlet UIView *_viewPeopleBg;
    
    
}
@property (nonatomic, retain) NSDictionary *dicContent;

@end

@implementation EmailContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.strTitle = @"邮件详情";
    
    _btnReply.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor;
    _btnReply.layer.borderWidth = 1;
    
    _btnForwarding.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor;
    _btnForwarding.layer.borderWidth = 1;

    
    _scrollViewBg.top = _heightTop;
    _scrollViewBg.height = ScreenHeight - _heightTop - _btnForwarding.height;
    
    _muArrAttachments = [[NSMutableArray alloc] init];
    _viewPeopleBg.backgroundColor = ClearColor;
    [self.theRequest netRequestEmailContetn:_dicEmail[@"id"]];
    [SBPublicAlert showMBProgressHUD:@"加载中..." andWhereView:self.view states:NO];
    // Do any additional setup after loading the view from its nib.
}

- (void)netRequest:(int)tag Finished:(NSDictionary *)model
{
    [SBPublicAlert hideMBprogressHUD:self.view];
    
    if ([model isKindOfClass:[NSDictionary class]]) {
        
        self.dicContent = model;
        
        NSString *strMailTitle = model[@"title"];
        CGSize size = [strMailTitle sizeWithStringFont:_labelEmailTitle.font sizewidth:_labelEmailTitle.width sizeheight:MAXFLOAT];
        _labelEmailTitle.height = size.height;
        _labelEmailTitle.text = strMailTitle;//主题
        
        _viewFrom.top = 0;
        
        _viewPeopleBg.top = _labelEmailTitle.bottom;
        
        
        CGFloat nextOriginY = 0;
        
        NSMutableString *muStringSendto = [[NSMutableString alloc] init];
        
        _labelFrom.text = model[@"from"];
        //收件人数据
        NSArray *arrSendto = model[@"sendto"];
        for (int i = 0; i < arrSendto.count; i++) {
            NSDictionary *dic = arrSendto[i];
            
            if (i != arrSendto.count-1) {
                [muStringSendto appendFormat:@"%@,",dic[@"name"]];
            } else {
                [muStringSendto appendFormat:@"%@",dic[@"name"]];
            }
//            CGFloat originX = _labelSendto.left + _labelSendto.width;
//            CGFloat originY = _labelSendto.top;
//            SendtoView *sendtoV = [[SendtoView alloc] initWithFrame:CGRectMake(originX, originY + (i*23), 300 - originX, 20)];
//            [sendtoV loadData:dic];
//            [_viewFrom addSubview:sendtoV];
//            
//            nextOriginY = sendtoV.top + sendtoV.height + 5;
            
        }
        nextOriginY = _labelSendtoName.top + _labelSendtoName.height + 5;
        
        _labelSendtoName.text = muStringSendto;
        
         NSMutableString *muStringCopyto = [[NSMutableString alloc] init];
        //抄送人数据
        NSArray *arrCopyto = model[@"copyto"];
        NSInteger num = arrCopyto.count;
        
        if (num == 0) {
            _labelCopyto.hidden = YES;
            _labelCopytoName.hidden = YES;
            _labelCopyto.hidden = _labelCopytoName.hidden;

        } else {
            _labelCopyto.hidden = NO;
            _labelCopytoName.hidden = NO;
            _labelCopyto.hidden = _labelCopytoName.hidden;

            //设置抄送人标签位置
            _labelCopyto.top = nextOriginY;
            for (int i = 0; i < num; i++) {
                NSDictionary *dic = arrCopyto[i];
                NSString *strName = dic[@"name"];
                if (strName.length != 0) {
                    if (i != num-1) {
                        [muStringCopyto appendFormat:@"%@,",strName];
                    } else {
                        [muStringCopyto appendFormat:@"%@",strName];
                    }
                }
            }
        }
        if (muStringCopyto.length == 0) {
            _labelCopytoName.hidden = YES;
            _imgViewCopyto.hidden = _labelCopytoName.hidden;
            _labelCopyto.hidden = _labelCopytoName.hidden;
        } else {
            _labelCopytoName.text = muStringCopyto;
            nextOriginY = _labelCopytoName.top + _labelCopytoName.height + 5;
        }


        NSMutableString *muStringBlindto = [[NSMutableString alloc] init];

        //密送人数据
        NSArray *arrBlindto = model[@"blindto"];
        num = arrBlindto.count;
        
        if (num == 0) {
            _labelBlindto.hidden = YES;
            _labelBlindtoName.hidden = _labelBlindto.hidden;
            _imgViewBlindto.hidden = _labelBlindto.hidden;
        } else {
            _labelBlindto.hidden = NO;
            _labelBlindtoName.hidden = NO;
            _imgViewBlindto.hidden = _labelBlindto.hidden;

            //设置抄送人标签位置
            _labelBlindto.top = nextOriginY;
            for (int i = 0; i < num; i++) {
                
                NSDictionary *dic = arrBlindto[i];
                NSString *strName = dic[@"name"];
                if (strName.length != 0) {
                    if (i != num-1) {
                        [muStringBlindto appendFormat:@"%@,",strName];
                    } else {
                        [muStringBlindto appendFormat:@"%@",strName];
                    }
                }
            }
        }
        if (muStringBlindto.length == 0) {
            _labelBlindtoName.hidden = YES;
            _labelBlindto.hidden = YES;
            _imgViewBlindto.hidden = _labelBlindto.hidden;
        } else {
            nextOriginY = _labelBlindtoName.top + _labelBlindtoName.height + 5;
            _labelBlindtoName.text = muStringBlindto;
        }
        
        _labelTimeText.top = nextOriginY;
        _labelTime.top = nextOriginY;
        _labelTime.text = model[@"recevietime"];
        
        _viewPeopleBg.height = _labelTime.bottom + 5;
        
        _viewFrom.height = _viewPeopleBg.top + _viewPeopleBg.height;
        
        _labelContent.top = _viewFrom.height + _viewFrom.top + 5;
        
        //邮件内容
        NSString *content = model[@"content"];
        if (!content.length) {
            content = @"";
        }
//        content = [content stringFilterHTML];
        if (isValidateHTML(content)) {
            NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[content dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            
            CGRect frame = [attrStr boundingRectWithSize:CGSizeMake(_labelContent.width, ScreenHeight) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];//[content sizeWithStringFont:_labelContent.font sizewidth:_labelContent.width sizeheight:MAXFLOAT];
            _labelContent.height = frame.size.height;
            
            _labelContent.attributedText = attrStr;
        } else {
            size = [content sizeWithStringFont:_labelContent.font sizewidth:_labelContent.width sizeheight:MAXFLOAT];
            _labelContent.height = size.height;
            _labelContent.text = content;
        }
//
        
        _labelContent.backgroundColor = ClearColor;
        CGFloat height = _labelContent.top + _labelContent.height + 10;
        CGFloat contentSizeHeight = 0;
        //附件
        NSArray *arrAttachment = model[@"attachments"];
        
        [_muArrAttachments removeAllObjects];
        [_muArrAttachments addObjectsFromArray:arrAttachment];
        
        contentSizeHeight = _labelContent.top + _labelContent.height + 10;
        
        for (int i = 0; i < arrAttachment.count; i++) {
            AttachmentView *attachmentView = [[AttachmentView alloc] initWithFrame:CGRectMake(0, height + (i * 38), _scrollViewBg.width, 40)];
            NSDictionary *dic = arrAttachment[i];
            attachmentView.delegate = self;
            attachmentView.tag = i+1;
            [attachmentView loadData:dic];
            [_scrollViewBg addSubview:attachmentView];
            attachmentView.backgroundColor = ClearColor;
            contentSizeHeight = attachmentView.top + attachmentView.height + 10;
        }
        _scrollViewBg.contentSize = CGSizeMake(_scrollViewBg.width, contentSizeHeight);
    }
}

- (void)attachmentView:(AttachmentView *)attachmentV
{
    NSInteger index = attachmentV.tag - 1;
    NSDictionary *dic = _muArrAttachments[index];
    NSString *str = dic[@"url"];
    NSString *strName = dic[@"name"];
    NSString *strUrl = nil;
     NSURL *url = [NSURL URLWithString:str];
    if (url) {
        strUrl = str;
    } else {//需要转码
        NSArray *arr = [str componentsSeparatedByString:@"/"];
        NSString *strFileName = [arr lastObject];
         NSString *strFileEncodeName = [strFileName stringEncodeWithURLString:strFileName];
        strUrl = [str stringByReplacingOccurrencesOfString:strFileName withString:strFileEncodeName];

    }
    ShowWebViewController *ctrl = [[ShowWebViewController alloc] initWithNibName:[AppDelegate strCtrlName:@"ShowWebViewController"] bundle:nil];
    ctrl.isDownFileUrl = YES;
    ctrl.strUrl = strUrl;
    ctrl.strTopTitle = strName;
    [[AppDelegate getNav] pushViewController:ctrl animated:YES];
}

- (void)downFileUrl:(NSString *)fileUrl
{
}

#pragma mark 回复按钮事件
- (IBAction)btnReplyClicked:(UIButton *)sender
{
    SendEmailViewController *ctrl = [[SendEmailViewController alloc] initWithNibName:[AppDelegate strCtrlName:@"SendEmailViewController"] bundle:nil];
    ctrl.type = ReplyMail;
//    ctrl.delegate = self;
    [self.navigationController pushViewController:ctrl animated:NO];
    [ctrl loadDic:_dicContent];
}

#pragma mark 转发按钮事件
- (IBAction)btnForwardingClicked:(UIButton *)sender
{
    SendEmailViewController *ctrl = [[SendEmailViewController alloc] initWithNibName:[AppDelegate strCtrlName:@"SendEmailViewController"] bundle:nil];
    ctrl.type = ForwardingMail;
//    ctrl.delegate = self;
    [self.navigationController pushViewController:ctrl animated:NO];
//    [self presentModalViewController:ctrl animated:YES];
    [ctrl loadDic:_dicContent];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
