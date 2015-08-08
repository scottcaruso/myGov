//
//  ResultsView.m
//  myGov
//
//  Copyright (c) 2013 Scott Caruso. All rights reserved.
//

#import "ResultsView.h"
#import "PoliticianView.h"
#import "createDictionary.h"

@interface ResultsView ()

@end

@implementation ResultsView

@synthesize arrayOfDictionaries,indexToPass,miniMap,loadingScreen,latitude,longitude,query,zipcode;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated]; //show the nav bar, which was hidden on the previous page

    loadingScreenFacts *createLoadingScreenFacts = [[loadingScreenFacts alloc] init];
    NSArray *facts = [createLoadingScreenFacts returnArrayOfFacts];
    uint32_t rnd = arc4random_uniform([facts count]);
    NSString *randomFact = [facts objectAtIndex:rnd];
    didYouKnow.text = randomFact;
    
    [spinning startAnimating]; //start the loading indicator spinning
    
    //Determine what kind of query was made by the ViewController
    [self setSunlightData:latitude long:longitude zipcode:zipcode];
}

-(void)setSunlightData:(float)lat long:(float)lon zipcode:(NSString*)zip
{
    //fetch the Sunlight Labs data
    if ([query isEqualToString:@"geolocation"])
    {
        url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://congress.api.sunlightfoundation.com/legislators/locate?latitude=%f&longitude=%f&apikey=eab4e1dfef1e467b8a25ed1eab0f7544",lat,lon]];
    } else if ([query isEqualToString:@"zipcode"])
    {
        url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://congress.api.sunlightfoundation.com/legislators/locate?zip=%@&apikey=eab4e1dfef1e467b8a25ed1eab0f7544",zip]];
    }
    
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:url];
    if (request != nil)
    {
        NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
        dataFromURL = [NSMutableData data];
        [self connection:connection didReceiveData:dataFromURL];
        [self connectionDidFinishLoading:connection];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (data != nil)
    {
        [dataFromURL appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self fetchedData:dataFromURL];
}

-(void)fetchedData:(NSData*)responseData
{
    //parse out the json data
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    resultsArray = [json objectForKey:@"results"];
    [self parseResultingArray:resultsArray];
}

-(void)parseResultingArray:(NSArray*)array
{
    [self multiDistrictSupport:array];
    for (int x = 0; x < [array count]; x++)
    {
        NSDictionary *thisPol = [array objectAtIndex:x];
        NSString *thisChamber = [thisPol objectForKey:@"chamber"];
        if ([thisChamber isEqualToString:@"house"])
        {
            if (representativeRawData == nil)
            {
                representativeRawData = [NSMutableDictionary dictionaryWithDictionary:thisPol];
            }
        } else if ([thisChamber isEqualToString:@"senate"])
        {
            if (firstSenatorRawData == nil)
            {
                firstSenatorRawData = [NSMutableDictionary dictionaryWithDictionary:thisPol];
            } else
            {
                secondSenatorRawData = [NSMutableDictionary dictionaryWithDictionary:thisPol];
            }
        } else
        {
            UIAlertView *noDataWarning = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"There was a problem retrieving your representative data. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [noDataWarning show];
        }
    }
    [self createDictionaries:representativeRawData firstSenator:firstSenatorRawData secondSenator:secondSenatorRawData];
}

-(void)multiDistrictSupport:(NSArray*)array
{
    districtsCovered = [[NSMutableArray alloc] init];
    if ([array count] > 3)
    {
        for (int x = 0; x < [array count]; x++)
        {
            NSDictionary *thisPol = [array objectAtIndex:x];
            NSString *thisChamber = [thisPol objectForKey:@"chamber"];
            if ([thisChamber isEqualToString:@"house"])
            {
                NSString *thisDistrict = [thisPol objectForKey:@"district"];
                stateCovered = [thisPol objectForKey:@"state"];
                if (thisDistrict != nil)
                {
                    [districtsCovered addObject:thisDistrict];
                }
            }
        }
        multiDistrict.hidden = FALSE;
        districtName.hidden = TRUE;
        if ([districtsCovered count] > 2)
        {
            for (int x = 3; x <= [districtsCovered count]; x++)
            {
                [multiDistrict insertSegmentWithTitle:@"" atIndex:x animated:FALSE];
            }
        }
        for (int x = 0; x < [districtsCovered count]; x++)
        {
            if ([districtsCovered objectAtIndex:x] != nil)
            {
                NSString *districtString = [NSString stringWithFormat:@"%@-%@",stateCovered,[districtsCovered objectAtIndex:x]];
                [multiDistrict setTitle:districtString forSegmentAtIndex:x];
            }
        }
    }
}

-(IBAction)onSegmentSelect:(id)sender
{
    for (int x = 0; x < [multiDistrict numberOfSegments]; x++)
    {
        if (multiDistrict.selectedSegmentIndex == x)
        {
            NSString *districtSelected = [NSString stringWithFormat:@"%@",[multiDistrict titleForSegmentAtIndex:x]];
            for (int x = 0; x < [resultsArray count]; x++)
            {
                NSDictionary *thisPol = [resultsArray objectAtIndex:x];
                NSString *thisDistrict = [thisPol objectForKey:@"district"];
                NSString *thisState = [thisPol objectForKey:@"state"];
                NSString *thisStatePlusDistrict = [NSString stringWithFormat:@"%@-%@",thisState,thisDistrict];
                
                if ([thisStatePlusDistrict isEqualToString:districtSelected])
                {
                    representativeRawData = [NSMutableDictionary dictionaryWithDictionary:thisPol];
                }
            }
        }
    }
    [self createDictionaries:representativeRawData firstSenator:firstSenatorRawData secondSenator:secondSenatorRawData];

}

-(void)createDictionaries:(NSDictionary*)representativeData firstSenator:(NSDictionary*)firstSenatorData secondSenator:(NSDictionary*)secondSenatorData
{
    //create strings for the politiican names
    NSString *firstSenatorName = [NSString stringWithFormat:@"%@ %@",[firstSenatorData objectForKey:@"first_name"],[firstSenatorData objectForKey:@"last_name"]];
    NSString *secondSenatorName = [NSString stringWithFormat:@"%@ %@",[secondSenatorData objectForKey:@"first_name"],[secondSenatorData objectForKey:@"last_name"]];
    NSString *representativeName = [NSString stringWithFormat:@"%@ %@", [representativeData objectForKey:@"first_name"],[representativeData objectForKey:@"last_name"]];
    
    //create strings for Twitter handle
    NSString *firstSenatorTwitter = [NSString stringWithFormat:@"@%@",[firstSenatorData objectForKey:@"twitter_id"]];
    NSString *secondSenatorTwitter = [NSString stringWithFormat:@"@%@",[secondSenatorData objectForKey:@"twitter_id"]];
    NSString *representativeTwitter = [NSString stringWithFormat:@"@%@",[representativeData objectForKey:@"twitter_id"]];
    
    //create strings for photo element. this is the element that tells the display which image to pull.
    NSString *firstSenatorPhoto = [NSString stringWithFormat:@"%@.jpg",[firstSenatorData objectForKey:@"bioguide_id"]];
    NSString *secondSenatorPhoto = [NSString stringWithFormat:@"%@.jpg",[secondSenatorData objectForKey:@"bioguide_id"]];
    NSString *representativePhoto = [NSString stringWithFormat:@"%@.jpg",[representativeData objectForKey:@"bioguide_id"]];

    createDictionary *dictionaryMaker = [[createDictionary alloc] init];
    //President and Vice President statically created, as they only change every 4-8 years or under exceptional circumstances.
    presidentInfo = [dictionaryMaker makeDictionary:@"Barack Obama" party:@"Democrat" hometown:@"Chicago, IL" birthday:@"8/4/1961" tookOffice:@"1/20/2009" website:@"http://www.barackobama.com" twitter:@"@barackobama" facebook:@"/barackobama" bioguidePhoto:@"president.png" contactForm:@"http://www.whitehouse.gov/contact/submit-questions-and-comments"];
    vicePresidentInfo = [dictionaryMaker makeDictionary:@"Joe Biden" party:@"Democrat" hometown:@"Wilmington, DE" birthday:@"10/20/1942" tookOffice:@"1/20/2009" website:@"http://www.joebiden.com" twitter:@"@JoeBiden" facebook:@"/JoeBiden" bioguidePhoto:@"vicepresident.png" contactForm:@"http://www.whitehouse.gov/contact/submit-questions-and-comments/vp"];
    
    //Senators/Representatives dynamically created
    firstSenatorInfo = [dictionaryMaker makeDictionary:firstSenatorName party:[self determinePoliticalParty:firstSenatorData] hometown:@"Coming Soon!" birthday:[firstSenatorData objectForKey:@"birthday"] tookOffice:@"Coming Soon!" website:[firstSenatorData objectForKey:@"website"] twitter:firstSenatorTwitter facebook:@"Coming Soon!" bioguidePhoto:firstSenatorPhoto contactForm:[firstSenatorData objectForKey:@"contact_form"]];
    secondSenatorInfo = [dictionaryMaker makeDictionary:secondSenatorName party:[self determinePoliticalParty:secondSenatorData] hometown:@"Coming Soon!" birthday:[secondSenatorData objectForKey:@"birthday"]  tookOffice:@"Coming Soon!" website:[secondSenatorData objectForKey:@"website"] twitter:secondSenatorTwitter facebook:@"Coming Soon!" bioguidePhoto:secondSenatorPhoto contactForm:[secondSenatorData objectForKey:@"contact_form"]];
    representativeInfo = [dictionaryMaker makeDictionary:representativeName party:[self determinePoliticalParty:representativeData] hometown:@"Coming Soon!" birthday:[representativeData objectForKey:@"birthday"] tookOffice:@"Coming Soon!" website:[representativeData objectForKey:@"website"] twitter:representativeTwitter facebook:@"Coming Soon!" bioguidePhoto:representativePhoto contactForm:[representativeData objectForKey:@"contact_form"]];
    
    //Put all of these objects into an array that can be pushed to the detail view
    arrayOfDictionaries = [[NSMutableArray alloc] initWithObjects:presidentInfo,vicePresidentInfo,firstSenatorInfo,secondSenatorInfo,representativeInfo,nil];
    
    [self reloadData];
}

//The below parses the dictionary to determine the political party of the object
-(NSString*)determinePoliticalParty:(NSDictionary*)data
{
    NSString *dataParty = [data objectForKey:@"party"];
    if ([dataParty isEqualToString:@"R"])
    {
        return @"Republican";
    } else if ([dataParty isEqualToString:@"D"])
    {
        return @"Democrat";
    } else
    {
        return @"Independent";
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

//This creates the rows for the ViewController table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 1)
    {
        return 2;
    }
    else if (section == 2)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

//This feeds the data for the table view
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *thisCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (thisCell == nil)
    {
        thisCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSDictionary *thisDictionary = [arrayOfDictionaries objectAtIndex:indexCounter];
    NSString *thisName = [thisDictionary objectForKey:@"Name"];
    NSString *thisParty = [thisDictionary objectForKey:@"Party"];
    thisCell.textLabel.text = thisName;
    thisCell.detailTextLabel.text = thisParty;
    indexCounter++;
    return thisCell;
}

//Set section titles
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"Executive Branch";
    }
    else if (section == 1)
    {
        return @"U.S. Senate";
    }
    else if (section == 2)
    {
        return @"House of Representatives";
    }
    else
    {
        return nil;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //The below grabs an int so that the subsequent view knows which index to use to pull politician data from the passed array.
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            indexToPass = 0;
        }
        else if (indexPath.row == 1)
        {
            indexToPass = 1;
        }
        else
        {
            indexToPass = 0;
        }
    } else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            indexToPass = 2;
        }
        else if (indexPath.row == 1)
        {
            indexToPass = 3;
        }
        else
        {
            indexToPass = 0;
        }
    } else if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            indexToPass = 4;
        }
        else
        {
            indexToPass = 4;
        }
    }
    if ([[segue identifier] isEqualToString:@"switchToDetail"])
    {
        // Get reference to the destination view controller
        PoliticianView *newView = [segue destinationViewController];
        
        // Pass the array of politician data and the reference index to the politician view
        newView.arrayOfDictionaries = arrayOfDictionaries;
        newView.indexToPass = indexToPass;
    }
}

