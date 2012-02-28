//
//  SecondViewController.h
//  alpha2
//
//  Created by George Williams on 11/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"
#import "SimpleLocation.h"
#import "AdsCell.h"

#ifdef ADS
#define ADSPOSITION 4
#endif

enum SearchViewMode
{
    SearchViewMap = 0,
    SearchViewList
};

enum MapListShowMode
{
    Middle=0,
    MapAll,
    ListAll
};

@interface SearchView : UIViewController 
    <UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate, MKMapViewDelegate>
{
    
}


//  IBOUTLET...
@property (nonatomic, retain) IBOutlet UITableView *tv;
@property (nonatomic, retain) IBOutlet MKMapView *mv;
@property (nonatomic, retain) IBOutlet UIToolbar *mapListUpDown;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *button_MqpList;

//  RETAIN...
@property (nonatomic, retain) NSMutableArray *cities;
@property (nonatomic, retain) NSMutableArray *lati;
@property (nonatomic, retain) NSMutableArray *longi;
@property (nonatomic, retain) NSMutableArray *flags;
@property (nonatomic, retain) CLLocationManager *location_Manager;
@property (nonatomic, retain) NSMutableDictionary *eventsAround;
@property (nonatomic, retain) NSMutableDictionary *allEvents;
@property (nonatomic, retain) NSMutableDictionary *dataForTable;

//ASSIGN...
@property (nonatomic, assign) enum SearchViewMode mode;
@property (nonatomic, assign) enum MapListShowMode status;
@property (nonatomic, assign) CLLocationCoordinate2D show_Default_location;
@property (nonatomic, assign) int modeList;
@property (nonatomic, assign) int VIP;

//  PUBLIC FUNC...
-(IBAction) buttonBackClicked:(id)sender;
-(IBAction) buttonMapListClicked:(id)sender;
-(void) showMap:(id)sender;
-(void) showList:(id)sender;
-(void)refreshMap;
-(void) reSize;
-(void) getEventAround:(double)lat:(double)longi;
-(IBAction) showAllmap;
-(IBAction) showAlllist;

@end
