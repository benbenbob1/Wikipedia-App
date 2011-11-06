//
//  ServerImageDetailViewController.m
//  Wikipedia Image Uploader
//
//  Created by Ben Brown on 11/5/11.
//  Copyright (c) 2011 Benbenbob Software. All rights reserved.
//

#import "ServerImageDetailViewController.h"

@implementation ServerImageDetailViewController

@synthesize wImg;

#pragma mark - View lifecycle

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
		
	}
    return self;
}

- (void)setWImg:(WikiImage *)aWImg {
	wImg = aWImg;
	[aWImg getMoreInfo];
	if (self.wImg.exifData && ![exifKeys count]) {
		NSLog(@"Got exif keys;");
		exifKeys = [NSArray arrayWithArray:[self.wImg.exifData allKeys]];
		gotExifStuff = YES;
	}
	else {
		NSLog(@"No exif keys (yet) :(");
		gotExifStuff = NO;
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		NSLog(@"getting header");
		UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 280, 280)];
		headerView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin;
		if (imgView == nil) {
			imgView = [[AsyncImageView alloc] initWithFrame:[headerView frame]];
			//imgView.frame = [headerView frame];
			[imgView loadImageFromURL:[NSURL URLWithString:self.wImg.actualURL]];
			imgView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin;
			imgView.contentMode = UIViewContentModeCenter;
			//NSLog(@"Trying to get img from %@", [[NSURL URLWithString:self.wImg.actualURL] absoluteString]);
		}
		[headerView addSubview:imgView];
		return headerView;
	}
	return [super tableView:tableView viewForHeaderInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return 300;
	}
	return 20;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.navigationItem.title = [self.wImg.title stringByReplacingOccurrencesOfString:PART_OF_FILENAME_TO_REMOVE withString:@""];
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

- (UIImage *)scaleAndRotateImage:(UIImage *)img {
	int kMaxResolution = 320; // Or whatever
	
    CGImageRef imgRef = img.CGImage;
	
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
	
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
	
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = img.imageOrientation;
    switch(orient) {
			
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
			
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
			
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
			
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
			
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
			
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
			
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
			
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
			
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
			
    }
	
    UIGraphicsBeginImageContext(bounds.size);
	
    CGContextRef context = UIGraphicsGetCurrentContext();
	
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
	
    CGContextConcatCTM(context, transform);
	
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	return imageCopy;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
	return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
	if (section == 0) {
		return 4;
	}
	if (section == 1) {
		return 1;
	}
	if (section == 2) {
		if (([[self.wImg.exifData allKeys] count]>0 && gotExifStuff)) {
			return [[self.wImg.exifData allKeys] count];
		}
		return 0;
	}
	if (section == 3) {
		return 2;
	}
	
	return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return @"Image";
	}
	if (section == 1) {
		return @"Comment";
	}
	if (section == 2) {
		if (([[self.wImg.exifData allKeys] count]>0 && gotExifStuff)) {
			return @"EXIF Data";
		}
	}
	return @"";
}

#pragma mark - Cell Customization

