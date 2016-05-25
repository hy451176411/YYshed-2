//
//  NickNameCellTableViewCell.m
//  Itserv_oa
//
//  Created by mac on 16/5/18.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import "ShedAliasCell.h"

@implementation ShedAliasCell

- (void)awakeFromNib {
	
}
/** 自定义构造方法 */
- (IBAction)updateAlias:(id)sender {
	NSString *nickname = self.shedAliasNickName.text;
	NSLog(@"updateAlias");
	if ([self.delegate respondsToSelector:@selector(updateShedAlias:)]) {
		[self.delegate updateShedAlias:nickname];
	}
}

+ (instancetype) cellWithTableView:(UITableView *) tableView {
	static NSString *ID = @"ShedAliasCell";
	ShedAliasCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	
	if (nil == cell) {
		cell = [[[NSBundle mainBundle] loadNibNamed:@"ShedAliasCell" owner:nil options:nil] firstObject];
	}
	
	return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	
	// Configure the view for the selected state
}
/** 加载数据 */
- (void)setModule:(NickNameModule *)module{
	_module = module;
	self.shedAlias.text = module.alias;
	self.shedAliasNickName.text = module.alias;
}

@end
