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

@interface ShedHomeViewController : UIViewController<UITextFieldDelegate,YYNetRequestDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) NSArray *groupsArray;
-(void)initDataSource;
@end
