//
//  FriendCell.h
//  Itserv_oa
//
//  Created by mac on 16/5/10.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Friend;
@interface FriendCell : UITableViewCell

@property(nonatomic, strong) Friend *friendData;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *desc;

+ (instancetype) cellWithTableView:(UITableView *) tableView;
@end
