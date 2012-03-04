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
#import "VenueItemView.h"
#import "SimilarDJView.h"
#import "EventModalParms.h" 
#import "feedbackView.h"
//leve
#import "LocalizedManager.h"

#define NEW_INTRO

@implementation djcAppDelegate

//  RETAIN...
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
@synthesize events_lbe=_events_lbe;
@synthesize feedback_view=_feedback_view;
@synthesize purchaseManager=_purchaseManager;
@synthesize viewController=_viewController;
@synthesize venue_view=_venue_view;

//  ASSIGN...
@synthesize VIP=_VIP;
@synthesize is_simulator=_is_simulator;
@synthesize showing_event_modal=_showing_event_modal;
@synthesize showing_dj_modal=_showing_dj_modal;
@synthesize showing_venue_modal=_showing_venue_modal;

//leve
@synthesize tb_events;
@synthesize tb_venue;
@synthesize tb_profile;

#ifdef INTRO
@synthesize player=_player;
#endif
//end 

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Add the tab bar controller's current view as a subview of the window
    //self.window.rootViewController = self.tabBarController;
    
    //UIWindow *win = self.window;
    
    self.VIP=1;//1=>no,0=>yes;
    
    //  Do notification registration...
    [[UIApplication sharedApplication]  registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    //leve
    self.tb_events.title=[LocalizedManager localizedString:@"events"];
    self.tb_venue.title=[LocalizedManager localizedString:@"venue"];
    self.tb_profile.title=[LocalizedManager localizedString:@"profile"];
    
#ifdef SPLASH
    //  Create splash view and make it root...
    SplashView *splash = [ [ SplashView alloc ] init ];
    self.window.rootViewController = splash;
    [splash release ];
#endif
    
#ifdef NEW_INTRO
    ViewController *vc = [[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil] autorelease];
    self.viewController = vc;
    self.window.rootViewController = self.viewController;
#endif
    
    //  Show the UI...
    [self.window makeKeyAndVisible];
    
#ifdef INTRO
    sleep(5);
    [self prepAudio]; 
	// Start playback
	[self.player play];
#endif
    
    return YES;
}

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
}

- (void)dealloc
{
    self.api = nil;
#ifdef INTRO
    [_player release];
#endif
    [_window release];
    [_tabBarController release];
    
    //leve
    [tb_profile release];
    [tb_events release];
    [tb_venue release];
    [super dealloc];
}


 // Optional UITabBarControllerDelegate method.
 - (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
 {
     //NSLog(@"tab!");
 }
 

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

#ifdef INTRO
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
#endif

//leve
- (void)localization
{
    self.tb_events.title=[LocalizedManager localizedString:@"events"];
    self.tb_venue.title=[LocalizedManager localizedString:@"venue"];
    self.tb_profile.title=[LocalizedManager localizedString:@"profile"];
}

#ifdef INTRO
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
	// just keep playing
	[self.player play];
}
#endif

-(NSString *) getCurURL
{
    return self.cur_url;
}

-(void) splashDone
{
    //  Set tab bar controller as root view now...
    if ( self.window.rootViewController != self.tabBarController )
    {
        self.window.rootViewController = self.tabBarController;
        self.tabBarController.delegate = self;
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO  withAnimation:NO];
    }
}



-(void) _showVenueModal:(NSObject *)obj
{
    EventModalParms *parms = (EventModalParms *)obj;
    Venue *venue = (Venue *)parms.data;
    UIViewController *src = parms.src;
    NSString *get_eid = (NSString *)parms.oid;
    
    if (self.venue_view == nil )
    {
        self.venue_view = [ [ [ VenueItemView alloc ] init ] autorelease ]; //ANA
    }
    //self.event_view.delegate = self;
    self.venue_view.venue = venue;
    self.venue_view.getv = get_eid;
    self.venue_view.parent = src;
    
    self.showing_venue_modal = YES;
    [ src presentModalViewController:self.venue_view animated:YES ];
    
    [ obj release ];
}


-(void) showVenueModal:(UIViewController *)src:(Venue *)venue:(NSString*)get_eid;
{    
    if ( self.showing_venue_modal )
    {
        [ Utility AlertMessage:@"Too many nested controls.  Please go back." ];
    }
    else
    {
        EventModalParms *parms = [ [ EventModalParms alloc ] init];
        parms.src = src;
        parms.data = venue;
        parms.oid = get_eid;
        [ self performSelector:@selector(_showVenueModal:) withObject:parms afterDelay:0.0];
    }
}

