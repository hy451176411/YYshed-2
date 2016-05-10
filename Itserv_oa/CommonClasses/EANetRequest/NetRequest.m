//
//  NetRequest.m
//  正式版网络请求类
//
//  Created by houpeng on 13-7-4.
//  Copyright (c) 2013年 eastedge. All rights reserved.
//

#import "NetRequest.h"

#import "ModelManager.h"

#include <CommonCrypto/CommonDigest.h>

#include <CommonCrypto/CommonHMAC.h>
#import "PicFileView.h"
#import "NSString+Extension.h"

@implementation NetRequest

- (void)dealloc
{
    for (ASIHTTPRequest *request in _requestDic.allValues) {
        [request clearDelegatesAndCancel];
        request.delegate = nil;
    }
    [_requestDic release];
    [super dealloc];
}


/* - (id)init */
//
- (id)init
{
    self = [super init];
    if (self) {
        _requestDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

/* - (id)initWith: */
//
- (id)initWithDelegate:(id <NetRequestDelegate>)aDelegate
{
    self = [super init];
    if (self) {
        
        _requestDic = [[NSMutableDictionary alloc] init];
        _delegate = aDelegate;
    }
    return self;
}

- (void)setRequest:(ASIHTTPRequest *)request forKey:(int)tag
{
    NSString *tagKey = [NSString stringWithFormat:@"%d",tag];
    ASIHTTPRequest *tempRequest = [_requestDic objectForKey:tagKey];
    [tempRequest clearDelegatesAndCancel];
    [_requestDic setObject:request forKey:tagKey];
}

- (ASIHTTPRequest *)creatRequestURLAndData:(NSString *)APIUrl WithDic:(id)tempDicOrStr withTag:(int)tag
{
    NSString *strUrl = [AppDelegate getAppDelegate].strOA;
    if (tag >= MailList || tag == SendEmail || tag == EmailContent || tag == DeleteMail) {
        strUrl = [AppDelegate getAppDelegate].strEmail;
    }
    
    if (tag == SendEmail) {//发送邮件
        NSString *strFace = [[AppDelegate getAppDelegate].strEmail stringByReplacingOccurrencesOfString:@"interface?OpenAgent" withString:@"HandleMailFromApp?OpenAgent"];
        strUrl = [NSString stringWithFormat:@"%@",strFace];
    }
    
    
    ASIFormDataRequest *request= nil;
    NSMutableString *urlStr = [NSMutableString stringWithString:strUrl];
    
    if ([tempDicOrStr isKindOfClass:[NSString class]] || tempDicOrStr == nil) {
        urlStr = [NSMutableString stringWithFormat:@"%@func=%@",strUrl,APIUrl];
        
        [urlStr appendFormat:@"%@",tempDicOrStr];
        
        request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
        request.delegate = self;
        [request setRequestMethod:@"GET"];
        [request setPostFormat:ASIURLEncodedPostFormat];
        [self setRequest:request forKey:tag];
        
    }else if ([tempDicOrStr isKindOfClass:[NSDictionary class]]) {
        NSString *strUrlData = tempDicOrStr[@"url"];
        urlStr = [NSMutableString stringWithFormat:@"%@func=%@",strUrl,APIUrl];

        urlStr = [NSMutableString stringWithFormat:@"%@%@",urlStr,strUrlData];
        
        request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
        request.delegate = self;
        //post表单的内容与文件上传
        NSString *stringBoundary = @"*****";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
        [request addRequestHeader:@"Content-Type" value:contentType];
        
        
        //create the body
        NSMutableData *postBody = [NSMutableData data];
        [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        //        NSArray *arrKey = tempDicOrStr[@"img"];
        //        for (int i = 0; i < arrKey.count; i++) {
        //            NSString *key = arrKey[i];
        //            if (![key isEqualToString:@"url"]) {
        //                NSString *value = tempDicOrStr[key];
        //                [request setPostValue:value forKey:key];
        //            } else {
        NSArray *arrImg = tempDicOrStr[@"img"];
        for (int j = 0; j < arrImg.count; j++) {
            PicFileView *picFileView = arrImg[j];
            UIImage *img = picFileView.img;
            NSData *dataImg = UIImagePNGRepresentation(img);
            NSString *imgName = picFileView.strImgName;
            NSString *imgKey = [NSString stringWithFormat:@"file"];
            NSString *type = [NSString stringWithFormat:@"image/%@",picFileView.strImgType];
            [request addData:dataImg withFileName:imgName andContentType:type forKey:imgKey];
        }
        
        NSDictionary *dict = tempDicOrStr[@"value"];
        if (dict && dict.count) {
            for (NSString *strKey in dict) {
                
                // strKey为键，str为值
                NSString *pair = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n",stringBoundary,strKey];
                [postBody appendData:[pair dataUsingEncoding:NSUTF8StringEncoding]];
                
                id value = [dict objectForKey:strKey];
                if ([value isKindOfClass:[NSString class]]) {
                    [postBody appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
                }else if ([value isKindOfClass:[NSData class]]){
                    [postBody appendData:value];
                }
                [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                
            }
        }
        [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setPostBody:postBody];
        [request setRequestMethod:@"POST"];
        [self setRequest:request forKey:tag];
        
    }
    request.timeOutSeconds = 30;
    NSLog(@"urlStr== %@\n",urlStr);
    
    request.tag = tag;
    return request;
}

#pragma mark 登录接口
- (void)netRequestLoginUser:(NSString *)user password:(NSString *)pwd
{
    user = [user stringEncodeWithURLString:user];
    NSString *tempStr = [NSString stringWithFormat:@"&username=%@&password=%@",user,pwd];
    
    ASIHTTPRequest *request = [self creatRequestURLAndData:Login_API WithDic:tempStr withTag:Login];
    [self startAsynchronousWithRequest:request];
}

-(void)login:(NSString*) username password:(NSString*) psd{
	NSMutableDictionary *resultsDictionary;// 返回的 JSON 数据
	NSDictionary *userDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:username, @"username",psd,@"password",nil];
	if ([NSJSONSerialization isValidJSONObject:userDictionary])
	{
		NSError *error;
		NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userDictionary options:NSJSONWritingPrettyPrinted error: &error];
		NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];
		NSURL *url = [NSURL URLWithString:@"http://182.92.67.74/api/sessions"];
		ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
		[request setRequestMethod:@"POST"];
		request.tag = Login;
		request.delegate = self;
		[request setPostBody:tempJsonData];
		[request startSynchronous];
		NSError *error1 = [request error];
		if (!error1) {
			NSString *response = [request responseString];
			NSLog(@"Test：%@",response);
		}
	}
}

#pragma mark 登录接口
- (void)netRequestLoginUser:(NSString *)user password:(NSString *)pwd verifycode:(NSString *)strCode
{
    NSString *strDevice = @"ios";
    if (!DevicePhone) {
        strDevice = @"iospad";
    }
    user = [user stringEncodeWithURLString:user];
    NSString *tempStr = [NSString stringWithFormat:@"&username=%@&password=%@&device=%@&imsi=&mac=&uuid=%@&verifycode=%@",user,pwd,strDevice,[SBAppMessage sbhDeviceUUID],strCode];
    
    ASIHTTPRequest *request = [self creatRequestURLAndData:Login_API WithDic:tempStr withTag:Login];
    [self startAsynchronousWithRequest:request];
}

#pragma mark 确认登录 http://localhost:8088/names.nsf?login&username=xxx&password=xxx
- (void)netRequestSureLoginUser:(NSString *)user password:(NSString *)pwd tag:(NSInteger)tag
{
    user = [user stringEncodeWithURLString:user];

    NSString *strIp = (tag == SureLogin) ? [AppDelegate getAppDelegate].strIp : [AppDelegate getAppDelegate].strMailIP;
    NSString *tempStr = [NSString stringWithFormat:@"&username=%@&password=%@",user,pwd];
    NSString *strApi = [NSString stringWithFormat:@"%@/names.nsf?",strIp];
    ASIHTTPRequest *request= nil;
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@%@%@&redirectto=%@/blank.htm",strApi,SureLogin_API,tempStr,strIp];
    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.delegate = self;
    [request setRequestMethod:@"GET"];
    NSLog(@"oa验证：%@",urlStr);
    [self setRequest:request forKey:tag];
    request.timeOutSeconds = 30;
    request.tag = tag;
    [self startAsynchronousWithRequest:request];
}

#pragma mark 注册
- (void)netRequestRegistUsername:(NSString *)username
                           phone:(NSString *)phone
                          bureau:(NSString *)bureau
                            dept:(NSString *)dept
{
    NSString *strDevice = @"ios";
    if (DevicePad) {
        strDevice = @"iospad";
    }
    NSString *tempStr = [NSString stringWithFormat:@"&appid=&appsecret=&username=%@&phone=%@&bureau=%@&dept=%@&device=%@&imsi=&mac=&uuid=%@",username,phone,bureau,dept,strDevice,[SBAppMessage sbhDeviceUUID]];
    
    ASIHTTPRequest *request = [self creatRequestURLAndData:Regist_API WithDic:tempStr withTag:Regist];
    [self startAsynchronousWithRequest:request];
}

//获取文件内容
- (void)netRequestFile:(NSString *)url
{
    ASIHTTPRequest *request= nil;
    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    request.delegate = self;
    [request setRequestMethod:@"GET"];
    [self setRequest:request forKey:DownFile];
    request.tag = ReadFile;
    [self startAsynchronousWithRequest:request];
}

#pragma mark 下载文件
- (void)netRequestDownFile:(NSString *)url withFileName:(NSString *)fileName
{
	ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
	//    fileName = [fileName stringEncodeWithURLString:fileName];
	NSString *filePath = kSaveFilePath(fileName);
	//设置文件保存路径
	request.delegate = self;
	[request setDownloadDestinationPath:filePath];
	[self setRequest:request forKey:DownFile];
	request.tag = DownFile;
	[self startAsynchronousWithRequest:request];
	
}

#pragma mark 获取子菜单列表getSubMenuList
- (void)netRequestgetSubMenuListMenuid:(NSString *)menuid
{
    NSString *userID = [AppDelegate getUserId];
    NSString *tempStr = [NSString stringWithFormat:@"&userid=%@&menuid=%@",userID,menuid];
    
    ASIHTTPRequest *request = [self creatRequestURLAndData:getSubMenuList WithDic:tempStr withTag:SubMenuList];
    [self startAsynchronousWithRequest:request];
}

#pragma mark 获取待处理列表getNeedDealList  待办
- (void)netRequestNeedDealListStar:(int)start dotype:(int)dotype size:(int)size
{
    NSString *userID = [AppDelegate getUserId];
    NSString *tempStr = [NSString stringWithFormat:@"&start=%d&userid=%@&limit=%d&dotype=%d",(start*PageSize),userID,PageSize,dotype];
    
    NSInteger tagType = NeedDealList;
    switch (dotype) {
        case 0:
            tagType = NeedDealList;
            break;
        case 1:
            tagType = NeedDealListOne;
            break;
        case 2:
            tagType = NeedDealListCounter;
            break;
        case 3:
            tagType = NeedDealListDo;
            break;
        default:
            break;
    }
    ASIHTTPRequest *request = [self creatRequestURLAndData:getNeedDealList WithDic:tempStr withTag:tagType];
    [self startAsynchronousWithRequest:request];
}


#pragma mark 获取推送消息列表getNotifyMsgList  从0开始  分页
- (void)netRequestNotifyMsgListStart:(int)start size:(int)size
{
    NSString *userID = [AppDelegate getUserId];
    NSString *tempStr = [NSString stringWithFormat:@"&start=%d&userid=%@&limit=%d",(start*PageSize),userID,PageSize];
    
    ASIHTTPRequest *request = [self creatRequestURLAndData:getNotifyMsgList WithDic:tempStr withTag:NotifyMsgList];
    [self startAsynchronousWithRequest:request];
}

#pragma mark 获取公文列表getDocList
- (void)netRequestNeedDealListStar:(int)start moduleid:(NSString *)moduleid size:(int)size type:(NSString *)type
{
    if (type.length == 0) {
        type = @"1";
    }
    NSString *userID = [AppDelegate getUserId];
    NSString *tempStr = [NSString stringWithFormat:@"&start=%d&userid=%@&moduleid=%@&limit=%d&type=%@",(start*PageSize),userID,moduleid,PageSize,type];
    
    NSInteger tag = DocList;
    ASIHTTPRequest *request = [self creatRequestURLAndData:getDocList WithDic:tempStr withTag:tag];
    [self startAsynchronousWithRequest:request];
}

//获取公文列表getDocList  综合查询
- (void)netRequestNeedDealListStar:(int)start
                          moduleid:(NSString *)moduleid
                              size:(int)size
                           keyword:(NSString *)keyword
                         startTime:(NSString *)startTime
                           endTime:(NSString *)endTime
{
    if (!startTime) {
        startTime = @"";
    }
    if (!endTime) {
        endTime = @"";
    }
    
    keyword = [keyword stringEncodeWithURLString:keyword];
    NSString *userID = [AppDelegate getUserId];
    NSString *tempStr = [NSString stringWithFormat:@"&start=%d&userid=%@&moduleid=%@&limit=%d&keyword=%@&type=4&Starttime=%@&endtime=%@",(start*PageSize),userID,moduleid,PageSize,keyword,startTime,endTime];
    
    NSInteger tag = DocList;
    ASIHTTPRequest *request = [self creatRequestURLAndData:getDocList WithDic:tempStr withTag:tag];
    [self startAsynchronousWithRequest:request];
}

#pragma mark 获取邮件列表getMailList
- (void)netRequestMailListStart:(int)start type:(int)type
{
    NSString *userID = [AppDelegate getUserId];
    NSString *tempStr = [NSString stringWithFormat:@"&start=%d&userid=%@&limit=%d&type=%d",(start*PageSize),userID,PageSize,type];
    
    NSInteger tag = MailList + type;
    ASIHTTPRequest *request = [self creatRequestURLAndData:getMailList WithDic:tempStr withTag:tag];
    [self startAsynchronousWithRequest:request];
}

#pragma mark 删除邮件deleteMail
- (void)netRequestDeleteMailID:(NSString *)mailId
{
    NSString *userID = [AppDelegate getUserId];
    NSString *tempStr = [NSString stringWithFormat:@"&userid=%@&mailid=%@",userID,mailId];
    
    ASIHTTPRequest *request = [self creatRequestURLAndData:deleteMail WithDic:tempStr withTag:DeleteMail];
    [self startAsynchronousWithRequest:request];
}

#pragma mark 邮件内容
- (void)netRequestEmailContetn:(NSString *)emailID
{
    NSString *userID = [AppDelegate getUserId];
    NSString *tempStr = [NSString stringWithFormat:@"&userid=%@&id=%@",userID,emailID];
    
    ASIHTTPRequest *request = [self creatRequestURLAndData:getMail WithDic:tempStr withTag:EmailContent];
    [self startAsynchronousWithRequest:request];
}

#pragma mark 获取通讯录getContactList
- (void)netRequestContactListStart:(int)start
{
    NSString *userID = [AppDelegate getUserId];
    NSString *tempStr = [NSString stringWithFormat:@"&userid=%@&start=%d",userID,(start*PageSize)];
    
    ASIHTTPRequest *request = [self creatRequestURLAndData:getContactList WithDic:tempStr withTag:ContactList];
    [request setTimeOutSeconds:60];
    [self startAsynchronousWithRequest:request];
}

#pragma mark 搜索
- (void)netRequestPeopleSearch:(NSString *)strSearch
{
    strSearch = [strSearch stringEncodeWithURLString:strSearch];
    NSString *tempStr = [NSString stringWithFormat:@"&search=%@",strSearch];
    
    NSString *strOaaddress = @"http://10.44.0.83";
    ASIHTTPRequest *request= nil;
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@/oa.nsf/%@?OpenAgent%@",strOaaddress,getContactSearch,tempStr];
    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.delegate = self;
    [request setRequestMethod:@"GET"];
    NSLog(@"search:%@",urlStr);
    [self setRequest:request forKey:ContactList];
    request.tag = ContactSearch;
    [self startAsynchronousWithRequest:request];
}

#pragma mark 获取通讯录getContactList
- (void)netRequestEmailContactListDept:(NSString *)strDept
{
    strDept = [strDept stringEncodeWithURLString:strDept];
    NSString *tempStr = [NSString stringWithFormat:@"&dept=%@",strDept];
    
    NSString *strOaaddress = @"http://10.44.0.83";
    ASIHTTPRequest *request= nil;
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@/oa.nsf/%@?OpenAgent%@",strOaaddress,getContactList,tempStr];
    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.delegate = self;
    [request setRequestMethod:@"GET"];
    NSLog(@"%@",urlStr);
    [self setRequest:request forKey:ContactList];
    request.tag = ContactList;
    [self startAsynchronousWithRequest:request];
}


#pragma mark 获取版本号
- (void)netRequestVersion
{
    ASIHTTPRequest *request = [self creatRequestURLAndData:getVersion WithDic:@"" withTag:Version];
    [self startAsynchronousWithRequest:request];
}

#pragma mark //获取服务器机构
- (void)netRequestAgency
{//http://10.44.0.83/oa.nsf/getContactList?OpenAgent&dept=%E5%B9%BF%E4%B8%9C%E6%A3%80%E9%AA%8C%E6%A3%80%E7%96%AB%E5%B1%80
//    [self netRequestEmailContactListDept:@"广东检验检疫局"];
//    return;
    ASIHTTPRequest *request = [self creatRequestURLAndData:getServerList WithDic:@"" withTag:Server];
    [self startAsynchronousWithRequest:request];
}

#pragma mark 获取pad验证码
- (void)netRequestCodeUsername:(NSString *)username bureau:(NSString *)bureau password:(NSString *)pass
{
    NSString *strDevice = @"iospad";
//    if (DevicePhone) {
//        strDevice = @"ios";
//    }
    bureau = [bureau stringEncodeWithURLString:bureau];
    username = [username stringEncodeWithURLString:username];
    
    NSString *tempStr = [NSString stringWithFormat:@"&username=%@&bureau=%@&password=%@&device=%@&imsi=&mac=&uuid=%@",username,bureau,pass,strDevice,[SBAppMessage sbhDeviceUUID]];
    ASIHTTPRequest *request = [self creatRequestURLAndData:getVerificationCode WithDic:tempStr withTag:VerficationCode];
    [self startAsynchronousWithRequest:request];
}

#pragma mark 发送邮件sendMail
- (void)netRequestSendMailFrom:(NSString *)from
                        sendto:(NSString *)sendto
                        copyto:(NSString*)copyto
                       blindto:(NSString *)blindto
                         title:(NSString *)title
                       content:(NSString *)content
                   attachments:(id)attachments
{
    NSString *userID = [AppDelegate getUserId];
    if (!copyto) {
        copyto = @"";
    }
    
    if (!blindto) {
        blindto = @"";
    }
    
    if (!content) {
        content = @"";
    }
    
    from = [from stringEncodeWithURLString:from];
    sendto = [sendto stringEncodeWithURLString:sendto];
    title = [title stringEncodeWithURLString:title];
    content = [content stringEncodeWithURLString:content];
    copyto = [copyto stringEncodeWithURLString:copyto];
    blindto = [blindto stringEncodeWithURLString:blindto];

    NSString *tempStr = [NSString stringWithFormat:@"&userid=%@&from=%@&sendto=%@&copyto=%@&blindto=%@&title=%@&content=%@",userID,from,sendto,copyto,blindto,title,content];
    //post
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    
    if ([attachments isKindOfClass:[NSArray class]]) {//上传附件
        
        [muDic setObject:tempStr forKey:@"url"];
        [muDic setObject:attachments forKey:@"img"];
        
    } else {//转发附件
        attachments = [attachments stringEncodeWithURLString:attachments];
        NSString *strData = [NSString stringWithFormat:@"%@&attachments=%@",tempStr,attachments];
        [muDic setObject:strData forKey:@"url"];
    }
    
  
//    if ([[AppDelegate getAppDelegate].strEmail rangeOfString:@"HandleMailFromApp?OpenAgent"].location == NSNotFound) {
//        ASIHTTPRequest *request = [self creatRequestURLAndData:getSendMail WithDic:tempStr withTag:SendEmail];
//        [self startAsynchronousWithRequest:request];
//        return;
//    }
    
    
    ASIHTTPRequest *request = [self creatRequestURLAndData:getSendMail WithDic:muDic withTag:SendEmail];
    [self startAsynchronousWithRequest:request];
}

- (void)netRequestNewSendMailFrom:(NSString *)from
                        sendto:(NSString *)sendto
                        copyto:(NSString*)copyto
                       blindto:(NSString *)blindto
                         title:(NSString *)title
                       content:(NSString *)content
                   attachments:(id)attachments
{
    NSString *userID = [AppDelegate getUserId];
    if (!copyto) {
        copyto = @"";
    }
    
    if (!blindto) {
        blindto = @"";
    }
    
    if (!content) {
        content = @"";
    }
    
//    sendto = @"999,admin";
//    sendto = [sendto stringEncodeWithURLString:sendto];
//    title = [title stringEncodeWithURLString:title];
//    content = [content stringEncodeWithURLString:content];
//    copyto = [copyto stringEncodeWithURLString:copyto];
//    blindto = [blindto stringEncodeWithURLString:blindto];
    
    NSString *tempStr = [NSString stringWithFormat:@"&userid=%@",[userID stringEncodeWithURLString:userID]];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"from":from, @"sendto":sendto, @"copyto":copyto, @"blindto":blindto, @"title":title, @"content":content}];
    //post
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    
    if ([attachments isKindOfClass:[NSArray class]]) {//上传附件
        

        [muDic setObject:attachments forKey:@"img"];
        
    } else {//转发附件
//        attachments = [attachments stringEncodeWithURLString:attachments];
        [dict setObject:attachments forKey:@"attachments"];
//        NSString *strData = [NSString stringWithFormat:@"%@&attachments=%@",tempStr,attachments];
//        [muDic setObject:strData forKey:@"url"];
    }
    
    [muDic setObject:tempStr forKey:@"url"];
    [muDic setObject:dict forKey:@"value"];
    //    if ([[AppDelegate getAppDelegate].strEmail rangeOfString:@"HandleMailFromApp?OpenAgent"].location == NSNotFound) {
    //        ASIHTTPRequest *request = [self creatRequestURLAndData:getSendMail WithDic:tempStr withTag:SendEmail];
    //        [self startAsynchronousWithRequest:request];
    //        return;
    //    }
    
    
    ASIHTTPRequest *request = [self creatRequestURLAndData:getSendMail WithDic:muDic withTag:SendEmail];
    [self startAsynchronousWithRequest:request];
}

