//
//  SecondController.m
//  REPagedScrollViewExample
//
//  Created by mac on 16/5/7.
//  Copyright (c) 2016年 Roman Efimov. All rights reserved.
//

#import "SecondController.h"
#import "SubViewController.h"
#import "TouchPropagatedScrollView.h"
#import "QHCommonUtil.h"

#define MENU_HEIGHT 36
#define MENU_BUTTON_WIDTH  60

#define MIN_MENU_FONT  13.f
#define MAX_MENU_FONT  18.f
@interface SecondController ()<UIScrollViewDelegate>
{
	UIView *_navView;
	UIView *_topNaviV;
	UIScrollView *_scrollV;
	
	TouchPropagatedScrollView *_navScrollV;
	
	float _startPointX;
	UIView *_selectTabV;
}

@end

@implementation SecondController

//- (void)viewDidLoad {
//    [super viewDidLoad];
//	[self.navigationController.navigationBar setBarTintColor:[UIColor greenColor]];
//	UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
//	UIImage *left = [UIImage imageNamed:@"logo.png"];
//	UIImageView* img = [[UIImageView alloc] initWithImage:left];
//	img.frame =CGRectMake(0, 0, 30, 30);
//	img.backgroundColor = [UIColor clearColor];
//	item.customView = img ;
//	self.navigationItem.leftBarButtonItem =item;
//	self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
//}

- (void)viewDidLoad
{
	//self.view.backgroundColor = [UIColor whiteColor];
	UIView *statusBarView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 0.f)];
	statusBarView.backgroundColor = [UIColor redColor];
	
	_navView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 20, self.view.frame.size.width, 44.f)];
	((UIImageView *)_navView).backgroundColor = [UIColor redColor];
	[self.view insertSubview:_navView belowSubview:statusBarView];
	_navView.userInteractionEnabled = YES;
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((_navView.frame.size.width - 200)/2, (_navView.frame.size.height - 40)/2, 200, 40)];
	[titleLabel setText:@"新闻列表"];
	[titleLabel setTextAlignment:NSTextAlignmentCenter];
	[titleLabel setTextColor:[UIColor whiteColor]];
	[titleLabel setFont:[UIFont boldSystemFontOfSize:22]];
	[titleLabel setBackgroundColor:[UIColor clearColor]];
	[_navView addSubview:titleLabel];
	
	
	
	_topNaviV = [[UIView alloc] initWithFrame:CGRectMake(0, _navView.frame.size.height + _navView.frame.origin.y, self.view.frame.size.width, MENU_HEIGHT)];
	_topNaviV.backgroundColor =[UIColor redColor];
	[self.view addSubview:_topNaviV];
	
	_scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _topNaviV.frame.origin.y + _topNaviV.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _topNaviV.frame.origin.y - _topNaviV.frame.size.height)];
	[_scrollV setPagingEnabled:YES];
	[_scrollV setBounces:NO];
	[_scrollV setShowsHorizontalScrollIndicator:NO];
	[self.view insertSubview:_scrollV belowSubview:_navView];
	_scrollV.delegate = self;
	[_scrollV.panGestureRecognizer addTarget:self action:@selector(scrollHandlePan:)];
	
	_selectTabV = [[UIView alloc] initWithFrame:CGRectMake(0, _scrollV.frame.origin.y - _scrollV.frame.size.height, _scrollV.frame.size.width, _scrollV.frame.size.height)];
	[_selectTabV setBackgroundColor:[UIColor grayColor]];
	[_selectTabV setHidden:YES];
	[self.view insertSubview:_selectTabV belowSubview:_navView];//当前选择了那个标签
	
	[self createTwo];
}

- (void)createTwo
{
	
	NSArray *arT = @[@"测试1", @"测试2", @"测试3", @"测试4", @"测试5", @"测试6", @"测试7", @"测试8", @"测试9", @"测试10"];
	_navScrollV = [[TouchPropagatedScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, MENU_HEIGHT)];
	[_navScrollV setShowsHorizontalScrollIndicator:NO];
	for (int i = 0; i < [arT count]; i++)
	{
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
		[btn setFrame:CGRectMake(MENU_BUTTON_WIDTH * i, 0, MENU_BUTTON_WIDTH, MENU_HEIGHT)];
		[btn setTitle:[arT objectAtIndex:i] forState:UIControlStateNormal];
		[btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		btn.tag = i + 1;
		if(i==0)
		{
			[self changeColorForButton:btn red:1];
			btn.titleLabel.font = [UIFont systemFontOfSize:MAX_MENU_FONT];
		}else
		{
			btn.titleLabel.font = [UIFont systemFontOfSize:MIN_MENU_FONT];
			[self changeColorForButton:btn red:0];
		}
		[btn addTarget:self action:@selector(actionbtn:) forControlEvents:UIControlEventTouchUpInside];
		[_navScrollV addSubview:btn];
	}
	[_navScrollV setContentSize:CGSizeMake(MENU_BUTTON_WIDTH * [arT count], MENU_HEIGHT)];
	[_topNaviV addSubview:_navScrollV];
	
	[self addView2Page:_scrollV count:[arT count] frame:CGRectZero];
}

- (void)addView2Page:(UIScrollView *)scrollV count:(NSUInteger)pageCount frame:(CGRect)frame
{
	for (int i = 0; i < pageCount; i++)
	{
		UIView *view = [[UIView alloc] initWithFrame:CGRectMake(scrollV.frame.size.width * i, 0, scrollV.frame.size.width, scrollV.frame.size.height)];
		view.tag = i + 1;
		view.userInteractionEnabled = YES;
		UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] init];
		singleTapRecognizer.numberOfTapsRequired = 1;
		[singleTapRecognizer addTarget:self action:@selector(pust2View:)];
		[view addGestureRecognizer:singleTapRecognizer];
		
		[self initPageView:view];
		
		[scrollV addSubview:view];
	}
	[scrollV setContentSize:CGSizeMake(scrollV.frame.size.width * pageCount, scrollV.frame.size.height)];
}

