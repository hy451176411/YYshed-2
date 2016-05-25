//
//  NickNameCell.h
//  Itserv_oa
//
//  Created by mac on 16/5/18.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NickNameModule.h"
/*
 大棚所有的传感器的别名
 */

@protocol ShedSensorCellDelegate <NSObject>
/** header被点击的代理方法 */
@optional
- (void) updateShedSensorAlias:(NSString *) alias withComonentId:(NSString*)component_id;
@end
@interface ShedSensorCell : UITableViewCell
- (IBAction)updateAlias:(id)sender;
+ (instancetype) cellWithTableView:(UITableView *) tableView;
@property (nonatomic, strong) NickNameModule *module;
@property (nonatomic, nonatomic) IBOutlet UITextField *shedAliasNickName;//大棚别名的更新框
@property (nonatomic, nonatomic) IBOutlet UILabel *shedAlias;//大棚的别名
/** 代理 */
@property(nonatomic, strong) id<ShedSensorCellDelegate> delegate;
@end
