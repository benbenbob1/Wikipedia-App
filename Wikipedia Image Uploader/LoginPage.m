//
//  LoginPage.m
//  Wikipedia Image Uploader
//
//  Created by Ben Brown on 11/1/11.
//  Copyright (c) 2011 Benbenbob Software. All rights reserved.
//

#import "LoginPage.h"


@implementation LoginPage

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		[cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
		cell.accessoryType = UITableViewCellAccessoryNone;
		if (indexPath.section == 0) {
			if ([[NSUserDefaults standardUserDefaults] boolForKey:LOGIN_GOOD_KEY]) {
				[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
			}
			[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
			UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, cell.contentView.frame.size.width-140, 25)];
			[textField setAdjustsFontSizeToFitWidth:YES];
			[textField setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin];
			[textField setAutocorrectionType:UITextAutocorrectionTypeNo];
			[cell setAccessoryView:textField];
			if (indexPath.row == 0) {
				cell.textLabel.text = @"Username:";
				[textField setPlaceholder:@"Required"];
				[textField setText:[[NSUserDefaults standardUserDefaults] stringForKey:USERNAME_KEY]];
				[textField setKeyboardType:UIKeyboardTypeEmailAddress];
				[textField setReturnKeyType:UIReturnKeyNext];
				[textField addTarget:self action:@selector(selectNext) forControlEvents:UIControlEventEditingDidEndOnExit];
				[textField setSecureTextEntry:NO];
			}
			else if (indexPath.row == 1) {
				cell.textLabel.text = @"Password:";
				[textField setPlaceholder:@"Required"];
				NSError *error = nil;
				[textField setText:[SFHFKeychainUtils getPasswordForUsername:[[NSUserDefaults standardUserDefaults] stringForKey:USERNAME_KEY] andServiceName:KEYCHAIN_KEY error:&error]];
				if (error) {
					NSLog(@"Error loading password: %@", [error localizedDescription]);
				}
				[textField setKeyboardType:UIKeyboardTypeAlphabet];
				[textField setReturnKeyType:UIReturnKeyDone];
				[textField addTarget:self action:@selector(resignResponder:) forControlEvents:UIControlEventEditingDidEndOnExit];
				[textField setSecureTextEntry:YES];
			}
		}
		else if (indexPath.section == 1) {
			if (indexPath.row == 0) {
				cell.textLabel.text = @"Login";
			}
			else if (indexPath.row == 1) {
				cell.textLabel.text = @"Cancel";
			}
		}
    }
	/*[cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
	cell.accessoryType = UITableViewCellAccessoryNone;
	if (indexPath.section == 0) {
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 20, cell.contentView.frame.size.width-140, 25)];
		[textField setAdjustsFontSizeToFitWidth:YES];
		[textField setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin];
		[textField setAutocorrectionType:UITextAutocorrectionTypeNo];
		[cell setAccessoryView:textField];
		if (indexPath.row == 0) {
			cell.textLabel.text = @"Username:";
			[textField setPlaceholder:@"example@email.com"];
			[textField setKeyboardType:UIKeyboardTypeEmailAddress];
			[textField setSecureTextEntry:NO];
		}
		else if (indexPath.row == 1) {
			cell.textLabel.text = @"Password:";
			[textField setPlaceholder:@"Required"];
			[textField setKeyboardType:UIKeyboardTypeAlphabet];
			[textField setSecureTextEntry:NO];
		}
	}
	else if (indexPath.section == 1) {
		if (indexPath.row == 0) {
			cell.textLabel.text = @"Login";
		}
		else if (indexPath.row == 1) {
			cell.textLabel.text = @"Cancel";
		}
	}*/
    
    // Configure the cell...
    
    return cell;
}

- (void)selectNext {
	//[self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
	if (cell.accessoryView.class == [UITextField class]) {
		[(UITextField *)cell.accessoryView becomeFirstResponder];
	}
}

- (void)resignResponder:(id)sender {
	[sender resignFirstResponder];
}

- (void)login {
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	UITextField *usernameField = (UITextField *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].accessoryView;
	UITextField *passwordField = (UITextField *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]].accessoryView;

	NSError *error = nil;
	NSString *oldUsername = [defs valueForKey:USERNAME_KEY];
	if ([usernameField.text compare:oldUsername] != NSOrderedSame) {
		[SFHFKeychainUtils deleteItemForUsername:oldUsername andServiceName:KEYCHAIN_KEY error:&error];
		if (error) {
			NSLog(@"Error in password deletion: %@", [error localizedDescription]);
			error = nil;
		}
	}
	
	[defs setObject:usernameField.text forKey:USERNAME_KEY];
	[SFHFKeychainUtils storeUsername:usernameField.text andPassword:passwordField.text forServiceName:KEYCHAIN_KEY updateExisting:YES error:&error];
	if (error) {
		NSLog(@"Error storing password: %@", [error localizedDescription]);
	}
	[defs synchronize];
	[self tryLoginUsingUName:usernameField.text andPass:passwordField.text];
	//[self.presentingViewController dismissModalViewControllerAnimated:YES];
}