-(void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    MKCoordinateSpan mapSpan; //default span that all of these locations use
    mapSpan.latitudeDelta = .05f;
    mapSpan.longitudeDelta = .05f;
    
    if ([query isEqualToString:@"zipcode"])
    {
        [self matchZipcodeToGeolocation:zipcode];
        CLLocationCoordinate2D mapCenter; //set the map centerpoint to the passed in latitude and longitude
        mapCenter.latitude = latitude;
        mapCenter.longitude = longitude;
        
        MKCoordinateRegion mapRegion;
        mapRegion.span = mapSpan;
        mapRegion.center = mapCenter;
        [miniMap setRegion:mapRegion];
        
        //call the geolocation function to populate the city name display after the mapview loads
        [self matchGeolocationToCity:latitude longitude:longitude];
        [self matchGeolocationToDistrict:latitude longitude:longitude];
    } else
    {
        CLLocationCoordinate2D mapCenter; //set the map centerpoint to the passed in latitude and longitude
        mapCenter.latitude = latitude;
        mapCenter.longitude = longitude;
        
        MKCoordinateRegion mapRegion;
        mapRegion.span = mapSpan;
        mapRegion.center = mapCenter;
        [miniMap setRegion:mapRegion];
        
        //call the geolocation function to populate the city name display after the mapview loads
        [self matchGeolocationToCity:latitude longitude:longitude];
        [self matchGeolocationToDistrict:latitude longitude:longitude];
    }
    sleep(2);
    self.loadingScreen.hidden = TRUE;
}

