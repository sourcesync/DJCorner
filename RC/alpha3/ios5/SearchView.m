//
//  SecondViewController.m
//  alpha2
//
//  Created by George Williams on 11/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SearchView.h"
#import "Utility.h"
#import "djcAppDelegate.h"
#import "MapKit/MapKit.h"
#import "SimpleLocation.h"


#define DEFAULT_LAT     40.730039
#define DEFAULT_LONG    -73.994358

@implementation SearchView

@synthesize tv=_tv;
@synthesize mv=_mv;
@synthesize button_MqpList=_button_MqpList;
@synthesize cities=_cities;
@synthesize lati=_lati;
@synthesize longi=_longi;
@synthesize mode=_mode;
@synthesize location_Manager=_location_Manager;
@synthesize show_Default_location=_show_Default_location;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    djcAppDelegate *app = (djcAppDelegate *)[ [ UIApplication sharedApplication ] delegate];
    app.search_view = self;
    
    self.mv.delegate = self;
    
    [ self.tv setDelegate:self ];
    [ self.tv setDataSource:self ];    
    self.cities = [ [ [ NSMutableArray alloc ] 
                   initWithObjects:
                   @"All Cities",
                   @"Amsterdam",
                   @"Berlin",
                   @"Bologna",
                   @"Beirut",
                   @"Berlin",
                   @"Buenos Aires",
                   @"Camboriu",
                   @"Ciauba",
                   @"Dallas",
                   @"Delhi",
                   @"Den Bosch",
                   @"Dubai",
                   @"Dublin",
                   @"Florence",
                   @"Florianopolis",
                   @"Goa",
                   @"Gold Coast",
                   @"Hamptons",
                   @"Hong Chong",
                   @"Ibiza",
                   @"Kaohsiung City",
                   @"Las Vegas",
                   @"Leuven",
                   @"London", 
                   @"Long Island City",
                   @"Los Angeles",
                   @"Madrid",
                   @"Manchester",
                   @"Miami",
                   @"Montreal",
                   @"Moscow",
                   @"Mumbai",
                   @"Mykonos",
                   @"New York City",
                   @"Paris",
                   @"Pasay City",
                   @"Punta del Este",
                   @"Rio de Janeiro",
                   @"San Diego",
                   @"Santa Ana",
                   @"Scottsdale",
                   @"Seoul",
                   @"Sharm El-Sheik",
                   @"Singapore",
                   @"Sydney",
                   @"Tokyo",
                   @"Toronto",
                     nil] autorelease ]; //ANA
    
    self.lati=[[[NSMutableArray alloc]
                initWithObjects:
                @"52.36",
                @"52.54",
                @"44.50",
                @"33.88",
                @"52.54",
                @"-34.60",
                @"-27.02",
                @"-15.56",
                @"-56.09",
                @"32.81",
                @"28.64",
                @"51.70",
                @"25.30",
                @"53.35",
                @"43.77",
                @"-27.58",
                @"15.45",
                @"-28.02",
                @"26.91",
                @"22.30",
                @"38.91",
                @"23.04",
                @"36.15",
                @"50.88",
                @"51.51",
                @"40.72",
                @"34.08",
                @"40.43",
                @"53.48",
                @"25.79",
                @"45.51",
                @"56.41",
                @"19.09",
                @"37.45",
                @"40.73",
                @"48.86",
                @"14.53",
                @"-34.96",
                @"-22.86",
                @"32.73",
                @"33.74",
                @"33.52",
                @"37.58",
                @"27.94",
                @"1.29",
                @"-33.74",
                @"35.74",
                @"43.66",
                nil] autorelease];
    
    self.longi=[[[NSMutableArray alloc]
                 initWithObjects:
                 @"4.90",
                 @"13.41",
                 @"11.34",
                 @"35.49",
                 @"13.41",
                 @"-58.37",
                 @"-48.65",
                 @"-56.09",
                 @"-96.76",
                 @"77.22",
                 @"5.31",
                 @"55.31",
                 @"-6.26",
                 @"11.25",
                 @"-48.55",
                 @"73.97",
                 @"153.29"
                 @"-80.11",
                 @"114.12",
                 @"1.43",
                 @"120.66",
                 @"-115.17",
                 @"4.70",
                 @"-0.12",
                 @"-74.00",
                 @"-118.24",
                 @"-3.69",
                 @"-2.24",
                 @"-80.22",
                 @"-73.55",
                 @"37.22",
                 @"72.87",
                 @"25.32",
                 @"-74.00",
                 @"2.35",
                 @"121.00",
                 @"-54.94",
                 @"-43.20",
                 @"-117.15",
                 @"-117.86",
                 @"-111.92",
                 @"126.97",
                 @"34.36",
                 @"103.85",
                 @"151.20",
                 @"139.69",
                 @"-79.38",
                 nil] autorelease];
    self.show_Default_location=CLLocationCoordinate2DMake(DEFAULT_LAT, DEFAULT_LONG);
    self.location_Manager=[[[CLLocationManager alloc] init] autorelease];
    
    [self.location_Manager setDelegate:self ];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //[ Utility AlertMessage:@"This is not yet implemented" ];
}

