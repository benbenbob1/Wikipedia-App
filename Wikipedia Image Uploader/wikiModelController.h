//
//  wikiModelController.h
//  Wikipedia Image Uploader
//
//  Created by Ben Brown on 10/28/11.
//  Copyright (c) 2011 Benbenbob Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@class wikiDataViewController;

@interface wikiModelController : NSObject <UIPageViewControllerDataSource>
- (wikiDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(wikiDataViewController *)viewController;
@end
