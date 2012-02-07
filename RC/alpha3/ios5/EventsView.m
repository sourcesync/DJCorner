//
//  FirstViewController.m
//  alpha2
//
//  Created by George Williams on 11/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EventsView.h"
#import "EventCell.h"
#import "Event.h"
#import "SimpleLocation.h"
#import "DJCAPI.h"
#import "Utility.h"
#import "djcAppDelegate.h"
#import "AdsCell.h"

#define DEFAULT_LAT     40.730039
#define DEFAULT_LONG    -73.994358

@implementation EventsView

@synthesize tv=_tv;
@synthesize mv=_mv;
@synthesize location_manager=_location_manager;
@synthesize my_last_location=_my_last_location;
@synthesize segmentDJ=_segmentDJ;
@synthesize tb=_tb;
@synthesize mode=_mode;
@synthesize buttonMapList=_buttonMapList;
@synthesize got_first_location=_got_first_location;
@synthesize got_first_events=_got_first_events;
@synthesize getter=_getter;
@synthesize activity=_activity;
@synthesize cur_search=_cur_search;
@synthesize header=_header;
@synthesize back_from;
@synthesize all_djs;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    self.location_manager = nil;
    self.getter = nil;
    self.cur_search = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle...

- (void) newGetter:(NSString *)cur_search;
{
    if (self.getter!=nil)
    {
        [ self.getter finished ];
        self.getter = nil;
    }
    self.getter = [ [ [ EventsGetter alloc ] init ] autorelease ]; //ANA
    
    self.getter.cur_city_search = cur_search;
    self.getter.delegate = self;
    self.getter.latitude = self.my_last_location.latitude;
    self.getter.longitude = self.my_last_location.longitude;
    self.getter.all_djs = self.all_djs;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    djcAppDelegate *app = (djcAppDelegate *)[ [ UIApplication sharedApplication ] delegate];
    app.events_view = self;
    
    self.mv.delegate = self;
    
    self.got_first_events = NO;
    
    self.all_djs = YES;
    [ self newGetter:nil ];
    
    //  make a suitable default location...
    self.my_last_location = CLLocationCoordinate2DMake(DEFAULT_LAT, DEFAULT_LONG);
    
    //  location manager init...
    self.location_manager = [ [[ CLLocationManager alloc ] init] autorelease];
    
    [ self.location_manager setDelegate:self ];
    
    //  table view init...
    [self.tv setDelegate:self ];
    [self.tv setDataSource:self ];
    
    //  refresh views...
    [ self updateViews ];
    
    //  start in list mode...
    [ self showList ];
    
    
    self.all_djs = NO;
    self.segmentDJ.selectedSegmentIndex=1;
    [ self.segmentDJ addTarget:self action:@selector(segmentDJClicked:) 
               forControlEvents:UIControlEventValueChanged ];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ( self.back_from )
    {
        
    }
    else
    {
        //  this will clear the previous views...
        [ self clearEvents ];
    
        //  make sure we have current gps location...
        self.got_first_location = NO;
        [ self.location_manager startUpdatingLocation];
        [ self.location_manager startMonitoringSignificantLocationChanges];
    
        //  config views...
        self.tv.hidden = YES;
        self.mv.hidden = YES;
        self.activity.hidden = NO;
        [ self.activity startAnimating ];
    
        //  config header...
        NSString *txt = @"Events:";
        if (self.cur_search!=nil)
        {
            txt = [ NSString stringWithFormat:@"Events In %@", self.cur_search ];
        }
        [ self.header setText:txt ];
    
        [ self showList ];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.back_from)
    {
        self.back_from = NO;
    }
    else
    {
        if (!self.got_first_events)
        {
            //  Schedule a default refresh in the future,
            //  in case location manager fails...
            [self performSelector:@selector(refreshFirstTime:) withObject:self afterDelay:3 ];
        }
        else
        {
            if (self.mode == EventViewMap ) [ self showMap ];
            else [ self showList ];
            self.activity.hidden = YES;
            [ self.activity stopAnimating ];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    
    [ self.getter cancel ];
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

#pragma mark - getter delegate...

-(void) failed
{
    if (self.mode == EventViewMap ) [ self showMap ];
    else [ self showList ];
    self.activity.hidden = YES;
    [ self.activity stopAnimating ];
    
    [ Utility AlertMessage:@"API call failed."];
    //[ Utility AlertAPICallFailedWithMessage:errMsg ];    
    [ self updateViews ];
}

-(void) got_events:(NSInteger)start:(NSInteger)end
{
    if (!self.activity.hidden)
    {
        // stop activity indicator if running...
        self.activity.hidden = YES;
        [ self.activity stopAnimating ];
        
        if (self.mode == EventViewMap ) [ self showMap ];
        else [ self showList ];
    }
    
    //  update the view...
    [ self updateViews ];
    
    self.got_first_events = YES;
    
    //  continue to get more...
    if (!self.getter.got_all)
    {
        [ self.getter getNext ];
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

- (void)refreshFirstTime:(id)obj
{
    //  Don't refresh first time if the location manager did it already...
    if (!self.got_first_location) 
    {
        [ self refreshEvents:nil:NO];
    }
}

- (void)refreshEvents: (NSString *)cur_search: (BOOL) force_list
{
    self.cur_search = cur_search;
    
    self.tv.hidden = YES;
    self.mv.hidden = YES;
    self.activity.hidden = NO;
    [ self.activity startAnimating ];
    self.mode = EventViewList;
    
    [self newGetter:cur_search ];
    
    [self.getter getNext ]; 
    
    NSString *txt = @"Events:";
    if (self.cur_search!=nil)
    {
        txt = [ NSString stringWithFormat:@"Events In %@", self.cur_search ];
    }
    [ self.header setText:txt ];
}

-(void) updateViews
{
    
    
    //  refresh the views...
    [ self.tv reloadData ];
    [ self refreshMap ];
}

-(void) clearEvents
{
    //  Cancel old/create new getter...
    [ self newGetter:self.cur_search ];
    
    //  refresh the views...
    [ self.tv reloadData ];
    [ self refreshMap ];
}

-(void) showMap
{
    self.mv.hidden = NO;
    self.tv.hidden = YES;
    self.mode = EventViewMap; 
    self.buttonMapList.title = @"list"; 
}

-(void) showList
{
    self.mv.hidden = YES;
    self.tv.hidden = NO;
    self.mode = EventViewList;
    self.buttonMapList.title = @"map";
}

-(void) getMore
{
    [ self.getter getNext ];
}

#pragma mark - table view delegate stuff...

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( self.getter.connectionProblem )
    {
        return 1;
    }
    else if ( self.getter.events == nil )
    {
        return 1;
    }
    else if ( [ self.getter.events count ] == 0 )
    {
        return 1;
    }
    else
    {
        NSInteger count = [ self.getter.events count ];
        if ( count < self.getter.total_to_get ) 
        {
            count += 1;
        }
        return count+count/3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( self.getter.connectionProblem )
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
        cell.textLabel.textColor = [ UIColor blackColor ];
        return cell;
    }
    else if ( self.getter.events == nil )
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
        cell.textLabel.textColor = [ UIColor blackColor ];
        return cell;   
    }
    else if ( [ self.getter.events count ] == 0 )
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
        cell.textLabel.textColor = [ UIColor blackColor ];
        return cell;     
    }
    else
    {
        NSInteger row = ([ indexPath row ]+indexPath.row/3);
        
        if ( row == [ self.getter.events count] )  // get more button...
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                     @"getmore_cell"];
            if (cell == nil) 
            {
                cell = [[[ UITableViewCell alloc] init] autorelease];
            }
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.textLabel.font = [ UIFont boldSystemFontOfSize:17 ];
            cell.textLabel.text = @"Get More Events...";
            cell.textLabel.textColor = [ UIColor blackColor ];
            return cell;
        }
        
        //add ads....
        if(row>0&&((row+1)%4==0))
        {
            UITableViewCell *ads=[tableView dequeueReusableCellWithIdentifier:[AdsCell reuseIdentifier]];
            
            if(ads==nil)
            {
                ads=[[[AdsCell alloc] init]autorelease ];
            }
            
            AdsCell *cell=(AdsCell *)ads;
            cell.lb_adsContent.text=@"hello,ads";
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
            Event *event = [ self.getter.events objectAtIndex:(row-(row+1)/4) ];
         
            //  venue name...
            NSString *vname = [NSString stringWithFormat:@"%@, %@",event.venue,event.city];
            cell.venue.text = vname;
            
            //  event name...
            NSString *ename = event.name;
            cell.event.text = ename;
            
            //  event performers...
            NSString *str = @"";
            for ( int i=0;i< [ event.performers count ] ;i++)
            {
                if (i==0) str = [ event.performers objectAtIndex:0 ];
                else str = [ NSString stringWithFormat:@"%@,%@", str, 
                            [ event.performers objectAtIndex:i ] ];
            }
            NSString *performers = str;
            cell.performers.text = performers;
            
            //  date...
            NSString *dtstr = event.datestr;
            cell.date.text = dtstr;
            
            //  distance...
            NSString *dstr = [ NSString stringWithFormat:@"%.1f mi",event.distance ];
            cell.distance.text = dstr;
        
            //  Initiate getting the pic...
            NSString *pp = event.pic_path;
        
            if ( pp != nil )
            {               
                NSNumber *num = [ NSNumber numberWithInteger:row];
                [ self.getter asyncGetPic:pp:num];
            
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
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( (self.getter.events ==nil)||([self.getter.events count]==0)||
        ([self.getter.events count]==[indexPath row]))
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
    
    [ tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if((row+1)%4==0)
    {
        return;
    }
    else if (row == [self.getter.events count] )
    {
        [ self getMore ];
    }
    else
    {
        Event *ev = [ self.getter.events objectAtIndex:row ];
     
        
        [ self.getter cancel ];
        
        djcAppDelegate *app = 
            ( djcAppDelegate *)[ [ UIApplication sharedApplication] delegate];
    
        [ app showEventModal:self:ev:nil ];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    int row = [ indexPath row ];
    
    Event *ev = [ self.getter.events objectAtIndex:row ];
    
    djcAppDelegate *app = 
    ( djcAppDelegate *)[ [ UIApplication sharedApplication] delegate];
    
    
    NSString *buyurl = ev.buyurl;
    [ app buyEvent: buyurl ];
    
    [ self.getter cancel ];
    
    [ app showBuyModal:self:ev ];
    
}

#pragma mark - map/location delegate stuff...

-(void)setMapRegion
{
    //if ( ( self.events==nil) || ( [self.events count] == 0 ) )
    if (NO)
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
        for (int i=0;i<[ self.getter.events count ];i++)
        {
            Event *event = [ self.getter.events objectAtIndex:i ];
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
        if (deltaLat < 0.1) {deltaLat = 0.1;}
        if (deltaLong < 0.1) {deltaLong = 0.1;}
        
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
    if (self.getter.events!=nil)
    {
        for ( int i=0; i < [ self.getter.events count ];i++)
        {
            //  Get this user's info...
            Event *event = (Event *)[ self.getter.events objectAtIndex:i ];
            
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
            annotationView.pinColor = MKPinAnnotationColorGreen;
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


-(IBAction) toolbarRefresh: (id)sender
{
    [ self clearEvents ];
    
    [ self refreshEvents:nil:NO ];
}

-(IBAction)searchClicked:(id)sender
{
    [ self.getter cancel ];
    
    djcAppDelegate *app = 
        ( djcAppDelegate *)[ [ UIApplication sharedApplication] delegate];
    [ app showSearchByCity:self ];
}


-(IBAction)buttonMapListClicked:(id)sender
{
    if (self.mode == EventViewMap )
    {
        [ self showList ];
    }
    else
    {
        [ self showMap ];
    }
}

#if 0
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
#endif



#pragma mark - Segment DJ...


-(IBAction)segmentDJClicked:(id)sender
{
   if (self.segmentDJ.selectedSegmentIndex == 0 )
   {
       self.all_djs = YES;
   }
   else
   {
       self.all_djs = NO;
   }
    
    [ self refreshEvents:self.cur_search :NO ];
}


#pragma mark - Location Manager delegate...


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //[ Utility AlertMessage:@"gps" ];
    
    self.got_first_location = TRUE;
    
    //  Get the user's location...
    CLLocationCoordinate2D location = [ newLocation coordinate ];
    
    //  Remember it...
    self.my_last_location = location;
    
    //  Got it, stop the updates... 
    [ self.location_manager stopUpdatingLocation];
    
    //NSString *str = [ NSString stringWithFormat:
      //               @"got gps %f %f", self.my_last_location.latitude,
       //              self.my_last_location.longitude ];
    //[ Utility AlertMessage:str ];
    
    [ self refreshEvents: self.cur_search: NO ];
    
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
