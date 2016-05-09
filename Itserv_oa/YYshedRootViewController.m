//
//  RootViewController.m
//  REPagedScrollViewExample
//
//  Created by Roman Efimov on 5/20/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "YYshedRootViewController.h"
#import "REPagedScrollView.h"
#import "YYshedLoginController.h"

@interface YYshedRootViewController ()

@end

@implementation YYshedRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	REPagedScrollView *scrollView = [[REPagedScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.pageControl.pageIndicatorTintColor = [UIColor redColor];
    scrollView.pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    [self.view addSubview:scrollView];
    
	UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height)];
	UIImage *img = [UIImage imageNamed:@"feature_guide_0.jpg"];
	[imageView initWithImage:img];
	[scrollView addPage:imageView];
	
 
	 imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height)];
	img = [UIImage imageNamed:@"feature_guide_1.jpg"];
	[imageView initWithImage:img];
    [scrollView addPage:imageView];
    

	
	CGRect CGone = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height);//画个矩形，初始化位置与大小
 
	UIView *view = [[UIView alloc]initWithFrame:CGone];//初始化view
	
	view.backgroundColor = [UIColor clearColor];
	UIButton* btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	btn.frame = CGRectMake((self.view.frame.size.width-60)/2, self.view.frame.size.height-100, 60, 40);
	[btn setTitle:@"skip" forState:UIControlStateNormal];
	[btn addTarget:self action:@selector(skip) forControlEvents:UIControlEventTouchUpInside];
	
	
	imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height)];
	img = [UIImage imageNamed:@"feature_guide_2.jpg"];
	[imageView initWithImage:img];
	[view addSubview:imageView];
	[view addSubview:btn];
	
	[scrollView addPage:view];

}
-(void)skip
{
	NSLog(@"skip");
	YYshedLoginController *control = [[YYshedLoginController alloc] init];
	[self presentViewController:control animated:YES completion:nil];
}
@end