- (void)startAsynchronousWithRequest:(ASIHTTPRequest *)request
{
    [request startAsynchronous];
}


#pragma mark -
#pragma mark ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *responseStr = [request responseString];
    NSLog(@"responseStr\n++++++++++++++++\n%@\n++++++++++++++++\n%d-----%d", responseStr ,request.responseStatusCode,request.tag);

//    responseStr = [responseStr stringFilterHTML];
    
    NSDictionary *dic = [responseStr JSONValue];
    
    
    if (request.tag == SureLogin) {//第二次请求，保存cookie
        NSHTTPCookie *cookie = request.requestCookies[0];
        [SaveData saveCookie:cookie];
    } else if (request.tag == ReadFile) {//下载文件
        if ([_delegate respondsToSelector:@selector(netRequest:Finished:)]) {
            [_delegate netRequest:request.tag Finished:@{@"data":request.responseData}];
        }
        return;
        
    } else if (request.tag == DownFile) {//下载文件
        if ([_delegate respondsToSelector:@selector(netRequest:Finished:)]) {
            [_delegate netRequest:request.tag Finished:@{@"data":@"success"}];
        }
        return;
        
    } else {
        if (!dic) {
            
            responseStr = [responseStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            responseStr = [responseStr stringByReplacingOccurrencesOfString:@"\r" withString:@"\\n"];
            
            dic = [responseStr JSONValue];
        }
    }
    
    
    
    
    
    NSDictionary *dicModel = dic[@"funcdata"];
    
    if (request.tag != SureLogin && request.tag != SureMail) {
//        responseStr = [responseStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//        dicModel = dic[@"funcdata"];
        if (!dic) {//jsonvalue failed
            if ([_delegate respondsToSelector:@selector(netRequest:requestFailed:)]) {
                [_delegate netRequest:request.tag requestFailed:@"请求失败"];
            }
            return;
        } else {
            NSInteger funcstat = [dic[@"funcstat"] integerValue];
            NSDictionary *dicData = dic[@"funcdata"];
            NSString *strResult = dicData[@"result"];
            if (strResult) {
                BOOL success = [strResult boolValue];
                if (funcstat != 0 || !success) {
                    NSString *strMessage = @"请求失败";
                    switch (funcstat) {
                        case 3001:
                            strMessage = @"系统认证失败";
                            [[AppDelegate getAppDelegate] logout];
                            break;
                        case 3002:
                            strMessage = @"参数不合法";
                            break;
                        case 3003:
                            strMessage = @"系统繁忙";
                            break;
                        case 4001:
                            strMessage = @"无此API";
                            break;
                        case 0:{
                            if (!success) {
                                strMessage = dicData[@"resultinfo"];
                            }
                        }break;
                        default:
                            break;
                    }
                    
                    if ([_delegate respondsToSelector:@selector(netRequest:requestFailed:)]) {
                        [_delegate netRequest:request.tag requestFailed:strMessage];
                    }
                    return;
                }
            } else {
                if (funcstat != 0) {
                    NSString *strMessage = @"请求失败";
                    switch (funcstat) {
                        case 3001:
                            strMessage = @"系统认证失败";
                            [[AppDelegate getAppDelegate] logout];
                            break;
                        case 3002:
                            strMessage = @"参数不合法";
                            break;
                        case 3003:
                            strMessage = @"系统繁忙";
                            break;
                        case 4001:
                            strMessage = @"无此API";
                            break;
                        default:
                            break;
                    }
                    
                    if ([_delegate respondsToSelector:@selector(netRequest:requestFailed:)]) {
                        [_delegate netRequest:request.tag requestFailed:strMessage];
                    }
                    return;
                }
            }
        }
    }
    
    BaseModel *model = nil;
    
    /*请求成功*/
    if ([_delegate respondsToSelector:@selector(netRequest:Finished:)]) {
        [_delegate netRequest:request.tag Finished:dicModel];
    }
    //    if (model != nil) {
    //        [model release];
    //
    //    }
    
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    BaseModel *model = [ModelManager parseModelWithFaileResult:@"100" tag:request.tag];
    NSLog(@"请求超时：%@",request.error);
    /*请求超时*/
    if ([_delegate respondsToSelector:@selector(netRequest:Failed:)]) {
        [_delegate netRequest:request.tag Failed:@{@"result":@"0"}];
    }
}

@end
