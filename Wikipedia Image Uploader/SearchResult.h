//
//  SearchResult.h
//  Wikipedia Image Uploader
//
//  Created by Ben Brown on 10/30/11.
//  Copyright (c) 2011 Benbenbob Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchResult : NSObject {
	NSString *resultTitle, *resultLink;
}

@property (nonatomic, retain) NSString *resultTitle, *resultLink;

@end
