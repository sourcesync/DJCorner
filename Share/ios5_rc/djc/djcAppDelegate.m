//
//  djcAppDelegate.m
//  alpha2
//
//  Created by George Williams on 11/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "djcAppDelegate.h"

#import "SplashView.h"
#import "EventView.h"
#import "Utility.h"
#import "SearchView.h"
#import "DjView.h"
#import "SimilarDJView.h"
//jimmy 
#import "feedbackView.h"
//end
#import "rootViewController.h"
#import "ParseOperation.h"
#import <CFNetwork/CFNetwork.h>
#import "LoadLazyView.h"
#import "LocalizedManager.h"

static NSString *const TopPaidAppsFeed =
@"http://phobos.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/toppaidapplications/limit=75/xml";

@implementation djcAppDelegate


@synthesize window=_window;
@synthesize tabBarController=_tabBarController;
@synthesize cur_url=_cur_url;
@synthesize event_view=_event_view;
@synthesize buy_view=_buy_view;
@synthesize cur_city_search=_cur_city_search;
@synthesize events_view=_events_view;
@synthesize djitem_view=_djitem_view;
@synthesize search_view=_search_view;
@synthesize mapit_view=_mapit_view;
@synthesize devtoken=_devtoken;
@synthesize api=_api;
@synthesize search_by_city_view=_search_by_city_view;
@synthesize search_by_djs=_search_by_djs;
@synthesize dj_schedule_view=_dj_schedule_view; 
@synthesize dj_similar_view=_dj_similar_view;
//jimmy
@synthesize feedback_view=_feedback_view;
@synthesize purchaseManager=_purchaseManager;
@synthesize VIP=_VIP;
@synthesize player=_player;

//leve
@synthesize tb_events;
@synthesize tb_venue;
@synthesize tb_profile;
//end 
//load lazy
@synthesize navigationController, appRecords, rootview, queue, appListFeedConnection, appListData;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.api = [ [ [ DJCAPI alloc ] init:self] autorelease];
    self.VIP=1;//1=>no,0=>yes;
    //[ self.api autorelease];
    
    //  Do notification registration...
    [[UIApplication sharedApplication]  registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    SplashView *splash = [ [ SplashView alloc ] init ];
    //LoadLazyView *splash = [[LoadLazyView alloc] init];
    self.window.rootViewController = splash;
    [splash release ];
    
    self.tb_events.title=[LocalizedManager localizedString:@"events"];
    self.tb_venue.title=[LocalizedManager localizedString:@"venue"];
    self.tb_profile.title=[LocalizedManager localizedString:@"profile"];
    
    [self.window makeKeyAndVisible];
    
 
    // Test the validity of the connection object. The most likely reason for the connection object
    // to be nil is a malformed URL, which is a programmatic error easily detected during development
    // If the URL is more dynamic, then you should implement a more flexible validation technique, and
    // be able to both recover from errors and communicate problems to the user in an unobtrusive manner.
  
    
    return YES;
}

