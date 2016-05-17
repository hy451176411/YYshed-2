//
//  ShedDetailBottomMenu.m
//  Itserv_oa
//
//  Created by mac on 16/5/17.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import "ShedDetailBottomMenu.h"
#import "CZPicker.h"
@interface ShedDetailBottomMenu ()<CZPickerViewDataSource, CZPickerViewDelegate>


@end

@implementation ShedDetailBottomMenu


-(NSString*)configNameWithDic:(id)dic {
	NSString *name = dic[@"dev_alias"];
	if ((name == nil)||[name isEqualToString:@"undefined"]) {
		name = dic[@"dev_name"];
	}
	if ((name == nil)||[name isEqualToString:@"未知设备"]||[name isEqualToString:@""]) {
		name = @"未知传感器";
	}
	return name;
}
-(float)configDataOfBottomMenu:(id)data{
	//[self initModel];
	UIView *rootView1 = [[UIView alloc] init];
	rootView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, MENU_H);
	float startY = 0;
	self.mSelectBtn = [[UIButton alloc] init];
	self.mSelectBtn.frame = CGRectMake(ELEMENT_SPACING, startY, SCREEN_WIDTH-2*ELEMENT_SPACING, MENU_H);
	self.mSelectBtn.titleLabel.font = SystemFontOfSize(16);
	NSString *name = [self configNameWithDic:self.menus[0]];
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
	NSString *name = [self configNameWithDic:self.menus[row]];
	return name;
}



- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView{
	return self.menus.count;
}

- (void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemAtRow:(NSInteger)row{
	NSString *name = [self configNameWithDic:self.menus[row]];
	NSLog(@"%@ is chosen!", name);
	[self.mSelectBtn setTitle:name forState:UIControlStateNormal];
	if (self.delegate && [self.delegate respondsToSelector:@selector(didConfirmWithItemAtRow:)]) {
		[_delegate didConfirmWithItemAtRow:self.menus[row]];
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
