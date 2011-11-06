//
//  wikiDataViewController.m
//  Wikipedia Image Uploader
//
//  Created by Ben Brown on 10/28/11.
//  Copyright (c) 2011 Benbenbob Software. All rights reserved.
//

#import "wikiDataViewController.h"

@implementation wikiDataViewController

@synthesize dataLabel = _dataLabel;
@synthesize dataObject = _dataObject;

/*#define iPHONE_PORTRAIT_KEYBOARD_HEIGHT 216
#define iPHONE_LANDSCAPE_KEYBOARD_HEIGHT 116
#define iPAD_PORTRAIT_KEYBOARD_HEIGHT 264
#define iPAD_LANDSCAPE_KEYBOARD_HEIGHT 352
#define PORTRAIT_KEYBOARD_HEIGHT ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone?(UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation])?iPHONE_PORTRAIT_KEYBOARD_HEIGHT:iPHONE_LANDSCAPE_KEYBOARD_HEIGHT):(UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation])?iPAD_PORTRAIT_KEYBOARD_HEIGHT:iPAD_LANDSCAPE_KEYBOARD_HEIGHT))*/


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view, typically from a nib.
	
	shouldIgnoreAction = YES;
	[self webViewLoadURL:[NSURL URLWithString:@"http://en.m.wikipedia.org"]];
	[webView setScalesPageToFit:YES];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
	[self.view setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth];
	if ([[NSUserDefaults standardUserDefaults] boolForKey:ADD_GPS_COORDS_KEY]) {
		[self getLocation];
	}
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.dataLabel.text = [self.dataObject description];
}

- (void)openLinkInSafari:(NSURL *)url {
	[[UIApplication sharedApplication] openURL:url];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	
	[searchResultsTable removeFromSuperview];
	searchResultsTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	[searchResultsTable setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
	[searchResultsTable setDelegate:self];
	[searchResultsTable setDataSource:self];
	[[self view] addSubview:searchResultsTable];
	[webView setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
	results = [[NSMutableArray alloc] init];
	[searchResultsTable setHidden:YES];
	
	/*NSString *wikiMainSite = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://en.m.wikipedia.org"] encoding:NSUTF8StringEncoding error:NULL];
	//wikiMainSite = [[wikiMainSite stringByReplacingOccurrencesOfString:@"<div id='searchbox'>" withString:@""] stringByReplacingOccurrencesOfString:@"<div id='header'>" withString:@""];
	
	NSRange startStringHeader = [wikiMainSite rangeOfString:@"<div id='header'>"];
	NSUInteger endStringHeader = [wikiMainSite rangeOfString:@"<div class='show' id='content_wrapper'>"].location-(startStringHeader.location+startStringHeader.length);
	wikiMainSite = [wikiMainSite stringByReplacingCharactersInRange:NSMakeRange(startStringHeader.location, endStringHeader) withString:@""];
	
	NSRange startStringFooter = [wikiMainSite rangeOfString:@"<div id='footer'>"];
	NSUInteger endStringFooter = [wikiMainSite rangeOfString:@"<div id='copyright'>"].location-(startStringFooter.location+startStringFooter.length)+3;
	wikiMainSite = [wikiMainSite stringByReplacingCharactersInRange:NSMakeRange(startStringFooter.location, endStringFooter) withString:@""];
	
	[webView loadHTMLString:wikiMainSite baseURL:[NSURL URLWithString:@"http://en.m.wikipedia.org"]];*/
	//[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://en.m.wikipedia.org"]]];
	//shouldIgnoreAction = YES;
	//[self webViewLoadURL:[NSURL URLWithString:@"http://en.m.wikipedia.org"]];
	/*
	UIMenuItem *openInSafariItem = [[UIMenuItem alloc] initWithTitle:@"Open in Safari" action:@selector(openInSafari:)];
	UIMenuItem *saveImageItem = [[UIMenuItem alloc] initWithTitle:@"Save" action:@selector(saveImage:)];
	[[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:openInSafariItem, saveImageItem, nil]];*/
}

- (void)keyboardDidShow:(NSNotification *)notification {
	CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
	CGRect keyboardFrameConverted = [self.view convertRect:keyboardFrame fromView:window];
	NSLog(@"Keyboard did show! height is %.0fpx", keyboardFrameConverted.size.height);
	[UIView animateWithDuration:0.25 animations:^(void){
		[searchBar setCenter:CGPointMake([searchBar center].x, [searchBar center].y-keyboardFrameConverted.size.height)];
		[bottomNavBar setCenter:CGPointMake([bottomNavBar center].x, [bottomNavBar center].y-keyboardFrameConverted.size.height)];
	} completion:^(BOOL finished) {
		NSLog(@"Completed! moved search bar center to %.0fpx", [searchBar center].y);
		[self showSearchResults];
	}];
	//[searchBar resignFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	[[UIMenuController sharedMenuController] setMenuItems:nil];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	/*if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	} else {
	    return YES;
	}*/
	return YES;
}

- (IBAction)actionButtonPressed:(id)sender {
	/*NSString *otherButtons;
	if ([bottomFullBar isHidden]) {
		otherButtons = @"Open in Safari", @"Upload Picture", nil;
	}
	else {
		otherButtons = [[NSArray alloc] initWithObjects:@"Open in Safari", @"Settings", nil];
	}*/
	UIActionSheet *actionSheet;
	if ([bottomFullBar isHidden]) {
		actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open in Safari", @"Upload Picture", @"Settings", nil];
	}
	else {
		actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open in Safari", nil];
	}
	[actionSheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
	if ([sender class] == [UIBarButtonItem class]) {
		[actionSheet showFromBarButtonItem:(UIBarButtonItem *)sender animated:YES];
	}
	else {
		[actionSheet showInView:self.view];
	}
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Open in Safari"]) {
		//[[UIApplication sharedApplication] openURL:[[webView request] URL]];
		[self openLinkInSafari:[[webView request] URL]];
	}
	else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Settings"]) {
		//[[UIApplication sharedApplication] openURL:[[webView request] URL]];
		[self settingsButtonPressed:nil];
	}
	else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Upload Picture"]) {
		//[[UIApplication sharedApplication] openURL:[[webView request] URL]];
		[self cameraButtonPressed:bottomFullBar];
	}
}

