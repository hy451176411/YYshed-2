//
//  SendEmailViewController.m
//  Itserv_oa
//
//  Created by xiexianhui on 14-6-5.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import "SendEmailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ContactsViewController.h"
#import "RADataObject.h"
//#import "Global.h"
#import "PeopleNameView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PicFileView.h"

@interface SendEmailViewController ()<ContactsViewDelegate,PicFileViewDelegate>
{
    IBOutlet UIScrollView *_scrollViewBg;
    IBOutlet UITextField *_fileAddressee;//收件人
    IBOutlet UITextField *_fileCc;//抄送
    IBOutlet UITextField *_fileBcc;//密送
    IBOutlet UITextField *_fileSender;//发件人
    IBOutlet UITextField *_fileTheme;//主题
    IBOutlet UITextView *_textViewContent;//内容
    
    IBOutlet UIView *_viewCcBg;
    
    IBOutlet UIView *_viewAddressee;//收件人背景视图
    IBOutlet UIView *_viewCc;//抄送背景视图
    
    IBOutlet UIView *_viewBccBg;
    IBOutlet UIView *_viewBcc;
    
    IBOutlet UIView *_viewContent;//正文
    
    IBOutlet UIButton *_btnFile;//附件
    
    IBOutlet UIView *_viewFile;
    
    BOOL _isShow;//键盘是否显示
    
    NSMutableArray *_muArrPerson;//收件人数组
    NSMutableArray *_muArrPersonCc;//抄送数组
    NSMutableArray *_muArrPersonBcc;//抄送数组
    
    NSMutableArray *_muArrFile;//转发时的附件数组

    ContactsViewController *ctrl;
    NSMutableArray *_muArrImg;//保存需要上传的图片
    NSString *_strContent;
    IBOutlet UIScrollView *_scrollViewPic;//图片

}

@property (nonatomic, assign) BOOL isHTMLStyle;
@end

@implementation SendEmailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isRightBtn = YES;
        _isAddTap = NO;
        _type = SendMail;
    }
    return self;
}

- (void)dealloc
{
    //释放通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

}

- (void)btnBackClicked:(UIButton *)sender
{
    if (self.navigationController) {
        [super btnBackClicked:sender];
    } else {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_type == SendMail || _type == PeopleSendMail) {
        self.strTitle = @"发邮件";
    } else {
        self.strTitle = (_type == ReplyMail) ? @"回复邮件" : @"转发邮件";
    }
    
    _muArrImg = [[NSMutableArray alloc] init];
    
    _muArrPerson = [[NSMutableArray alloc] init];
    _muArrPersonCc = [[NSMutableArray alloc] init];
    _muArrPersonBcc = [[NSMutableArray alloc] init];
    
    _muArrFile = [[NSMutableArray alloc] init];
    
    _btnFile.layer.masksToBounds = YES;
    _btnFile.layer.cornerRadius = 3;
    _btnFile.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor;
    _btnFile.layer.borderWidth = 1;
    _btnFile.layer.shadowColor = [UIColor blackColor].CGColor;
    _btnFile.layer.shadowOffset = CGSizeMake(0, 2);
    
    _scrollViewBg.top = _heightTop;
    _scrollViewBg.height = ScreenHeight - _heightTop;
    
    _isShow = NO;
    
    [self btnReplaceRightWithImgNameArr:nil title:@"发送"];
    
    //键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    [_fileAddressee becomeFirstResponder];
    _scrollViewBg.contentSize = CGSizeMake(_scrollViewBg.width, _textViewContent.top + _textViewContent.height + 20);
    
    _viewFile.top = ScreenHeight;
    _viewFile.hidden = YES;
    _btnFile.hidden = YES;
    
    if (_dicDraft) {
        [self loadDraftDetail:_dicDraft];
    }
    
    if (_type == PeopleSendMail && _dicPeople) {//通讯录进入
        NSMutableArray *muArrSendto = [NSMutableArray array];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:_dicPeople[@"mail"] forKey:@"mail"];
        [dic setObject:_dicPeople[@"personname"] forKey:@"personname"];
        RADataObject *data = [RADataObject dataObjectWithDic:dic children:nil];
        [muArrSendto addObject:data];
        [self contactsWithPeople:muArrSendto withType:1];
    }
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark 从草稿箱进入编辑
- (void)loadDraftDetail:(NSDictionary *)dic
{
    [self.theRequest netRequestEmailContetn:dic[@"id"]];
    [SBPublicAlert showMBProgressHUD:@"" andWhereView:self.view states:NO];
}

