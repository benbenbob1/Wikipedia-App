//
//  ServerImageDetailViewController.h
//  Wikipedia Image Uploader
//
//  Created by Ben Brown on 11/5/11.
//  Copyright (c) 2011 Benbenbob Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WikiImage.h"
#import "Configuration.h"

@interface ServerImageDetailViewController : UITableViewController

- (UIImage *)scaleAndRotateImage:(UIImage *)img;

@property (strong, nonatomic) WikiImage *wImg;

@end
