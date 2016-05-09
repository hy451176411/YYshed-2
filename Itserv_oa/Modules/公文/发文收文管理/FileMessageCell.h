//
//  FileMessageCell.h
//  Itserv_oa
//
//  Created by xiexianhui on 14-5-31.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileMessageCell : UITableViewCell
{
    IBOutlet UIImageView *_imgViewIcon;//图标
    IBOutlet UILabel *_labelTitle;//标题
    IBOutlet UILabel *_labelMess;//描述
}

- (void)loadData:(NSDictionary *)theDic withIndex:(NSInteger)row;

@end
