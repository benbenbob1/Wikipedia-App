//
//  ServerImageDetailViewController.h
//  Wikipedia Image Uploader
//
//  Created by Ben Brown on 11/5/11.
//  Copyright (c) 2011 Benbenbob Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WikiImage.h"
#import "Configuration.h"
#import "AsyncImageView.h"
#import <QuartzCore/QuartzCore.h>

@interface ServerImageDetailViewController : UITableViewController <UIAlertViewDelegate> {
	NSArray *exifKeys;
	AsyncImageView *imgView;
	BOOL gotExifStuff;
}

- (UIImage *)scaleAndRotateImage:(UIImage *)img;
- (UITableViewCell *)createCellForIdentifier:(NSString *)idendtifier tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(UITableViewCellStyle)style selectable:(BOOL)selectable;


- (void)initCellForTitleCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;
- (void)customizeCellForTitleCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;

- (void)initCellForSizeCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;
- (void)customizeCellForSizeCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;

- (void)initCellForDatePubCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;
- (void)customizeCellForDatePubCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;

- (void)initCellForMediaTypeCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;
- (void)customizeCellForMediaTypeCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;

- (void)initCellForCommentCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;
- (void)customizeCellForCommentCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;

- (void)initCellForExifCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;
- (void)customizeCellForExifCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;

- (void)initCellForRegularCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;
- (void)customizeCellForRegularCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;

/*
 - (void)initCellForUseInArticle2Cell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;
 - (void)customizeCellForUseInArticle2Cell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;
 
 - (void)initCellForDeleteCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;
 - (void)customizeCellForDeleteCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;
*/

@property (strong, nonatomic) WikiImage *wImg;

@end
