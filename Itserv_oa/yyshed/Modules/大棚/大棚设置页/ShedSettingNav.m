//
//  ShedSettingNav.m
//  Itserv_oa
//
//  Created by mac on 16/5/18.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import "ShedSettingNav.h"
#import "CommonShed.h"

@interface ShedSettingNav () <ViewPagerDataSource, ViewPagerDelegate>

@end
float screenW ;
@implementation ShedSettingNav

- (void)viewDidLoad {
	
	self.dataSource = self;
	self.delegate = self;
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		self.edgesForExtendedLayout = UIRectEdgeNone;
	}
	[super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
	return self.viewControllers.count;
}
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
	UILabel *label = [UILabel new];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont systemFontOfSize:13.0];
	UIViewController *toViewController = (self.viewControllers)[index];
	NSString *title = toViewController.title;
	label.text = title;
	label.textAlignment = NSTextAlignmentCenter;
	//label.textColor = [UIColor redColor];
	[label sizeToFit];
	//label.backgroundColor = [UIColor blueColor];
	
	return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
	UIViewController *toViewController = (self.viewControllers)[index];
	return toViewController;
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
	
	switch (option) {
		case ViewPagerOptionStartFromSecondTab:
			return 1.0;
			break;
		case ViewPagerOptionCenterCurrentTab:
			return 0.0;
			break;
		case ViewPagerOptionTabLocation:
			return 1.0;
			break;
		case ViewPagerOptionTabWidth:
			screenW = SCREEN_WIDTH;
			float menuH = 1;
			if (self.viewControllers.count>0) {
				menuH = screenW/self.viewControllers.count;
			}
			return menuH;
		default:
			break;
	}
	
	return value;
}
- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
	
	switch (component) {
		case ViewPagerIndicator:
			return [[UIColor greenColor] colorWithAlphaComponent:0.64];
			break;
		default:
			break;
	}
	
	return color;
}
-(void)setViewControls: (NSArray*)controls{
	self.viewControllers = controls;
}

@end