- (void)loadDic:(NSDictionary *)dic
{
    [self performSelector:@selector(loadReplyForwardingDic:) withObject:dic afterDelay:0.01];
}

#pragma mark 回复和转发邮件显示收件人主题，
- (void)loadReplyForwardingDic:(NSDictionary *)dicData
{
    //收件人
    //收件人数据
    NSMutableArray *muArrSendto = [NSMutableArray array];
    
    if (_type == ReplyMail) {//回复
        NSString *strFrom = dicData[@"from"];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:strFrom forKey:@"mail"];
            [dic setObject:strFrom forKey:@"personname"];
            RADataObject *data = [RADataObject dataObjectWithDic:dic children:nil];
            [muArrSendto addObject:data];
        
        [self contactsWithPeople:muArrSendto withType:1];
    } else if ((_type == SendMail) && dicData) {//从草稿进入
        //收件
        //收件人数据
        NSArray *arrSendto = dicData[@"sendto"];
        NSMutableArray *muArrSendto = [NSMutableArray array];
        for (int i = 0; i < arrSendto.count; i++) {
            NSDictionary *dicSendto = arrSendto[i];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            NSString *strMail = dicSendto[@"mail"];
            NSString *strName = dicSendto[@"name"];
            if (strMail.length != 0 && strName.length != 0) {
                [dic setObject:strMail forKey:@"mail"];
                [dic setObject:dicSendto[@"name"] forKey:@"personname"];
                RADataObject *data = [RADataObject dataObjectWithDic:dic children:nil];
                [muArrSendto addObject:data];
            }
        }
        [self contactsWithPeople:muArrSendto withType:1];
    }
    

    
//    //抄送
//    //抄送人数据
//    NSArray *arrCopyto = dicData[@"copyto"];
//    NSMutableArray *muArrCopyto = [NSMutableArray array];
//    for (int i = 0; i < arrCopyto.count; i++) {
//        NSDictionary *dicCopyto = arrCopyto[i];
//        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//        NSString *strMail = dicCopyto[@"mail"];
//        NSString *strName = dicCopyto[@"name"];
//        if (strMail.length != 0 && strName.length != 0) {
//            [dic setObject:strMail forKey:@"mail"];
//            [dic setObject:dicCopyto[@"name"] forKey:@"personname"];
//            RADataObject *data = [RADataObject dataObjectWithDic:dic children:nil];
//            [muArrCopyto addObject:data];
//        }
//    }
//    [self contactsWithPeople:muArrCopyto withType:2];
//
//    //密送
//    NSArray *arrBlindto = dicData[@"blindto"];
//    NSMutableArray *muArrBlindto = [NSMutableArray array];
//    for (int i = 0; i < arrBlindto.count; i++) {
//        NSDictionary *dicBlindto = arrBlindto[i];
//        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//        NSString *strMail = dicBlindto[@"mail"];
//        NSString *strName = dicBlindto[@"name"];
//        if (strMail.length != 0 && strName.length != 0) {
//            [dic setObject:strMail forKey:@"mail"];
//            [dic setObject:dicBlindto[@"name"] forKey:@"personname"];
//            RADataObject *data = [RADataObject dataObjectWithDic:dic children:nil];
//            [muArrBlindto addObject:data];
//        }
//    }
//    [self contactsWithPeople:muArrBlindto withType:3];
    
    //主题
    NSString *strMailTitle = dicData[@"title"];
    NSMutableString *strTitle = [NSMutableString string];
    if (_type == SendMail && dicData) {
        [strTitle appendFormat:@"%@",strMailTitle];
    } else {
        (_type == ReplyMail) ? [strTitle appendFormat:@"回复:%@",strMailTitle] : [strTitle appendFormat:@"转发:%@",strMailTitle];
    }
      _fileTheme.text = strTitle;
    
    
    //内容
    _strContent = dicData[@"content"];
    NSMutableString *muStrContent = nil;
    if (_type == SendMail) {
        if (_strContent) {
            muStrContent = [NSMutableString stringWithString:_strContent];
        } else {
            muStrContent = [NSMutableString string];
        }
        _textViewContent.text = muStrContent;
    } else {
        if (isValidateHTML(_strContent)) {
            self.isHTMLStyle = YES;
//            _textViewContent.backgroundColor = [UIColor grayColor];
            _strContent = [NSString stringWithFormat:@"<BR><BR><BR><BR>------------------ 原始邮件 ----------------<BR>%@",_strContent];
            _strContent = [_strContent stringByReplacingOccurrencesOfString:@"\n" withString:@"<BR>"];
            NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[_strContent dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSFontAttributeName: SystemFontOfSize(15) } documentAttributes:nil error:nil];
            _textViewContent.attributedText = attrStr;
            [_textViewContent sizeToFit];
        } else {
            muStrContent = [NSMutableString stringWithFormat:@"\n\n\n\n------------------ 原始邮件 ----------------\n%@",_strContent];
            _textViewContent.text = muStrContent;
        }
    }
    
    //附件
    NSArray *arrAttachment = dicData[@"attachments"];
    [_muArrFile addObjectsFromArray:arrAttachment];
    
    
}