- (UITableViewCell *)createCellForIdentifier:(NSString *)idendtifier tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(UITableViewCellStyle)style selectable:(BOOL)selectable {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idendtifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:style reuseIdentifier:idendtifier];
		cell.selectionStyle = selectable?UITableViewCellSelectionStyleBlue:UITableViewCellSelectionStyleNone;
		SEL initCellSelector = NSSelectorFromString([NSString stringWithFormat:@"initCellFor%@:indexPath:", idendtifier]);
		if ([self respondsToSelector:initCellSelector]) {
			[self performSelector:initCellSelector withObject:cell withObject:indexPath];
		}
	}
	SEL customizeCellSelector = NSSelectorFromString([NSString stringWithFormat:@"customizeCellFor%@:indexPath:", idendtifier]);
	if ([self respondsToSelector:customizeCellSelector]) {
		[self performSelector:customizeCellSelector withObject:cell withObject:indexPath];
	}
	
	return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *identifier;
	BOOL selectable = NO;
	UITableViewCellStyle style = UITableViewCellStyleDefault;
	
	switch (indexPath.section) {
		case 0:
			style = UITableViewCellStyleValue1;
			switch (indexPath.row) {
				case 0:
					identifier = @"TitleCell";
					break;	
				case 1:
					identifier = @"SizeCell";
					break;
				case 2:
					identifier = @"DatePubCell";
					break;
				case 3:
					identifier = @"MediaTypeCell";
					break;
			}
			break;
		case 1:
			identifier = @"CommentCell";
			break;
		case 2:
			style = UITableViewCellStyleValue1;
			identifier = @"ExifCell";
			break;
		default:
			identifier = @"RegularCell";
			selectable = YES;
			break;
	}
	
    /*
	 static NSString *CellIdentifier = @"Cell";
	 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		if (indexPath.section == 0) {
			if (indexPath.row == 0) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
				cell.textLabel.text = @"Title";
				cell.detailTextLabel.text = [self.wImg.title stringByReplacingOccurrencesOfString:PART_OF_FILENAME_TO_REMOVE withString:@""];
			}
			else if (indexPath.row == 1) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
				cell.textLabel.text = @"Size";
				cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1fx%.1f", [self.wImg imgSize].width, [self.wImg imgSize].height];
			}
			else if (indexPath.row == 2) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
				cell.textLabel.text = @"Date Published";
				cell.detailTextLabel.text = self.wImg.pubDate;
			}
			else if (indexPath.row == 3) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
				cell.textLabel.text = @"Media Type";
				cell.detailTextLabel.text = self.wImg.mediaType;
			}
		}
		else if (indexPath.section == 1) {
			
			if (indexPath.row == 0) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
				[cell.textLabel setNumberOfLines:0];
				[cell.textLabel setLineBreakMode:UILineBreakModeWordWrap];
				//cell.textLabel.text = @"Comment";
				cell.textLabel.text = self.wImg.comment;
			}
		}
		else if (indexPath.section == 2) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
			if (exifKeys) {
				cell.textLabel.text = [exifKeys objectAtIndex:indexPath.row];
				cell.detailTextLabel.text = [self.wImg.exifData objectForKey:[exifKeys objectAtIndex:indexPath.row]];
			}
			else {
				cell.textLabel.text = [[self.wImg.exifData allKeys] objectAtIndex:indexPath.row];
				cell.detailTextLabel.text = [self.wImg.exifData objectForKey:[[self.wImg.exifData allKeys] objectAtIndex:indexPath.row]];
			}
		}
		else if (indexPath.section == 3) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
			if (indexPath.row == 0) {
				cell.textLabel.text = @"Use image in current article";
			}
			else if (indexPath.row == 1) {
				cell.textLabel.text = @"Use image in...";
			}
		}
		else if (indexPath.section == 4) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
			if (indexPath.row == 0) {
				cell.textLabel.text = @"Flag for deletion...";
			}
		}
    }*/
	
	
    
    // Configure the cell...
    
    return [self createCellForIdentifier:identifier tableView:tableView indexPath:indexPath style:style selectable:selectable];
}

- (void)initCellForTitleCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
	//[imgView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.wImg.actualURL]]]];
	//NSLog(@"Img set");
}
- (void)customizeCellForTitleCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
	cell.textLabel.text = @"Title";
	cell.detailTextLabel.text = [self.wImg.title stringByReplacingOccurrencesOfString:PART_OF_FILENAME_TO_REMOVE withString:@""];
}

- (void)initCellForSizeCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
	
}
- (void)customizeCellForSizeCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
	cell.textLabel.text = @"Size";
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1fx%.1f", [self.wImg imgSize].width, [self.wImg imgSize].height];
}

- (void)initCellForDatePubCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
	[cell.detailTextLabel setAdjustsFontSizeToFitWidth:YES];
}
- (void)customizeCellForDatePubCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
	cell.textLabel.text = @"Published";
	cell.detailTextLabel.text = self.wImg.pubDate;
	/*NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"us"]];
	[df setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss zzz"];
	[df setFormatterBehavior:NSDateFormatterBehaviorDefault];
	NSDate *date = [df dateFromString:self.wImg.pubDate];
	[df setDoesRelativeDateFormatting:YES];
	[df setDateFormat:@"zzz"];
	NSLog(@"Zone: %@", [df stringFromDate:date]);
	//[df setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
	[df setDateFormat:@"h:mm a EEEE, MMM d, yyyy zzz"];
	cell.detailTextLabel.text = [df stringFromDate:date];*/
}

