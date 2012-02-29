//
//  djcAppDelegate.h
//  alpha2
//
//  Created by George Williams on 11/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EventView.h"
#import "BuyView.h"
#import "Event.h"
#import "SearchView.h"
#import "EventsView.h"
#import "MapitView.h"
#import "DJCAPI.h"
#import "DJItemView.h"
#import "DJ.h"
#import "DjView.h"
#import "DJSearchView.h"
#import "ScheduleView.h"
#import "SimilarDJView.h"
#import "feedbackView.h"
#import "InAppPurchaseManager.h"
#import "EventSearchLocationBased.h"
#import <AVFoundation/AVFoundation.h>
#import "ViewController.h"

@interface djcAppDelegate : NSObject 
<UIApplicationDelegate, UITabBarControllerDelegate,
EventViewDelegate, DJCAPIServiceDelegate,AVAudioPlayerDelegate>
{
#ifdef INTRO
    AVAudioPlayer *player; 
#endif
}

//  IBOUTLET...
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
//leve
@property (nonatomic, retain) IBOutlet UITabBarItem * tb_events;
@property (nonatomic, retain) IBOutlet UITabBarItem * tb_venue;
@property (nonatomic, retain) IBOutlet UITabBarItem * tb_profile;

//  RETAIN...
#ifdef INTRO
@property (retain) AVAudioPlayer *player;
#endif

@property (strong, nonatomic) ViewController *viewController;
@property (nonatomic, retain) NSString *cur_url;
@property (atomic,    retain) EventView *event_view;
@property (atomic,    retain) BuyView *buy_view;
@property (nonatomic, retain) NSString *cur_city_search;
@property (atomic, retain) SearchView *search_view;
@property (atomic, retain) EventsView *events_view;
@property (atomic, retain) MapitView *mapit_view;
@property (nonatomic, retain) NSString *devtoken;
@property (nonatomic, retain) DJCAPI *api;
@property (atomic, retain) DJItemView *djitem_view;
@property (atomic, retain) SearchView *search_by_city_view;
@property (atomic, retain) DjView *search_by_djs;
@property (atomic, retain) ScheduleView *dj_schedule_view;
@property (nonatomic, retain) SimilarDJView *dj_similar_view;
@property (nonatomic, retain) EventSearchLocationBased *events_lbe;
@property (nonatomic, retain) feedbackView *feedback_view;
@property (nonatomic, retain) InAppPurchaseManager *purchaseManager;

//  ASSIGN...
@property (nonatomic, assign) int VIP;
@property (nonatomic, assign) BOOL is_simulator;

//  PUBLIC FUNCS...
-(void) buyEvent:(NSString *)url;
-(NSString *) getCurURL;
-(void) mapIt:(UIViewController *)src:(NSString *)search:(CLLocationCoordinate2D)latlong;
-(void) splashDone;
-(void) showEventModal:(UIViewController *)src:(Event *)evt:(NSString*)get_eid;
-(void) showDJItemModal:(UIViewController *)src:(DJ *)dj:(NSString *)getdj;
-(void) showBuyModal:(UIViewController *)src:(Event *)evt;
-(void) doSearch:(UIViewController *)src:(NSString *)search;
-(void) showSearchByCity:(UIViewController *)src;
-(void) showSearchDJS:(UIViewController *)src:(NSString *)search;
-(void) showDJSchedule:(UIViewController *)src:(DJ *)dj;
-(void) showSimilarDJS:(UIViewController *)src:(DJ *)dj;
-(void) showFeedback:(UIViewController *)src:(DJ *)dj;
-(void) showSearchLocationBased:(UIViewController *)src;
-(void) purchaseManagerStart;
-(void) prepModals;

#ifdef INTRO
-(BOOL)prepAudio;
#endif

//leve
-(void) localization;
@end
