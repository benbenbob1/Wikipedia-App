//
//  SettingsView.m
//  Wikipedia Image Uploader
//
//  Created by Ben Brown on 10/31/11.
//  Copyright (c) 2011 Benbenbob Software. All rights reserved.
//

#import "SettingsView.h"

@implementation SettingsView

enum {
	kOpenLinksInSafariTag,
	kNotifyWhenNearbyTag,
	kAddGPSCoordsTag
};


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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 2;
	}
	if (section == 1) {
		return 3;
	}
	if (section == 2) {
		//return 2;
		return 1;
	}
	return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return @"Settings";
	}
	if (section == 1) {
		return @"Login Info (for uploading pictures)";
	}
	if (section == 2) {
		return @"";
	}
	return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	
	if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	}
	cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
	cell.textLabel.numberOfLines = 0;
	[cell setAccessoryView:nil];
	[cell setAccessoryType:UITableViewCellAccessoryNone];
	if (indexPath.section == 0) {
		UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
		[switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
		[cell setAccessoryView:switchView];
		if (indexPath.row == 0) {
			cell.textLabel.text = @"Open web links in Safari";
			[switchView setTag:kOpenLinksInSafariTag];
			[switchView setOn:[defs boolForKey:@"openLinksInSafari"]];
		}
		else if (indexPath.row == 1) {
			cell.textLabel.text = @"Notify me to take pictures when I am near an article that needs them";
			[switchView setTag:kNotifyWhenNearbyTag];
			[switchView setOn:[defs boolForKey:@"notifyWhenNearby"]];
			//CGRect appSize =  [(UIScreen *)[[UIScreen screens] objectAtIndex:0] applicationFrame];
			//[cell.textLabel setFrame:CGRectMake(cell.textLabel.frame.origin.x, cell.textLabel.frame.origin.y, appSize.size.width*0.75, cell.textLabel.frame.size.height)];
		}
		
		//[cell.detailTextLabel setText:@"Hello!"];
		//[cell.detailTextLabel setTextColor:[UIColor redColor]];
	}
	else if (indexPath.section == 1) {
		if (indexPath.row == 0) {
			cell.textLabel.text = @"Username/Password";
			[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
		}
		else if (indexPath.row == 1) {
			NSString *licenseName;
			switch (licenseSelected) {
				case 1:
					licenseName = @"CC-BY-3.0";
					break;
				case 2:
					licenseName = @"CC-Zero";
					break;
				default:
					licenseName = @"CC-BY-SA-3.0";
					break;
			}
			cell.textLabel.text = [NSString stringWithFormat:@"License Type (%@)", licenseName];
			[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
		}
		else if (indexPath.row == 2) {
			cell.textLabel.text = @"Attach GPS coordinates";
			UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
			[switchView setTag:kAddGPSCoordsTag];
			[switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
			[switchView setOn:[defs boolForKey:@"addGPSCoords"]];
			[cell setAccessoryView:switchView];
		}
	}
	else if (indexPath.section == 2) {
		/*if (indexPath.row == 0) {
			cell.textLabel.text = @"Save";
		}
		else if (indexPath.row == 1) {
			cell.textLabel.text = @"Cancel";
		}*/
		cell.textLabel.text = @"Return";
	}
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	/*if ([settingsTable cellForRowAtIndexPath:indexPath]) {
		NSString *cellText = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
		UIFont *cellFont = [tableView cellForRowAtIndexPath:indexPath].textLabel.font;
		CGSize constrainSize = CGSizeMake(280.0f, MAXFLOAT);
		CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constrainSize lineBreakMode:UILineBreakModeWordWrap];
		return labelSize.height+20;
	}*/
	if (indexPath.section == 0 && indexPath.row == 1) {
		CGRect appSize =  [(UIScreen *)[[UIScreen screens] objectAtIndex:0] applicationFrame];
		NSString *cellText = @"Notify me to take pictures when I am near an article that needs them";
		UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:17.0];
		CGSize constrainSize = CGSizeMake(appSize.size.width*0.5, MAXFLOAT);
		CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constrainSize lineBreakMode:UILineBreakModeWordWrap];
		return labelSize.height+10;
	}
	return 50;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	[cell setBackgroundColor:[UIColor whiteColor]];
	[cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
	if (indexPath.section == 0 && indexPath.row == 1) {
		CGRect appSize =  [(UIScreen *)[[UIScreen screens] objectAtIndex:0] applicationFrame];
		[cell.textLabel setFrame:CGRectMake(cell.textLabel.frame.origin.x, cell.textLabel.frame.origin.y, appSize.size.width*0.5, cell.textLabel.frame.size.height)];
	}
	/*if (indexPath.section == 2) {
		if (indexPath.row == 0) {
			[cell setBackgroundColor:[UIColor greenColor]];
		}
		else if (indexPath.row == 1) {
			[cell setBackgroundColor:[UIColor redColor]];
		}
	}*/
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0 || (indexPath.section == 1 && indexPath.row == 2)) {
		[self switchAction:[settingsTable cellForRowAtIndexPath:indexPath].accessoryView];
	}
	else if (indexPath.section == 1 && indexPath.row == 1) {
		LicensePickerViewController *licenseView = [[LicensePickerViewController alloc] initWithNibName:@"LicensePickerViewController" bundle:nil];
		[licenseView setDelegate:self];
		NSArray *licenses = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Licenses" ofType:@"plist"]];
		[licenseView setLicenses:licenses];
		[licenseView setSelectedLicense:licenseSelected];
		[self presentModalViewController:licenseView animated:YES];
	}
	else if (indexPath.section == 2) {
		[self saveAndReturn];
	}
}



- (void)licensePickerDidFinish:(int)selectedLicense {
	NSLog(@"License %i chosen", selectedLicense);
	[self dismissModalViewControllerAnimated:YES];
	licenseSelected = selectedLicense;
	[settingsTable reloadData];
}

- (void)switchAction:(UISwitch *)sender {
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	if ([sender tag] == kOpenLinksInSafariTag) {
		NSLog(@"kOpenLinksInSafariTag changed to %i!", [sender isOn]);
		[defs setBool:![defs boolForKey:@"openLinksInSafari"] forKey:@"openLinksInSafari"];
	}
	else if ([sender tag] == kNotifyWhenNearbyTag) {
		NSLog(@"kNotifyWhenNearbyTag changed!");
		[defs setBool:![defs boolForKey:@"notifyWhenNearby"] forKey:@"notifyWhenNearby"];
	}
	else if ([sender tag] == kAddGPSCoordsTag) {
		NSLog(@"kAddGPSCoordsTag changed!");
		[defs setBool:![defs boolForKey:@"addGPSCoords"] forKey:@"addGPSCoords"];
	}
	[defs synchronize];
	[settingsTable reloadData];
}

- (void)saveAndReturn {
	[self.presentingViewController dismissModalViewControllerAnimated:YES];
}

@end
