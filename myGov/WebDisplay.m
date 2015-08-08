//
//  WebDisplay.m
//  myGov
//
//  Created by Scott Caruso on 6/20/13.
//  Copyright (c) 2013 Scott Caruso. All rights reserved.
//

#import "WebDisplay.h"

@interface WebDisplay ()

@end

@implementation WebDisplay
@synthesize contactURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:contactURL]]];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
