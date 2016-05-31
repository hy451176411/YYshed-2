//
//  ShedHomeViewController.h
//  Itserv_oa
//
//  Created by mac on 16/5/9.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYNetRequest.h"
#import "EADefine.h"
#import "HomeShedDetail.h"
#import "AddDevice.h"
#import "ScanZcodeVC.h"
#import "PullToRefreshTableView.h"

@interface ShedHomeViewController : UIViewController<UITextFieldDelegate,YYNetRequestDelegate,UIAlertViewDelegate,AddDeviceDelegate,ScanZcodeVCDelegate>
{
	PullToRefreshTableView *_pullTableView;//带有上拉加载，下拉刷新
}
//@property (nonatomic, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, nonatomic) NSMutableArray *groupsArray;
-(void)initDataSource:(NSDictionary *)model;

@end