/*
 
-(void)applicationDidFinishLaunching:(UIApplication *)application{

    self.api = [ [ [ DJCAPI alloc ] init:self] autorelease];
    self.VIP=1;//1=>no,0=>yes;
    //[ self.api autorelease];
    
    //  Do notification registration...
    [[UIApplication sharedApplication]  registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    rootview = [[rootViewController alloc] init];
	[_window addSubview:rootview.view];
	[_window makeKeyAndVisible];
    
    // Initialize the array of app records and pass a reference to that list to our root view controller
    self.appRecords = [NSMutableArray array];
    rootview.array = self.appRecords;
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:TopPaidAppsFeed]];
    self.appListFeedConnection = [[[NSURLConnection alloc] initWithRequest:urlRequest delegate:self] autorelease];
    
    // Test the validity of the connection object. The most likely reason for the connection object
    // to be nil is a malformed URL, which is a programmatic error easily detected during development
    // If the URL is more dynamic, then you should implement a more flexible validation technique, and
    // be able to both recover from errors and communicate problems to the user in an unobtrusive manner.
    //
    NSAssert(self.appListFeedConnection != nil, @"Failure to create URL connection.");
    
    // show in the status bar that network activity is starting
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
 
}
//////////////load start //////////////
- (void)handleLoadedApps:(NSArray *)loadedApps
{
    [self.appRecords addObjectsFromArray:loadedApps]; 
    // tell our table view to reload its data, now that parsing has completed
    [rootview.tableView reloadData];
}
- (void)didFinishParsing:(NSArray *)appList
{
    [self performSelectorOnMainThread:@selector(handleLoadedApps:) withObject:appList waitUntilDone:NO];
    
    self.queue = nil;   // we are finished with the queue and our ParseOperation
}
- (void)parseErrorOccurred:(NSError *)error
{
    [self performSelectorOnMainThread:@selector(handleError:) withObject:error waitUntilDone:NO];
}

#pragma mark -
#pragma mark NSURLConnection delegate methods

- (void)handleError:(NSError *)error
{
    NSString *errorMessage = [error localizedDescription];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cannot Show Top Paid Apps"
														message:errorMessage
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.appListData = [NSMutableData data];    // start off with new data
}

// -------------------------------------------------------------------------------
//	connection:didReceiveData:data
// -------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [appListData appendData:data];  // append incoming data
}

// -------------------------------------------------------------------------------
//	connection:didFailWithError:error
// -------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if ([error code] == kCFURLErrorNotConnectedToInternet)
	{
        // if we can identify the error, we can present a more precise message to the user.
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"No Connection Error"
															 forKey:NSLocalizedDescriptionKey];
        NSError *noConnectionError = [NSError errorWithDomain:NSCocoaErrorDomain
														 code:kCFURLErrorNotConnectedToInternet
													 userInfo:userInfo];
        [self handleError:noConnectionError];
    }
	else
	{
        // otherwise handle the error generically
        [self handleError:error];
    }
    
    self.appListFeedConnection = nil;   // release our connection
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.appListFeedConnection = nil;   // release our connection
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;   
    
    // create the queue to run our ParseOperation
    self.queue = [[NSOperationQueue alloc] init];
    ParseOperation *parser = [[ParseOperation alloc] initWithData:appListData delegate:self];
    
    [queue addOperation:parser]; // this will start the "ParseOperation"
    
    [parser release];
 
    self.appListData = nil;
}
*/
////////load end ///////////

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    //abort();
}

- (void)localization
{
    self.tb_events.title=[LocalizedManager localizedString:@"events"];
    self.tb_venue.title=[LocalizedManager localizedString:@"venue"];
    self.tb_profile.title=[LocalizedManager localizedString:@"profile"];
}
- (void)dealloc
{
    self.api = nil;
    [appRecords release]; 
	[rootViewController release];
    [appListFeedConnection release];
    [appListData release];
    [_player release];
    [_window release];
    [_tabBarController release];
    [tb_profile release];
    [tb_events release];
    [tb_venue release];
    [super dealloc];
}

/*
 // Optional UITabBarControllerDelegate method.
 - (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
 {
 }
 */

/*
 // Optional UITabBarControllerDelegate method.
 - (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
 {
 }
 */

#pragma mark - public funcs...

-(void) buyEvent:(NSString *)url
{
    self.cur_url = url;
}

-(void) doSearch:(UIViewController *)src:(NSString *)search
{
    self.cur_city_search = search;
    [ self.events_view refreshEvents:self.cur_city_search:YES ];
    [ self.tabBarController setSelectedIndex:1 ];
    [ src dismissModalViewControllerAnimated:YES ];
}

-(void) mapIt:(UIViewController *)src:(NSString *)search:(CLLocationCoordinate2D)latlong
{
    self.mapit_view = [ [ [ MapitView alloc ] init ] autorelease ]; //ANA
    self.mapit_view.location = search;
    self.mapit_view.latlong = latlong;
    self.mapit_view.parent = src;
    [ src presentModalViewController:self.mapit_view animated:YES ];
}

-(BOOL) prepAudio
{
    
	NSError *error;
	NSString *path = [[NSBundle mainBundle] pathForResource:@"backgroundmusic" ofType:@"mp3"];
	if (![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        return NO; 
    }
	//Initialize the player
	self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error];
	self.player.delegate = self;
    player.numberOfLoops = -1;  
	if (!self.player)
	{
		NSLog(@"Error: %@", [error localizedDescription]);
		return NO;
	} 
	[self.player prepareToPlay];
    
    return YES;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
	// just keep playing
	[self.player play];
}

-(NSString *) getCurURL
{
    return self.cur_url;
}

-(void) splashDone
{
    if ( self.window.rootViewController != self.tabBarController )
    {
        self.window.rootViewController = self.tabBarController;
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO  withAnimation:NO];
    }
}


