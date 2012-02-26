//
//  FirstViewController.h
//  alpha2
//
//  Created by George Williams on 11/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"
#import "SimpleLocation.h"
#import "DJCAPI.h"
#import "EventsGetter.h"
#import "AdsCell.h"
#import "EventCell.h"

#define EVENTS_ADS

#ifdef EVENTS_ADS
#define ADSPOSITION 4
#endif

enum EventViewMode
{
    EventViewMapOnly = 0,
    EventViewListOnly,
    EventViewListMap
};


@interface EventsView : UIViewController 
    < UITableViewDataSource, UITableViewDelegate,
    CLLocationManagerDelegate, MKMapViewDelegate,
    EventsGetterDelegate>
{

}

//  RETAIN...
@property (nonatomic, retain) CLLocationManager *location_manager;
@property (nonatomic, retain) EventsGetter *getter;
@property (nonatomic, retain) NSString *cur_search;
@property (nonatomic, retain) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic, retain) SimpleLocation *me_annotation;

//  IBOUTLET...
@property (nonatomic, retain) IBOutlet UITableView *tv;
@property (nonatomic, retain) IBOutlet MKMapView *mv;
@property (nonatomic, retain) IBOutlet UIToolbar *tb;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentDJ;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *buttonMapList;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, retain) IBOutlet UILabel *header;


//  ASSIGN...
@property (nonatomic, assign) CLLocationCoordinate2D my_last_location;
@property (nonatomic, assign) enum EventViewMode mode;
@property (nonatomic, assign) BOOL got_first_location;
@property (nonatomic, assign) BOOL got_first_events;
@property (nonatomic, assign) BOOL back_from;
@property (nonatomic, assign) BOOL all_djs;
@property (nonatomic, assign) int VIP;
@property (nonatomic, assign) BOOL scrolling;
@property (nonatomic, assign) BOOL refresh;
@property (nonatomic, assign) int sort_criteria;


//  PUBLIC FUNCS...
-(void) refreshFirstTime:(id)obj;
- (void)refreshEvents: (NSString *)cur_search: (BOOL)force_list;
-(void) refreshMap;
-(void) updateViews;
-(void) clearEvents;
-(void) showMap;
-(void) showList;
-(IBAction) toolbarRefresh: (id)sender;
-(void) getMore;
-(IBAction)searchClicked:(id)sender;
-(IBAction)buttonMapListClicked:(id)sender;
-(IBAction)segmentDJClicked:(id)sender;
-(void)loadImageForRow: (EventCell *)tcell: (NSIndexPath *)path;
-(void)loadImagesForOnscreenRows;

@end
