//
//  FriendCell.h
//  Itserv_oa
//
//  Created by mac on 16/5/10.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Component;
@interface FriendCell : UITableViewCell

@property(nonatomic, strong) Component *friendData;
@property (nonatomic, nonatomic) IBOutlet UIImageView *mPointer;
@property (nonatomic, nonatomic) IBOutlet UIImageView *mPointer1;
@property (nonatomic, nonatomic) IBOutlet UIImageView *mPointer2;
@property (nonatomic, nonatomic) IBOutlet UILabel *mLable;

@property (nonatomic, nonatomic) IBOutlet UILabel *mLable1;
@property (nonatomic, nonatomic) IBOutlet UILabel *mLable2;
+ (instancetype) cellWithTableView:(UITableView *) tableView;
@end
