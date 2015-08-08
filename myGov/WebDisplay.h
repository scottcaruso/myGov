//
//  WebDisplay.h
//  myGov
//
//  Created by Scott Caruso on 6/20/13.
//  Copyright (c) 2013 Scott Caruso. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebDisplay : UIViewController
{
    IBOutlet UIWebView *webview;
}

@property (nonatomic) NSString *contactURL;

@end
