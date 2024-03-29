//
//  LicensePickerViewController.m
//  WikiSnaps
//
//  Created by Derk-Jan Hartman on 26-03-11.
//  Copyright 2011 Wikimedia Commons. All rights reserved.
//

#import "LicensePickerViewController.h"


@implementation LicensePickerViewController

@synthesize descriptionText, pickerLabel;
@synthesize licenses, selectedLicense;
@synthesize delegate;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom init
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    navItem.title = @"License";
    dismissButton.title = @"Select";
    dismissButton.target = self;
    dismissButton.action = @selector( dismissLicensePicker: );
    
    [pickerControl selectRow:selectedLicense inComponent:0 animated: NO];
    NSDictionary *aLicense = [self.licenses objectAtIndex:selectedLicense];
    self.pickerLabel.text = [aLicense objectForKey:@"name"];
    [self.descriptionText loadHTMLString:[aLicense objectForKey:@"description"] baseURL:nil];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    self.descriptionText = nil;
    self.pickerLabel = nil;
    self.licenses = nil;
    self.delegate = nil;

	//[super dealloc];
}

#pragma mark Actions
- (IBAction) dismissLicensePicker: (id) sender
{
    [self.delegate licensePickerDidFinish: [pickerControl selectedRowInComponent:0]];
}

#pragma mark UIPickerViewDelegate

- (NSString*)pickerView: (UIPickerView *)aPickerView 
			 titleForRow: (NSInteger)row 
			 forComponent: (NSInteger)component
{
    NSDictionary *dict = [self.licenses objectAtIndex:row];
    if( dict != nil ) {
        return [dict objectForKey:@"short"];
    }
    return @"";
}

- (void)pickerView: (UIPickerView *)aPickerView
                    didSelectRow:(NSInteger)row
                    inComponent:(NSInteger)component
{
    NSDictionary *dict = [self.licenses objectAtIndex:row];
    if( dict != nil ) {
        self.pickerLabel.text = [dict objectForKey:@"name"];
        [self.descriptionText loadHTMLString: [dict objectForKey:@"description"] baseURL: nil];
    }
}

#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView: (UIPickerView *)aPickerView
{
    return 1;
}


- (NSInteger)pickerView: (UIPickerView *)aPickerView numberOfRowsInComponent: (NSInteger)component
{
    NSInteger numberOfRows = [self.licenses count];
    
    return numberOfRows;
}


@end
