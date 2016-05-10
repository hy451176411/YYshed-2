//
//  FriendCell.m
//  Itserv_oa
//
//  Created by mac on 16/5/10.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import "FriendCell.h"
#import "Friend.h"
@implementation FriendCell

- (void)awakeFromNib {
    // Initialization code
//	self.img.backgroundColor=[UIColor clearColor];
//	self.title.backgroundColor=[UIColor clearColor];
//	self.desc.backgroundColor=[UIColor clearColor];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/** 自定义构造方法 */
+ (instancetype) cellWithTableView:(UITableView *) tableView {
	static NSString *ID = @"friendCell";
	FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	
	if (nil == cell) {
		cell = [[[NSBundle mainBundle] loadNibNamed:@"FriendCell" owner:nil options:nil] firstObject];
	}
	
	return cell;
}

/** 加载数据 */
- (void)setFriendData:(Friend *)friendData {
	_friendData = friendData;
	//self.img.image = [UIImage imageNamed:friendData.icon];
	//self.title.text = friendData.name;
	//self.desc.textColor = friendData.isVip?[UIColor redColor]:[UIColor blackColor];
	//self.desc.text = friendData.intro;
}

@end
