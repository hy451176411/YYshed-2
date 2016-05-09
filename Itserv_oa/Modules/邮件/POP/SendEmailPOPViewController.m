//
//  SendEmailPOPViewController.m
//  Itserv_oa
//
//  Created by xiexianhui on 14-6-5.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import "SendEmailPOPViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ContactsViewController.h"
#import "RADataObject.h"
#import "PeopleNameView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PicFileView.h"
#import "SBHPublicDate.h"
#import "EmailContactsViewController.h"

@interface SendEmailPOPViewController ()<ContactsViewDelegate,PicFileViewDelegate,UIAlertViewDelegate>
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

    NSMutableArray *_muArrImg;//保存需要上传的图片

    IBOutlet UIScrollView *_scrollViewPic;//图片

}
@end

@implementation SendEmailPOPViewController

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
    //判断是否需要保存
    if (_muArrPerson.count == 0 && _muArrPersonCc.count == 0 && _muArrPersonBcc.count == 0 && _fileTheme.text.length == 0 && _textViewContent.text.length == 0) {
        
    } else {//提示是否保存
        if (_type == SendMail) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"是否要将此邮件存为草稿?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
            return;
        }
        
    }
    [self back];
}

- (void)back
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {//要保存
        NSString *strDraftID = @"";
        if (_dicDraft) {
            strDraftID = _dicDraft[@"draftID"];
        }
        NSDictionary *dic = @{@"to":_muArrPerson,@"cc":_muArrPersonCc,@"bcc":_muArrPersonBcc,@"subject":_fileTheme.text,@"content":_textViewContent.text,@"draftID":strDraftID,@"time":[SBHPublicDate dateWithDate:[NSDate date]]};
        [SaveData saveEmailDic:dic index:_index];
        
        
        if (_delegate && [_delegate respondsToSelector:@selector(saveDraftEmail)] && _dicDraft) {
            [_delegate saveDraftEmail];
        }
        
    }
    [self back];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_type == SendMail) {
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

//    [_fileAddressee becomeFirstResponder];
    _scrollViewBg.contentSize = CGSizeMake(_scrollViewBg.width, _textViewContent.top + _textViewContent.height + 20);
    
    _viewFile.top = ScreenHeight;
    _btnFile.top = _viewFile.top - _btnFile.height - 5;
//    _viewFile.hidden = YES;
//    _btnFile.hidden = YES;
    
    if (_dicDraft) {
        [self loadDraftDetail:_dicDraft];
//        [self performSelector:@selector(loadDraftDetail:) withObject:_dicDraft afterDelay:0.5];
    }
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark 从草稿箱进入编辑
- (void)loadDraftDetail:(NSDictionary *)dic
{
    //收件人
    //收件人数据
    NSArray *arrSendto = dic[@"to"];
    [self contactsWithPeople:arrSendto withType:1];
    //抄送
    NSArray *arrCC = dic[@"cc"];
    [self contactsWithPeople:arrCC withType:2];
    //密送
    NSArray *arrBCC = dic[@"bcc"];
    [self contactsWithPeople:arrBCC withType:3];
    //主题
    NSString *strMailTitle = dic[@"subject"];
    _fileTheme.text = strMailTitle;
    //内容
    NSString *content = dic[@"content"];
    _textViewContent.text = content;
    //附件
    NSArray *arrAttachments = dic[@"arrAttachment"];
    if (arrAttachments.count > 0) {
        [self showFileView];
        
        CGFloat widthBtn = 85;
        CGFloat heightBtn = 90;
        CGRect rect = CGRectMake(0, 5, widthBtn, heightBtn);
        CGFloat originX = 10;
        for (int i = 0; i < arrAttachments.count; i++) {
            
            rect.origin.x = originX;
            
            PicFileView *picFileView = [[PicFileView alloc] initWithFrame:rect];
            picFileView.delegate = self;
            [_scrollViewPic addSubview:picFileView];
            [_muArrImg addObject:picFileView];
            
            NSDictionary *dic = arrAttachments[i];
            id data = dic[@"data"];
            UIImage *img = nil;
            if ([data isKindOfClass:[UIImage class]]) {
                img = dic[@"data"];
            } else {
                img = nil;
                picFileView.data = data;
            }

            NSString *fileName = dic[@"fileName"];
            [picFileView loadWithImg:img withFileName:fileName];
            
            originX = picFileView.right + 10;
        }
        
        int num = [_muArrImg count];
        
        [_scrollViewPic setContentSize:CGSizeMake((widthBtn+10)*num, 0)];
//        [picFileView loadWithImg:img withFileName:strfileName];
    }
}

- (void)loadDic:(MCOMessageParser *)parser
{
    self.msgParser = parser;
    [self performSelector:@selector(loadReplyForwardingDic:) withObject:parser afterDelay:0.01];
}

#pragma mark 回复和转发邮件显示收件人主题，
- (void)loadReplyForwardingDic:(MCOMessageParser *)messageParser
{
    MCOMessageHeader *header = messageParser.header;
    //收件人
    if (_type == ReplyMail) {
        //收件人数据
        NSMutableArray *muArrTo = [NSMutableArray array];
        MCOAddress *address = header.from;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:address.mailbox forKey:@"mail"];
        NSString *strName = address.displayName;
        if (!strName) {
            strName = address.mailbox;
        }
        [dic setObject:strName forKey:@"personname"];
        RADataObject *data = [RADataObject dataObjectWithDic:dic children:nil];
        [muArrTo addObject:data];
        [self contactsWithPeople:muArrTo withType:1];
    }
   
    //主题
    NSString *strMailTitle = header.subject;
    NSMutableString *strTitle = [NSMutableString string];
    if (_type == SendMail && _dicDraft) {
        [strTitle appendFormat:@"%@",strMailTitle];
    } else {
        (_type == ReplyMail) ? [strTitle appendFormat:@"回复:%@",strMailTitle] : [strTitle appendFormat:@"转发:%@",strMailTitle];
    }
      _fileTheme.text = strTitle;
    //内容
    NSString *content = messageParser.plainTextBodyRendering;
    if (!content.length) {
        content = messageParser.htmlBodyRendering;
        if (!content.length) {
            content = @"";
        } else {
            content = [content stringFilterHTML];
        }
    } else {
        content = [[MailMessage sharedInstance] contentWithStr:content arr:messageParser.attachments];
    }
    NSMutableString *muStrContent = nil;
    if (_type == SendMail) {
        if (content) {
            muStrContent = [NSMutableString stringWithString:content];
        } else {
            muStrContent = [NSMutableString string];
        }
    } else {
        muStrContent = [NSMutableString stringWithFormat:@"\n\n\n\n------------------ 原始邮件 ----------------\n%@",content];
    }
    _textViewContent.text = muStrContent;

    if (_type == ForwardingMail) {//转发
        //显示附件
        
        NSArray *arrAttachment = messageParser.attachments;
        NSLog(@"附件：%@",arrAttachment);
        if (arrAttachment.count > 0 ) {
            [self showFileView];
            
            CGFloat widthBtn = 85;
            CGFloat heightBtn = 90;
            CGRect rect = CGRectMake(0, 5, widthBtn, heightBtn);
            CGFloat originX = 10;
            for (int i = 0; i < arrAttachment.count; i++) {
                
                rect.origin.x = originX;
                
                PicFileView *picFileView = [[PicFileView alloc] initWithFrame:rect];
                picFileView.delegate = self;
                [_scrollViewPic addSubview:picFileView];
                [_muArrImg addObject:picFileView];
                picFileView.isLine = YES;
                
                MCOAttachment *attachment = arrAttachment[i];
//                NSString *mimetype = attachment.mimeType;
                UIImage *img = [UIImage imageWithData:attachment.data];
                NSString *fileName = attachment.filename;
                
                if (!img) {
                    picFileView.data = attachment.data;
                }
                [picFileView loadWithImg:img withFileName:fileName];
                originX = picFileView.right + 10;
            }
            int num = [_muArrImg count];
            [_scrollViewPic setContentSize:CGSizeMake((widthBtn+10)*num, 0)];
        }
    }
    
    
//    //附件
//    NSArray *arrAttachment = dicData[@"attachments"];
//    [_muArrFile addObjectsFromArray:arrAttachment];
}

