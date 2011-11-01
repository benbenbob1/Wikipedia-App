//
//  SearchResult.m
//  Wikipedia Image Uploader
//
//  Created by Ben Brown on 10/30/11.
//  Copyright (c) 2011 Benbenbob Software. All rights reserved.
//

#import "SearchResult.h"

@implementation SearchResult

@synthesize resultLink, resultTitle;

- (NSString *)description {
	return [NSString stringWithFormat:@"%@ (%@)", resultTitle, resultLink];
}


@end
