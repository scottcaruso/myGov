//
//  noAnimationSegue.m
//  myGov
//
//  Copyright (c) 2013 Scott Caruso. All rights reserved.
//

#import "noAnimationSegue.h"

@implementation noAnimationSegue

- (void) perform {
    UIViewController *src = (UIViewController *) self.sourceViewController;
    UIViewController *dst = (UIViewController *) self.destinationViewController;
    [UIView transitionWithView:src.navigationController.view duration:0.0
    options:UIViewAnimationOptionTransitionNone
    animations:^{
        [src.navigationController pushViewController:dst animated:NO];
                    }
                    completion:NULL];
}

@end
