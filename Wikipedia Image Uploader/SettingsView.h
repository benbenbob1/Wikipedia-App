//
//  SettingsView.h
//  Wikipedia Image Uploader
//
//  Created by Ben Brown on 10/31/11.
//  Copyright (c) 2011 Benbenbob Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LicensePickerViewController.h"
#import "LoginPage.h"
#import "Configuration.h"
#import "wikiDataViewController.h"

@interface SettingsView : UIViewController <UITableViewDataSource, UITableViewDelegate, LicensePickerDelegate> {
	IBOutlet UITableView *settingsTable;
	int licenseSelected;
	BOOL addGPSCoords, notifyWhenNearby, openLinksInSafari;
}

- (void)switchAction:(UISwitch *)sender;
- (void)saveAndReturn;

@end
