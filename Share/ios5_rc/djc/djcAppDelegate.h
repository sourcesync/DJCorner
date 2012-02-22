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
#import <AVFoundation/AVFoundation.h>
 
#import "ParseOperation.h"
#import "AppRecord.h"

@class rootViewController;
@interface djcAppDelegate : NSObject 
<UIApplicationDelegate, UITabBarControllerDelegate,
EventViewDelegate, DJCAPIServiceDelegate,AVAudioPlayerDelegate>//,ParseOperationDelegate
{
    AVAudioPlayer *player;  
    /**/
    //UIWindow				*window; 
    // this view controller hosts our table of top paid apps
    rootViewController      *rootview; 
    // the list of apps shared with "RootViewController"
    NSMutableArray          *appRecords; 
    // the queue to run our "ParseOperation"
    NSOperationQueue		*queue; 
    // RSS feed network connection to the App Store
    NSURLConnection         *appListFeedConnection;
    NSMutableData           *appListData;
    /**/
    
}

//  IBOUTLET...
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet UITabBarItem * tb_events;
@property (nonatomic, retain) IBOutlet UITabBarItem * tb_venue;
@property (nonatomic, retain) IBOutlet UITabBarItem * tb_profile;


//  RETAIN...
@property (retain) AVAudioPlayer *player;
@property (nonatomic, retain) NSString *cur_url;
@property (atomic, retain) EventView *event_view;
@property (atomic, retain) BuyView *buy_view;
@property (nonatomic, retain) NSString *cur_city_search;
@property (atomic, retain) SearchView *search_view;
@property (atomic, retain) EventsView *events_view;
@property (atomic, retain) MapitView *mapit_view;
@property (nonatomic, retain) NSString *devtoken;
@property (nonatomic, assign) int VIP;
@property (nonatomic, retain) DJCAPI *api;
@property (atomic, retain) DJItemView *djitem_view;
@property (atomic, retain) SearchView *search_by_city_view;
@property (atomic, retain) DjView *search_by_djs;
//@property (nonatomic, retain) DJSearchView *search_by_djs;
@property (atomic, retain) ScheduleView *dj_schedule_view;
@property (nonatomic, retain) SimilarDJView *dj_similar_view;
//jimmy added
@property (nonatomic, retain) feedbackView *feedback_view;
@property (nonatomic, retain) InAppPurchaseManager *purchaseManager;


/**/
//load lazy
 
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet rootViewController *rootview; 
@property (nonatomic, retain) NSMutableArray *appRecords; 
@property (nonatomic, retain) NSOperationQueue *queue; 
@property (nonatomic, retain) NSURLConnection *appListFeedConnection;
@property (nonatomic, retain) NSMutableData *appListData; 
/**/
//end
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
-(void) purchaseManagerStart;
-(BOOL) prepAudio;
-(void) localization;
@end
