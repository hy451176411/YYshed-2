//
//  NickNameCell.m
//  Itserv_oa
//
//  Created by mac on 16/5/18.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import "ShedSensorCell.h"

@implementation ShedSensorCell

- (void)awakeFromNib {
    // Initialization code
}

/** 自定义构造方法 */
- (IBAction)updateAlias:(id)sender {
	NSLog(@"updateAlias");
	if ([self.delegate respondsToSelector:@selector(updateShedSensorAlias:)]) {
		[self.delegate updateShedSensorAlias:self.module];
	}
}

+ (instancetype) cellWithTableView:(UITableView *) tableView {
	static NSString *ID = @"ShedSensorCell";
	ShedSensorCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	
	if (nil == cell) {
		cell = [[[NSBundle mainBundle] loadNibNamed:@"ShedSensorCell" owner:nil options:nil] firstObject];
	}
	
	return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
}

/** 加载数据 */
- (void)setModule:(NickNameModule *)module{
	_module = module;
	self.shedAlias.text = module.alias;
	self.shedAliasNickName.text = module.alias;
}
@end
