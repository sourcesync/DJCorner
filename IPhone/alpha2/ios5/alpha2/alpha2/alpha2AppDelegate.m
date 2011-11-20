//
//  alpha2AppDelegate.m
//  alpha2
//
//  Created by George Williams on 11/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "alpha2AppDelegate.h"

#import "SplashView.h"
#import "EventView.h"

@implementation alpha2AppDelegate


@synthesize window=_window;
@synthesize tabBarController=_tabBarController;
@synthesize cur_url=_cur_url;
@synthesize event_view=_event_view;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Add the tab bar controller's current view as a subview of the window
    //self.window.rootViewController = self.tabBarController;
    
    SplashView *splash = [ [ SplashView alloc ] init ];
    self.window.rootViewController = splash;
    [ splash release ];
    
    [self.window makeKeyAndVisible];
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
    [_window release];
    [_tabBarController release];
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
    [ self.tabBarController setSelectedIndex:4 ];
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
        
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO  animated:NO];
    }
}


-(void) showEventModal:(UIViewController *)src:(Event *)evt
{
    self.event_view = [ [ EventView alloc ] init ];
    self.event_view.delegate = self;
    self.event_view.event = evt;
    [ src presentModalViewController:self.event_view animated:YES ];
}

#pragma mark - eventview delegate stuff...

-(void) eventViewDone
{
    [ self.event_view dismissModalViewControllerAnimated:YES ];
}


@end
