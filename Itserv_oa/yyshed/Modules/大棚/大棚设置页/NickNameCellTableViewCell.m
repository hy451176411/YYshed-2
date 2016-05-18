//
//  NickNameCellTableViewCell.m
//  Itserv_oa
//
//  Created by mac on 16/5/18.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import "NickNameCellTableViewCell.h"

@implementation NickNameCellTableViewCell

- (void)awakeFromNib {
    
}
/** 自定义构造方法 */
+ (instancetype) cellWithTableView:(UITableView *) tableView {
	static NSString *ID = @"NickNameCellTableViewCell";
	NickNameCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	
	if (nil == cell) {
		cell = [[[NSBundle mainBundle] loadNibNamed:@"NickNameCellTableViewCell" owner:nil options:nil] firstObject];
	}
	
	return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
