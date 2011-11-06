//
//  WikiImage.h
//  Wikipedia Image Uploader
//
//  Created by Ben Brown on 11/3/11.
//  Copyright (c) 2011 Benbenbob Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Configuration.h"

@interface WikiImage : NSObject <NSXMLParserDelegate> {
	NSMutableArray *resultsArr;
	//NSString *result;
	NSMutableString *currentElementValue;
}

- (void)getMoreInfo;

@property (strong, nonatomic) UIImage *thumbImg;
@property (strong, nonatomic) NSString *title, *desc, *imgURL;
@property (strong, nonatomic) NSString *pubDate, *comment, *actualURL, *mediaType;
@property (strong, nonatomic) NSDictionary *exifData;
@property (nonatomic) CGSize imgSize;

@end
