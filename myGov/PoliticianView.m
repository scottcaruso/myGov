//
//  PoliticianView.m
//  myGov
//
//  Copyright (c) 2013 Scott Caruso. All rights reserved.
//

#import "PoliticianView.h"
#import "ResultsView.h"

@interface PoliticianView ()

@end

@implementation PoliticianView
@synthesize arrayOfDictionaries,indexToPass;

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
    //REMEMBER - if you change issue topics, you also need to change issue details!!!
    issueTopics = [[NSArray alloc] initWithObjects:
                   @"Education",
                   @"Energy Policy",
                   @"Environment",
                   @"Gay Rights",
                   @"Gridlock in Washington",
                   @"Immigration",
                   @"Job Creation",
                   @"Military Spending - Not Enough",
                   @"Military Spending - Too Much",
                   @"National Security",
                   @"Taxes",
                   @"Women's Rights", nil];
    issueDetails = [[NSArray alloc] initWithObjects:
                    @"Our children deserve a better future! Support more education funding!",
                    @"America's energy policy is laughable. More domestic production!",
                    @"The environment is our future. We need laws to protect her!",
                    @"Gay rights are human rights. Stand with our brothers and sisters.",
                    @"Why can't Washington get anything done? Compromise, not posturing!",
                    @"Secure the border first! Then worry about citizenship.",
                    @"No jobs = no economy. Pass a jobs bill now!",
                    @"Our militiary needs our support. More funding now!",
                    @"We spend way too much money on our military. Cut spending now!",
                    @"Stop being so weak on national security! Terrorism never sleeps.",
                    @"My taxes are too darn high! Stop taking my money!",
                    @"We won't rest until all WOMEN are created equal, too!",nil];

    [self showSelectedData:arrayOfDictionaries index:indexToPass];    
    indexCounter = 0;
}

- (void)viewDidLoad
{
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            [self showSelectedData:arrayOfDictionaries index:0];
        }
        else if (indexPath.row == 1)
        {
            [self showSelectedData:arrayOfDictionaries index:1];
        }
        else
        {
            indexToPass = 0;
            [self showSelectedData:arrayOfDictionaries index:0];
        }
    } else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            [self showSelectedData:arrayOfDictionaries index:2];
        }
        else if (indexPath.row == 1)
        {
            [self showSelectedData:arrayOfDictionaries index:3];
        }
        else
        {
            [self showSelectedData:arrayOfDictionaries index:3];
        }
    } else if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            [self showSelectedData:arrayOfDictionaries index:4];
        }
        else
        {
            [self showSelectedData:arrayOfDictionaries index:4];
        }
    }
}

-(void)showSelectedData:(NSArray*)baseDictionaryArray index:(int)index
{
    defaultDictionary = [baseDictionaryArray objectAtIndex:index];
    polName.text = [defaultDictionary objectForKey:@"Name"];
    self.navigationController.navigationItem.title=[defaultDictionary objectForKey:@"Name"];
    polParty.text = [defaultDictionary objectForKey:@"Party"];
    NSString *birthdayString = [NSString stringWithFormat:@"Birthday: %@",[defaultDictionary objectForKey:@"Birthday"]];
    polBirthday.text = birthdayString;
    polWebsite.text = [defaultDictionary objectForKey:@"Website"];
    currentTwitterAccountName = [defaultDictionary objectForKey:@"Twitter"];
    [polTwitter setTitle:currentTwitterAccountName forState:UIControlStateNormal];
    UIImage *image = [UIImage imageNamed:[defaultDictionary objectForKey:@"Photo"]];
    [polImage setImage:image];
    self.navigationItem.title = [defaultDictionary objectForKey:@"Name"];
    polTwitter.enabled = TRUE;
    followUser.hidden = TRUE;
    tweetUser.hidden = TRUE;
}

-(IBAction)clickTwitterButton:(id)sender
{
    polTwitter.enabled = FALSE;
    followUser.hidden = FALSE;
    tweetUser.hidden = FALSE;
}

