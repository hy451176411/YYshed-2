//
//  AttachmentView.h
//  Itserv_oa
//
//  Created by xiexianhui on 14-6-7.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AttachmentView;

@protocol AttachmentViewDelegate <NSObject>

@optional
- (void)attachmentView:(AttachmentView *)attachmentV;

@end

@interface AttachmentView : UIView
{
    UILabel *_labelName;
//    UILabel *_labelUrl;
    UILabel *_labelSize;
}
@property (nonatomic, assign) id<AttachmentViewDelegate> delegate;
- (void)loadData:(NSDictionary *)dic;
- (void)loadMCOAttachment:(MCOAttachment *)attachment;
@end
