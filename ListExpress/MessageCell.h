//
//  MessageCell.h
//  ListExpress
//
//  Created by Per Borin on 2013-07-01.
//  Copyright (c) 2013 Per Borin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell <UIWebViewDelegate>{
    UIWebView *_webView;
}

- (void)updateLinkText:(NSString *)linkText;

@end