-(IBAction)followUser:(id)sender
{
    [self isFollowingUser];
}

-(IBAction)tweetUser:(id)sender
{
    UIAlertView *tweetOptions = [[UIAlertView alloc] initWithTitle:@"Send Tweet" message:@"Would you like to write your own Tweet or choose a pre-written one?" delegate:self cancelButtonTitle:@"My own" otherButtonTitles:@"Pre-written",nil];
    tweetOptions.alertViewStyle = UIAlertViewStyleDefault;
    [tweetOptions show];
}

-(IBAction)emailUser:(id)sender
{
    UIAlertView *emailOptions = [[UIAlertView alloc] initWithTitle:@"Send Email" message:@"Would you like to write your own Email or choose a pre-written one?" delegate:self cancelButtonTitle:@"My own" otherButtonTitles:@"Pre-written",nil];
    emailOptions.alertViewStyle = UIAlertViewStyleDefault;
    [emailOptions show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:@"Send Tweet"])
    {
        if (buttonIndex == 0)
        {
            [self sendCustomTweet];
        }
        else if (buttonIndex == 1)
        {
            cameToPickerFrom = @"tweet";
           issuePicker.hidden = FALSE;
        }
    } else if ([alertView.title isEqualToString:@"Send Email"])
    {
       if (buttonIndex == 0)
       {
           NSString *emailString = [NSString stringWithFormat:@"Dear %@,",polName.text];
           emailTemplate.text = emailString;
           emailPopup.hidden = FALSE;
       } else if (buttonIndex == 1)
       {
           cameToPickerFrom = @"email";
           issuePicker.hidden = FALSE;
       }


    }
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [issueTopics count];
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    for (int x = 0; x < [issueTopics count]; x++)
    {
        if (x == row)
        {
            NSString *thisString = [issueTopics objectAtIndex:x];
            return thisString;
        }
    }
    return nil;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    for (int x = 0; x < [issueTopics count]; x++)
    {
        if (x == row)
        {
            NSString *chosenIssue = [issueDetails objectAtIndex:x];
            if ([cameToPickerFrom isEqualToString:@"twitter"])
            {
                [self sendPrewrittenTweet:chosenIssue];
            } else if ([cameToPickerFrom isEqualToString:@"email"])
            {
                [self showPrewrittenEmail:chosenIssue];
            }
        }
    }
    issuePicker.hidden = TRUE;
    polTwitter.enabled = TRUE;
    followUser.hidden = TRUE;
    tweetUser.hidden = TRUE;
}

-(void)showPrewrittenEmail:(NSString*)issueString
{
    NSString *emailString = [NSString stringWithFormat:@"Dear %@,\r\r%@\r\rSincerely,\r",polName.text,issueString];
    emailTemplate.text = emailString;
    emailPopup.hidden = FALSE;
}

-(void)addUserToFollowerList
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
	if (accountStore != nil)
    {
        ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        if (accountType != nil)
        {
            [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
                if (granted)
                {
                    NSArray *twitterAccounts = [accountStore accountsWithAccountType:accountType];
                    if (twitterAccounts != nil)
                    {
                        ACAccount *currentAccount = [twitterAccounts objectAtIndex:0];
                        if (currentAccount == nil)
                        {
                            NSLog(@"There is no account configured!");
                        } else
                        {
                            NSString *url = [NSString stringWithFormat:@"https://api.twitter.com/1.1/friendships/create.json?screen_name=%@&follow=true",currentTwitterAccountName];
                            NSURL *addFriendURL = [NSURL URLWithString:url];
                            
                            SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:addFriendURL parameters:nil];
                            if (request != nil)
                            {
                                [request setAccount:currentAccount];
                                
                                [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error){
                                    NSInteger responseCode = [urlResponse statusCode];
                                    if (responseCode == 200)
                                    {
                                        //the dispatch ensures that the alert view is run against the main thread, preventing an invalid memory allocation
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Success!" message:[NSString stringWithFormat:@"You are now following %@ on Twitter!",currentTwitterAccountName] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                success.alertViewStyle = UIAlertViewStyleDefault;
                                            [success show];});
                                    } else
                                    {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            UIAlertView *failure = [[UIAlertView alloc] initWithTitle:@"Follow Failed" message:[NSString stringWithFormat:@"The follow attempt failed. Please try again later."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                            failure.alertViewStyle = UIAlertViewStyleDefault;
                                            [failure show];});
                                    }
                                }];
                            }
                        }
                    }
                }
                else
                {
                    [self accessNotGranted]; //if access is not granted, call the appropriate alert
                }
            }];
        }
    }
    polTwitter.enabled = TRUE;
    followUser.hidden = TRUE;
    tweetUser.hidden = TRUE;
}

