//
//  wikiDataViewController.h
//  Wikipedia Image Uploader
//
//  Created by Ben Brown on 10/28/11.
//  Copyright (c) 2011 Benbenbob Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResult.h"
#import "SettingsView.h"

@interface wikiDataViewController : UIViewController <UIWebViewDelegate, UIAlertViewDelegate, UISearchBarDelegate, UINavigationBarDelegate, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, NSXMLParserDelegate> {
	IBOutlet UIActivityIndicatorView *indView;
	IBOutlet UIWebView *webView;
	IBOutlet UIActivityIndicatorView *loadingIndicator;
	IBOutlet UIButton *loadingBacking;
	IBOutlet UISearchBar *searchBar;
	IBOutlet UINavigationBar *bottomNavBar, *topNavBar;
	IBOutlet UIToolbar *bottomFullBar;
	IBOutlet UIBarButtonItem *actionButton, *moreButton, *settingsButton, *searchButton, *reloadButton;
	IBOutlet UISegmentedControl *historyControlButton;
	UITableView *searchResultsTable;
	NSMutableString *currentElementValue;
	SearchResult *result;
	NSMutableArray *results;
	BOOL didConvertURL, shouldIgnoreAction;
}

- (IBAction)historyControl:(UISegmentedControl *)sender;
- (void)openLinkInSafari:(NSURL *)url;
- (void)closeSearchResults;
- (void)showSearchResults;
- (void)lowerSearchBar;
- (void)raiseSearchBar;
- (void)webViewLoadURL:(NSURL *)url;
- (IBAction)actionButtonPressed:(id)sender;
- (IBAction)moreButtonPressed:(id)sender;
- (IBAction)searchButtonPressed:(id)sender;
- (IBAction)settingsButtonPressed:(id)sender;
- (void)searchForQuery:(NSString *)query;
- (NSString *)convertMobilePageFromURL:(NSURL *)pageURL;
- (void)convertPageAndGo:(NSURL *)pageURL;

@property (strong, nonatomic) IBOutlet UILabel *dataLabel;
@property (strong, nonatomic) id dataObject;
@end