- (void)loadContacts:(NSInteger)type
{
//    if (!ctrl) {
       EmailContactsViewController *ctrl = [[EmailContactsViewController alloc] initWithNibName:[AppDelegate strCtrlName:@"EmailContactsViewController"] bundle:nil];
        ctrl.delegate = self;
//    } else {
////        [ctrl reloadData];
//    }
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
            data.viewPeople = nameView;
        }
        
        [vBg addSubview:nameView];

        
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
        
    sender.enabled = NO;
    [self.view endEditing:YES];
    NSString *strTheme =  _fileTheme.text;//主题
    NSString *strContent =  _textViewContent.text;//内容
    id file;
    
    NSString *strAttachments = @"";
    file = strAttachments;

    if (_muArrPerson.count == 0) {//收件人不能为空
        [SBPublicAlert showMBProgressHUD:@"收件人不能为空" andWhereView:self.view hiddenTime:kHiddenAlertTime];
    } else if (strTheme.length == 0) {//主题不能为空
        [SBPublicAlert showMBProgressHUD:@"主题不能为空" andWhereView:self.view hiddenTime:kHiddenAlertTime];
    } else {//发送邮件
        __block UIButton *btn = sender;
        
        __block SendEmailPOPViewController *popCtrl = self;
        
        NSArray *arrFile = @[];
        if (_type == ForwardingMail) {
            arrFile = _muArrImg;
        } else if (_type == SendMail) {
            arrFile = _muArrImg;
        }
        [SBPublicAlert showMBProgressHUD:@"" andWhereView:self.view states:NO];
        
        [[MailMessage sharedInstance] sendEmailToArr:_muArrPerson
                                               ccArr:_muArrPersonCc
                                              bccArr:_muArrPersonBcc
                                             subject:strTheme
                                         contentText:strContent
                                       attachmentArr:arrFile
                                            mailType:_type
                                       withIsSuccess:^(BOOL success){
                                           
                                           if (success) {
                                               btn.enabled = YES;
                                               [popCtrl showAlertSuccess:success];
                                           } else {
                                               [SBPublicAlert showMBProgressHUD:@"发送失败" andWhereView:self.view hiddenTime:kHiddenAlertTime];
                                           }
        }];
    }
}