- (void)initPageView:(UIView *)view
{
	int width = (view.frame.size.width - 20)/3;
	float x = 5;
	float y = 4;
	UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, self.view.frame.size.height - 64)];
	int sumJ = (int)(1+arc4random()%4);
	int sumI = (int)(1+arc4random()%3);
	for (int j = 1; j <= sumJ; j++)
	{
		for (int i = 1; i <= 3; i++)
		{
			if (j == sumJ && i > sumI)
			{
				break;
			}
			float w = x * i + width * (i - 1);
			float h = y * j + width * (j - 1);
			UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(w, h, width, width)];
			[l setBackgroundColor:[QHCommonUtil getRandomColor]];
			[v addSubview:l];
		}
	}
	
	[view addSubview:v];
}

- (void)changeView:(float)x
{
	float xx = x * (MENU_BUTTON_WIDTH / self.view.frame.size.width);
	
	float startX = xx;
	//    float endX = xx + MENU_BUTTON_WIDTH;
	int sT = (x)/_scrollV.frame.size.width + 1;
	
	if (sT <= 0)
	{
		return;
	}
	UIButton *btn = (UIButton *)[_navScrollV viewWithTag:sT];
	float percent = (startX - MENU_BUTTON_WIDTH * (sT - 1))/MENU_BUTTON_WIDTH;
	float value = [QHCommonUtil lerp:(1 - percent) min:MIN_MENU_FONT max:MAX_MENU_FONT];
	btn.titleLabel.font = [UIFont systemFontOfSize:value];
	[self changeColorForButton:btn red:(1 - percent)];
	
	if((int)xx%MENU_BUTTON_WIDTH == 0)
		return;
	UIButton *btn2 = (UIButton *)[_navScrollV viewWithTag:sT + 1];
	float value2 = [QHCommonUtil lerp:percent min:MIN_MENU_FONT max:MAX_MENU_FONT];
	btn2.titleLabel.font = [UIFont systemFontOfSize:value2];
	[self changeColorForButton:btn2 red:percent];
}

- (void)changeColorForButton:(UIButton *)btn red:(float)nRedPercent
{
	float value = [QHCommonUtil lerp:nRedPercent min:0 max:212];
	[btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
}

#pragma mark - action

- (void)actionbtn:(UIButton *)btn
{
	[_scrollV scrollRectToVisible:CGRectMake(_scrollV.frame.size.width * (btn.tag - 1), _scrollV.frame.origin.y, _scrollV.frame.size.width, _scrollV.frame.size.height) animated:YES];
	
	float xx = _scrollV.frame.size.width * (btn.tag - 1) * (MENU_BUTTON_WIDTH / self.view.frame.size.width) - MENU_BUTTON_WIDTH;
	[_navScrollV scrollRectToVisible:CGRectMake(xx, 0, _navScrollV.frame.size.width, _navScrollV.frame.size.height) animated:YES];
}



-(void)scrollHandlePan:(UIPanGestureRecognizer*) panParam
{
	BOOL isPaning = NO;
	if(_scrollV.contentOffset.x < 0)
	{
		isPaning = YES;
		//        isLeftDragging = YES;
		//        [self showMask];
	}
	else if(_scrollV.contentOffset.x > (_scrollV.contentSize.width - _scrollV.frame.size.width))
	{
		isPaning = YES;
		//        isRightDragging = YES;
		//        [self showMask];
	}
	if(isPaning)
	{
		
	}
}

- (void)pust2View:(UITapGestureRecognizer *)tap
{
	CGPoint point = [tap locationInView:_scrollV];
	int t = point.x/_scrollV.frame.size.width + 1;
	SubViewController *subViewController = [[SubViewController alloc] initWithFrame:[UIScreen mainScreen].bounds andSignal:@""];
	subViewController.szSignal = [NSString stringWithFormat:@"%d--%d", t, 1];
	
	
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	_startPointX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[self changeView:scrollView.contentOffset.x];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	float xx = scrollView.contentOffset.x * (MENU_BUTTON_WIDTH / self.view.frame.size.width) - MENU_BUTTON_WIDTH;
	[_navScrollV scrollRectToVisible:CGRectMake(xx, 0, _navScrollV.frame.size.width, _navScrollV.frame.size.height) animated:YES];
}
@end
