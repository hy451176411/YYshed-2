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
#import "Column.h"

@interface HomeVC ()<YYNetRequestDelegate>
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
    }
    return self;
}

//主要用来方向改变后重新改变布局
- (void) setLayout: (BOOL) aPortait {

    [self setViewFrame];
}


-(void)viewDidLoad{
	[super viewDidLoad];
	self.theRequest = [NetRequestManager createNetRequestWithDelegate:self];
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
	[self.theRequest getColumnList];
}

//设置View方向
-(void) setViewFrame{
 
}
-(void)initViews:(NSArray*)data{
	//contentView大小设置
	int vWidth = (int)([UIScreen mainScreen].bounds.size.width);
	int vHeight = (int)([UIScreen mainScreen].bounds.size.height);
	//contentView大小设置
	
	CGRect vViewRect = CGRectMake(0, 0, vWidth, vHeight -44 -80);
	UIView *vContentView = [[UIView alloc] initWithFrame:vViewRect];
	if (mHomeView == nil) {
		mHomeView = [[HomeView alloc] initWithFrame:vContentView.frame];
	}
	mHomeView.titles = data;
	[mHomeView initViews];
	[vContentView addSubview:mHomeView];
	
	self.view = vContentView;
	[self setViewFrame];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)initDatas:(NSDictionary *)model{
	NSArray *funcdata = [model objectForKey:@"funcdata"];
	NSMutableArray *data = [NSMutableArray array];
	for (int i=0; i<funcdata.count; i++) {
		NSDictionary *dic = funcdata[i];
		Column *column = [[Column alloc]init];
		column.ID =[dic objectForKey:@"id"];
		column.name =[dic objectForKey:@"name"];
		column.PID =[dic objectForKey:@"pid"];
		[data addObject:column];
	}
	[self initViews:data];
}
#pragma mark 登录请求成功
- (void)netRequest:(int)tag Finished:(NSDictionary *)model
{
	NSLog(@"----------%@",model);
	[self initDatas:model];
}

- (void)netRequest:(int)tag Failed:(NSDictionary *)model
{
	NSLog(@"请求超时");
	[SBPublicAlert showMBProgressHUD:@"请求超时" andWhereView:self.view hiddenTime:kHiddenAlertTime];
}

- (void)netRequest:(int)tag requestFailed:(NSString *)message
{
	[SBPublicAlert showMBProgressHUD:message andWhereView:self.view hiddenTime:kHiddenAlertTime];
}

@end
