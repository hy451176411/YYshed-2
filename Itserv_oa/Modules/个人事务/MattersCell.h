//
//  MattersCell.h
//  Itserv_oa
//
//  Created by xiexianhui on 14-6-2.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MattersCell : UITableViewCell
{
    IBOutlet UIImageView *_imgViewIcon;//图标
    IBOutlet UILabel *_labelTitle;//标题
    IBOutlet UILabel *_labelTime;//时间
    IBOutlet UILabel *_labelDes;//描述
    IBOutlet UILabel *_labelHeard;//
    __weak IBOutlet UIView *_viewCellBg;
    
}
+ (CGFloat)cellHeight:(NSDictionary *)dic;
- (void)loadData:(NSDictionary *)dic;
@end