- (IBAction)moreButtonPressed:(id)sender {
	[bottomFullBar setHidden:NO];
	//[bottomLeftNavBar setAlpha:0.0f];
	CGRect appSize =  [(UIScreen *)[[UIScreen screens] objectAtIndex:0] applicationFrame];
	if (UIInterfaceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
		[UIView animateWithDuration:0.25 animations:^(void){
			[searchBar setFrame:CGRectMake(-[searchBar frame].size.width, [searchBar frame].origin.y, [searchBar frame].size.width, [searchBar frame].size.height)];
			[bottomNavBar setFrame:CGRectMake(appSize.size.width, [bottomNavBar frame].origin.y, [bottomNavBar frame].size.width, [bottomNavBar frame].size.height)];
			//[bottomLeftNavBar setAlpha:1.0f];
		}];
	}
	else {
		[UIView animateWithDuration:0.25 animations:^(void){
			[searchBar setFrame:CGRectMake(-[searchBar frame].size.width, [searchBar frame].origin.y, [searchBar frame].size.width, [searchBar frame].size.height)];
			[bottomNavBar setFrame:CGRectMake(appSize.size.height, [bottomNavBar frame].origin.y, [bottomNavBar frame].size.width, [bottomNavBar frame].size.height)];
			//[bottomLeftNavBar setAlpha:1.0f];
		}];
	}
}