//This function uses an external data source to match the Geolocated area to the closest City/State name pair. It is called after the mapview loads. 
-(void)matchGeolocationToCity:(float)lat longitude:(float)lon
{
    NSURL *geonamesURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://api.geonames.org/findNearbyStreetsJSON?lat=%f&lng=%f&maxRows=1&username=mygov",lat,lon]];
    if (geonamesURL != nil)
    {
        NSData *thisData = [[NSData alloc] initWithContentsOfURL:geonamesURL];
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:thisData options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *thisObject = [json objectForKey:@"streetSegment"];
        if ([query isEqualToString:@"geolocation"])
        {
            closestTown = [thisObject objectForKey:@"adminName2"];
        }
        NSString *state = [thisObject objectForKey:@"adminCode1"];
        NSString *locationString = [NSString stringWithFormat:@"%@, %@",closestTown, state];
        nearestTownName.text = locationString;
    }
}

//This function uses an external data source to match the Geolocated area to the appropriate congressional district name
-(void)matchGeolocationToDistrict:(float)lat longitude:(float)lon
{
    NSURL *geonamesURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://congress.api.sunlightfoundation.com/districts/locate?latitude=%f&longitude=%f&apikey=eab4e1dfef1e467b8a25ed1eab0f7544",lat,lon]];
    if (url != nil)
    {
        NSData *thisData = [[NSData alloc] initWithContentsOfURL:geonamesURL];
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:thisData options:NSJSONReadingMutableContainers error:nil];
        NSArray *thisDistrict = [json objectForKey:@"results"];
        NSDictionary *districtDictionary = [thisDistrict objectAtIndex:0];
        NSNumber *district = [districtDictionary objectForKey:@"district"];
        NSString *state = [districtDictionary objectForKey:@"state"];
        NSString *districtNumber;
        if (district == 0)
        {
            districtNumber = @"AL";
            NSString *locationString = [NSString stringWithFormat:@"%@-%@",state, districtNumber];
            districtName.text = locationString;
        } else
        {
            districtNumber = [NSString stringWithFormat:@"%@",district];
            NSString *locationString = [NSString stringWithFormat:@"%@-%@",state, districtNumber];
            districtName.text = locationString;
        }
    }
}