- (void)tryLoginUsingUName:(NSString *)uName andPass:(NSString *)pass {
	//NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?action=login&lgname=%@&lgpassword=%@", API_URL, uName, pass]];
	//NSLog(@"URL: %@", url.absoluteString);
	//NSString *str = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:NULL];
	//NSLog(@"Login Str: %@", str);
	NSURL *url = [NSURL URLWithString:API_URL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setPostFormat:ASIURLEncodedPostFormat];
	[request addPostValue:@"login" forKey:@"action"];
	[request addPostValue:@"xml" forKey:@"format"];
	[request addPostValue:uName forKey:@"lgname"];
	[request addPostValue:pass forKey:@"lgpassword"];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(requestTokenFinished:)];
	[request setDidFailSelector:@selector(requestTokenFailed:)];
	[request startAsynchronous];
}

- (void)requestTokenFinished:(ASIHTTPRequest *)request {
	NSDictionary *dict = [XMLReader dictionaryForXMLData:[request responseData] error:NULL];
	NSLog(@"Dict: %@", dict);
	NSDictionary *login = [[dict objectForKey:@"api"] objectForKey: @"login"];
    assert( login != nil );
	
    if( [[login objectForKey:@"result"] caseInsensitiveCompare:@"NeedToken"] != NSOrderedSame ) {
		NSLog(@"not NeedToken");
		return;
    }
    
    token = [login objectForKey:@"token"];
    assert( token != nil );
    
    //New request
    NSURL *url = [NSURL URLWithString:API_URL];
    ASIFormDataRequest *newRequest = [ASIFormDataRequest requestWithURL:url];
    [newRequest setPostFormat:ASIURLEncodedPostFormat];
    
    [newRequest addPostValue:@"login" forKey:@"action"];
    [newRequest addPostValue:@"xml" forKey: @"format"];
    [newRequest addPostValue:token forKey:@"lgtoken"];
    NSString *username = [[NSUserDefaults standardUserDefaults] valueForKey:USERNAME_KEY];
    [newRequest addPostValue:username forKey: @"lgname"];
	
    NSString *password = [SFHFKeychainUtils getPasswordForUsername:username andServiceName:KEYCHAIN_KEY error:NULL];
    [newRequest addPostValue:password forKey: @"lgpassword"];
    
    [newRequest setDelegate:self];
    [newRequest setDidFinishSelector:@selector(requestLoginFinished:)];
    [newRequest setDidFailSelector:@selector(requestLoginFailed:)];
    [newRequest startAsynchronous];
}

- (void)requestTokenFailed:(ASIHTTPRequest *)request {
	NSLog(@"First post failed: %@", [[request error] localizedDescription]);
}

- (void)requestLoginFinished:(ASIHTTPRequest *)request
{
    NSError *error = nil;
    NSDictionary *dict = [XMLReader dictionaryForXMLData: [request responseData] error: &error];
	//NSLog(@"Dict received: %@", dict);
    if( error ) {
        /* XML parser error */
        NSLog(@"Upload failed: %@", [error localizedDescription]);
        return;
    }
	
    NSDictionary *login = [[dict objectForKey:@"api"] objectForKey: @"login"];
    assert( login != nil );
	
    if( [[login objectForKey:@"result"] caseInsensitiveCompare:@"Success"] != NSOrderedSame ) {
		if ([[login objectForKey:@"result"] caseInsensitiveCompare:@"NotExists"] == NSOrderedSame) {
			NSLog(@"The username/password combination does not exist.");
			[self reportError:@"The username/password combination does not exist."];
		}
		NSLog(@"no success response: %@", [login objectForKey:@"result"]);
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:LOGIN_GOOD_KEY];
		return;
    }
    
    NSLog(@"Success!");
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:LOGIN_GOOD_KEY];
	[self.tableView reloadData];
	[self.presentingViewController dismissModalViewControllerAnimated:YES];
}

- (void)requestLoginFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Login failed: %@", [[request error] localizedDescription]);
}

- (void)reportError:(NSString *)errorString {
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([[[tableView cellForRowAtIndexPath:indexPath] accessoryView] class] == [UITextField class]) {
		NSLog(@"Text field");
		[(UITextField *)[[tableView cellForRowAtIndexPath:indexPath] accessoryView] becomeFirstResponder];
	}
	else if (indexPath.section == 1) {
		[tableView deselectRowAtIndexPath:indexPath animated:NO];
		if (indexPath.row == 0) {
			[self login];
		}
		else if (indexPath.row == 1) {
			[self.presentingViewController dismissModalViewControllerAnimated:YES];
		}
	}
}

@end
