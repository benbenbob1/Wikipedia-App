//
//  ImageDetailsViewController.h
//  Wikipedia Image Uploader
//
//  Created by Ben Brown on 11/1/11.
//  Copyright (c) 2011 Benbenbob Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonsUpload.h"
#import "ImageUploadViewController.h"

@interface ImageDetailsViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate> {
	IBOutlet UITextView *descriptionField;
	IBOutlet UITextField *titleField;
	IBOutlet UIButton *uploadButton;
	IBOutlet UILabel *gettingLocationLabel;
	IBOutlet UIActivityIndicatorView *gettingLocationIndicator;
}

- (IBAction)upload:(id)sender;
- (IBAction)cancel:(id)sender;
- (void)textFieldChanged;

@property (strong, nonatomic) CommonsUpload *upload;

@end