- (IBAction)searchButtonPressed:(id)sender {
	[UIView animateWithDuration:0.25 animations:^(void){
		//[bottomLeftNavBar setFrame:[searchBar frame]];
		[searchBar setFrame:CGRectMake(0, [searchBar frame].origin.y, [searchBar frame].size.width, [searchBar frame].size.height)];
		[bottomNavBar setFrame:CGRectMake([searchBar frame].size.width, [bottomNavBar frame].origin.y, [bottomNavBar frame].size.width, [bottomNavBar frame].size.height)];
		//[bottomLeftNavBar setAlpha:1.0f];
	} completion:^(BOOL finished) {
		[bottomFullBar setHidden:YES];
	}];
}

- (IBAction)settingsButtonPressed:(id)sender {
	SettingsView *settingsPage = [[SettingsView alloc] initWithNibName:@"SettingsView" bundle:nil];
	[settingsPage setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
	[self presentModalViewController:settingsPage animated:YES];
}

- (IBAction)locationButtonPressed:(id)sender {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"This button does nothing, it would just do the same thing as what the button in the Wikipedia app already does" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];
}

- (IBAction)historyControl:(UISegmentedControl *)sender {
	NSLog(@"Hist Cont! %i pressed", [historyControlButton selectedSegmentIndex]);
	//[[self undoManager] disableUndoRegistration];
	if ([historyControlButton selectedSegmentIndex] == 0) {
		//[webView loadRequest:[NSURLRequest requestWithURL:[undos objectAtIndex:[undos count]-2]]];
		NSLog(@"Undoing: %@", [self undoManager].undoActionName);
		shouldIgnoreAction = YES;
		[[self undoManager] undo];
		
	}
	else if ([historyControlButton selectedSegmentIndex] == 1) {
		//[webView loadRequest:[NSURLRequest requestWithURL:[undos objectAtIndex:[undos indexOfObject:[[webView request] URL]]+1]]];
		NSLog(@"Redoing: %@", [self undoManager].redoActionName);
		shouldIgnoreAction = YES;
		[[self undoManager] redo];
	}
	//[[self undoManager] enableUndoRegistration];
}

- (IBAction)cameraButtonPressed:(id)sender {
	//[self showImagePicker:sender];
	ManageImagesPage *mIP = [[ManageImagesPage alloc] init];
	UINavigationController *navCon = [[UINavigationController alloc] init];
	[navCon setDelegate:self];
	[navCon pushViewController:mIP animated:NO];
	[self presentViewController:navCon animated:YES completion:NULL];
}

#pragma mark - Image Chooser Stuff

