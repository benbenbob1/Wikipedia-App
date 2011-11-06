//
//  WikiImage.m
//  Wikipedia Image Uploader
//
//  Created by Ben Brown on 11/3/11.
//  Copyright (c) 2011 Benbenbob Software. All rights reserved.
//

#import "WikiImage.h"

@implementation WikiImage

@synthesize desc, imgURL, title, thumbImg, pubDate, comment, actualURL, imgSize, exifData, mediaType;

/*- (void)setImgURL:(NSString *)anImgURL {
	imgURL = anImgURL;
	NSURL *url = [NSURL URLWithString:anImgURL];
	NSString *str = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:NULL];
	NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
	[parser setDelegate:self];
	[parser parse];
	NSLog(@"Starting to parse %@", str);
}*/

- (NSString *)description {
	return [NSString stringWithFormat:@"%@ - %@", self.title, self.desc];
}

/*- (void)setTitle:(NSString *)aTitle {
	
}*/

- (void)getMoreInfo {
	if (self.title) {
		NSString *str = [[[NSString stringWithFormat:@"%@?format=xml&action=query&titles=%@&prop=imageinfo&iiprop=url|size|metadata|mediatype|comment", API_URL, self.title] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"|" withString:@"%7c"];
		NSURL *url = [NSURL URLWithString:str];
		NSString *strParse = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:NULL];
		NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
		[parser setDelegate:self];
		[parser parse];
		//NSLog(@"Starting to parse %@", strParse);
	}
}

#pragma mark - XML Parser

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	if ([elementName isEqualToString:@"imageinfo"]) {
		//result = [[WikiImage alloc] init];
	}
	if ([elementName isEqualToString:@"ii"]) {
		[self setComment:[attributeDict objectForKey:@"comment"]];
		[self setImgSize:CGSizeMake([[attributeDict objectForKey:@"width"] floatValue], [[attributeDict objectForKey:@"height"] floatValue])];
		[self setMediaType:[attributeDict objectForKey:@"mediatype"]];
		[self setActualURL:[attributeDict objectForKey:@"url"]];
		[self setExifData:[[attributeDict objectForKey:@"metadata"] dictionaryRepresentation]];
	}
	//NSLog(@"Attributes for %@: %@", elementName, attributeDict);
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if (!currentElementValue) {
		currentElementValue = [[NSMutableString alloc] initWithString:string];
	}
	else {
		[currentElementValue appendString:string];
	}
	NSLog(@"Found characters: %@", string);
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if ([elementName isEqualToString:@"imageinfo"]) {
		//[self.tableView reloadData];
		NSLog(@"Done! com: %@, size: %@, etc.", self.comment, NSStringFromCGSize(self.imgSize));
		return;
	}
	/*else if ([elementName isEqualToString:@"ii"]) {
		[result setTitle:[currentElementValue stringByReplacingOccurrencesOfString:@"File:" withString:@""]];
	}
	else if ([elementName isEqualToString:@"description"]) {
		[result setDesc:currentElementValue];
	}
	else if ([elementName isEqualToString:@"pubDate"]) {
		[result setPubDate:currentElementValue];
	}*/
	currentElementValue = nil;
}

@end
