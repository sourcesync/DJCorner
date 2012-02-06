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

enum SearchViewMode
{
    SearchViewMap = 0,
    SearchViewList
};

@interface SearchView : UIViewController 
    <UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate, MKMapViewDelegate>
{
    
}


//  IBOUTLET...
@property (nonatomic, retain) IBOutlet UITableView *tv;
@property (nonatomic, retain) IBOutlet MKMapView *mv;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *button_MqpList;

//  RETAIN...
@property (nonatomic, retain) NSMutableArray *cities;
@property (nonatomic, retain) NSMutableArray *lati;
@property (nonatomic, retain) NSMutableArray *longi;
@property (nonatomic, retain) CLLocationManager *location_Manager;

//ASSIGN...
@property (nonatomic, assign) enum SearchViewMode mode;
@property (nonatomic, assign) CLLocationCoordinate2D show_Default_location;

//  PUBLIC FUNC...
-(IBAction) buttonBackClicked:(id)sender;
-(IBAction) buttonMapListClicked:(id)sender;
-(void) showMap:(id)sender;
-(void) showList:(id)sender;
-(void)refreshMap;

@end
