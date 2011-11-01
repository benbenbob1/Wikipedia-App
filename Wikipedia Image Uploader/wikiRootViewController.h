//
//  wikiRootViewController.h
//  Wikipedia Image Uploader
//
//  Created by Ben Brown on 10/28/11.
//  Copyright (c) 2011 Benbenbob Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface wikiRootViewController : UIViewController <UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;

@end