- (void)loadContacts:(NSInteger)type
{
    if (!ctrl) {
        ctrl = [[ContactsViewController alloc] initWithNibName:[AppDelegate strCtrlName:@"ContactsViewController"] bundle:nil];
        ctrl.delegate = self;
    } else {
        [ctrl reloadData];
    }
    ctrl.type = type;
    [self.view endEditing:YES];

    [[AppDelegate getNav] pushViewController:ctrl animated:YES];
}


#pragma mark 选择收件人按钮事件
- (IBAction)btnSelectPeopleClicked:(UIButton *)sender
{
    [self loadContacts:1];
}

#pragma mark 选择抄送按钮事件
- (IBAction)btnCcPeopleClicked:(UIButton *)sender
{
    [self loadContacts:2];
}

#pragma mark 选择密送按钮事件
- (IBAction)btnBccPeopleClicked:(UIButton *)sender
{
    [self loadContacts:3];
}

- (void)loadPeopleWithArrPeople:(NSArray *)arr withPeopleData:(NSMutableArray *)muArr withView:(UIView *)vBg withFile:(UITextField *)field
{
    for (int i = 0; i < arr.count; i++) {
        RADataObject *data = arr[i];
        NSDictionary *dic = data.dicOrgparent;
        NSString *strPersonid = dic[@"personid"];
        
        int j;
        for (j = 0; j < muArr.count; j++) {
            RADataObject *lastData = muArr[j];
            NSDictionary *lastDic = lastData.dicOrgparent;
            NSString *strLastPersonid = lastDic[@"personid"];
            if ([strPersonid isEqualToString:strLastPersonid]) {
                break;
            }
        }
        if (j >= muArr.count) {//没有此联系人要添加
            [muArr addObject:data];
        }
    }
    
    CGFloat originX = 0;
    CGFloat originY= 3;
    
    for (int i = 0; i < muArr.count; i++) {
        RADataObject *data = muArr[i];
        NSDictionary *dic = data.dicOrgparent;
        PeopleNameView *nameView = (PeopleNameView *)data.viewPeople;
        if (!nameView) {//没有数据
            nameView = [[PeopleNameView alloc] initWithFrame:CGRectMake(originX, originY, 20, 24)];
            [nameView loadDataView:dic];
            [vBg addSubview:nameView];
            data.viewPeople = nameView;
        }
        
        CGFloat width = originX + nameView.width;
        if (width > vBg.width - 10) {//大于view宽度
            nameView.left = 0;
            nameView.top = originY + 27;
        }
        originX = nameView.left + nameView.width + 5;
        originY = nameView.top;
    }
    
    if (originX > vBg.width - 20) {
        originX = 0;
        originY = originY + 27;
    }
    field.left = originX;
    field.top = originY;
    field.width = vBg.width - originX;
    field.text = @" ";
    vBg.height = originY + 31;
}

- (void)contactsWithPeople:(NSArray *)arr withType:(NSInteger)type
{
    
    switch (type) {
        case 1:{//收件人
            [self loadPeopleWithArrPeople:arr withPeopleData:_muArrPerson withView:_viewAddressee withFile:_fileAddressee];
            _viewCcBg.top = _viewAddressee.top + _viewAddressee.height;
            
            _viewBccBg.top = _viewCcBg.top + _viewCcBg.height;
            
            _viewContent.top = _viewBccBg.top + _viewBccBg.height;
        }break;
        case 2:{//抄送
            [self loadPeopleWithArrPeople:arr withPeopleData:_muArrPersonCc withView:_viewCc withFile:_fileCc];
            _viewCcBg.height = _viewCc.top + _viewCc.height;
            
            _viewBccBg.top = _viewCcBg.top + _viewCcBg.height;
            
            _viewContent.top = _viewBccBg.top + _viewBccBg.height;

        }break;
        case 3:{//密送
            [self loadPeopleWithArrPeople:arr withPeopleData:_muArrPersonBcc withView:_viewBcc withFile:_fileBcc];
            _viewBccBg.height = _viewBcc.top + _viewBcc.height;
            _viewContent.top = _viewBccBg.top + _viewBccBg.height;

        }break;
        default:
            break;
    }
}

