//
//  FriendHeader.m
//  FriendsList
//
//  Created by hellovoidworld on 14/12/12.
//  Copyright (c) 2014年 hellovoidworld. All rights reserved.
//

#import "FriendHeader.h"
#import "FriendGroup.h"
#import "ShedDetailVC.h"
@implementation FriendHeader



+ (instancetype) friendHeaderWithTableView:(UITableView *) tableView {
    static NSString *ID = @"friendHeader";
    FriendHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    
    if (nil == header) {
       header = [[[NSBundle mainBundle] loadNibNamed:@"FriendHeader" owner:nil options:nil] firstObject];
		
    }
    
    return header;
}
/** 子控件布局方法 
    在init的时候，只分配的内存，没有初始化控件的尺寸，在此处header已经有了位置尺寸了
 */
- (void)layoutSubviews {
    // 必须先调用父类的方法
    [super layoutSubviews];
	self.mExpand.tag = 100;
	self.headerTitle.tag = 101;
	
}

/** 加载数据  */
- (void)setFriendGroup:(FriendGroup *)friendGroup {
    _friendGroup = friendGroup;
    
    // 1组名
	self.headerTitle.text = friendGroup.name;
	
    // 2.在线人数/好友数
    //self.onlineCountView.text = [NSString stringWithFormat:@"%@/%d", friendGroup.online, friendGroup.friends.count];
}

/** 点击事件 */
- (IBAction)headerClick:(id)sender {
	self.clickView = self.mExpand;
	// 1.伸展、隐藏组内好友
	self.friendGroup.opened = !self.friendGroup.isOpened;
	// 2.刷新tableView
	if ([self.delegate respondsToSelector:@selector(friendHeaderDidClickedHeader:)]) {
		[self.delegate friendHeaderDidClickedHeader:self];
	}
}


/**
 被加到父控件之前
 由于tableView刷新数据后，所有header会被重新创建，所以要在这里对箭头朝向做出修改
 */
- (void)didMoveToSuperview {
    // 改变箭头朝向，顺时针旋转90度
	if (self.friendGroup.isOpened)
	{
		CGFloat countWidth = 42;
		CGFloat countHeight = 30;
		CGFloat countX = self.mExpand.frame.origin.x-10;
		CGFloat countY = self.mExpand.frame.origin.y;
		self.mExpand.frame  = CGRectMake(countX, countY, countWidth, countHeight);
		UIImage *imgage =[UIImage imageNamed:@"expand.png"];
		[self.mExpand setImage:imgage forState:UIControlStateNormal];
		[self.mExpand setBackgroundColor:[UIColor clearColor]];
	}else
	{
		CGFloat countWidth = 30;
		CGFloat countHeight = 42;
		CGFloat countX = self.mExpand.frame.origin.x;
		CGFloat countY = self.mExpand.frame.origin.y-10;
		self.mExpand.frame  = CGRectMake(countX, countY, countWidth, countHeight);
		UIImage *imgage =[UIImage imageNamed:@"lead.png"];
		[self.mExpand setImage:imgage forState:UIControlStateNormal];
		[self.mExpand setBackgroundColor:[UIColor clearColor]];
	}
	//CGFloat rotation = self.friendGroup.isOpened? M_PI_2 : 0;
	//self.mExpand.imageView.transform = CGAffineTransformMakeRotation(rotation);
}
- (IBAction)headerTitleClick:(id)sender {
	self.clickView = self.headerTitle;
	NSLog(@"headerTitleClick");
	if ([self.delegate respondsToSelector:@selector(HeaderTitleDidClicked:)]) {
		[self.delegate HeaderTitleDidClicked:self.friendGroup];
	}
}
@end