- (void)initCellForMediaTypeCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
	
}
- (void)customizeCellForMediaTypeCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
	cell.textLabel.text = @"Media Type";
	cell.detailTextLabel.text = self.wImg.mediaType;
}

- (void)initCellForCommentCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
	[cell.textLabel setNumberOfLines:0];
	[cell.textLabel setLineBreakMode:UILineBreakModeWordWrap];
}
- (void)customizeCellForCommentCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
	cell.textLabel.text = self.wImg.comment;
}

- (void)initCellForExifCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
	if (!gotExifStuff) {
		NSLog(@"Trying for exif");
		if (self.wImg.exifData) {
			NSLog(@"Got exif keys;");
			exifKeys = [NSArray arrayWithArray:[self.wImg.exifData allKeys]];
			gotExifStuff = YES;
		}
		else {
			NSLog(@"No exif keys (yet) :(");
			gotExifStuff = NO;
		}
	}
}
- (void)customizeCellForExifCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
	if (exifKeys) {
		cell.textLabel.text = [exifKeys objectAtIndex:indexPath.row];
		cell.detailTextLabel.text = [self.wImg.exifData objectForKey:[exifKeys objectAtIndex:indexPath.row]];
	}
	else {
		cell.textLabel.text = [[self.wImg.exifData allKeys] objectAtIndex:indexPath.row];
		cell.detailTextLabel.text = [self.wImg.exifData objectForKey:[[self.wImg.exifData allKeys] objectAtIndex:indexPath.row]];
	}
}

- (void)initCellForRegularCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
}
- (void)customizeCellForRegularCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 3) {
		if (indexPath.row == 0) {
			cell.textLabel.text = @"Use image in current article";
		}
		else if (indexPath.row == 1) {
			cell.textLabel.text = @"Use image in other article";
		}
	}
	else if (indexPath.section == 4) {
		if (indexPath.row == 0) {
			cell.textLabel.text = @"Flag for deletion";
		}
	}
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 4) {
		//UIView *cellView = [cell contentView];
		CAGradientLayer *gradient = [CAGradientLayer layer];
		gradient.frame = cell.backgroundView.bounds;
		//gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor redColor] CGColor], (id)[[UIColor whiteColor] CGColor], nil];
		gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor redColor] CGColor], (id)[[UIColor whiteColor] CGColor], nil];
		[cell.backgroundView.layer insertSublayer:gradient atIndex:0];
		[cell.backgroundView.layer setMasksToBounds:YES];
		[cell.textLabel setBackgroundColor:[UIColor clearColor]];
		[cell.textLabel setTextColor:[UIColor whiteColor]];
		[cell.backgroundView.layer setCornerRadius:5.0f];
		//[[cell contentView].layer insertSublayer:gradient atIndex:0];
	}
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
    if (indexPath.section == 4) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Flag for Deletion" message:@"Enter the message" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
		UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(12, 45, 260, 25)];
		[textField setBackgroundColor:[UIColor whiteColor]];
		[textField setBorderStyle:UITextBorderStyleRoundedRect];
		[alert setAutoresizesSubviews:YES];
		[textField setPlaceholder:@"Enter the reason for deletion"];
		[textField becomeFirstResponder];
		[alert addSubview:textField];
		[alert show];
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	/*if ([settingsTable cellForRowAtIndexPath:indexPath]) {
	 NSString *cellText = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
	 UIFont *cellFont = [tableView cellForRowAtIndexPath:indexPath].textLabel.font;
	 CGSize constrainSize = CGSizeMake(280.0f, MAXFLOAT);
	 CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constrainSize lineBreakMode:UILineBreakModeWordWrap];
	 return labelSize.height+20;
	 }*/
	/*if (indexPath.section == 0 && indexPath.row == 0) {
		//CGRect appSize =  [(UIScreen *)[[UIScreen screens] objectAtIndex:0] applicationFrame];
		return self.wImg.imgSize.height;
	}*/
	if (indexPath.section == 1 && indexPath.row == 0) {
		CGRect appSize =  [(UIScreen *)[[UIScreen screens] objectAtIndex:0] applicationFrame];
		NSString *cellText = self.wImg.comment;
		UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:17.0];
		CGSize constrainSize = CGSizeMake(appSize.size.width*0.5, MAXFLOAT);
		CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constrainSize lineBreakMode:UILineBreakModeWordWrap];
		return labelSize.height+10;
	}
	return 50;
}

@end
