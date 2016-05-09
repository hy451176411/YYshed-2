
//The MIT License (MIT)
//
//Copyright (c) 2013 Rafał Augustyniak
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of
//this software and associated documentation files (the "Software"), to deal in
//the Software without restriction, including without limitation the rights to
//use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//the Software, and to permit persons to whom the Software is furnished to do so,
//subject to the following conditions:
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>

@interface RADataObject : NSObject<NSCoding>

@property (strong, nonatomic) NSDictionary *dicOrgparent;
@property (strong, nonatomic) NSMutableArray *children;
@property (strong, nonatomic) NSString *strOrgId;//当前部门id
@property (strong, nonatomic) NSString *strOrgparentid;//父部门id

@property (nonatomic, assign) BOOL isOrgparentid;//是否有上级部门
@property (nonatomic, assign) BOOL isPeople;//是否是联系人
@property (nonatomic, assign) BOOL isOpen;

@property (nonatomic, assign) BOOL isAdd;//是否已经添加

@property (nonatomic, retain) UIView *viewPeople;

- (id)initWithDic:(NSDictionary *)dic children:(NSArray *)children;

+ (id)dataObjectWithDic:(NSDictionary *)dic children:(NSArray *)children;

@end
