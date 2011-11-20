//
//  FirstViewController.h
//  alpha2
//
//  Created by George Williams on 11/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"
#import "DJCAPI.h"

enum EventViewMode
{
    EventViewMap = 0,
    EventViewList
};


@interface FirstViewController : UIViewController 
    < UITableViewDataSource, UITableViewDelegate,
    CLLocationManagerDelegate, MKMapViewDelegate,
    DJCAPIServiceDelegate >
{

}


//  RETAIN...
@property (nonatomic, retain) NSMutableArray *events;
@property (nonatomic, retain) CLLocationManager *location_manager;
@property (nonatomic, retain) DJCAPI *api;

//  IBOUTLET...
@property (nonatomic, retain) IBOutlet UITableView *tv;
@property (nonatomic, retain) IBOutlet MKMapView *mv;
@property (nonatomic, retain) IBOutlet UIToolbar *tb;
@property (nonatomic, retain) IBOutlet UISegmentedControl *sc;
@property (nonatomic, retain) IBOutlet UISegmentedControl *sc_maplist;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *my;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *djc;

//  ASSIGN...
@property (nonatomic, assign) CLLocationCoordinate2D my_last_location;
@property (nonatomic, assign) enum EventViewMode mode;
@property (nonatomic, assign) BOOL connectionProblem;
@property (nonatomic, assign) BOOL got_first_location;

//  PUBLIC FUNCS...
-(void) refreshEvents;
-(void) refreshMap;
-(void) updateViews;
-(void) clearEvents;
-(IBAction) mapListClicked: (id)sender;
-(IBAction) segmentClicked: (id)sender;
-(IBAction) segmentMLClicked: (id)sender;
-(void) showMap;
-(void) showList;



@end