- (IBAction)showImagePicker:(id)sender {
	NSLog(@"Showing img picker");
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	[picker setDelegate:self];
	[picker setAllowsEditing:NO];
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
		picker.showsCameraControls = YES;
		picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
	}
	else {
		picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	}
	if (IS_IPAD) {
		UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:picker];
		if ([sender class] == [UIBarButtonItem class]) {
			[popover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
		}
		else if (sender == nil) {
			[popover presentPopoverFromRect:CGRectZero inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
		}
		else {
			[popover presentPopoverFromRect:CGRectMake([sender frame].origin.x, [sender frame].origin.y, [sender frame].size.width, [sender frame].size.height) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
		}
		popoverController = popover;
	}
	else {
		if (self.isFirstResponder) {
			[self presentModalViewController:picker animated:YES];
		}
		else {
			[self.presentedViewController presentModalViewController:picker animated:YES];
		}
	}
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	if (IS_IPAD) {
		[popoverController dismissPopoverAnimated:NO];
	}
	else {
		[picker.presentingViewController dismissModalViewControllerAnimated:NO];
	}
	NSMutableDictionary *metaData = [NSMutableDictionary dictionaryWithDictionary:[info valueForKey:UIImagePickerControllerMediaMetadata]];
	
    [metaData setObject:[self currentLocation] forKey: (NSString *)kCGImagePropertyGPSDictionary];
    // Store the image on the Camera Roll
	UIImage *img = [info valueForKey:UIImagePickerControllerOriginalImage];
    if( picker.sourceType == UIImagePickerControllerSourceTypeCamera ) {
        Class assestsLibClass = (NSClassFromString(@"ALAssetsLibrary"));
        if( assestsLibClass != nil ) {
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            
            ALAssetsLibraryWriteImageCompletionBlock completionBlock = ^(NSURL *newURL, NSError *error) {
                if (error) {
                    NSLog( @"Could not write image to photoalbum: %@", error );
                } else {
                    [self uploadImageFromURL:newURL image:img];
                }
            };
			
            [library writeImageToSavedPhotosAlbum:[img CGImage] metadata:metaData completionBlock:completionBlock];
            return;
        } else {
            //self.image = [self.image correctOrientation:self.image];
            UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
        }
    }
	NSLog(@"Picking Finished, info: %@", [info valueForKey:UIImagePickerControllerMediaURL]);
	[self uploadImageFromURL:[info valueForKey:UIImagePickerControllerMediaURL] image:img];
	
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	if (IS_IPAD) {
		[(UIPopoverController *)picker.parentViewController dismissPopoverAnimated:YES];
	}
	else {
		[picker.presentingViewController dismissModalViewControllerAnimated:YES];
	}
}

- (void)uploadImageFromURL:(NSURL *)url image:(UIImage *)imageToUpload{
	NSLog(@"Upload img from url (%@)", url.absoluteString);
	CommonsUpload *upload = [[CommonsUpload alloc] init];
	[upload setDelegate:self];
	[upload setOriginalImage:imageToUpload];
	[upload setImageURL:url];
	
	ImageDetailsViewController *imgDetailsVC = [[ImageDetailsViewController alloc] init];
	[imgDetailsVC setUpload:upload];
	//[self presentModalViewController:imgDetailsVC animated:YES];
	if (self.isFirstResponder) {
		[self presentModalViewController:imgDetailsVC animated:YES];
	}
	else {
		[self.presentedViewController presentModalViewController:imgDetailsVC animated:YES];
	}
	//[upload setImageTitle:[NSString stringWithFormat:@"%@.jpg", @"Test Title"]];
	//[upload setDescription:@"Test Description"];
	/*ImageUploadViewController *imgUploader = [[ImageUploadViewController alloc] init];
	imgUploader.upload = upload;
	//[self presentModalViewController:imgUploader animated:YES];
	[self presentViewController:imgUploader animated:YES completion:^{
		NSLog(@"Completed imgUploader");
	}];*/
	//[upload uploadImage];
	//[self.presentedViewController.navigationController pushViewController:imgUploader animated:YES];
}

#pragma mark - Web View Stuff

- (void)webViewLoadURL:(NSURL *)url {
	[webView loadRequest:[NSURLRequest requestWithURL:url]];
	/*if (!shouldIgnoreAction) {
		[[self undoManager] registerUndoWithTarget:self selector:@selector(webViewLoadURL:) object:url];
		NSLog(@"Registered request of %@", [url absoluteString]);
	}
	shouldIgnoreAction = NO;*/
}

- (void)webViewDidStartLoad:(UIWebView *)aWebView {
	[loadingBacking setHidden:NO];
	[loadingIndicator startAnimating];
	if (!shouldIgnoreAction) {
		[[self undoManager] registerUndoWithTarget:webView selector:@selector(loadRequest:) object:[webView request]];
		[[self undoManager] setActionName:[NSString stringWithFormat:@"Action: %@", [[webView request].URL absoluteString]]];
		NSLog(@"Registered request of %@", [webView request].URL);
	}
	shouldIgnoreAction = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
	[loadingBacking setHidden:YES];
	[loadingIndicator stopAnimating];
	[topNavBar.topItem setTitle:[[[webView stringByEvaluatingJavaScriptFromString:@"document.title"] stringByReplacingOccurrencesOfString:@" - Wikipedia, the free encyclopedia" withString:@""] stringByReplacingOccurrencesOfString:@", the free encyclopedia" withString:@""]];
	//NSLog(@"Loc = %@", [webView stringByEvaluatingJavaScriptFromString:@"document.location"]);
	//[undos addObject:[[aWebView request] URL]];
	/*
	 if (!isFirstPage) {
	 [[self undoManager] registerUndoWithTarget:self selector:@selector(webViewLoadURL:) object:[aWebView request].URL];
	 NSLog(@"Registered request of %@", [aWebView request].URL);
	 }
	 isFirstPage = NO;
	 */
	[historyControlButton setEnabled:[[self undoManager] canUndo] forSegmentAtIndex:0];
	[historyControlButton setEnabled:[[self undoManager] canRedo] forSegmentAtIndex:1];
	/*UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:webView action:@selector(goBack)];
	[self.navigationItem setLeftBarButtonItem:backButton];*/
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	[loadingBacking setHidden:YES];
	[loadingIndicator stopAnimating];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
}

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	if (didConvertURL && [[[request URL] absoluteString] rangeOfString:@".wikipedia"].location != NSNotFound) {
		didConvertURL = NO;
		return YES;
	}
	if ([[[request URL] absoluteString] rangeOfString:@".wikipedia"].location != NSNotFound) {
		NSLog(@"The link is on wikipedia (%@)", [[request URL] absoluteString]);
		didConvertURL = NO;
		if ([[[request URL] absoluteString] rangeOfString:@"m.wiki"].location == NSNotFound) {
			//NSLog(@"No m.wiki found");
			//[webView loadHTMLString:[self convertMobilePageFromURL:[request URL]] baseURL:[NSURL URLWithString:@"http://en.m.wikipedia.org"]];
			[self convertPageAndGo:[request URL]];
			didConvertURL = YES;
			return NO;
		}
		else {
			//NSLog(@"It is on m.wiki");
			if (didConvertURL) {
				didConvertURL = NO;
				return YES;
			}
			//[webView loadHTMLString:[self convertMobilePageFromURL:[NSURL URLWithString:[[[request URL] absoluteString] stringByReplacingOccurrencesOfString:@"m.wiki" withString:@"wiki"]]] baseURL:[NSURL URLWithString:@"http://en.wikipedia.org"]];
			[self convertPageAndGo:[NSURL URLWithString:[[[request URL] absoluteString] stringByReplacingOccurrencesOfString:@"m.wiki" withString:@"wiki"]]];
			didConvertURL = YES;
			return NO;
		}
	}
	else {
		NSLog(@"Not on wikipedia");
		if ([[NSUserDefaults standardUserDefaults] boolForKey:OPEN_LINKS_IN_SAFARI_KEY]) {
			[self openLinkInSafari:[request URL]];
			return NO;
		}
		else {
			return YES;
		}
	}
	return YES;
}

