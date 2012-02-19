//
//  EventSearchLocationBased.h
//  djc
//
//  Created by George Williams on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapitView.h"

enum EventSearchMode
{
    List=0,
    MapList,
    MapOnly
} EventSearchMode;

@interface EventSearchLocationBased : UIViewController
    < UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate>


//  RETAIN...
@property (nonatomic, retain) NSMutableArray *cities;
@property (nonatomic, retain) NSMutableArray *lati;
@property (nonatomic, retain) NSMutableArray *longi;
@property (nonatomic, retain) NSMutableArray *flags;

//  IBOUTLET...
@property (nonatomic, retain) IBOutlet UIBarButtonItem *cancelButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *okButton;
@property (nonatomic, retain) IBOutlet UITableView *tv;
@property (nonatomic, retain) IBOutlet MKMapView *mv;

//  ASSIGN...
@property (nonatomic, assign) enum EventSearchMode mode;

//  PUBLIC FUNCS...
-(IBAction)cancelClicked:(id)sender;
-(IBAction)okClicked:(id)sender;


-(void)refreshMap;

@end
