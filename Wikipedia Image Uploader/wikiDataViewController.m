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

#define iPHONE_PORTRAIT_KEYBOARD_HEIGHT 215
#define iPAD_PORTRAIT_KEYBOARD_HEIGHT 260
#define PORTRAIT_KEYBOARD_HEIGHT ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone?iPHONE_PORTRAIT_KEYBOARD_HEIGHT:iPAD_PORTRAIT_KEYBOARD_HEIGHT)


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
	
	searchResultsTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
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
	shouldIgnoreAction = YES;
	[self webViewLoadURL:[NSURL URLWithString:@"http://en.m.wikipedia.org"]];
	/*
	UIMenuItem *openInSafariItem = [[UIMenuItem alloc] initWithTitle:@"Open in Safari" action:@selector(openInSafari:)];
	UIMenuItem *saveImageItem = [[UIMenuItem alloc] initWithTitle:@"Save" action:@selector(saveImage:)];
	[[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:openInSafariItem, saveImageItem, nil]];*/
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
}

- (IBAction)moreButtonPressed:(id)sender {
	[bottomFullBar setHidden:NO];
	//[bottomLeftNavBar setAlpha:0.0f];
	CGRect appSize =  [(UIScreen *)[[UIScreen screens] objectAtIndex:0] applicationFrame];
	[UIView animateWithDuration:0.25 animations:^(void){
		[searchBar setFrame:CGRectMake(-[searchBar frame].size.width, [searchBar frame].origin.y, [searchBar frame].size.width, [searchBar frame].size.height)];
		[bottomNavBar setFrame:CGRectMake(appSize.size.width, [bottomNavBar frame].origin.y, [bottomNavBar frame].size.width, [bottomNavBar frame].size.height)];
		//[bottomLeftNavBar setAlpha:1.0f];
	}];
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
		[[self undoManager] beginUndoGrouping];
		[[self undoManager] registerUndoWithTarget:webView selector:@selector(loadRequest:) object:[aWebView request]];
		[[self undoManager] setActionName:[NSString stringWithFormat:@"Action: %@", [[aWebView request].URL absoluteString]]];
		[[self undoManager] endUndoGrouping];
		NSLog(@"Registered request of %@", [aWebView request].URL);
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
	if (didConvertURL) {
		didConvertURL = NO;
		return YES;
	}
	if ([[[request URL] absoluteString] rangeOfString:@".wiki"].location != NSNotFound) {
		//NSLog(@"The link is on wiki");
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
				return YES;
			}
			//[webView loadHTMLString:[self convertMobilePageFromURL:[NSURL URLWithString:[[[request URL] absoluteString] stringByReplacingOccurrencesOfString:@"m.wiki" withString:@"wiki"]]] baseURL:[NSURL URLWithString:@"http://en.wikipedia.org"]];
			[self convertPageAndGo:[NSURL URLWithString:[[[request URL] absoluteString] stringByReplacingOccurrencesOfString:@"m.wiki" withString:@"wiki"]]];
			didConvertURL = YES;
			return NO;
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
	[self showSearchResults];
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
	[UIView animateWithDuration:0.25 animations:^(void){
		[searchBar setCenter:CGPointMake([searchBar center].x, [searchBar center].y-PORTRAIT_KEYBOARD_HEIGHT)];
		[bottomNavBar setCenter:CGPointMake([bottomNavBar center].x, [bottomNavBar center].y-PORTRAIT_KEYBOARD_HEIGHT)];
	}];
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

@end