- (NSString *)convertMobilePageFromURL:(NSURL *)pageURL {
	NSURL *url = [NSURL URLWithString:[[pageURL absoluteString] stringByReplacingOccurrencesOfString:@".wiki" withString:@".m.wiki"]];
	NSString *str = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:NULL];
	//NSLog(@"str: %@", str);
	NSRange startStringHeader = [str rangeOfString:@"<div id='header'>"];
	NSUInteger endStringHeader = [str rangeOfString:@"<div class='show' id='content_wrapper'>"].location-(startStringHeader.location+startStringHeader.length);
	str = [str stringByReplacingCharactersInRange:NSMakeRange(startStringHeader.location, endStringHeader) withString:@""];
	
	NSRange startStringFooter = [str rangeOfString:@"<div id='footer'>"];
	NSUInteger endStringFooter = [str rangeOfString:@"<div id='copyright'>"].location-(startStringFooter.location+startStringFooter.length)+3;
	str = [str stringByReplacingCharactersInRange:NSMakeRange(startStringFooter.location, endStringFooter) withString:@""];
	//NSLog(@"Converting %@ to %@", pageURL, url);
	didConvertURL = YES;
	//[webView loadHTMLString:str baseURL:[NSURL URLWithString:@"http://en.m.wikipedia.org"]];
	return str;
}

