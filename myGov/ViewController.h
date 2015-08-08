//
//  ViewController.h
//  myGov
//
//  Copyright (c) 2013 Scott Caruso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

//Creating a comment and checking in just to test Git upload

@interface ViewController : UIViewController <UIAlertViewDelegate,CLLocationManagerDelegate>
{
    IBOutlet UIButton *zipCodeSearch;
    IBOutlet UIButton *geoSearch;
    float latitude;
    float longitude;
    NSString *typeOfQuery;
    NSString *enteredZip;
}
@property (strong,nonatomic) CLLocationManager *locationManager;

-(IBAction)zipCodeClick:(id)sender;

@end
