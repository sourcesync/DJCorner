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
#import "AdsCell.h"
#import "LocalizedManager.h"


#define DEFAULT_LAT     40.730039
#define DEFAULT_LONG    -73.994358
#define RADIUS  20.000000

@implementation SearchView

@synthesize tv=_tv;
@synthesize mv=_mv;
@synthesize button_MqpList=_button_MqpList;
@synthesize cities=_cities;
@synthesize lati=_lati;
@synthesize longi=_longi;
@synthesize flags=_flags;
@synthesize mode=_mode;
@synthesize status=_status;
@synthesize location_Manager=_location_Manager;
@synthesize show_Default_location=_show_Default_location;
@synthesize eventsAround=_eventsAround;
@synthesize allEvents=_allEvents;
@synthesize modeList=_modeList;
@synthesize dataForTable=_dataForTable;
@synthesize mapListUpDown=_mapListUpDown;
@synthesize VIP=_VIP;
//leve
@synthesize button_Back;
@synthesize lb_search_by_city;
@synthesize button_map;
@synthesize button_list;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    djcAppDelegate *app = (djcAppDelegate *)[ [ UIApplication sharedApplication ] delegate];
    self.VIP=app.VIP;
    app.search_view = self;
    
    self.mv.delegate = self;
    self.mode=SearchViewList;
    self.modeList=1;
    
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
                   @"Hong Kong",
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
                @"52.368263",
                @"52.547131",
                @"44.504831",
                @"33.889521",
                @"52.547131",
                @"-34.601846",
                @"-27.020902",
                @"-15.564836",
                @"32.818265",
                @"28.648394",
                @"51.700363",
                @"25.304304",
                @"53.351781",
                @"43.773573",
                @"-27.582546",
                @"15.456327",
                @"-28.026531",
                @"26.914417",
                @"22.309426",
                @"38.912274",
                @"23.043089",
                @"36.130665",
                @"50.883326",
                @"51.516862",
                @"40.725405",
                @"34.083375",
                @"40.436495",
                @"53.485390",
                @"25.798037",
                @"45.518857",
                @"56.413901",
                @"19.090022",
                @"37.458508",
                @"40.732169",
                @"48.861327",
                @"14.539804",
                @"-34.963763",
                @"-22.866053",
                @"32.732996",
                @"33.749036",
                @"33.521934",
                @"37.582133",
                @"27.943232",
                @"1.295590",
                @"-33.963004",
                @"35.746512",
                @"43.664891",
                nil] autorelease];
    
    self.longi=[[[NSMutableArray alloc]
                 initWithObjects:
                 @"4.901276",
                 @"13.414307",
                 @"11.345444",
                 @"35.495496",
                 @"13.414307",
                 @"-58.370361",
                 @"-48.655701",
                 @"-56.094818",
                 @"-96.768265",
                 @"77.228394",
                 @"5.315666",
                 @"55.313416",
                 @"-6.267014",
                 @"11.256866",
                 @"-48.552704",
                 @"73.977644",
                 @"153.299103",
                 @"-80.114064",
                 @"114.125977",
                 @"1.432343",
                 @"120.662842",
                 @"-115.171738",
                 @"4.705582",
                 @"-0.129776",
                 @"-74.004593",
                 @"-118.240356",
                 @"-3.695526",
                 @"-2.249107",
                 @"-80.226631",
                 @"-73.555527",
                 @"37.221680",
                 @"72.875748",
                 @"25.327606",
                 @"-74.005280",
                 @"2.352791",
                 @"121.000929",
                 @"-54.948979",
                 @"-43.205109",
                 @"-117.158203",
                 @"-117.867680",
                 @"-111.924891",
                 @"126.975861",
                 @"34.365749",
                 @"103.857880",
                 @"151.208267",
                 @"139.691162",
                 @"-79.381714",
                 nil] autorelease];
    self.flags=[[[NSMutableArray alloc] 
                 initWithObjects:@"nl.png",
                 @"de.png",
                 @"ie.png",
                 @"lb.png",
                 @"de.png",
                 @"ar.png",
                 @"br.png",
                 @"br.png",
                 @"us.png",
                 @"in.png",
                 @"nl.png",
                 @"ae.png",
                 @"ie.png",
                 @"it.png",
                 @"br.png",
                 @"in.png",
                 @"au.png",
                 @"us.png",
                 @"hk.png",
                 @"es.png",
                 @"tw.png",
                 @"us.png",
                 @"be.png",
                 @"gb.png",
                 @"us.png",
                 @"us.png",
                 @"es.png",
                 @"gb.png",
                 @"us.png",
                 @"ca.png",
                 @"ru.png",
                 @"in.png",
                 @"gr.png",
                 @"us.png",
                 @"fr.png",
                 @"ph.png",
                 @"uy.png",
                 @"br.png",
                 @"us.png",
                 @"us.png",
                 @"us.png",
                 @"kr.png",
                 @"eg.png",
                 @"sg.png",
                 @"au.png",
                 @"jp.png",
                 @"ca.png",nil] autorelease];
    self.allEvents=[[NSMutableDictionary alloc] init];
    for(int i=0;i<self.lati.count;i++)
    {
        NSMutableDictionary *temp=[[[NSMutableDictionary alloc] init] autorelease];
        [temp setObject:[self.lati objectAtIndex:i] forKey:@"lat"];
        [temp setObject:[self.longi objectAtIndex:i] forKey:@"longi"];
        [temp setObject:[self.flags objectAtIndex:i] forKey:@"flag"];
        [temp setObject:[self.cities objectAtIndex:(i+1)] forKey:@"city"];
        [self.allEvents setObject:temp forKey:[NSString stringWithFormat:@"%d",i]];
    }
    
    self.show_Default_location=CLLocationCoordinate2DMake(DEFAULT_LAT, DEFAULT_LONG);
    self.location_Manager=[[CLLocationManager alloc] init];
    
    [self.location_Manager setDelegate:self ];
    if(self.dataForTable==nil)
    {
        self.dataForTable=[[NSMutableDictionary alloc] init];
    }
    self.dataForTable=self.allEvents;
    
    //leve
    self.button_MqpList.title=[LocalizedManager localizedString:@"map"];
    self.button_Back.title=[LocalizedManager localizedString:@"back"];
    self.lb_search_by_city.text=[LocalizedManager localizedString:@"searchbycity"];
    self.button_list.title=[LocalizedManager localizedString:@"list"];
    self.button_map.title=[LocalizedManager localizedString:@"map"];
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
    NSLog(@"fdsfdsfdsfdsfdsfdsfdsfdsfdsfdsfdsfdsfdsfdsfdsfdsfdsfdsf");
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
    //leve
    self.button_MqpList.title=[LocalizedManager localizedString:@"map"];
    self.button_Back.title=[LocalizedManager localizedString:@"back"];
    self.lb_search_by_city.text=[LocalizedManager localizedString:@"searchbycity"];
    self.button_list.title=[LocalizedManager localizedString:@"list"];
    self.button_map.title=[LocalizedManager localizedString:@"map"];
}



