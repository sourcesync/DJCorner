//
//  FirstViewController.m
//  alpha2
//
//  Created by George Williams on 11/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"
#import "EventCell.h"
#import "Event.h"
#import "SimpleLocation.h"
#import "DJCAPI.h"
#import "Utility.h"
#import "alpha2AppDelegate.h"

#define DEFAULT_LAT     40.730039
#define DEFAULT_LONG    -73.994358

@implementation FirstViewController

@synthesize tv=_tv;
@synthesize mv=_mv;
@synthesize events=_events;
@synthesize location_manager=_location_manager;
@synthesize my_last_location=_my_last_location;
@synthesize sc=_sc;
@synthesize sc_maplist=_sc_maplist;
@synthesize tb=_tb;
@synthesize mode=_mode;
@synthesize api=_api;
@synthesize my=_my;
@synthesize djc=_djc;
@synthesize connectionProblem=_connectionProblem;
@synthesize got_first_location=_got_first_location;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle...

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.api = [ [ DJCAPI alloc ] init:self ];
    
    //  make a suitable default location...
    self.my_last_location = CLLocationCoordinate2DMake(DEFAULT_LAT, DEFAULT_LONG);
    
    //  location manager init...
    self.location_manager = [[ CLLocationManager alloc ] init ];
    [ self.location_manager setDelegate:self ];
    
    //  table view init...
    [self.tv setDelegate:self ];
    [self.tv setDataSource:self ];
    
    [self.sc addTarget:self 
                action:@selector(segmentClicked:)  
                forControlEvents:UIControlEventValueChanged];
    [self.sc_maplist addTarget:self 
                action:@selector(segmentMLClicked:)  
                forControlEvents:UIControlEventValueChanged];
    //[self.my setEnabled:YES];
    //[self.djc setEnabled:NO];
     
    //  start in map mode...
    [ self showMap ];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //  this will clear the previous views...
    [ self clearEvents ];
    
    //  make sure we have current gps location...
    //self.got_first_location = NO;
    //[ self.location_manager startUpdatingHeading ];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //  get data from server...
    [self refreshEvents ];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
    {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } 
    else 
    {
        return YES;
    }
}

#pragma mark - djcapi...

-(void) apiLoadingFailed:(NSString *)errMsg
{
    [ Utility AlertAPICallFailedWithMessage:errMsg ];
    self.connectionProblem = YES;
    self.events = nil;
    [ self updateViews ];
}

-(void) got_events:(NSDictionary *)data
{
    NSInteger status = [ [ data objectForKey:@"status" ] integerValue ];
    if (status>0)
    {
        NSMutableArray *results = [ data objectForKey:@"results" ];
        self.events = [ Event ParseFromAPI:results ];
        [ self updateViews ];
    }
    else
    {
        [ Utility AlertAPICallFailedWithMessage:@"API Call Return Bad Status." ];
        self.connectionProblem = YES;
        self.events = nil;
        [ self updateViews ];
    }
}

-(void) got_pic:(UIImageForCell *)ufc
{
    int row = [ ufc.idx integerValue ];
    
    NSIndexPath *path = [ NSIndexPath indexPathForRow:row inSection:0 ];
    
    EventCell *cell = (EventCell *)[ self.tv cellForRowAtIndexPath:path ];
    [ cell.activity stopAnimating ];
    [ cell.icon setImage:ufc.img];
    [ cell.icon setHidden:NO ];
}

#pragma mark - assorted funcs...

- (void)refreshEvents
{
    //  Cancel any existing calls...
    [ self.api cancelRequest ];
    [ self.api cancelAsyncPicDownloads ];
    
    self.connectionProblem = NO;
    
    //  Make api call...
    NSMutableDictionary *loc_dct = [ [ NSMutableDictionary alloc ] initWithCapacity:0 ];
    [loc_dct autorelease];
    
    NSNumber *lat = [ NSNumber numberWithFloat :40.731844 ];
    [ loc_dct setObject:lat forKey:@"lat" ];
    NSNumber *lng = [ NSNumber numberWithFloat :-73.99734 ];
    [ loc_dct setObject:lng forKey:@"lng" ];
    
    NSMutableDictionary *paging_dct = [ [ NSMutableDictionary alloc ] initWithCapacity:0 ];
    [paging_dct autorelease];
    if ( ![self.api get_events:loc_dct:paging_dct ] )
    {
        [ Utility AlertAPICallFailedWithMessage:@"API Called Failed." ];
        self.connectionProblem = YES;
    }
    
    //  get events data...
    //self.events = [ Event ParseFromAPI ];
}

-(void) updateViews
{
    //  refresh the views...
    [ self.tv reloadData ];
    [ self refreshMap ];
}

-(void) clearEvents
{
    self.events = nil;
    
    //  refresh the views...
    [ self.tv reloadData ];
    [ self refreshMap ];
}

-(void) showMap
{
    self.mv.hidden = NO;
    self.tv.hidden = YES;
    self.mode = EventViewMap;
    self.sc_maplist.selectedSegmentIndex = 0;
    //self.mlb.title = @"List";
    
}

