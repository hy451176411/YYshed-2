//
//  ShedHomeViewController.m
//  Itserv_oa
//
//  Created by mac on 16/5/9.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import "ShedHomeViewController.h"

@interface ShedHomeViewController ()

@end

@implementation ShedHomeViewController

NSArray *friendsArray;//好友列表
NSArray *familyArray;//亲戚列表
NSArray *schoolmateArray;//同学列表
NSArray *friendstravelArray;//驴友列表
NSArray *xianFriendsArray;//西安好友列表
NSArray *strangersArray;//陌生人列表

NSDictionary *dataDic;//第二层需要展示的数据
- (void)viewDidLoad {
	[super viewDidLoad];
	[self.navigationController.navigationBar setBarTintColor:[UIColor greenColor]];
	//添加左边的按钮
	UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
	UIImage *left = [UIImage imageNamed:@"logo.png"];
	UIImageView* img = [[UIImageView alloc] initWithImage:left];
	img.frame =CGRectMake(0, 0, 30, 30);
	img.backgroundColor = [UIColor clearColor];
	item.customView = img ;
	//右边按钮
	UIImage *right = [UIImage imageNamed:@"add.png"];
	
	UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] init];
	UIImageView* rightIV = [[UIImageView alloc] initWithImage:right];
	UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightBtnClick)];
	[rightIV addGestureRecognizer:singleTap];
	rightIV.frame =CGRectMake(0, 0, 25, 25);
	rightIV.backgroundColor = [UIColor clearColor];
	rightItem.customView = rightIV ;
	
	self.navigationItem.leftBarButtonItem =item;
	self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
	self.navigationItem.rightBarButtonItem =rightItem;
	
	//初始化中间部分
	self.mTableView.showsVerticalScrollIndicator=NO;
	self.mTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
//	NSArray *monthNames = [NSArray arrayWithObjects:@"朋友",@"亲戚",@"同学",@"驴友",@"论坛好友", nil];
//	int months = monthNames.count;
//	self.titleArray = monthNames;
	[self initDataSource];
	self.mTableView.delegate = self;
	self.mTableView.dataSource = self;
	[self.mTableView reloadData];
}

#pragma mark --tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	//返回列表的行数
	int num = self.titleArray.count;
	return num;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
	
	UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 5, self.view.frame.size.width, 30)];
	titleLabel.text= self.titleArray[section];
	[view addSubview:titleLabel];
	
	return view;
}
-(void)initDataSource
{
	self.titleArray=[NSArray arrayWithObjects:@"朋友",@"亲戚",@"同学",@"驴友",@"论坛好友", nil];
	
	NSDictionary *dic01=[[NSDictionary alloc]initWithObjectsAndKeys:@"张三丰",@"name",@"男",@"sex", nil];
	NSDictionary *dic02=[[NSDictionary alloc]initWithObjectsAndKeys:@"邓超",@"name",@"男",@"sex", nil];
	NSDictionary *dic03=[[NSDictionary alloc]initWithObjectsAndKeys:@"吴奇隆",@"name",@"男",@"sex", nil];
	
	friendsArray=[NSArray arrayWithObjects:dic01,dic02,dic03, nil];
	
	NSDictionary *dic11=[[NSDictionary alloc]initWithObjectsAndKeys:@"爸爸",@"name",@"男",@"sex", nil];
	NSDictionary *dic12=[[NSDictionary alloc]initWithObjectsAndKeys:@"弟弟",@"name",@"男",@"sex", nil];
	NSDictionary *dic13=[[NSDictionary alloc]initWithObjectsAndKeys:@"三哥",@"name",@"男",@"sex", nil];
	NSDictionary *dic14=[[NSDictionary alloc]initWithObjectsAndKeys:@"大伯",@"name",@"男",@"sex", nil];
	NSDictionary *dic15=[[NSDictionary alloc]initWithObjectsAndKeys:@"二舅",@"name",@"男",@"sex", nil];
	
	familyArray=[NSArray arrayWithObjects:dic11,dic12,dic13,dic14,dic15, nil];
	
	NSDictionary *dic21=[[NSDictionary alloc]initWithObjectsAndKeys:@"胖子",@"name",@"男",@"sex", nil];
	NSDictionary *dic22=[[NSDictionary alloc]initWithObjectsAndKeys:@"雄哥",@"name",@"男",@"sex", nil];
	NSDictionary *dic23=[[NSDictionary alloc]initWithObjectsAndKeys:@"小六子",@"name",@"男",@"sex", nil];
	
	schoolmateArray=[NSArray arrayWithObjects:dic21,dic22,dic23, nil];
	
	
	NSDictionary *dic31=[[NSDictionary alloc]initWithObjectsAndKeys:@"三炮",@"name",@"男",@"sex", nil];
	NSDictionary *dic32=[[NSDictionary alloc]initWithObjectsAndKeys:@"郑海峰",@"name",@"男",@"sex", nil];
	NSDictionary *dic33=[[NSDictionary alloc]initWithObjectsAndKeys:@"王重阳",@"name",@"男",@"sex", nil];
	NSDictionary *dic34=[[NSDictionary alloc]initWithObjectsAndKeys:@"丘处机",@"name",@"男",@"sex", nil];
	NSDictionary *dic35=[[NSDictionary alloc]initWithObjectsAndKeys:@"吕娜",@"name",@"男",@"sex", nil];
	NSDictionary *dic36=[[NSDictionary alloc]initWithObjectsAndKeys:@"郭金明",@"name",@"男",@"sex", nil];
	
	friendstravelArray=[NSArray arrayWithObjects:dic31,dic32,dic33,dic34,dic35,dic36, nil];
	
	NSDictionary *dic41=[[NSDictionary alloc]initWithObjectsAndKeys:@"李晓峰",@"name",@"男",@"sex", nil];
	NSDictionary *dic42=[[NSDictionary alloc]initWithObjectsAndKeys:@"王蒙",@"name",@"男",@"sex", nil];
	NSDictionary *dic43=[[NSDictionary alloc]initWithObjectsAndKeys:@"李建",@"name",@"男",@"sex", nil];
	
	xianFriendsArray=[NSArray arrayWithObjects:dic41,dic42,dic43, nil];
	
	NSDictionary *dic51=[[NSDictionary alloc]initWithObjectsAndKeys:@"胡雪",@"name",@"男",@"sex", nil];
	NSDictionary *dic52=[[NSDictionary alloc]initWithObjectsAndKeys:@"张小欢",@"name",@"男",@"sex", nil];
	NSDictionary *dic53=[[NSDictionary alloc]initWithObjectsAndKeys:@"刘丽丽",@"name",@"男",@"sex", nil];
	
	strangersArray=[NSArray arrayWithObjects:dic51,dic52,dic53, nil];
	
	
	//dataDic=[NSDictionary dictionaryWithObjectsAndKeys:friendsArray,[self.titleArray objectAtIndex:0],familyArray,[self.titleArray objectAtIndex:1],schoolmateArray,[self.titleArray objectAtIndex:2],friendstravelArray,[self.titleArray objectAtIndex:3],xianFriendsArray,[self.titleArray objectAtIndex:4], strangersArray,[self.titleArray objectAtIndex:5], nil];
	
	
}


-(void)rightBtnClick{
	UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请添加大棚!" delegate:self  cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
	[alter show];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
