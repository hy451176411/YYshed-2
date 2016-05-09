//
//  PicFileView.h
//  Itserv_oa
//
//  Created by xiexianhui on 14-7-1.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PicFileView;

@protocol PicFileViewDelegate <NSObject>

- (void)picFileView:(PicFileView *)picFileView;

@end

@interface PicFileView : UIView
{
    UIImageView *_imgViewPic;
    
}
@property (nonatomic, assign) id<PicFileViewDelegate> delegate;
@property (nonatomic, retain) NSString *strImgName;
@property (nonatomic, retain) NSData *data;
@property (nonatomic, retain) UIImage *img;
@property (nonatomic, retain) NSString *strImgType;
@property (nonatomic, assign) BOOL isLine;

- (void)loadWithImg:(UIImage *)theImg withFileName:(NSString *)strFile;

@end