-(void)accessNotGranted
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Twitter access denied. Please minimize the application and configure a Twitter account on this device." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
}

-(void)isFollowingUser
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
	if (accountStore != nil)
    {
        ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        if (accountType != nil)
        {
            [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
                if (granted)
                {
                    NSArray *twitterAccounts = [accountStore accountsWithAccountType:accountType];
                    if (twitterAccounts != nil)
                    {
                        ACAccount *currentAccount = [twitterAccounts objectAtIndex:0];
                        if (currentAccount == nil)
                        {
                            NSLog(@"There is no account configured!");
                        } else
                        {
                            NSString *url = [NSString stringWithFormat:@"https://api.twitter.com/1.1/friendships/lookup.json?screen_name=%@",currentTwitterAccountName];
                            NSURL *getFriendUrl = [NSURL URLWithString:url];
                            
                            SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:getFriendUrl parameters:nil];
                            if (request != nil)
                            {
                                [request setAccount:currentAccount];
                                [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                                    NSInteger responseCode = [urlResponse statusCode];
                                    if (responseCode == 200)
                                    {
                                        NSArray *response = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
                                        if (response != nil)
                                        {
                                            NSDictionary *thisUser = [response objectAtIndex:0];
                                            NSArray *userConnections = [thisUser objectForKey:@"connections"];
                                            NSLog(@"%@",userConnections);
                                            for (int x = 0; x < [userConnections count]; x++)
                                            {
                                                NSString *connectionType = [userConnections objectAtIndex:x];
                                                if ([connectionType isEqualToString:@"following"])
                                                {
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        UIAlertView *alreadyFollowing = [[UIAlertView alloc] initWithTitle:@"Already Following!" message:[NSString stringWithFormat:@"You are already following %@ on Twitter!",currentTwitterAccountName] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                        alreadyFollowing.alertViewStyle = UIAlertViewStyleDefault;
                                                        [alreadyFollowing show];});
                                                    break;
                                                } else
                                                {
                                                    [self addUserToFollowerList];
                                                }
 
                                            }
                                        }
                                    }
                                    else
                                    {
                                        //Error handling
                                    }
                                }];
                            } else
                            {
                                [self addUserToFollowerList];
                            }
                        }
                    }
                }
                else
                {
                    [self accessNotGranted]; //if access is not granted, call the appropriate alert
                }
            }];
        }
    }
}

-(void)sendCustomTweet
{
    SLComposeViewController *postTweet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    if (postTweet != nil)
    {
        NSString *tweetStart = [NSString stringWithFormat:@"%@",currentTwitterAccountName];
        [postTweet setInitialText:tweetStart];
        [self presentViewController:postTweet animated:true completion:nil];
    }
}

-(void)sendPrewrittenTweet:(NSString*)issueString
{
    SLComposeViewController *postTweet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    if (postTweet != nil)
    {
        NSString *tweet= [NSString stringWithFormat:@"%@: %@",currentTwitterAccountName,issueString];
        [postTweet setInitialText:tweet];
        [self presentViewController:postTweet animated:true completion:nil];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"web"])
    {
        emailPopup.hidden = TRUE;
        WebDisplay *web = [segue destinationViewController];
        web.contactURL = [defaultDictionary objectForKey:@"Contact Form"];
    }
}

@end