#pragma mark 发送邮件按钮事件
- (void)btnRightClicked:(UIButton *)sender
{
    [self.view endEditing:YES];
    NSString *strAddressee =  _fileAddressee.text;//收件人
    NSString *strCc = @"";//抄送
    NSString *strBcc = @"";//密送
    NSString *strSender =  [AppDelegate getUserId];//发件人
    NSString *strTheme =  _fileTheme.text;//主题
    NSString *strContent =  _textViewContent.text;//[NSString stringWithCString:[(NSString *)[_textViewContent.attributedText string] cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSUTF8StringEncoding];//_textViewContent.text;//内容
    id file;
    
    NSString *strAttachments = @"";
    file = strAttachments;
    
    if (self.isHTMLStyle) {
        NSString *inputContent = [[_textViewContent.text componentsSeparatedByString:@"------------------ 原始邮件 ----------------"] firstObject];
        strContent = [inputContent stringByAppendingString:_strContent];
    }

    if (_muArrPerson.count == 0) {//收件人不能为空
        [SBPublicAlert showMBProgressHUD:@"收件人不能为空" andWhereView:self.view hiddenTime:kHiddenAlertTime];
    } else if (strTheme.length == 0) {//主题不能为空
        [SBPublicAlert showMBProgressHUD:@"主题不能为空" andWhereView:self.view hiddenTime:kHiddenAlertTime];

    } else {//发送邮件
        RADataObject *data = nil;
        NSDictionary *dic = nil;
        if (_muArrPerson.count != 0) {
            //收件人
            data = _muArrPerson[0];
            dic = data.dicOrgparent;
            strAddressee = dic[@"mail"];
            
            for (int i = 1; i < _muArrPerson.count; i++) {
                RADataObject *data = _muArrPerson[i];
                NSDictionary *dic = data.dicOrgparent;
                NSString *mail = dic[@"mail"];
                strAddressee = [NSString stringWithFormat:@"%@,%@",strAddressee,mail];
            }
        }
        
        if (_muArrPersonCc.count != 0) {
            //抄送
            data = _muArrPersonCc[0];
            dic = data.dicOrgparent;
            strCc = dic[@"mail"];
            
            for (int i = 1; i < _muArrPersonCc.count; i++) {
                RADataObject *data = _muArrPersonCc[i];
                NSDictionary *dic = data.dicOrgparent;
                NSString *mail = dic[@"mail"];
                strCc = [NSString stringWithFormat:@"%@,%@",strCc,mail];
            }
        }

        if (_muArrPersonBcc.count != 0) {
            //密送
            data = _muArrPersonBcc[0];
            dic = data.dicOrgparent;
            strBcc = dic[@"mail"];
            
            for (int i = 1; i < _muArrPersonBcc.count; i++) {
                RADataObject *data = _muArrPersonBcc[i];
                NSDictionary *dic = data.dicOrgparent;
                NSString *mail = dic[@"mail"];
                strBcc = [NSString stringWithFormat:@"%@,%@",strBcc,mail];
            }
        }
        
        if (_type == ForwardingMail) {//可能有附件
            
            for (int i = 0; i < _muArrFile.count; i++) {
                NSDictionary *dic = _muArrFile[i];
                NSString *attachmentsID = dic[@"id"];

                strAttachments = [NSString stringWithFormat:@"%@,%@",strAttachments,attachmentsID];
            }
            if (strAttachments.length > 1) {
                strAttachments = [strAttachments substringFromIndex:1];
            }
            
            file = strAttachments;
        } else if (_type == SendMail) {//是发邮件
            if (_muArrImg.count > 0) {
                file = _muArrImg;
            }
        }
        
        [SBPublicAlert showMBProgressHUD:@"发送中..." andWhereView:self.view states:NO];
        [self.theRequest netRequestNewSendMailFrom:strSender sendto:strAddressee copyto:strCc blindto:strBcc title:strTheme content:strContent attachments:file];
    }
}