- (void)convertPageAndGo:(NSURL *)pageURL {
	NSString *str = [self convertMobilePageFromURL:pageURL];
	[webView loadHTMLString:str baseURL:pageURL];
}

#pragma mark - Search Bar Stuff

- (void)searchBarTextDidBeginEditing:(UISearchBar *)aSearchBar {
	//NSLog(@"Going from %@ to %@", NSStringFromCGPoint([searchBar center]), NSStringFromCGPoint(CGPointMake([searchBar center].x, [searchBar center].y+CGRectFromString(UIKeyboardFrameEndUserInfoKey).origin.y)));
	[self raiseSearchBar];
	//[self showSearchResults];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar {
	[self lowerSearchBar];
	[self searchForQuery:[searchBar text]];
	//[searchResultsTable reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)aSearchBar {
	[self lowerSearchBar];
	[self closeSearchResults];
	//[searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)aSearchBar {
	[self lowerSearchBar];
}

- (void)searchBar:(UISearchBar *)aSearchBar textDidChange:(NSString *)searchText {
	if ([[searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]>=2) {
		//[self showSearchResults];
		[self searchForQuery:searchText];
		//[searchResultsTable reloadData];
	}
	else {
		//[searchBar setShowsCancelButton:NO animated:YES];
	}
}

- (void)searchForQuery:(NSString *)query {
	[results removeAllObjects];
	[searchResultsTable reloadData];
	query = [query stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://en.wikipedia.org/w/api.php?format=xml&action=opensearch&search=%@", query]];
	//NSDictionary *dict = [NSDictionary dictionaryWithContentsOfURL:url];
	//NSArray *dict = [NSArray arrayWithContentsOfURL:url];
	//NSString *str = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:NULL];
	//NSDictionary *dict = [NSDictionary dictionaryWithObjects:[str componentsSeparatedByString:<#(NSString *)#>] forKeys:<#(NSArray *)#>
	NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
	[xmlParser setDelegate:self];
	[xmlParser parse];
	//NSLog(@"Dict: %@", dict);
}

- (void)showSearchResults {
	CGRect appSize =  [(UIScreen *)[[UIScreen screens] objectAtIndex:0] applicationFrame];
	[searchResultsTable setHidden:NO];
	[searchResultsTable setFrame:CGRectMake(0, [topNavBar frame].size.height, appSize.size.width, [searchBar frame].origin.y-([topNavBar frame].origin.y+[topNavBar frame].size.height))];
	[searchResultsTable reloadData];
}

- (void)closeSearchResults {
	//[searchResultsTable removeFromSuperview];
	//searchResultsTable = nil;
	[searchResultsTable setHidden:YES];
}

- (void)raiseSearchBar {
	[moreButton setEnabled:NO];
	/*[UIView animateWithDuration:0.25 animations:^(void){
		[searchBar setCenter:CGPointMake([searchBar center].x, [searchBar center].y-PORTRAIT_KEYBOARD_HEIGHT)];
		[bottomNavBar setCenter:CGPointMake([bottomNavBar center].x, [bottomNavBar center].y-PORTRAIT_KEYBOARD_HEIGHT)];
	}];*/
	[searchBar setShowsCancelButton:YES animated:YES];
}

- (void)lowerSearchBar {
	[moreButton setEnabled:YES];
	/*[UIView animateWithDuration:0.25 animations:^(void){
		[searchBar setCenter:CGPointMake([searchBar center].x, [searchBar center].y+PORTRAIT_KEYBOARD_HEIGHT)];
		[bottomNavBar setCenter:CGPointMake([bottomNavBar center].x, [bottomNavBar center].y+PORTRAIT_KEYBOARD_HEIGHT)];
		[searchResultsTable setFrame:CGRectMake(0, [topNavBar frame].size.height, searchResultsTable.frame.size.width, [searchBar frame].origin.y-([topNavBar frame].origin.y+[topNavBar frame].size.height))];
	}];*/
	CGRect appSize =  [(UIScreen *)[[UIScreen screens] objectAtIndex:0] applicationFrame];
	if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
		CGFloat tempFloat = appSize.size.width;
		appSize.size.width = appSize.size.height;
		appSize.size.height = tempFloat;
	}
	[UIView animateWithDuration:0.25 animations:^(void){
		[searchBar setCenter:CGPointMake([searchBar center].x, appSize.size.height-[searchBar frame].size.height/2)];
		[bottomNavBar setCenter:CGPointMake([bottomNavBar center].x, appSize.size.height-[bottomNavBar frame].size.height/2)];
		[searchResultsTable setFrame:CGRectMake(0, [topNavBar frame].size.height, searchResultsTable.frame.size.width, [searchBar frame].origin.y-([topNavBar frame].origin.y+[topNavBar frame].size.height))];
	}];
	[searchBar setShowsCancelButton:NO animated:YES];
	[searchBar resignFirstResponder];
}

#pragma mark - XML Parser

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	if ([elementName isEqualToString:@"Item"]) {
		result = [[SearchResult alloc] init];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if (!currentElementValue) {
		currentElementValue = [[NSMutableString alloc] initWithString:string];
	}
	else {
		[currentElementValue appendString:string];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if ([elementName isEqualToString:@"SearchSuggestion"]) {
		[searchResultsTable reloadData];
		//NSLog(@"Results: %@", results);
		return;
	}
	
	if ([elementName isEqualToString:@"Item"] && result != nil) {
		[results addObject:result];
		result = nil;
	}
	else {
		if ([elementName isEqualToString:@"Text"]) {
			[result setResultTitle:currentElementValue];
		}
		else if ([elementName isEqualToString:@"Url"]) {
			[result setResultLink:currentElementValue];
		}
	}
	currentElementValue = nil;
}

#pragma mark - Table View Stuff

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [results count]>=1?[results count]:1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	
	if (cell == nil)
	{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		
		
	}
	
	if ([results count]>=1) {
		cell.textLabel.text = [(SearchResult *)[results objectAtIndex:indexPath.row] resultTitle];
		//[cell.detailTextLabel setText:@"Hello!"];
		//[cell.detailTextLabel setTextColor:[UIColor redColor]];
	}
	else {
		cell.textLabel.text = @"No results";
	}
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[(SearchResult *)[results objectAtIndex:indexPath.row] resultLink]]]];
	/*NSURL *url = 
	NSString *str = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:NULL];
	NSLog(@"str: %@", str);
	NSRange startStringHeader = [str rangeOfString:@"<div id='header'>"];
	NSUInteger endStringHeader = [str rangeOfString:@"<div class='show' id='content_wrapper'>"].location-(startStringHeader.location+startStringHeader.length);
	str = [str stringByReplacingCharactersInRange:NSMakeRange(startStringHeader.location, endStringHeader) withString:@""];
	
	NSRange startStringFooter = [str rangeOfString:@"<div id='footer'>"];
	NSUInteger endStringFooter = [str rangeOfString:@"<div id='copyright'>"].location-(startStringFooter.location+startStringFooter.length)+3;
	str = [str stringByReplacingCharactersInRange:NSMakeRange(startStringFooter.location, endStringFooter) withString:@""];
	
	[webView loadHTMLString:str baseURL:[NSURL URLWithString:@"http://en.m.wikipedia.org"]];*/
	if ([results count]>=1) {
		NSURL *url = [NSURL URLWithString:[(SearchResult *)[results objectAtIndex:indexPath.row] resultLink]];
		[webView loadHTMLString:[self convertMobilePageFromURL:url] baseURL:[NSURL URLWithString:@"http://en.m.wikipedia.org"]];
		[self lowerSearchBar];
		[self closeSearchResults];
	}
}

