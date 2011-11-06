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
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
	if (section == 0) {
		return 5;
	}
	if (section == 1) {
		return 1;
	}
	if (section == 2) {
		return [[self.wImg.exifData allKeys] count];
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return @"Image";
	}
	if (section == 1) {
		return @"Comment";
	}
	if (section == 2) {
		return @"EXIF Data";
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		if (indexPath.section == 0) {
			if (indexPath.row == 0) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
				cell.imageView.image = [self scaleAndRotateImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.wImg.actualURL]]]];
				[cell.imageView setContentMode:UIViewContentModeCenter];
				[cell.imageView setAutoresizesSubviews:YES];
				[cell.imageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
				//cell.detailTextLabel.text = [self.wImg.title stringByReplacingOccurrencesOfString:PART_OF_FILENAME_TO_REMOVE withString:@""];
			}
			else if (indexPath.row == 1) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
				cell.textLabel.text = @"Title";
				cell.detailTextLabel.text = [self.wImg.title stringByReplacingOccurrencesOfString:PART_OF_FILENAME_TO_REMOVE withString:@""];
			}
			else if (indexPath.row == 2) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
				cell.textLabel.text = @"Size";
				cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1fx%.1f", [self.wImg imgSize].width, [self.wImg imgSize].height];
			}
			else if (indexPath.row == 3) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
				cell.textLabel.text = @"Date Published";
				cell.detailTextLabel.text = self.wImg.pubDate;
			}
			else if (indexPath.row == 4) {
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
			[cell.detailTextLabel setNumberOfLines:0];
			[cell.detailTextLabel setLineBreakMode:UILineBreakModeWordWrap];
			cell.textLabel.text = [[self.wImg.exifData allKeys] objectAtIndex:indexPath.row];
			cell.detailTextLabel.text = [self.wImg.exifData objectForKey:[[self.wImg.exifData allKeys] objectAtIndex:indexPath.row]];
		}
    }
	
	[cell.detailTextLabel setAdjustsFontSizeToFitWidth:YES];
    
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	/*if ([settingsTable cellForRowAtIndexPath:indexPath]) {
	 NSString *cellText = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
	 UIFont *cellFont = [tableView cellForRowAtIndexPath:indexPath].textLabel.font;
	 CGSize constrainSize = CGSizeMake(280.0f, MAXFLOAT);
	 CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constrainSize lineBreakMode:UILineBreakModeWordWrap];
	 return labelSize.height+20;
	 }*/
	if (indexPath.section == 0 && indexPath.row == 0) {
		//CGRect appSize =  [(UIScreen *)[[UIScreen screens] objectAtIndex:0] applicationFrame];
		return self.wImg.imgSize.height;
	}
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
