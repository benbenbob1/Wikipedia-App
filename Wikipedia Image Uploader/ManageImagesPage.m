//
//  ManageImagesPage.m
//  Wikipedia Image Uploader
//
//  Created by Ben Brown on 11/3/11.
//  Copyright (c) 2011 Benbenbob Software. All rights reserved.
//

#import "ManageImagesPage.h"

@implementation ManageImagesPage

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
		if (!df) {
			df = [[NSDateFormatter alloc] init];
			[df setLenient:YES];
			[df setFormatterBehavior:NSDateFormatterMediumStyle];
		}
        imagesArr = [[NSMutableArray alloc] init];
		[self loadImages];
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
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonAction)];
	self.navigationItem.leftBarButtonItem = doneButton;
}

- (void)doneButtonAction {
	[self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
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

- (void)loadImages {
	//commons.wikimedia.org/w/api.php?action=feedcontributions&user=Benbenbob1&format=xml
	if (![[NSUserDefaults standardUserDefaults] stringForKey:USERNAME_KEY]) {
		LoginPage *loginPage = [[LoginPage alloc] init];
		[self.navigationController pushViewController:loginPage animated:YES];
		return;
	}
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://commons.wikimedia.org/w/api.php?action=feedcontributions&user=%@&format=xml", [[NSUserDefaults standardUserDefaults] stringForKey:USERNAME_KEY]]];
	NSString *str = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:NULL];
	NSLog(@"str: %@", str);
	NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
	[xmlParser setDelegate:self];
	[xmlParser parse];
	//NSLog(@"Dict: %@", dict);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return UIInterfaceOrientationIsPortrait(interfaceOrientation);
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [imagesArr count]>0?[imagesArr count]:1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil && [imagesArr count]>0) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		UIImage *img = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[(WikiImage *)[imagesArr objectAtIndex:indexPath.row] imgURL]]]];
		[cell.imageView setImage:img];
		cell.textLabel.text = [[(WikiImage *)[imagesArr objectAtIndex:indexPath.row] title] stringByReplacingOccurrencesOfString:PART_OF_FILENAME_TO_REMOVE withString:@""];
		//cell.detailTextLabel.text = [(WikiImage *)[imagesArr objectAtIndex:indexPath.row] desc];
		//cell.detailTextLabel.text = [df stringFromDate:(NSDate *)[(WikiImage *)[imagesArr objectAtIndex:indexPath.row] pubDate]];
		cell.detailTextLabel.text = [(WikiImage *)[imagesArr objectAtIndex:indexPath.row] pubDate];
    }
	else if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		cell.textLabel.text = @"You have not uploaded any images yet";
		[cell.textLabel setAdjustsFontSizeToFitWidth:YES];
	}
    
    // Configure the cell...
    
    return cell;
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
	if ([imagesArr count]>0) {
		WikiImage *curWikiImage = [imagesArr objectAtIndex:indexPath.row];
		if (curWikiImage.imgURL) {
			ServerImageDetailViewController *sIDVC = [[ServerImageDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
			[sIDVC setWImg:curWikiImage];
			[self.navigationController pushViewController:sIDVC animated:YES];
		}
	}
}

#pragma mark - XML Parser

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	if ([elementName isEqualToString:@"item"]) {
		result = [[WikiImage alloc] init];
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
	if ([elementName isEqualToString:@"version"]) {
		[self.tableView reloadData];
		NSLog(@"Results: %@", imagesArr);
		return;
	}
	
	if ([elementName isEqualToString:@"item"] && result != nil) {
		[imagesArr addObject:result];
		result = nil;
	}
	else {
		if ([elementName isEqualToString:@"link"]) {
			[result setImgURL:currentElementValue];
		}
		else if ([elementName isEqualToString:@"title"]) {
			[result setTitle:[currentElementValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
		}
		else if ([elementName isEqualToString:@"description"]) {
			[result setDesc:currentElementValue];
		}
		else if ([elementName isEqualToString:@"pubDate"]) {
			/*NSDate *pubDate = [df dateFromString:currentElementValue];
			NSLog(@"Date found: %@", [df stringFromDate:pubDate]);
			[result setPubDate:pubDate];*/
			[result setPubDate:currentElementValue];
		}
	}
	currentElementValue = nil;
}

@end
