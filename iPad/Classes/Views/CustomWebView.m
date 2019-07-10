//
//  CustomWebView.m
//  FlashCardDB
//
//  Created by Friends on 1/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomWebView.h"
#import "Utils.h"


@implementation CustomWebView

@synthesize searchText;


- (void)loadClearBgHTMLString:(NSString *)str 
{
	self.opaque = NO;
    self.configuration.dataDetectorTypes = UIDataDetectorTypeNone;
    self.configuration.allowsInlineMediaPlayback = YES;
	self.backgroundColor = [UIColor clearColor];
	NSRange range = [str rangeOfString:@"<html"];
	
	if (range.length > 0) 
	{
		[self loadHTMLString:[NSString stringWithFormat:@"<html><body bgcolor = transparent><font face=\"Arial\"><font size=\"4\">%@</font></html>", str] baseURL:nil];
	}
	
	else
	{
		
		NSString* fName = [[NSBundle mainBundle] pathForResource:[Utils getFileName:str] ofType:nil inDirectory:nil];
		
		//NSString* str = [[NSBundle mainBundle] pathForResource:@"front" ofType:@"html"];
		BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fName];
		if (fileExists == YES) {
			
		
			NSURL* url = [[NSURL alloc] initFileURLWithPath:fName];
			NSURLRequest* req = [[[NSURLRequest alloc] initWithURL:url] autorelease];
			
			//NSLog(@"%@, %@", str, fName);
			
			[self loadRequest:req];
			self.navigationDelegate = self;
		}
		else {
			[self loadHTMLString:[NSString stringWithFormat:@"<html><body bgcolor = transparent><font face=\"Arial\"><font size=\"40\">%@</font></html>",str] baseURL:nil];
		}

	}
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [act stopAnimating];

    if (searchText!=nil && [searchText length] > 0) {
        [self highlightAllOccurencesOfString:searchText];
    }
}

- (NSInteger)highlightAllOccurencesOfString:(NSString*)str
{
	NSString* jsCode=[Utils getJSCode];
    [self stringByEvaluatingJavaScriptFromString:jsCode];
	
    NSString *startSearch = [NSString stringWithFormat:@"FC_HighlightAllOccurencesOfString('%@')",str];
    [self stringByEvaluatingJavaScriptFromString:startSearch];
	
    NSString *result = [self stringByEvaluatingJavaScriptFromString:@"FC_SearchResultCount"];
    NSLog(@"Match Found ....%@",result);
	return 0;
	
}

- (void)removeAllHighlights
{
    [self stringByEvaluatingJavaScriptFromString:@"FC_RemoveAllHighlights()"];
}



- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [act stopAnimating];
}

@end
