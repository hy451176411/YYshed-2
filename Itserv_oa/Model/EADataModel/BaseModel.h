//
//  BaseModel.h
//  基类model，可以根据需要修改扩充
//
//  Created by houpeng on 13-7-4.
//  Copyright (c) 2013年 eastedge. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EADefine.h"

@interface BaseModel : NSObject

@property (retain, nonatomic) NSString *errorMessage;

@property (retain, nonatomic) NSString *Result;

@property (nonatomic, assign) BOOL success; /*可以通过这个判断是否请求成功并且有数据*/

@property (nonatomic, assign) NSInteger requestTag; /*这个与相应的请求的tag是同步的*/


- (id)initWithResult:(NSString*)aResult requestTag:(NSInteger)aRequestTag andErrorMessage:(NSDictionary *)error;

- (id)initWithRequestTag:(NSInteger)aRequestTag;

+ (BaseModel *)modelObjectWithDictionary:(NSDictionary *)dict;
- (id)initWithDictionary:(NSDictionary *)dict;

@end