-(void) showEventModal:(UIViewController *)src:(Event *)evt:(NSString*)get_eid;
{
    self.event_view = [ [ [ EventView alloc ] init ] autorelease ]; //ANA
    //self.event_view.delegate = self;
    self.event_view.event = evt;
    self.event_view.get_eid = get_eid;
    self.event_view.parent = src;
    [ src presentModalViewController:self.event_view animated:YES ];
}


-(void) showDJItemModal:(UIViewController *)src:(DJ *)dj:(NSString *)getdj
{
    self.djitem_view = [ [ [  DJItemView alloc ] init ] autorelease ]; //ANA
    self.djitem_view.dj = dj;
    self.djitem_view.getdj = getdj;
    self.djitem_view.parent = src;
    [ src presentModalViewController:self.djitem_view animated:YES ];
    [src release];
}


-(void) showSearchByCity:(UIViewController *)src
{
    self.search_by_city_view = [ [ [  SearchView alloc ] init ] autorelease ]; //ANA
    [ src presentModalViewController:self.search_by_city_view animated:YES ];
}


-(void) showSearchDJS:(UIViewController *)src:(NSString *)search
{
    self.search_by_djs = [ [ [  DjView alloc ] init ] autorelease ]; //ANA
    self.search_by_djs.search = search;
    [ src presentModalViewController:self.search_by_djs animated:YES ];
}


-(void) showDJSchedule:(UIViewController *)src:(DJ *)dj
{
    self.dj_schedule_view = [ [ [  ScheduleView alloc ] init ] autorelease ]; //ANA
    self.dj_schedule_view.djname = dj.name;
    self.dj_schedule_view.djid = dj.djid;
    self.dj_schedule_view.parent = src;
    [ src presentModalViewController:self.dj_schedule_view animated:YES ];
}


-(void) showSimilarDJS:(UIViewController *)src:(DJ *)dj
{
    self.dj_similar_view= [ [ [  SimilarDJView alloc ] init ] autorelease ]; //ANA
    self.dj_similar_view.djname = dj.name;
    self.dj_similar_view.djid = dj.djid; 
    self.dj_similar_view.parent = src;
    [ src presentModalViewController:self.dj_similar_view animated:YES ];
}
//jimmy

-(void) showFeedback:(UIViewController *)src:(DJ *)dj
{
    self.feedback_view= [ [ [  feedbackView alloc ] init ] autorelease ]; 
    //ANA
    //self.dj_feedback_view.djname = dj.name;
    //self.dj_feedback_view.djid = dj.djid; 
    self.feedback_view.parent = src;
    [ src presentModalViewController:self.feedback_view animated:YES ];
}

//end 


-(void) showBuyModal:(UIViewController *)src:(Event *)evt
{
    self.buy_view = [ [ [ BuyView alloc ] init ] autorelease ]; //ANA
    self.buy_view.event = evt;
    self.buy_view.parent = src;
    [ src presentModalViewController:self.buy_view animated:YES ];
}

-(void)purchaseManagerStart
{
    if(self.purchaseManager==nil)
    {
        self.purchaseManager=[[InAppPurchaseManager alloc] init];
    }
    [self.purchaseManager requestProUpgradeProductData];
}


#pragma mark - eventview delegate stuff...

-(void) eventViewDone
{
    [ self.event_view dismissModalViewControllerAnimated:YES ];
}

#pragma mark - notifications...

- (void)application:(UIApplication *)application 
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //  Get string version of binary token...
    NSString *tokstr = [ deviceToken description ];
    
    //  Remember it...
    self.devtoken = tokstr;
    
#if 0
    NSString *dispstr = \
    [ NSString stringWithFormat:@"Notifications registration success ->%@<-.", tokstr ];
    [ Utility AlertMessage:dispstr];
#endif
    
    if ( ! [ self.api register_device:tokstr ] )
    {
        [ Utility AlertMessage:@"Failed to register device with server." ];
    }
    
}

- (void)application:(UIApplication *)application 
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    //[ Utility AlertMessage:@"notifications registration failed- using simulator credentials."];
    
    //  Remember it...
    self.devtoken = @"SIMULATOR";
    
    if ( ! [ self.api register_device:self.devtoken ] )
    {
        [ Utility AlertMessage:@"Failed to register device with server." ];
    }    
}

- (void)application:(UIApplication *)application 
didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //[ Utility AlertMessage:@"got notification"];
    
}

#pragma mark - api...

-(void) device_registered:(NSDictionary *)data
{
    
}

-(void) apiLoadingFailed:(NSString *)errMsg
{
    [ Utility AlertAPICallFailed ];
}

@end
