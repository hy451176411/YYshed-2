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
@interface ShedHomeViewController : UIViewController<UITextFieldDelegate,YYNetRequestDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) NSMutableArray *groupsArray;
-(void)initDataSource:(NSDictionary *)model;
@end