//This function uses an external data source to match the Zipcode to an approximate latitude and longitude in that area.
-(void)matchZipcodeToGeolocation:(NSString*)zip
{
    NSURL *geonamesURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://api.geonames.org/postalCodeLookupJSON?postalcode=%@&country=US&username=mygov",zip]];
    if (url != nil)
    {
        NSData *thisData = [[NSData alloc] initWithContentsOfURL:geonamesURL];
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:thisData options:NSJSONReadingMutableContainers error:nil];
        NSArray *thisDistrict = [json objectForKey:@"postalcodes"];
        if (![thisDistrict count])
        {
            UIAlertView *badZipCode = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"The zip code you entered could not be found in the U.S. Please try again, or utilize the Geolocattion function." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [badZipCode show];
            [self performSegueWithIdentifier:@"backToMain" sender:nil];
        }
        else
        {
            NSDictionary *districtDictionary = [thisDistrict objectAtIndex:0];
            id latitudeObject = [districtDictionary objectForKey:@"lat"];
            latitude = [latitudeObject floatValue];
            id longitudeObject = [districtDictionary objectForKey:@"lng"];
            longitude = [longitudeObject floatValue];
            closestTown = [districtDictionary objectForKey:@"placeName"];
        }
    }
}


//sets indexCounter to zero (used for various functions) and then reloads the tableView
-(void)reloadData
{
    indexCounter = 0;
    [self.tableView reloadData];
}

@end