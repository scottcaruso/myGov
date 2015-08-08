//
//  ViewController.m
//  myGov
//
//

#import "ViewController.h"
#import "ResultsView.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    typeOfQuery = @"geolocation";
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    /*sleep(3.5);
    UIImageView *splashScreen = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"myGovbackground.png"]];
    [self.view addSubview:splashScreen];

    [UIView animateWithDuration:.3 animations:^{splashScreen.alpha = 0.0;}
                     completion:(void (^)(BOOL)) ^{
                         [splashScreen removeFromSuperview];
                     }
     ];*/
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    
    // Code to check if the app can respond to the new selector found in iOS 8. If so, request it.
    if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
    if (authStatus == kCLAuthorizationStatusAuthorizedWhenInUse || authStatus == kCLAuthorizationStatusAuthorizedAlways)
    {
        [self.locationManager startUpdatingLocation];
    } else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Not Enabled" message:@"Location services are disabled, so Geolocation is unavailable at this time." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.alertViewStyle = UIAlertViewStyleDefault;
        geoSearch.enabled = false;
        [alert show];
    }

    [self.locationManager startUpdatingLocation];
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *lastLocation = [locations lastObject];
    longitude = lastLocation.coordinate.longitude;
    latitude = lastLocation.coordinate.latitude;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)zipCodeClick:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Zip Code Entry" message:@"Please enter a 5-digit zip code to search for." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Search",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    int zipIsValid = 0;
    if (buttonIndex == 1)
    {
        UITextField *thisTextField = [alertView textFieldAtIndex:0];
        NSString *enteredText = thisTextField.text;
        if ([enteredText length] != 5)
        {
            UIAlertView *warning = [[UIAlertView alloc] initWithTitle:@"Invalid Zip Code" message:@"You did not enter 5 digits. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            warning.alertViewStyle = UIAlertViewStyleDefault;
            [warning show];
        }
        if ([enteredText length] == 5)
        {
            for (int x = 0; x < 5; x++)
            {
                unichar thischar = [enteredText characterAtIndex:x];
                if (isnumber(thischar) == FALSE)
                {
                    UIAlertView *warning = [[UIAlertView alloc] initWithTitle:@"Invalid Zip Code" message:@"You did not enter a Zip Code with 5 valid digits. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                    warning.alertViewStyle = UIAlertViewStyleDefault;
                    [warning show];
                    break;
                }
                if (x == 4 && (isnumber(thischar) == TRUE))
                {
                    zipIsValid = 1;
                }
            }
        }
        if (zipIsValid == 1)
        {
            typeOfQuery = @"zipcode";
            enteredZip = enteredText;
            [self performSegueWithIdentifier:@"advanceToMap" sender:nil];
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //[self locationManager];
    if ([segue.identifier isEqualToString:@"advanceToMap"])
    {
        ResultsView *newView = [segue destinationViewController];
        newView.latitude = latitude;
        newView.longitude = longitude;
        newView.query = typeOfQuery;
        newView.zipcode = enteredZip;
    }
}

@end