#pragma mark - Location Stuff

- (void)getLocation {
	if ([[NSUserDefaults standardUserDefaults] boolForKey:ADD_GPS_COORDS_KEY]) {
		if (![CLLocationManager locationServicesEnabled]) {
			NSLog(@"No GPS avaliable");
			return;
		}
		NSLog(@"Doing GPS stuff");
		if (nil == locMan)
			locMan = [[CLLocationManager alloc] init];
		//[locMan setPurpose:@"To add GPS data to an image"];
		[locMan setDelegate:self];
		[locMan setDistanceFilter:10.0];
		[locMan setDesiredAccuracy:kCLLocationAccuracyBest];
		/*[uploadButton setTitle:@"(Getting location)" forState:UIControlStateDisabled];
		 [uploadButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
		 [uploadButton setContentEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 20)];
		 [uploadButton setEnabled:NO];
		 [gettingLocationIndicator startAnimating];*/
		[locMan startUpdatingLocation];
	}
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	//[gettingLocationIndicator stopAnimating];
	NSLog(@"Found Location, %@", newLocation);
	//gotLoc = YES;
	loc = newLocation;
	/*if ([[titleField text] length]>0) {
		[uploadButton setEnabled:YES];
	}
	else {
		[uploadButton setTitle:@"Upload" forState:UIControlStateDisabled];
	}
	[uploadButton setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
	[uploadButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];*/
	[manager stopUpdatingLocation];
}

