//
//  UITableViewCell.h
//  Itserv_oa
//
//  Created by mac on 16/5/10.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserTableViewCell : UITableViewCell


@property (strong,nonatomic) UIImageView *headerphoto;//头像
@property (strong,nonatomic) UILabel *nameLabel;//昵称
@property (strong,nonatomic) UILabel *isOnLine;//是否在线
@property (strong,nonatomic) UILabel *introductionLabel;//个性签名，动态等
@property (strong,nonatomic) UILabel *networkLabel;//网络状态


@end