- (void)netRequest:(int)tag Finished:(NSDictionary *)model
{
    NSString *strMessage = @"发送成功";
    if (_type == ReplyMail) {
        strMessage = @"回复成功";
    } else if (_type == ForwardingMail) {
        strMessage = @"转发成功";
    } else if (tag == EmailContent) {//从草稿箱进入  调用邮件内容接口
        
        self.dicDraft = model;
        [self loadDic:_dicDraft];
        
        [SBPublicAlert hideMBprogressHUD:self.view];
        return;
    }
    
    [SBPublicAlert showMBProgressHUD:strMessage andWhereView:self.view hiddenTime:kHiddenAlertTime];
    
    if (_type == SendMail) {
        [self performSelector:@selector(sendFinsh) withObject:nil afterDelay:kHiddenAlertTime - 0.5];
    } else {
        [self performSelector:@selector(btnBackClicked:) withObject:nil afterDelay:kHiddenAlertTime - 0.5];
    }
   
}

- (void)sendFinsh
{
    [self btnBackClicked:nil];
    if (_delegate && [_delegate respondsToSelector:@selector(sendEmailSuccess)]) {
        [_delegate sendEmailSuccess];
    }
}

-(void)keyboardWillShow:(NSNotification*)note
{
    _isShow = YES;
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];

    [self settingScrollViewContentSize];
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    CGFloat scrollViewHeight = ScreenHeight - keyboardBounds.size.height - _heightTop;
    
    _scrollViewBg.height = scrollViewHeight;
    _btnFile.top = ScreenHeight - keyboardBounds.size.height - _btnFile.height - 5;
    
    CGSize size = [self sizeContentText];
    
    _textViewContent.height = size.height;
    _viewContent.height = _textViewContent.top + _textViewContent.height + 5;
    
    CGFloat heightContent = _viewContent.top + _viewContent.height;
    if (heightContent <= scrollViewHeight) {
        
        _viewContent.height = scrollViewHeight - (_viewContent.top);
        _textViewContent.height = _viewContent.height - _textViewContent.top - 5;
    }
    _scrollViewBg.contentSize = CGSizeMake(_scrollViewBg.width, _viewContent.top + _viewContent.height);
    
	[UIView commitAnimations];
}

-(void)keyboardWillHide:(NSNotification*)note
{
    _isShow = NO;
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    CGFloat scrollViewHeight = ScreenHeight - _heightTop;
    
    _scrollViewBg.height = scrollViewHeight;
    if (_scrollViewBg.contentSize.height < _scrollViewBg.height) {
        _scrollViewBg.contentSize = CGSizeMake(_scrollViewBg.width, _scrollViewBg.height+1);
    }
    if (_viewFile.hidden) {
        _btnFile.top = ScreenHeight - _btnFile.height - 5;
    }
    
    CGSize size = [self sizeContentText];
    
    _textViewContent.height = size.height;
    _viewContent.height = _textViewContent.top + _textViewContent.height + 5;
    
    CGFloat heightContent = _viewContent.top + _viewContent.height;
    if (heightContent <= scrollViewHeight) {
        
        _viewContent.height = scrollViewHeight - (_viewContent.top);
        _textViewContent.height = _viewContent.height - _textViewContent.top - 5;
    }
    _scrollViewBg.contentSize = CGSizeMake(_scrollViewBg.width, _viewContent.top + _viewContent.height);

    
//    CGFloat heightContent = _textViewContent.top + _textViewContent.height;
//    if (heightContent <= scrollViewHeight) {
//        _viewContent.height = scrollViewHeight - (_textViewContent.top + _viewContent.top);
//    }

	[UIView commitAnimations];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <= -25) {
        [self.view endEditing:YES];
    }
}

