//
//  Configuration.h
//  Wikipedia Image Uploader
//
//  Created by Ben Brown on 11/1/11.
//  Copyright (c) 2011 Benbenbob Software. All rights reserved.
//

#ifndef Wikipedia_Image_Uploader_Configuration_h
#define Wikipedia_Image_Uploader_Configuration_h

enum {
	kOLIS,
	kNWN,
	kAGC
};

#define IS_IPAD ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

#define USERNAME_KEY @"UsernameKey"
#define KEYCHAIN_KEY @"KeychainKey"

#define LICENSE_KEY @"LicenseKey"

#define LOGIN_GOOD_KEY @"LoginGood"

#define OPEN_LINKS_IN_SAFARI_KEY @"OpenLinksInSafari"
#define OPEN_LINKS_IN_SAFARI_TAG kOLIS

#define NOTIFY_WHEN_NEARBY_KEY @"NotifyWhenNearby"
#define NOTIFY_WHEN_NEARBY_TAG kNWN

#define ADD_GPS_COORDS_KEY @"AddGPSCoords"
#define ADD_GPS_COORDS_TAG kAGC

#define PART_OF_FILENAME_TO_REMOVE @"File:"

//Constants
#define DESTINATION_URL @"http://commons.wikimedia.org/wiki/File:%@"
#define API_URL @"http://commons.wikimedia.org/w/api.php"
#define APP_CATEGORY [NSString stringWithFormat:@"Images uploaded using Wikipedia for %@", IS_IPAD?@"iPad":@"iPhone"]
#define DEFAULT_LICENSE @"{{self|cc-by-sa-3.0}}"

//Errors
#define FILENAME_EXISTS_WARNING @"exists"
#define BAD_FILENAME_WARNING @"badfilename"
#define IMAGE_EXISTS_BUT_DELETED @"duplicate-archive"

#endif