- (void)dealloc
{
    self.cities = nil;
    self.lati=nil;
    self.longi=nil;
    self.location_Manager=nil;
    self.eventsAround=nil;
    self.allEvents=nil;
    self.dataForTable=nil;
    
    //leve
    [button_Back release];
    [lb_search_by_city release];
    [button_map release];
    [button_list release];
    
    [super dealloc];
}


#pragma mark - table view delegates...


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#ifdef ADS
    //return [ self.cities count ]+self.cities.count/(ADSPOSITION+1) ;
    return  [self.allEvents count]+1+(self.dataForTable.count+1)/(ADSPOSITION+1)*self.modeList*self.VIP;
#else
    return  [self.allEvents count];
#endif
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [ indexPath row ];
#ifdef ADS
    if((self.modeList==1&&self.VIP==1)&&row>0&&(row+1)%(ADSPOSITION+1)==0)
    {
        UITableViewCell *ads=[tableView dequeueReusableCellWithIdentifier:[AdsCell reuseIdentifier]];
        if(ads==nil)
        {
            ads=[[[AdsCell alloc] init] autorelease];
        }
        
        AdsCell *cell=(AdsCell *)ads;
        
        cell.lb_adsContent.text=@"";
        [cell.iv setImage:[UIImage imageNamed:@"redbull.png"]];
        [cell.iv sizeToFit];
        return cell;
    }
    else
#endif
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 @"search_cell"];
        
        if (cell == nil) 
        {
            cell = [[[ UITableViewCell alloc] init] autorelease];
        }
        
        //[ cell.textLabel setText: [ self.cities objectAtIndex:(row-row/(ADSPOSITION+1)) ] ];
        if(row==0)
        {
            [cell.textLabel setText:@"All Cities"];
        }
        else
        {
#ifdef ADS
            [cell.textLabel setText:[[self.dataForTable valueForKey:
                [NSString stringWithFormat:@"%d",
                 (row-1-self.VIP*self.modeList*row/(ADSPOSITION+1))]] valueForKey:@"city"]];
#else
            [cell.textLabel setText:[[self.dataForTable valueForKey:
                                      [NSString stringWithFormat:@"%d", row]] valueForKey:@"city"]];
#endif
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = [ UIColor blackColor ];
        
        return cell;
    }
    
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
#ifdef ADS
    else if((self.modeList==1&&self.VIP==1)&&row>0&&(row+1)%(ADSPOSITION+1)==0)
    {
        return;
    }
