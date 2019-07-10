//
//  CustomWebView.h
//  FlashCardDB
//
//  Created by Friends on 1/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface CustomWebView :  WKWebView  <WKNavigationDelegate>
{
    UIActivityIndicatorView* act;
    NSString* searchText;
    WKWebViewConfiguration* configuration;
}

@property (nonatomic,retain) NSString* searchText;

///- (void)loadHTMLString:(NSString *)str;

- (void)loadClearBgHTMLString:(NSString *)str;
- (NSInteger)highlightAllOccurencesOfString:(NSString*)str;
- (void)removeAllHighlights;

@end