#pragma mark 附件
- (IBAction)btnFileClicked:(UIButton *)sender
{
    if (_isShow && !_viewFile.hidden) {
        sender.selected = YES;
        
        [UIView animateWithDuration:0.3 animations:^{
            _viewFile.top = ScreenHeight - _viewFile.height;
            _btnFile.top = _viewFile.top - _btnFile.height - 5;
            _viewFile.hidden = NO;
        } completion:^(BOOL finsh) {
        }];
    } else {
        if (_viewFile.top < ScreenHeight) {
            sender.selected = NO;
            [UIView animateWithDuration:0.3 animations:^{
                _viewFile.top = ScreenHeight;
                _btnFile.top = ScreenHeight - _btnFile.height - 5;
            } completion:^(BOOL finsh) {
                _viewFile.hidden = YES;
            }];
        } else {
             sender.selected = YES;
            
            [UIView animateWithDuration:0.3 animations:^{
                _viewFile.top = ScreenHeight - _viewFile.height;
                _btnFile.top = _viewFile.top - _btnFile.height - 5;
                _viewFile.hidden = NO;
            } completion:^(BOOL finsh) {
            }];
        }
    }
    [self.view endEditing:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _fileAddressee) {//收件人
        if ([_fileAddressee.text isEqualToString:@" "] || _fileAddressee.text.length == 0) {
        } else {
            //将自己输入的做成邮箱
            NSString *strAddressee = _fileAddressee.text;
            
            BOOL status = [strAddressee hasPrefix:@" "] == 1 ?  YES : NO;
            if (status) {
                strAddressee = [strAddressee substringFromIndex:1];
            }
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:strAddressee forKey:@"mail"];
            [dic setObject:strAddressee forKey:@"personname"];
            RADataObject *data = [RADataObject dataObjectWithDic:dic children:nil];
            
            [self contactsWithPeople:@[data] withType:1];
            
        }
    } else if (textField == _fileCc) {//抄送
        if ([_fileCc.text isEqualToString:@" "] || _fileCc.text.length == 0) {
        } else {
            //将自己输入的做成邮箱
            NSString *strAddressee = _fileCc.text;
            
            BOOL status = [strAddressee hasPrefix:@" "] == 1 ?  YES : NO;
            if (status) {
                strAddressee = [strAddressee substringFromIndex:1];
            }
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:strAddressee forKey:@"mail"];
            [dic setObject:strAddressee forKey:@"personname"];
            RADataObject *data = [RADataObject dataObjectWithDic:dic children:nil];
            [self contactsWithPeople:@[data] withType:2];
        }
    } else if (textField == _fileBcc) {//密送
        if ([_fileBcc.text isEqualToString:@" "] || _fileBcc.text.length == 0) {
        } else {
            //将自己输入的做成邮箱
            NSString *strAddressee = _fileBcc.text;
            
            BOOL status = [strAddressee hasPrefix:@" "] == 1 ?  YES : NO;
            if (status) {
                strAddressee = [strAddressee substringFromIndex:1];
            }
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:strAddressee forKey:@"mail"];
            [dic setObject:strAddressee forKey:@"personname"];
            RADataObject *data = [RADataObject dataObjectWithDic:dic children:nil];
            [self contactsWithPeople:@[data] withType:3];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _fileAddressee) {//收件人
        if ([_fileAddressee.text isEqualToString:@" "] || _fileAddressee.text.length == 0) {
             [_fileCc becomeFirstResponder];
        } else {
            //将自己输入的做成邮箱
            NSString *strAddressee = _fileAddressee.text;
            
            BOOL status = [strAddressee hasPrefix:@" "] == 1 ?  YES : NO;
            if (status) {
                strAddressee = [strAddressee substringFromIndex:1];
            }
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:strAddressee forKey:@"mail"];
            [dic setObject:strAddressee forKey:@"personname"];
            RADataObject *data = [RADataObject dataObjectWithDic:dic children:nil];
            
            [self contactsWithPeople:@[data] withType:1];
           
        }
    } else if (textField == _fileCc) {//抄送
        if ([_fileCc.text isEqualToString:@" "] || _fileCc.text.length == 0) {
            [_fileBcc becomeFirstResponder];
        } else {
            //将自己输入的做成邮箱
            NSString *strAddressee = _fileCc.text;

            BOOL status = [strAddressee hasPrefix:@" "] == 1 ?  YES : NO;
            if (status) {
                strAddressee = [strAddressee substringFromIndex:1];
            }
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:strAddressee forKey:@"mail"];
            [dic setObject:strAddressee forKey:@"personname"];
            RADataObject *data = [RADataObject dataObjectWithDic:dic children:nil];
            [self contactsWithPeople:@[data] withType:2];
        }
    } else if (textField == _fileBcc) {//密送
        if ([_fileBcc.text isEqualToString:@" "] || _fileBcc.text.length == 0) {
            [_fileTheme becomeFirstResponder];
        } else {
            //将自己输入的做成邮箱
            NSString *strAddressee = _fileBcc.text;
            
            BOOL status = [strAddressee hasPrefix:@" "] == 1 ?  YES : NO;
            if (status) {
                strAddressee = [strAddressee substringFromIndex:1];
            }
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:strAddressee forKey:@"mail"];
            [dic setObject:strAddressee forKey:@"personname"];
            RADataObject *data = [RADataObject dataObjectWithDic:dic children:nil];
            [self contactsWithPeople:@[data] withType:3];
        }
    } else if (textField == _fileTheme) {//主题
        [_textViewContent becomeFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length == 1 && [string isEqualToString:@""]) {
       //开始删除前面的联系人
        if (textField == _fileAddressee) {//收件人
            [self clearPeopleWithArr:_muArrPerson withView:_viewAddressee withField:_fileAddressee];
            return NO;
        } else if (textField == _fileCc) {//抄送
            [self clearPeopleWithArr:_muArrPersonCc withView:_viewCc withField:_fileCc];
            return NO;
        } else if (textField == _fileBcc) {//密送
            [self clearPeopleWithArr:_muArrPersonBcc withView:_viewBcc withField:_fileBcc];
            return NO;
        }
    }
    return YES;
}

