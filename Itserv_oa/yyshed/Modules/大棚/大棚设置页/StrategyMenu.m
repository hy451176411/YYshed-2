//
//  StrategyMenu.m
//  Itserv_oa
//
//  Created by mac on 16/5/19.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import "StrategyMenu.h"
#import "CZPicker.h"
@interface StrategyMenu ()<CZPickerViewDataSource, CZPickerViewDelegate>

@end

@implementation StrategyMenu


//-(NSString*)configNameWithDic:(id)dic {
//	NSString *name = dic[@"dev_alias"];
//	if ((name == nil)||[name isEqualToString:@"undefined"]) {
//		name = dic[@"dev_name"];
//	}
//	if ((name == nil)||[name isEqualToString:@"未知设备"]||[name isEqualToString:@""]) {
//		name = @"未知传感器";
//	}
//	return name;
//}
-(float)configDataOfBottomMenu:(id)data{
	//[self initModel];
	//self.menus = [NSArray arrayWithObjects:@"初一",@"初二",@"初三",@"初四",nil];
	UIView *rootView1 = [[UIView alloc] init];
	rootView1.frame = CGRectMake(0, 0, SCREEN_WIDTH-2*ELEMENT_SPACING, MENU_H);
	float startY = 0;
	float tipW = 85;
	UILabel  *lowTip = [[UILabel alloc] init];
	lowTip.frame =CGRectMake(0, startY, tipW, MENU_H);
	lowTip.text = @"预案名称：";
	[rootView1 addSubview:lowTip];
	
	self.mSelectBtn = [[UIButton alloc] init];
	self.mSelectBtn.frame = CGRectMake(tipW, startY, SCREEN_WIDTH-2*ELEMENT_SPACING-tipW, MENU_H);
	self.mSelectBtn.titleLabel.font = SystemFontOfSize(16);
	NSString *name = self.menus[0];
	[self.mSelectBtn setTitle:name forState:UIControlStateNormal];
	[self.mSelectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[self.mSelectBtn setBackgroundImage:[UIImage imageNamed:@"button5.png"] forState:UIControlStateNormal];
	[self.mSelectBtn addTarget:self action:@selector(showWithFooter:) forControlEvents:UIControlEventTouchUpInside];
	self.mSelectBtn.userInteractionEnabled =YES;
	
	UIImage *down = [UIImage imageNamed:@"down.png"];
	UIImageView* downImg = [[UIImageView alloc] initWithImage:down];
	downImg.frame =CGRectMake(SCREEN_WIDTH-60,10, 34, 27);
	downImg.backgroundColor = [UIColor redColor];
	
	[rootView1 addSubview:self.mSelectBtn];
	[rootView1 addSubview:downImg];
	[self addSubview:rootView1];
	startY = startY +MENU_H;
	return startY;
}

- (NSString *)czpickerView:(CZPickerView *)pickerView
			   titleForRow:(NSInteger)row{
	NSString *name = self.menus[row];
	return name;
}



- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView{
	return self.menus.count;
}

- (void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemAtRow:(NSInteger)row{
	NSString *name = self.menus[row];
	NSLog(@"%@ is chosen!", name);
	[self.mSelectBtn setTitle:name forState:UIControlStateNormal];
	if (self.delegate && [self.delegate respondsToSelector:@selector(didConfirmWithItemAtRow:)]) {
		[_delegate didConfirmWithItemAtRow:nil];
	}
}

- (void)showWithFooter:(id)sender {
	CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"请选择" cancelButtonTitle:@"Cancel" confirmButtonTitle:@"确定"];
	picker.delegate = self;
	picker.dataSource = self;
	//picker.needFooterView = YES;
	[picker show];
}
@end