-(void) showList
{
    self.mv.hidden = YES;
    self.tv.hidden = NO;
    self.mode = EventViewList;
    self.sc_maplist.selectedSegmentIndex = 1;
    //self.mlb.title = @"Map";
}

#pragma mark - table view delegate stuff...

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( self.connectionProblem )
    {
        return 1;
    }
    else if ( self.events == nil )
    {
        return 1;
    }
    else if ( [ self.events count ] == 0 )
    {
        return 1;
    }
    else
    {
        return [ self.events count ];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( self.connectionProblem )
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 @"noitem_cell"];
        if (cell == nil) 
        {
            cell = [[[ UITableViewCell alloc] init] autorelease];
        }
        cell.textLabel.text = @"Connection Problem...";
        cell.textLabel.font = [ UIFont boldSystemFontOfSize:17 ];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.textColor = [ UIColor whiteColor ];
        return cell;
    }
    else if ( self.events == nil )
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 @"noitem_cell"];
        if (cell == nil) 
        {
            cell = [[[ UITableViewCell alloc] init] autorelease];
        }
        cell.textLabel.text = @"Please Wait...";
        cell.textLabel.font = [ UIFont boldSystemFontOfSize:17 ];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.textColor = [ UIColor whiteColor ];
        return cell;   
    }
    else if ( [ self.events count ] == 0 )
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 @"noitem_cell"];
        if (cell == nil) 
        {
            cell = [[[ UITableViewCell alloc] init] autorelease];
        }
        cell.textLabel.text = @"No Events...";
        cell.textLabel.font = [ UIFont boldSystemFontOfSize:17 ];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.textColor = [ UIColor whiteColor ];
        return cell;     
    }
    else
    {
        UITableViewCell *cl = [tableView dequeueReusableCellWithIdentifier:
                               [ EventCell reuseIdentifier ]];
        if (cl == nil) 
        {
            cl = [[[ EventCell alloc] init] autorelease];
        }
        
        EventCell *cell = (EventCell *)cl;
        int row = [ indexPath row ];
        Event *event = [ self.events objectAtIndex:row ];
        
        NSString *name = event.name;
        cell.name.text = name;
        cell.msg.text = event.venue;
        NSString *dstr = [ NSString stringWithFormat:@"%.1f m",event.distance ];
        cell.distance.text = dstr;
        
        //  Initiate getting the pic...
        NSString *pp = event.pic_path;
        
        if ( pp != nil )
        {            
            NSNumber *num = [ NSNumber numberWithInteger:row];
            [ self.api asyncGetPic:pp:num];
            
            [ cell.activity startAnimating ];
            [ cell.icon setHidden:YES ];
        }
        else
        {
            [ cell.icon setHidden:YES ];
        }
        
        return cell;   
        
    }
     
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( (self.events ==nil)||([self.events count]==0))
    {
        return 44;
    }
    else
    {
        return 75.0f;
    }
}

#if 0
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}
#endif

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [ indexPath row ];
    
    Event *ev = [ self.events objectAtIndex:row ];
     
    alpha2AppDelegate *app = 
        ( alpha2AppDelegate *)[ [ UIApplication sharedApplication] delegate];
    
    [ app showEventModal:self:ev ];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    int row = [ indexPath row ];
    
    Event *ev = [ self.events objectAtIndex:row ];
    
    alpha2AppDelegate *app = 
    ( alpha2AppDelegate *)[ [ UIApplication sharedApplication] delegate];
    
    NSString *buyurl = ev.buyurl;
    [ app buyEvent: buyurl ];
}

#pragma mark - map/location delegate stuff...

-(void)setMapRegion
{
    //if ( ( self.events==nil) || ( [self.events count] == 0 ) )
    if (YES)
    {
        MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
        MKCoordinateRegion region = MKCoordinateRegionMake( self.my_last_location, span );
        [ self.mv setShowsUserLocation:YES];
        [ self.mv setRegion:region];
    }
    else // calculate from events...
    {
        
        double max_long = self.my_last_location.longitude;
        double min_long = self.my_last_location.longitude;
        double max_lat = self.my_last_location.latitude;
        double min_lat = self.my_last_location.latitude;
        
        //find min and max values
        for (int i=0;i<[ self.events count ];i++)
        {
            Event *event = [ self.events objectAtIndex:i ];
            double lat = event.latitude;
            double lng = event.longitude;
            
            if ( lat > max_lat) {max_lat = lat;}
            if ( lat < min_lat) {min_lat = lat;}
            if ( lng > max_long) {max_long = lng;}
            if ( lng< min_long) {min_long = lng;}
        }
        
        //calculate center of map
        double center_long = (max_long + min_long) / 2;
        double center_lat = (max_lat + min_lat) / 2;
        
        //calculate deltas
        double deltaLat = fabs(max_lat - min_lat);
        double deltaLong = fabs(max_long - min_long);
        
        //set minimal delta
        if (deltaLat < 5) {deltaLat = 5;}
        if (deltaLong < 5) {deltaLong = 5;}
        
        //create new region and set map
        CLLocationCoordinate2D coord = {.latitude =  center_lat, .longitude =  center_long};
        MKCoordinateSpan span = MKCoordinateSpanMake(deltaLat, deltaLong);
        MKCoordinateRegion region = {coord, span};
        [self.mv setRegion:region];
    }
    
}


