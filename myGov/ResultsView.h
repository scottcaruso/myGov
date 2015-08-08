//
//  ResultsView.h
//  myGov
//
//  Copyright (c) 2013 Scott Caruso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "loadingScreenFacts.h"

@interface ResultsView : UIViewController <UITableViewDelegate,MKMapViewDelegate,NSURLConnectionDelegate,CLLocationManagerDelegate>
{
    NSURL *url;
    NSString *closestTown;
    
    IBOutlet UITableView *listOfPoliticians;
    IBOutlet UILabel *nearestTownName;
    IBOutlet UILabel *districtName;
    
    NSMutableDictionary *presidentInfo;
    NSMutableDictionary *vicePresidentInfo;
    NSMutableDictionary *firstSenatorInfo;
    NSMutableDictionary *secondSenatorInfo;
    NSMutableDictionary *representativeInfo;
    
    //dictionaries for constructing results
    NSMutableDictionary *firstSenatorRawData;
    NSMutableDictionary *secondSenatorRawData;
    NSMutableDictionary *representativeRawData;
    
    IBOutlet UIActivityIndicatorView *spinning;
    IBOutlet UITextView *didYouKnow;
    int indexCounter; //this is a very basic control for helping with the table creation
    
    NSString *currentElement;
    
    CLLocationManager *locationManager;
    
    NSMutableData *dataFromURL;
    NSMutableArray *districtsCovered;
    NSString *stateCovered;
    NSArray *resultsArray;
    
    IBOutlet UISegmentedControl *multiDistrict;

}

@property (nonatomic) NSMutableArray *arrayOfDictionaries;
@property (nonatomic) int indexToPass; //this tells this view which index to pass to the next view
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (nonatomic) NSString *query;
@property (nonatomic) NSString *zipcode;

@property IBOutlet UITableView *tableView;
@property IBOutlet MKMapView *miniMap;
@property IBOutlet UIView *loadingScreen;

//-(void)setGovtrackData;
-(void)reloadData;
-(void)setSunlightData:(float)latitude long:(float)longitude zipcode:(NSString*)zip;
-(void)parseResultingArray:(NSArray*)array;
-(void)createDictionaries:(NSDictionary*)representativeData firstSenator:(NSDictionary*)firstSentatorData secondSenator:(NSDictionary*)secondSenatorData;
-(void)matchGeolocationToCity:(float)lat longitude:(float)lon;
-(void)matchGeolocationToDistrict:(float)lat longitude:(float)lon;
-(void)matchZipcodeToGeolocation:(NSString*)zip;

-(IBAction)onSegmentSelect:(id)sender;

@end
