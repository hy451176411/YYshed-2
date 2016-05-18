//
//  NickNameCellTableViewCell.h
//  Itserv_oa
//
//  Created by mac on 16/5/18.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//
/*
 大棚别名
 */
#import <UIKit/UIKit.h>
#import "NickNameModule.h"
@protocol ShedAliasCellDelegate <NSObject>
/** header被点击的代理方法 */
@optional
- (void) updateShedAlias:(NickNameModule *) module;
@end

@interface ShedAliasCell : UITableViewCell
@property (nonatomic, strong) NickNameModule *module;
- (IBAction)updateAlias:(id)sender;
+ (instancetype) cellWithTableView:(UITableView *) tableView;
@property (weak, nonatomic) IBOutlet UILabel *shedAlias;
@property (weak, nonatomic) IBOutlet UITextField *shedAliasNickName;

/** 代理 */
@property(nonatomic, strong) id<ShedAliasCellDelegate> delegate;
@end
