//
//  ModelManager.h
//  所有model的缓存，并带有解析所有model的方法
//
//  Created by houpeng on 13-7-4.
//  Copyright (c) 2013年 eastedge. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseModel.h"


@interface ModelManager : NSObject

//@property (nonatomic, retain) FriendShipFriendShipLIstModel *friendshipModel;

@property (nonatomic, assign) BOOL isClearCache;

+ (id)sharedModelManager;

/*
 字典转对象 正式版
 */
+ (BaseModel *)parseModelWithDictionary:(NSDictionary *)jsonDic
                                    tag:(int)tag;

+ (BaseModel *)parseModelWithFaileResult:(NSString *)result
                                     tag:(int)tag;

- (void)setModel:(BaseModel *)model WithTag:(int)tag;


/*
 *
 * 字典转对象 测试版
 *
 */
+ (BaseModel *)parseTestModelWithDictionary:(NSDictionary *)jsonDic
                                        tag:(int)tag;

/*
 *
 *  清除内存中的缓存
 *
 */

- (void)clearCacheInMemory;

@end
