//
//  UITableViewCell.m
//  Itserv_oa
//
//  Created by mac on 16/5/10.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import "UITableViewCell.h"

@implementation UITableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier NS_AVAILABLE_IOS(3_0){
	self=[super initWithStyle:style reuseIdentifier:reuseIdentifier ];
	if (self) {
		headerphoto=[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 50, 50)];
		[self.contentView addSubview:headerphoto];
		
		nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 5, 200, 25)];
		nameLabel.backgroundColor=[UIColor clearColor];
		nameLabel.font=[UIFont systemFontOfSize:16];
		[self.contentView addSubview:nameLabel];
		
		isOnLine=[[UILabel alloc]initWithFrame:CGRectMake(60, 40, 50, 5)];
		isOnLine.font=[UIFont systemFontOfSize:10];
		[self.contentView addSubview:isOnLine];
		
		introductionLabel=[[UILabel alloc]initWithFrame:CGRectMake(120, 40, 180, 5)];
		introductionLabel.font=[UIFont systemFontOfSize:10];
		[self.contentView addSubview:introductionLabel];
		
		networkLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-50, 5, 50, 25)];
		networkLabel.font=[UIFont systemFontOfSize:10];
		[self.contentView addSubview:networkLabel];
	}
	return self;
}


@end
