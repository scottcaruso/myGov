//
//  PoliticianView.h
//  myGov
//
//  Copyright (c) 2013 Scott Caruso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "WebDisplay.h"

@interface PoliticianView : UIViewController <UITableViewDelegate,UIPickerViewDelegate,UIAlertViewDelegate>
{
    int indexCounter; //this is a very basic control for helping with the table creation
    IBOutlet UILabel *polName;
    IBOutlet UILabel *polParty;
    IBOutlet UILabel *polHometown;
    IBOutlet UILabel *polBirthday;
    IBOutlet UILabel *polOfficeDate;
    IBOutlet UILabel *polWebsite;
    IBOutlet UIButton *polTwitter;
    IBOutlet UIButton *polEmail;
    IBOutlet UIImageView *polImage;
    
    IBOutlet UIButton *followUser;
    IBOutlet UIButton *tweetUser;
    
    IBOutlet UIView *issuePicker;
    
    IBOutlet UIView *emailPopup;
    IBOutlet UITextView *emailTemplate;
    IBOutlet UIButton *advanceToWebview;
    
    NSArray *issueTopics;
    NSArray *issueDetails;
    
    NSString *cameToPickerFrom;

    NSString *currentTwitterAccountName;
    
    NSDictionary *defaultDictionary;
}

@property (nonatomic) NSMutableArray *arrayOfDictionaries;
@property (nonatomic) int indexToPass; //this tells this view what index in the dictionary it should display first

-(void)showSelectedData:(NSArray*)baseDictionaryArray index:(int)indexToPass; //function to change the display at the top of the view

-(IBAction)clickTwitterButton:(id)sender;
-(IBAction)followUser:(id)sender;
-(IBAction)tweetUser:(id)sender;
-(IBAction)emailUser:(id)sender;

-(void)addUserToFollowerList;
-(void)sendPrewrittenTweet:(NSString*)issueString;
-(void)showPrewrittenEmail:(NSString*)issueString;

@end
