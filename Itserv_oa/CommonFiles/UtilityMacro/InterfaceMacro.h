//
//  InterfaceMacro.h
//  ProjectStructure
//
//  Created by zhangfeng on 13-8-30.
//  Copyright (c) 2013年 zhangfeng. All rights reserved.
//
/****** 跟接口相关的宏定义 ******/
#ifndef ProjectStructure_InterfaceMacro_h
#define ProjectStructure_InterfaceMacro_h

#pragma mark - 服务器地址配置信息
#define DefaultServerAddress @"http://www.femtoapp.com/clients/lesson/services.php?wsdl"
//#define DefaultServerAddress @"http://115.28.13.32/soap/services.php?wsdl"

#pragma mark - webservice配置信息
#define DefaultWebServiceNameSpace @""

#pragma mark - 网络请求的默认请求方式
#define DefaultHttpMethod @"POST"//默认的http请求方式，如果POST用的多就设为POST

//所有接口共用的键
#define POSTHttpMethod @"POST" //POST请求方法
#define GETHttpMethod @"GET" //GET请求方法
#define PUTHttpMethod @"PUT" //PUT请求方法
#define DELETEHttpMethod @"DELETE" //DELETE请求方法

//请求接口时用的参数的键
#define kCeinID @"CeinID"
#define kPwd @"pwd"
#define kPage @"page"
#define kPageSize @"pageSize"

//接口返回的结果，共用的键
#define kCode @"code"
#define kData @"data"
#define kMessage @"msg"
#define kTotalPage @"totalpage"
#define kTotalCount @"totalCount"

#define kReturnNode @"return"

//每页请求的数据条数
#define PageSize 20

//开始页码
#define kStartPage 0

#endif