#pragma mark 清除所有联系人
- (void)clearAllWithArr:(NSMutableArray *)muArr withView:(UIView *)vBg withField:(UITextField *)field
{
    for (int i = 0; i < muArr.count; i++) {
        RADataObject *data = muArr[i];
        PeopleNameView *nameView = (PeopleNameView *)data.viewPeople;
        [nameView removeFromSuperview];
        data.viewPeople = nil;
    }
    
    if (field == _fileAddressee) {//收件人
        _viewAddressee.height = 30;
        
        _fileAddressee.left = 4;
        _fileAddressee.top = 2;
        _fileAddressee.width = _viewAddressee.width - _fileAddressee.left;
        
        _viewCcBg.top = _viewAddressee.top + _viewAddressee.height;
        _viewBccBg.top = _viewCcBg.top + _viewCcBg.height;
        
        _viewContent.top = _viewBccBg.top + _viewBccBg.height;
    } else if (field == _fileCc) {//抄送
        _viewCc.height = 30;
        
        _viewCcBg.height = 40;
        
        _fileCc.left = 4;
        _fileCc.top = 2;
        _fileCc.width = _viewCc.width - _fileCc.left;
        
        _viewBccBg.top = _viewCcBg.top + _viewCcBg.height;
        
        _viewContent.top = _viewBccBg.top + _viewBccBg.height;
    } else if (field == _fileBcc) {//密送
        _viewBcc.height = 30;
        _viewBccBg.height = 40;
        
        _fileBcc.left = 4;
        _fileBcc.top = 2;
        _fileBcc.width = _viewBcc.width - _fileBcc.left;
        
        _viewContent.top = _viewBccBg.top + _viewBccBg.height;
    }
    _scrollViewBg.contentSize = CGSizeMake(ScreenWidth, _viewContent.top + _viewContent.height + 10);
}

#pragma mark 清除单个联系人
- (void)clearPeopleWithArr:(NSMutableArray *)muArr withView:(UIView *)vBg withField:(UITextField *)field
{
    RADataObject *data = [muArr lastObject];
    PeopleNameView *nameView = (PeopleNameView *)data.viewPeople;
    CGFloat originX = nameView.left;
    CGFloat originY = nameView.top;
    [nameView removeFromSuperview];
    
    field.left = originX;
    field.top = originY;
    field.width = vBg.width -  originX;
    [muArr removeLastObject];
    
    vBg.height = field.top + field.height + 5;
    
    if (field == _fileAddressee) {//收件人
        _viewAddressee.height = _fileAddressee.top + _fileAddressee.height + 5;
        
        _viewCcBg.top = _viewAddressee.top + _viewAddressee.height;
        _viewBccBg.top = _viewCcBg.top + _viewCcBg.height;
        
        _viewContent.top = _viewBccBg.top + _viewBccBg.height;
    } else if (field == _fileCc) {//抄送
        _viewCc.height = _fileCc.top + _fileCc.height + 5;
        _viewCcBg.height = _viewCc.top + _viewCc.height;
        
        _viewBccBg.top = _viewCcBg.top + _viewCcBg.height;
        
        _viewContent.top = _viewBccBg.top + _viewBccBg.height;

        
    } else if (field == _fileBcc) {//密送
        _viewBcc.height = _fileBcc.top + _fileBcc.height + 5;
        _viewBccBg.height = _viewBcc.top + _viewBcc.height;
        
        _viewContent.top = _viewBccBg.top + _viewBccBg.height;
    }
    
    _scrollViewBg.contentSize = CGSizeMake(ScreenWidth, _viewContent.top + _viewContent.height + 10);
}