-(void) viewWillAppear:(BOOL)animated
{
    [ self.tv reloadData ];
    [self.location_Manager startUpdatingLocation];
    [self.location_Manager startMonitoringSignificantLocationChanges];


}



- (void)dealloc
{
    self.cities = nil;
    [super dealloc];
}


#pragma mark - table view delegates...


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ self.cities count ] ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             @"search_cell"];
    int row = [ indexPath row ];
    if (cell == nil) 
    {
        cell = [[[ UITableViewCell alloc] init] autorelease];
    }
    
    [ cell.textLabel setText: [ self.cities objectAtIndex:row ] ];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = [ UIColor blackColor ];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    djcAppDelegate *app = (djcAppDelegate *)[ [ UIApplication sharedApplication ] delegate];

    [ self.tv deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = [ indexPath row ];
    
    if ( row == 0 )
    {
        [ app doSearch:self:nil];
    }
    else
    {
        UITableViewCell *cell = [ self.tv cellForRowAtIndexPath:indexPath ];
        NSString *city = cell.textLabel.text;
        [ app doSearch:self:city];
    }
}
/*
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
}
 */

#pragma map....
-(void) setMapRegion
{
    if(YES)
    {
        MKCoordinateSpan span=MKCoordinateSpanMake(0.1, 0.1);
        MKCoordinateRegion region=MKCoordinateRegionMake(self.show_Default_location, span);
        [self.mv setShowsUserLocation:YES];
        [self.mv setRegion:region];
    }
    else
    {
       
    }
}

-(void)refreshMap
{
    //remove exists annotations
    for(id<MKAnnotation> annotation in self.mv.annotations)
    {
        [self.mv removeAnnotation:annotation];
    }
    
    //get this user's locaation...
    CLLocationCoordinate2D coordidate;
    coordidate.latitude=self.show_Default_location.latitude;
    coordidate.longitude=self.show_Default_location.longitude;
    
    //create this user's annonation
    SimpleLocation *annonaion=[[SimpleLocation alloc] initWithName];
    annonaion.name=[NSString stringWithString:@"Francisco"];
    annonaion.message=nil;
    annonaion.coordinate=coordidate;
    annonaion.pp=nil;
    annonaion.type=0;
    [self.mv addAnnotation:annonaion];
    if(YES)//here is to deal with each city
    {
        
    }
    [self setMapRegion];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation 
{
    static NSString *identifier = @"SimpleLocation"; 
    if([annotation isKindOfClass:[SimpleLocation class]])
    {
        //
        //  Customize the pin view...
        //
        SimpleLocation *location=(SimpleLocation *)annotation;
        MKPinAnnotationView *annonationView=(MKPinAnnotationView *)
        [self.mv dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if(annonationView==nil)
        {
            annonationView=[[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
        }
        
        else
        {
            annonationView.annotation=annotation;
        }
        
        annonationView.enabled=YES;
        annonationView.canShowCallout=YES;
        
        //
        //  Customize the pin color...  
        //
        if (location.type==0)
        {
            annonationView.pinColor = MKPinAnnotationColorRed;
        }
        else
        {
            annonationView.pinColor = MKPinAnnotationColorGreen;
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
            annonationView.leftCalloutAccessoryView = nil;
            //  TODO: mem leak?...
        }
        
        UIButton *rightButton=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        annonationView.rightCalloutAccessoryView=rightButton;
        
        return annonationView;
    }
    else
    {
        //  TODO: assert error...
        return nil;  
    }
    
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{

}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    SimpleLocation *annotation=view.annotation;
    /*
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"fd" message:annotation.name delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
     */
    djcAppDelegate *app=(djcAppDelegate *)[[UIApplication sharedApplication] delegate];
    [app doSearch:self :annotation.name];
}

#pragma mark -searchview mode...

-(void) showMap:(id)sender
{
    self.mv.hidden=NO;
    self.tv.hidden=YES;
    self.mode=SearchViewMap;
    self.button_MqpList.title=@"List";
}

-(void) showList:(id)sender
{
    self.mv.hidden=YES;
    self.tv.hidden=NO;
    self.mode=SearchViewList;
    self.button_MqpList.title=@"Map";
}
#pragma mark - button callbacks...


-(IBAction) buttonBackClicked:(id)sender
{
    [ self dismissModalViewControllerAnimated:YES ];
}

-(IBAction)buttonMapListClicked:(id)sender
{
    //self.tv.hidden=YES;
    //self.mv.hidden=NO;
    if(self.mode==SearchViewMap)
    {
        [self showList:sender];
    }
    else
    {
        [self showMap:sender];
    }
}

#pragma mark - Location Manager delegate...


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //  Get the user's location...
    CLLocationCoordinate2D location = [ newLocation coordinate ];
    
    //  Remember it...
    self.show_Default_location = location;
    
    //  Got it, stop the updates... 
    [ self.location_Manager stopUpdatingLocation];
    [ self refreshMap];
    
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
