//
//  HomeVC.m
//  ShowProduct
//
//  Created by lin on 14-5-22.
//  Copyright (c) 2014年 @"". All rights reserved.
//

#import "HomeVC.h"
#import "HomeView.h"
#import "Macros.h"

@interface HomeVC ()
{
    HomeView *mHomeView;
}
@end

@implementation HomeVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    self = [super initWithNibName:aNibName bundle:aBuddle];
    if (self != nil) {
        [self initCommonData];
        [self initTopNavBar];
    }
    return self;
}

//主要用来方向改变后重新改变布局
- (void) setLayout: (BOOL) aPortait {

    [self setViewFrame];
}

//重载导航条
-(void)initTopNavBar{
    self.title = @"我的新闻客户端";
    self.navigationItem.leftBarButtonItem = Nil;
}

-(void)viewDidLoad{
	[super viewDidLoad];
	[self.navigationController.navigationBar setBarTintColor:[UIColor greenColor]];
	UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
	UIImage *left = [UIImage imageNamed:@"logo.png"];
	UIImageView* img = [[UIImageView alloc] initWithImage:left];
	img.frame =CGRectMake(0, 0, 30, 30);
	img.backgroundColor = [UIColor clearColor];
	item.customView = img ;
	self.navigationItem.leftBarButtonItem =item;
	self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    [self initView];
}

//初始化数据
-(void)initCommonData{
    
}



// 初始View
- (void) initView {
    
    if (IS_IOS7) {
        self.edgesForExtendedLayout =UIRectEdgeNone ;
    }
    //contentView大小设置
    int vWidth = (int)([UIScreen mainScreen].bounds.size.width);
    int vHeight = (int)([UIScreen mainScreen].bounds.size.height);
    //contentView大小设置
    
    CGRect vViewRect = CGRectMake(0, 0, vWidth, vHeight -44 -20);
    UIView *vContentView = [[UIView alloc] initWithFrame:vViewRect];
    if (mHomeView == nil) {
        mHomeView = [[HomeView alloc] initWithFrame:vContentView.frame];
    }
    [vContentView addSubview:mHomeView];
    
    self.view = vContentView;
    
    [self setViewFrame];
   
}

//设置View方向
-(void) setViewFrame{
 
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

//------------------------------------------------


@end
