//
//  FriendCell.m
//  Itserv_oa
//
//  Created by mac on 16/5/10.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import "FriendCell.h"
#import "Component.h"
@implementation FriendCell

- (void)awakeFromNib {

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
- (void)setFriendData:(Component *)friendData {
	_friendData = friendData;
	self.mLable.text = friendData.air_temperature;
	self.mLable1.text = friendData.air_humidity;
	//self.desc.textColor = friendData.isVip?[UIColor redColor]:[UIColor blackColor];
	//self.desc.text = friendData.intro;
}

@end
