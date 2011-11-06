//
//  ImageDetailsViewController.m
//  Wikipedia Image Uploader
//
//  Created by Ben Brown on 11/1/11.
//  Copyright (c) 2011 Benbenbob Software. All rights reserved.
//

#import "ImageDetailsViewController.h"

@implementation ImageDetailsViewController

@synthesize upload;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[titleField addTarget:self action:@selector(textFieldChanged) forControlEvents:UIControlEventEditingChanged];
	[titleField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIDeviceOrientationIsPortrait(interfaceOrientation);
}

- (IBAction)upload:(id)sender {
	ImageUploadViewController *imgUploader = [[ImageUploadViewController alloc] init];
	self.upload.imageTitle = [NSString stringWithFormat:@"%@.jpg", titleField.text];
	self.upload.description = [descriptionField text];
	imgUploader.upload = self.upload;
	//[self presentModalViewController:imgUploader animated:YES];
	[self presentViewController:imgUploader animated:YES completion:^{
		NSLog(@"Completed imgUploader");
	 }];
	[self.presentingViewController dismissModalViewControllerAnimated:NO];
}

- (void)textFieldChanged {
	if ([[titleField text] length]>0) {
		[uploadButton setEnabled:YES];
	}
	/*else if (gotLoc) {
		[uploadButton setTitle:@"Upload" forState:UIControlStateDisabled];
		[uploadButton setEnabled:NO];
	}*/
	else {
		[uploadButton setEnabled:NO];
	}
}

- (IBAction)cancel:(id)sender {
	[self.presentingViewController dismissModalViewControllerAnimated:YES];
}

/*- (void)textViewDidChange:(UITextView *)textView {
	if ([[titleField text] length]>0) {
		[uploadButton setEnabled:YES];
	}
	else {
		[uploadButton setEnabled:NO];
	}
}*/

- (void)textFieldDidEndEditing:(UITextField *)textField {
	if (![self.upload verifyTitle:textField.text]) {
		textField.textColor = [UIColor redColor];
		[uploadButton setEnabled:NO];
	}
	else {
		textField.textColor = [UIColor blackColor];
		[uploadButton setEnabled:YES];
	}
	[textField resignFirstResponder];
}

@end
