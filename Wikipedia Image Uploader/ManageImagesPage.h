//
//  ManageImagesPage.h
//  Wikipedia Image Uploader
//
//  Created by Ben Brown on 11/3/11.
//  Copyright (c) 2011 Benbenbob Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WikiImage.h"
#import "Configuration.h"
#import "LoginPage.h"
#import "ServerImageDetailViewController.h"

@interface ManageImagesPage : UITableViewController <UINavigationControllerDelegate, NSXMLParserDelegate> {
	
	NSMutableArray *imagesArr;
	WikiImage *result;
	NSMutableString *currentElementValue;
	NSDateFormatter *df;
}

- (void)loadImages;
- (void)doneButtonAction;

@end
