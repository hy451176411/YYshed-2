//
//  FriendHeader.h
//  FriendsList
//
//  Created by hellovoidworld on 14/12/12.
//  Copyright (c) 2014年 hellovoidworld. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FriendGroup, FriendHeader;

@protocol FriendHeaderDelegate <NSObject>
/** header被点击的代理方法 */
@optional
- (void) friendHeaderDidClickedHeader:(FriendHeader *) header;
- (void) HeaderTitleDidClicked:(FriendGroup *) group;
@end

@interface FriendHeader : UITableViewHeaderFooterView


/** 包含了箭头图标和组名、背景色的按钮 */
@property(nonatomic, nonatomic) UIButton *headerButtonView;

- (IBAction)headerClick:(id)sender;

/** 在线人数 */
@property(nonatomic, nonatomic) UILabel *onlineCountView;
@property (nonatomic, nonatomic) IBOutlet UIButton *mExpand;
- (IBAction)headerTitleClick:(id)sender;

@property(nonatomic, strong) UIView *clickView;

/** group数据 */
@property(nonatomic, strong) FriendGroup *friendGroup;
@property (nonatomic, nonatomic) IBOutlet UIView *mView;
@property (nonatomic, nonatomic) IBOutlet UILabel *headerTitle;

/** 代理 */
@property(nonatomic, strong) id<FriendHeaderDelegate> delegate;

+ (instancetype) friendHeaderWithTableView:(UITableView *) tableView;

@end
