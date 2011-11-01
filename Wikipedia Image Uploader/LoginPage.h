//
//  LoginPage.h
//  Wikipedia Image Uploader
//
//  Created by Ben Brown on 11/1/11.
//  Copyright (c) 2011 Benbenbob Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFHFKeychainUtils.h"
#import "Configuration.h"
#import "ASIFormDataRequest.h"
#import "XMLReader.h"

@interface LoginPage : UITableViewController <UIAlertViewDelegate> {
	NSString *token;
}

- (void)selectNext;
- (void)resignResponder:(id)sender;
- (void)login;
- (void)tryLoginUsingUName:(NSString *)uName andPass:(NSString *)pass;
- (void)requestTokenFinished:(ASIHTTPRequest *)request;
- (void)requestTokenFailed:(ASIHTTPRequest *)request;

- (void)requestLoginFinished:(ASIHTTPRequest *)request;
- (void)requestLoginFailed:(ASIHTTPRequest *)request;

- (void)reportError:(NSString *)errorString;

@end