- (void)showAlertSuccess:(BOOL)success
{
    
    NSMutableArray *muArr = [NSMutableArray array];
    for (int i = 0; i < _muArrImg.count; i++) {
        NSMutableDictionary *dicAttachment = [NSMutableDictionary dictionary];
        PicFileView *picFileView = _muArrImg[i];
        UIImage *img = picFileView.img;
        NSString *imgName = picFileView.strImgName;
        
        if (!img) {
            img = picFileView.data;
        }
        dicAttachment[@"isLine"] = @(picFileView.isLine);
        dicAttachment[@"data"] = img;
        dicAttachment[@"fileName"] = imgName;
        [muArr addObject:dicAttachment];
    }
    
    NSDate *date = [SBHPublicDate dateWithDate:[NSDate date]];
    NSString *strDraftID = [SBHPublicDate stringConversionWithDate:date timeType:@"yyyy-MM-dd HH:mm:ss"];
    NSDictionary *dic = @{@"to":_muArrPerson,@"cc":_muArrPersonCc,@"bcc":_muArrPersonBcc,@"subject":_fileTheme.text,@"content":_textViewContent.text,@"draftID":strDraftID,@"time":date,@"arrAttachment":muArr};
//将发送的邮件保存到本地
    [SaveData saveSendEmailDic:dic];
    
    NSString *strMessage = @"发送成功";
    if (!success) {
        strMessage = @"发送失败";
        [SBPublicAlert showMBProgressHUD:strMessage andWhereView:self.view hiddenTime:kHiddenAlertTime];
    } else {
        [SBPublicAlert showMBProgressHUD:strMessage andWhereView:self.view hiddenTime:kHiddenAlertTime];
        
        if (_type == SendMail) {
            [self performSelector:@selector(sendFinsh) withObject:nil afterDelay:kHiddenAlertTime - 0.5];
        } else {
            [self performSelector:@selector(back) withObject:nil afterDelay:kHiddenAlertTime - 0.5];
        }
    }
 }

- (void)sendFinsh
{
    [self back];
    if (_delegate && [_delegate respondsToSelector:@selector(sendDraftEmailSuccessIndex:)] && _dicDraft) {
        [_delegate sendDraftEmailSuccessIndex:_index];
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
            [self showFileView];
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
                [self showFileView];
            } completion:^(BOOL finsh) {
            }];
        }
    }
    [self.view endEditing:YES];
}


- (void)showFileView
{
    _viewFile.top = ScreenHeight - _viewFile.height;
    _btnFile.top = _viewFile.top - _btnFile.height - 5;
    _viewFile.hidden = NO;
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
            if (_muArrPerson.count > 0) {
                [self clearPeopleWithArr:_muArrPerson withView:_viewAddressee withField:_fileAddressee];
                return NO;
            }
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
    
    field.left = originX + 4;
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
