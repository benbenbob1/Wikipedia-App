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
#import "ImageUploadViewController.h"
#import "ImageDetailsViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/ImageIO.h>
#import "wikiDataViewController.h"

@interface ManageImagesPage : UITableViewController <UINavigationControllerDelegate, NSXMLParserDelegate, UIPopoverControllerDelegate, UIImagePickerControllerDelegate> {
	
	NSMutableArray *imagesArr;
	WikiImage *result;
	NSMutableString *currentElementValue;
	UIPopoverController *popoverController;
	//NSDateFormatter *df;
}

- (void)loadImages;
- (void)doneButtonAction;
- (void)uploadButtonAction:(UIBarButtonItem *)sender;
- (IBAction)showImagePicker:(id)sender;
- (void)uploadImageFromURL:(NSURL *)url image:(UIImage *)imageToUpload;

@end
