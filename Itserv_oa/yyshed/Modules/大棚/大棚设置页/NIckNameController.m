//
//  NIckNameController.m
//  Itserv_oa
//
//  Created by mac on 16/5/18.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import "NIckNameController.h"
#import "FriendCell.h"
#import "NickNameCellTableViewCell.h"

@interface NIckNameController ()

@end

@implementation NIckNameController

- (void)viewDidLoad {
    [super viewDidLoad];
	//初始化中间部分
	self.tableView.showsVerticalScrollIndicator=NO;
	self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
	self.tableView.sectionHeaderHeight = 44;
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - dataSource方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	//int nums = self.friendGroups.count;
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NickNameCellTableViewCell *cell = [NickNameCellTableViewCell cellWithTableView:self.tableView];
	//FriendGroup *group = self.friendGroups[indexPath.section];
	//cell.friendData = group.friends[indexPath.row];
	return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 131;
}

@end
