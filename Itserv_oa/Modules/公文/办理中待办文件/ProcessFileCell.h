//
//  ProcessFileCell.h
//  Itserv_oa
//
//  Created by xiexianhui on 14-6-2.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProcessFileCell : UITableViewCell
{
    IBOutlet UILabel *_labelTitle;
    IBOutlet UILabel *_labelHeardText;
    IBOutlet UILabel *_labelTime;
    IBOutlet UIImageView *_imgViewIcon;
    
    __weak IBOutlet UIView *_viewCellBg;
    
}
+ (CGFloat)cellHeight:(NSDictionary *)dic;

- (void)loadData:(NSDictionary *)dic;

@end