#endif
    else
    {
        UITableViewCell *cell = [ self.tv cellForRowAtIndexPath:indexPath ];
        NSString *city = cell.textLabel.text;
        [ app doSearch:self:city];
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.modeList==0)
    {
        return 30;
    }
#ifdef ADS
    if((self.modeList==1&&self.VIP)&&(indexPath.row>0)&&((indexPath.row+1)%(ADSPOSITION+1)==0))
    {
        return 90.0f;
    }
#endif
    return 40;
}
 

#pragma map....
-(void) setMapRegion
{
    if(YES)
    {
        MKCoordinateSpan span=MKCoordinateSpanMake(100, 100);
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
    SimpleLocation *annonaion=[[[SimpleLocation alloc] initWithName] autorelease];
    annonaion.name=[NSString stringWithString:@"All cities"];
    annonaion.message=nil;
    annonaion.coordinate=coordidate;
    annonaion.pp=nil;
    annonaion.type=0;
    
    self.show_Default_location=CLLocationCoordinate2DMake(annonaion.coordinate.latitude, annonaion.coordinate.longitude);
    
    [self.mv addAnnotation:annonaion];
    
    
    //if((self.cities.count!=0)&&(self.longi.count==self.lati.count)&&(self.lati.count!=0))//here is to deal with each city
    if([self.eventsAround count]>0)
    {
        //for(int i=0;i<self.lati.count;i++)
        for(int i=0;i<self.eventsAround.count;i++)
        {
            CLLocationCoordinate2D coordidateCity;
            //coordidate.latitude=[[NSString stringWithFormat:@"%@",[self.lati objectAtIndex:i]] doubleValue];
            coordidateCity.latitude=[[NSString stringWithFormat:@"%@",[[self.eventsAround valueForKey:[NSString stringWithFormat:@"%d",i]] valueForKey:@"lat"]] doubleValue];
            //coordidate.longitude=[[NSString stringWithFormat:@"%@",[self.longi objectAtIndex:i]] doubleValue];   
            coordidateCity.longitude=[[NSString stringWithFormat:@"%@",[[self.eventsAround valueForKey:[NSString stringWithFormat:@"%d",i]] valueForKey:@"longi"]] doubleValue];
            
            SimpleLocation *annotationCity=[[[SimpleLocation alloc] initWithName] autorelease];
            annotationCity.name=[NSString stringWithFormat:@"%@",[[self.eventsAround valueForKey:[NSString stringWithFormat:@"%d",i]] valueForKey:@"city"]];
            annotationCity.coordinate=coordidateCity;
            annotationCity.message=nil;
            annotationCity.pp=[NSString stringWithFormat:@"%@",[[self.eventsAround valueForKey:[NSString stringWithFormat:@"%d",i]] valueForKey:@"flag"]];
            annotationCity.type=0;
            [self.mv addAnnotation:annotationCity];
            
        }
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

        if(location.type==0)
        {
            annonationView.pinColor=MKPinAnnotationColorRed;
        }
        else
        {
            annonationView.pinColor = MKPinAnnotationColorGreen;
        }
        
        if(location.pp!=nil)
        {
            UIImage *flag=[UIImage imageNamed:location.pp] ;
            float rate=flag.size.height/flag.size.width;
            UIImage *newFlag=[Utility imageWithImage:flag scaledToSize:CGSizeMake(12.0f/rate,12.0f)];
            [annonationView setImage:newFlag];
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
            //[ smaller release ];  // TODO: why does this crash ?
            
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
    if([annotation.name isEqualToString:@"All cities"])
    {
        [app doSearch:self :nil];
    }
    else
    {
        [app doSearch:self :annotation.name];
    }
    
}

#pragma mark -searchview mode...

-(void) showMap:(id)sender
{
    [self getEventAround:self.show_Default_location.latitude :self.show_Default_location.longitude];
    self.mv.hidden=NO;
    self.tv.hidden=NO;
    self.modeList=0;
    self.status=Middle;
    [self reSize];
    self.mode=SearchViewMap;
    self.button_MqpList.title=[LocalizedManager localizedString:@"list"];
    self.dataForTable=nil;
    self.dataForTable=[[NSMutableDictionary alloc] init];
    self.dataForTable=self.eventsAround;
    [self.tv performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    [self refreshMap];
}

-(void) showList:(id)sender
{
    self.modeList=1;
    [self.tv setFrame:CGRectMake(self.tv.frame.origin.x, self.mv.frame.origin.y, self.tv.frame.size.width, 390)];
    self.mv.hidden=YES;
    self.tv.hidden=NO;
    self.mode=SearchViewList;
    self.button_MqpList.title=[LocalizedManager localizedString:@"map"];
    self.dataForTable=nil;
    self.dataForTable=[[NSMutableDictionary alloc] init];
    self.dataForTable=self.allEvents;
    [self.tv performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
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

-(IBAction)showAllmap
{
    if(self.status!=Middle)
    {
        self.status=Middle;
    }
    else
    {
        self.status=MapAll;
    }
    [self reSize];
}

-(IBAction)showAlllist
{
    if(self.status!=Middle)
    {
        self.status=Middle;
    }
    else
    {
        self.status=ListAll;
    }
    [self reSize];
}

-(void)reSize
{
    if(self.status==Middle)
    {
        [self.mv setHidden:NO];
        [self.tv setHidden:NO];
        [self.tv setFrame:CGRectMake(self.tv.frame.origin.x,( self.mv.frame.origin.y+195+self.mapListUpDown.frame.size.height), self.tv.frame.size.width, (195))];
        [self.mv setFrame:CGRectMake(self.mv.frame.origin.x, self.mv.frame.origin.y, self.mv.frame.size.width, 195)];
        [self.mapListUpDown setFrame:CGRectMake(self.mapListUpDown.frame.origin.x, (self.mv.frame.origin.y+195), self.mapListUpDown.frame.size.width, self.mapListUpDown.frame.size.height)];
    }
    else if(self.status==MapAll)
    {
        [self.mv setHidden:NO];
        //[self.tv setFrame:CGRectMake(self.tv.frame.origin.x,( self.tv.frame.size.height/2+55), 0, 0)];
        [self.tv setHidden:YES];
        [self.mv setFrame:CGRectMake(self.mv.frame.origin.x, self.mv.frame.origin.y, self.mv.frame.size.width, (390-self.mapListUpDown.frame.size.height))];
        [self.mapListUpDown setFrame:CGRectMake(self.mapListUpDown.frame.origin.x, (self.mv.frame.origin.y+self.mv.frame.size.height), self.mapListUpDown.frame.size.width, self.mapListUpDown.frame.size.height)];
    }
    else
    {
        [self.tv setHidden:NO];
        [self.tv setFrame:CGRectMake(self.mv.frame.origin.x,self.mv.frame.origin.y+self.mapListUpDown.frame.size.height, self.tv.frame.size.width, (390-self.mapListUpDown.frame.size.height))];
        //[self.mv setFrame:CGRectMake(self.mv.frame.origin.x, self.mv.frame.origin.y, 0, 0)];
        [self.mv setHidden:YES];
        [self.mapListUpDown setFrame:CGRectMake(self.mv.frame.origin.x, self.mv.frame.origin.y, self.mapListUpDown.frame.size.width, self.mapListUpDown.frame.size.height)];
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[LocalizedManager localizedString:@"location_prompt"] 
                                                    message:[LocalizedManager localizedString:@"turn_on_location_serve"]
                                                   delegate:nil 
                                          cancelButtonTitle:[LocalizedManager localizedString:@"cancel"] 
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

-(void)getEventAround:(double)lat :(double)longi
{
    if(self.eventsAround==nil)
    {
        self.eventsAround=[[NSMutableDictionary alloc] init];
    }
    int count=0;
    for(int i =0;i<self.lati.count;i++)
    {
        double latI=[[self.lati objectAtIndex:i] doubleValue];
        double lonI=[[self.longi objectAtIndex:i] doubleValue];
        if((latI>(lat-RADIUS))&&(latI<(lat+RADIUS))&&(lonI>(longi-RADIUS))&&(lonI<(longi+RADIUS)))
        {
            NSMutableDictionary *temp=[[[NSMutableDictionary alloc] init] autorelease];
            [temp setObject:[NSString stringWithFormat:@"%f",latI] forKey:@"lat"];
            [temp setObject:[NSString stringWithFormat:@"%f",lonI] forKey:@"longi"];
            [temp setObject:[self.flags objectAtIndex:i] forKey:@"flag"];
            [temp setObject:[self.cities objectAtIndex:(i+1)] forKey:@"city"];
            [self.eventsAround setObject:temp forKey:[NSString stringWithFormat:@"%d",count++]];
            //[self.eventsAround setObject:temp forKey:[self.cities objectAtIndex:(i+1)]];
        }
    }
    
}


@end
