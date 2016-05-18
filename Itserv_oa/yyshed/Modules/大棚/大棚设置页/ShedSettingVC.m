//
//  ShedSettingVC.m
//  Itserv_oa
//
//  Created by mac on 16/5/18.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import "ShedSettingVC.h"
#import "CommonShed.h"

@interface ShedSettingVC ()

@end

@implementation ShedSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
	[self initSegmentedControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initSegmentedControl
{
	NSArray *segmentedData = [[NSArray alloc]initWithObjects:@"别名设置",@"报警预案设置",@"其他设置",nil];
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedData];
	float width = SCREEN_WIDTH - 2*ELEMENT_SPACING;
	segmentedControl.frame = CGRectMake(ELEMENT_SPACING, ELEMENT_SPACING,width, 45.0);
	/*
	 这个是设置按下按钮时的颜色
	 */
	segmentedControl.tintColor = [UIColor colorWithRed:49.0 / 256.0 green:148.0 / 256.0 blue:208.0 / 256.0 alpha:1];
	segmentedControl.selectedSegmentIndex = 0;//默认选中的按钮索引
	
	
	/*
	 下面的代码实同正常状态和按下状态的属性控制,比如字体的大小和颜色等
	 */
	NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:12],NSFontAttributeName,[UIColor redColor], NSForegroundColorAttributeName, nil];
	
	
	[segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
	
	
	NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
	
	[segmentedControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
	
	//设置分段控件点击相应事件
	[segmentedControl addTarget:self action:@selector(doSomethingInSegment:)forControlEvents:UIControlEventValueChanged];
	
	[self.view addSubview:segmentedControl];
}
-(void)doSomethingInSegment:(UISegmentedControl *)Seg
{
	
	NSInteger Index = Seg.selectedSegmentIndex;
	
	switch (Index)
	{
		case 0:
			self.view.backgroundColor = [UIColor redColor];
			break;
		case 1:
			self.view.backgroundColor = [UIColor blueColor];
			break;
		case 2:
			self.view.backgroundColor = [UIColor greenColor];
			break;
		default:
			break;
	}
}
@end