-(void) doneVenueModal
{
    self.showing_venue_modal = NO;
}

-(void) _showEventModal:(NSObject *)obj
{
    EventModalParms *parms = (EventModalParms *)obj;
    Event *evt = (Event *)parms.data;
    UIViewController *src = parms.src;
    NSString *get_eid = (NSString *)parms.oid;
    
    if (self.event_view == nil )
    {
        self.event_view = [ [ [ EventView alloc ] init ] autorelease ]; //ANA
    }
    //self.event_view.delegate = self;
    self.event_view.event = evt;
    self.event_view.get_eid = get_eid;
    self.event_view.parent = src;
    
    self.showing_event_modal = YES;
    [ src presentModalViewController:self.event_view animated:YES ];
    
    [ obj release ];
}


-(void) showEventModal:(UIViewController *)src:(Event *)evt:(NSString*)get_eid;
{    
    if ( self.showing_event_modal )
    {
        [ Utility AlertMessage:@"Too many nested controls.  Please go back." ];
    }
    else
    {
        EventModalParms *parms = [ [ EventModalParms alloc ] init];
        parms.src = src;
        parms.data = evt;
        parms.oid = get_eid;
        [ self performSelector:@selector(_showEventModal:) withObject:parms afterDelay:0.0];
    }
}

-(void) doneEventModal
{
    self.showing_event_modal = NO;
}

-(void) _showDJItemModal:(NSObject *)obj
{
    EventModalParms *parms = (EventModalParms *)obj;
    DJ *dj = (DJ *)parms.data;
    UIViewController *src = parms.src;
    NSString *getdj = (NSString *)parms.oid;
    
    if (self.djitem_view == nil )
    {
        self.djitem_view = [ [ [  DJItemView alloc ] init ] autorelease ]; //ANA
    }
    self.djitem_view.dj = dj;
    self.djitem_view.getdj = getdj;
    self.djitem_view.parent = src;
    self.showing_dj_modal = YES;
    [ src presentModalViewController:self.djitem_view animated:YES ];
    
    [ obj release ];
}


-(void) showDJItemModal:(UIViewController *)src:(DJ *)dj:(NSString *)getdj
{
    if ( self.showing_dj_modal )
    {
        [ Utility AlertMessage:@"Too many nested controls.  Please go back." ];
    }
    else
    {
        EventModalParms *parms = [ [ EventModalParms alloc ] init];
        parms.src = src;
        parms.data = dj;
        parms.oid = getdj;
        [ self performSelector:@selector(_showDJItemModal:) withObject:parms afterDelay:0.0];
    }
}


-(void) doneDJItemModal
{
    self.showing_dj_modal = NO;
}

-(void) showSearchByCity:(UIViewController *)src
{
    self.search_by_city_view = [ [ [  SearchView alloc ] init ] autorelease ]; //ANA
    [ src presentModalViewController:self.search_by_city_view animated:YES ];
}


-(void) showSearchLocationBased:(UIViewController *)src
{
    if (self.events_lbe==nil)
    {
        self.events_lbe = [ [ [ EventSearchLocationBased alloc ] init ] autorelease ];
    }
    [ src presentModalViewController:self.events_lbe animated:YES ];
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

-(void) prepModals
{
    //  Stash an event view modal form...
    if (self.event_view == nil )
    {
        self.event_view = [ [ [ EventView alloc ] init ] autorelease ]; //ANA
    }
    
    //  Stash a djitem view modal form...
    if (self.djitem_view == nil )
    {
        self.djitem_view = [ [ [  DJItemView alloc ] init ] autorelease ]; //ANA
    }
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
    
    self.is_simulator = NO;
    
#if 0
    NSString *dispstr = \
    [ NSString stringWithFormat:@"Notifications registration success ->%@<-.", tokstr ];
    [ Utility AlertMessage:dispstr];
#endif
    
    if ( self.api == nil )
    {
        self.api = [ [ [ DJCAPI alloc ] init:self] autorelease];
    }
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
    
    self.is_simulator = YES;
    
    if ( self.api == nil )
    {
        self.api = [ [ [ DJCAPI alloc ] init:self] autorelease];
    }
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

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [ Utility AlertLowMemory ];
    
    //  Release any stashed modal forms...
    //  TODO: don't release any forms for which we are currently viewing !
    self.event_view = nil;
    self.djitem_view = nil;
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