- (void)settingScrollViewContentSize
{
   
    CGSize size = [self sizeContentText];
    
    _textViewContent.height = size.height;
    _viewContent.height = _textViewContent.top + _textViewContent.height + 5;
    
    CGFloat heightContent = _viewContent.top + _viewContent.height;
    if (heightContent <= _scrollViewBg.height) {
        
        _viewContent.height = _scrollViewBg.height - (_viewContent.top);
        _textViewContent.height = _viewContent.height - _textViewContent.top - 5;
    }
    
    _scrollViewBg.contentSize = CGSizeMake(_scrollViewBg.width, _viewContent.top + _viewContent.height);
    
    if (_scrollViewBg.contentSize.height > _scrollViewBg.height) {
        
//        _scrollViewBg.contentOffset = CGPointMake(0, _scrollViewBg.contentSize.height - _scrollViewBg.height);
    }

    return;
}

- (CGSize)sizeContentText
{
    NSString *strText = (_textViewContent.text.length == 0) ? @"" : _textViewContent.text;
    CGSize size = [strText sizeWithTextViewStringFont:_textViewContent.font sizewidth:_textViewContent.width sizeheight:MAXFLOAT];
    return size;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
//    if ([text isEqualToString:@"\n"]) {
//        [self btnRightClicked:nil];
//    }
    [self performSelector:@selector(settingScrollViewContentSize) withObject:nil afterDelay:0.1];
    return YES;
}

#pragma mark 选择图片
#pragma mark UIButton按钮事件
- (IBAction)btnSelectPicClicked:(UIButton *)sender
{
   UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
//    imagePicker.allowsEditing = YES;
    if (sender.tag == 2) {//从相册选择图片
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:imagePicker animated:YES completion:^{
            ;
        }];
    } else {//从拍照
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:^{
                ;
            }];
        }
        else{
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该设备不支持照相功能!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
    
    __block NSString *strfileName = @"";
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    ALAssetsLibrary* alLibrary = [[ALAssetsLibrary alloc] init];
    //获取图片名称
    [alLibrary assetForURL:imageURL resultBlock:^(ALAsset *asset) {
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        // 带有后缀名
        strfileName = [representation filename];
        
        CGFloat widthBtn = 85;
        CGFloat heightBtn = 90;
        
        // 图片太大，等比例缩放
        CGRect rect = CGRectMake(0, 5, widthBtn, heightBtn);
        if ([_muArrImg count] != 0) {//图片数组
            PicFileView *btn = (PicFileView *)[_muArrImg lastObject];
            rect = btn.frame;
            rect.origin.x = btn.frame.size.width + btn.frame.origin.x + 10;
        }
        PicFileView *picFileView = [[PicFileView alloc] initWithFrame:rect];
        picFileView.delegate = self;
        [_scrollViewPic addSubview:picFileView];
        [_muArrImg addObject:picFileView];
        
        int num = [_muArrImg count];
        
        [_scrollViewPic setContentSize:CGSizeMake((widthBtn+10)*num, 0)];
//        _scrollViewPic.backgroundColor = GrayColor;
        [picFileView loadWithImg:img withFileName:strfileName];
        
//        [self saveImageWithImage:img withType:strfileName];

    } failureBlock:^(NSError *error){
  
    }];
}

#pragma mark PicFileViewDelegate
- (void)picFileView:(PicFileView *)picFileView
{
    [_muArrImg removeObject:picFileView];
    
    [picFileView removeFromSuperview];
    
    CGFloat widthBtn = 85;
    CGFloat heightBtn = 90;
    
    // 图片太大，等比例缩放
    CGRect rect = CGRectMake(0, 5, widthBtn, heightBtn);
    
    for (PicFileView *picFile in _muArrImg) {
        picFile.frame = rect;
        rect.origin.x = picFile.width + picFile.left + 10;
    }
}



//[request addFile:imagePath forKey:@"file"];
#pragma mark - 保存图片
- (NSString *)saveImageWithImage:(UIImage *)image withType:(NSString *)fileName
{
    if (image) {
        NSString *homePath = NSHomeDirectory();
        NSString *strPath = [NSString stringWithFormat:@"tmp/%@",fileName];
        //set image path
        NSString *imagePath = [homePath stringByAppendingPathComponent:strPath];
        //save image
        [UIImageJPEGRepresentation(image,1.0) writeToFile:imagePath atomically:YES];
        
//        NSString *faceUrl = [[NSUserDefaults standardUserDefaults] objectForKey:USERINFO_FACE];
//        
//        if (faceUrl) {
//            //移除之前的头像
//            [[SDImageCache sharedImageCache] removeImageForKey:faceUrl];
//        }
        
        return imagePath;
    } else {
        return nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