-(void)refreshMap
{
    //  Remove existing annotations...
    for (id<MKAnnotation> annotation in self.mv.annotations) 
    {
        [self.mv removeAnnotation:annotation];
    }
    
    //  Get this user's location...
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = self.my_last_location.latitude;
    coordinate.longitude = self.my_last_location.longitude;
    
    //  Create this user's annotation...
    SimpleLocation *annotation = [ [ SimpleLocation alloc ] initWithName ];
    annotation.name = [ NSString stringWithString:@"You are here." ];
    annotation.message = nil;
    annotation.coordinate = coordinate;
    annotation.pp = nil;
    annotation.type=0;
    [ annotation autorelease ];
    [ self.mv addAnnotation:annotation];
    
    //  Add the events if any...
    if (self.events!=nil)
    {
        for ( int i=0; i < [ self.events count ];i++)
        {
            //  Get this user's info...
            Event *event = (Event *)[ self.events objectAtIndex:i ];
            
            //  Get this event's location...
            CLLocationCoordinate2D coordinate;
            double lat = event.latitude;
            double lng = event.longitude;
            coordinate.latitude = lat;
            coordinate.longitude = lng;
            
            //  Create events's annotation...
            SimpleLocation *annotation = [ [ SimpleLocation alloc ] initWithName];
            annotation.name = event.name;
            annotation.coordinate = coordinate;
            annotation.message = event.venue;
            annotation.type = 1;
            //annotation.pp = pp;
            [ annotation autorelease ];
            
            [ self.mv addAnnotation:annotation];        
        }
    }
    
    //  Reconfigure bounding area of map...
    [ self setMapRegion ];
    
}



- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation 
{
    static NSString *identifier = @"SimpleLocation";   
    
    if ([annotation isKindOfClass:[SimpleLocation class]]) 
    {
        //
        //  Customize the pin view...
        //
        
        SimpleLocation *location = (SimpleLocation *) annotation;
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) 
        [self.mv dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) 
        {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            
            [ annotationView autorelease ];
        } 
        else 
        {
            annotationView.annotation = annotation;
        }
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        
        //
        //  Customize the pin color...  
        //
        if (location.type==0)
        {
            annotationView.pinColor = MKPinAnnotationColorRed;
        }
        else
        {
            //  Choose a random color for 'other'...
            int number = (arc4random()%100);
            if (number==0)
                annotationView.pinColor = MKPinAnnotationColorGreen;
            else
                annotationView.pinColor = MKPinAnnotationColorPurple;
        }
        
#if 0
        //
        //  Customize the left accessory...
        //
        if ( (location.pp != nil )&& (location.type!=0) )
        {
            UIImage *avatar = [ Utility getPic:location.pp ];
            float aspect = avatar.size.height/avatar.size.width;
            UIImage *smaller = 
            [ Utility imageWithImage:avatar scaledToSize:CGSizeMake(32.0f/aspect,32.0f)];
            
            UIImageView *iv = [ [ UIImageView alloc ] initWithImage:smaller ];
            //[ smaller release ];  // TODO: why does this crash ?!
            
            annotationView.leftCalloutAccessoryView = iv;
            //[ iv release ];
        }
        else
#endif
            
        {
            annotationView.leftCalloutAccessoryView = nil;
            //  TODO: mem leak?...
        }
        
        return annotationView;
    }
    else
    {
        //  TODO: assert error...
        return nil;  
    }
}


#pragma mark - button/segment callbacks...

-(IBAction) mapListClicked: (id)sender
{
    if (self.mode==EventViewMap)
    {
        [ self showList ];
    }
    else
    {
        [ self showMap ];
    }
}
 
-(IBAction) segmentClicked: (id)sender
{
    if ( self.sc.selectedSegmentIndex == 0 )
    {
        
    }
    else
    {
        [ Utility AlertMessage:@"This feature is not yet implemented" ];
    }
}


-(IBAction) segmentMLClicked: (id)sender
{
    if ( self.sc_maplist.selectedSegmentIndex == 0 )
    {
        [ self showMap ];
    }
    else
    {
        [ self showList ];
    }
}



#pragma mark - Location Manager delegate...


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.got_first_location = TRUE;
    
    //  Get the user's location...
    CLLocationCoordinate2D location = [ newLocation coordinate ];
    
    //  Remember it...
    self.my_last_location = location;
    
    //  Got it, stop the updates... 
    [ self.location_manager stopUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Service Disabled" 
                                                    message:@"To re-enable, please go to Settings and turn on Location Service for this app." 
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}


@end
