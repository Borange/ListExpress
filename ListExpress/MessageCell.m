//
//  MessageCell.m
//  ListExpress
//
//  Created by Per Borin on 2013-07-01.
//  Copyright (c) 2013 Per Borin. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width, 100)];
        [self addSubview:_webView];
        _webView.delegate = self;
        [_webView loadHTMLString:@"hello <b>this</b> is a text http://www.dn.se this is a link inside a webview" baseURL:nil];
        
    }
    return self;
}

- (void)updateLinkText:(NSString *)linkText{
    NSString *link = [NSString stringWithFormat:@"%@ -- %@", linkText, @"yes http://www.dn.se this is a link inside a webview"];
    
    link = [self cleanHTMLText:link];
    
    
    [_webView loadHTMLString:link baseURL:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    
    return YES;
}

- (NSString *)cleanHTMLText:(NSString *)htmlText{
    NSMutableString *theText = [NSMutableString stringWithString:htmlText];
    
    NSError *error = NULL;
    NSRegularExpression *detector = [NSRegularExpression regularExpressionWithPattern:[self linkRegex] options:0 error:&error];
    NSArray *links = [detector matchesInString:theText options:0 range:NSMakeRange(0, theText.length)];
    NSMutableArray *current = [NSMutableArray arrayWithArray:links];
    
    for ( int i = 0; i < [links count]; i++ ) {
        NSTextCheckingResult *cr = [current objectAtIndex:0];
        NSString *url = [theText substringWithRange:cr.range];
        
        [theText replaceOccurrencesOfString:url
                                 withString:[NSString stringWithFormat:@"<a href=\"%@\">%@</a>", url, url]
                                    options:NSLiteralSearch
                                      range:NSMakeRange(0, theText.length)];
        
        current = [NSMutableArray arrayWithArray:[detector matchesInString:theText options:0 range:NSMakeRange(0, theText.length)]];
        [current removeObjectsInRange:NSMakeRange(0, ( (i+1) * 2 ))];
    }
    
    [theText replaceOccurrencesOfString:@"\n" withString:@"<br />" options:NSLiteralSearch range:NSMakeRange(0, theText.length)];
    
    return theText;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
}

#pragma mark -
#pragma mark Regex

- (NSString *)linkRegex
{
    return @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
}

@end