- (NSMutableDictionary *)currentLocation {
    NSMutableDictionary *locDict = [[NSMutableDictionary alloc] init];
	
    if (loc != nil) {
        CLLocationDegrees exifLatitude = loc.coordinate.latitude;
        CLLocationDegrees exifLongitude = loc.coordinate.longitude;
        CLLocationDistance exifAltitude = loc.altitude;
		
        [locDict setObject:@"2.2.0.0" forKey:(NSString *)kCGImagePropertyGPSVersion];
        [locDict setObject:loc.timestamp forKey:(NSString*)kCGImagePropertyGPSTimeStamp];
		
        if (exifLatitude < 0.0) {
			exifLatitude = exifLatitude*(-1);
			[locDict setObject:@"S" forKey:(NSString*)kCGImagePropertyGPSLatitudeRef];
        } else {
			[locDict setObject:@"N" forKey:(NSString*)kCGImagePropertyGPSLatitudeRef];
        }
        [locDict setObject:[NSNumber numberWithFloat:exifLatitude] forKey:(NSString*)kCGImagePropertyGPSLatitude];
		
        if (exifLongitude < 0.0) {
			exifLongitude=exifLongitude*(-1);
			[locDict setObject:@"W" forKey:(NSString*)kCGImagePropertyGPSLongitudeRef];
        } else {
			[locDict setObject:@"E" forKey:(NSString*)kCGImagePropertyGPSLongitudeRef];
        }
        [locDict setObject:[NSNumber numberWithFloat:exifLongitude] forKey:(NSString*) kCGImagePropertyGPSLongitude];
        
        if (!isnan(exifAltitude)){
            if (exifAltitude < 0) {
                exifAltitude = -exifAltitude;
                [locDict setObject:@"1" forKey:(NSString *)kCGImagePropertyGPSAltitudeRef];
            } else {
                [locDict setObject:@"0" forKey:(NSString *)kCGImagePropertyGPSAltitudeRef];
            }
            [locDict setObject:[NSNumber numberWithFloat:exifAltitude] forKey:(NSString *)kCGImagePropertyGPSAltitude];
        }
        
        // Speed, must be converted from m/s to km/h
        if (loc.speed >= 0){
            [locDict setObject:@"K" forKey:(NSString *)kCGImagePropertyGPSSpeedRef];
            [locDict setObject:[NSNumber numberWithFloat:loc.speed*3.6] forKey:(NSString *)kCGImagePropertyGPSSpeed];
        }
		
        // Heading
        if (loc.course >= 0){
            [locDict setObject:@"T" forKey:(NSString *)kCGImagePropertyGPSTrackRef];
            [locDict setObject:[NSNumber numberWithFloat:loc.course] forKey:(NSString *)kCGImagePropertyGPSTrack];
        }
    }
	
    return locDict;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	NSLog(@"GPS Error");
}

@end
