//
//  LogMacro.h
//  CBExtension
//
//  Created by ly on 13-6-29.
//  Copyright (c) 2013年 Lei Yan. All rights reserved.
//
/*************打印信息相关的方法定义***********/
#ifndef ProjectStructure_LogMacro_h
#define ProjectStructure_LogMacro_h

#ifdef LOG_SHOW_MODAL

#  define PMETHODBEGIN NSLog(@"+++%s/(%d) come in+++", __func__, __LINE__)
#  define PMETHODEND  NSLog(@"---%s/(%d) come out---", __func__, __LINE__)
#  define PINFO(KEY,VALUE) NSLog(@"***%@/%@ %@ = %@***",NSStringFromClass([self class]), NSStringFromSelector(_cmd),KEY,VALUE)
#  define PINT(KEY,VALUE) NSLog(@"###%@/%@ %@ = %d###",NSStringFromClass([self class]), NSStringFromSelector(_cmd),KEY,VALUE)
#  define PFLOAT(KEY,VALUE) NSLog(@"###%@/%@ %@ = %f###",NSStringFromClass([self class]), NSStringFromSelector(_cmd),KEY,VALUE)
#  define PDOUBLE(KEY,VALUE) NSLog(@"###%@/%@ %@ = %f###",NSStringFromClass([self class]), NSStringFromSelector(_cmd),KEY,VALUE)
#  define POBJECT(A) NSLog(@"%s(%d): \n***INFO= %@***", __func__, __LINE__,A)
#  define PERROR(A) NSLog(@"%s(%d): \n###error= %@###",__func__, __LINE__,A)
#  define PSUBVIEWS(A) NSLog(@"%@/%@~~~subviews =~~~\n %@",NSStringFromClass([self class]), NSStringFromSelector(_cmd),[A subviews])

#else


#  define PMETHODBEGIN
#  define PMETHODEND
#  define PINT(KEY,VALUE)
#  define PFLOAT(KEY,VALUE)
#  define PDOUBLE(KEY,VALUE)
# define  PINFO(KEY,VALUE)
#  define POBJECT(A)
#  define PERROR(A)
#  define PSUBVIEWS(A)

#endif

//#define NSLog(...) @""

#endif
