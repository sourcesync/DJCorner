//
//  EventSearchLocationBased.m
//  djc
//
//  Created by George Williams on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventSearchLocationBased.h"
#import "SimpleLocation.h"

#define DEFAULT_LAT     40.730039
#define DEFAULT_LONG    -73.994358

@implementation EventSearchLocationBased

//  ASSIGN...
@synthesize mode=_mode;

//  RETAIN...
@synthesize cities=_cities;
@synthesize lati=_lati;
@synthesize longi=_longi; 
@synthesize flags=_flags;

//  IBOUTLET...
@synthesize cancelButton=_cancelButton;
@synthesize okButton=_okButton;
@synthesize tv=_tv;
@synthesize mv=_mv;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - button delegates...


-(IBAction)cancelClicked:(id)sender
{
    [ self dismissModalViewControllerAnimated:YES ];
}

-(IBAction)okClicked:(id)sender
{
    [ self dismissModalViewControllerAnimated:YES ];
}

#pragma mark - map view delegate and funcs...


-(void)refreshMap
{
    //remove exists annotations
    for(id<MKAnnotation> annotation in self.mv.annotations)
    {
        [self.mv removeAnnotation:annotation];
    }
    
    //get this user's locaation...
    CLLocationCoordinate2D coordidate;
    coordidate.latitude=DEFAULT_LAT;
    coordidate.longitude=DEFAULT_LONG;
    
    //create this user's annonation
    SimpleLocation *annotation=[[[SimpleLocation alloc] initWithName] autorelease];
    annotation.name=[NSString stringWithString:@"All cities"];
    annotation.message=nil;
    annotation.coordinate=coordidate;
    annotation.pp=nil;
    annotation.type=0;
    
    //self.show_Default_location=CLLocationCoordinate2DMake(annotation.coordinate.latitude, annotation.coordinate.longitude);
    
    [self.mv addAnnotation:annotation];
    
#if 1
    //if((self.cities.count!=0)&&(self.longi.count==self.lati.count)&&(self.lati.count!=0))//here is to deal with each city
    //if([self.eventsAround count]>0)
    {
        for(int i=1;i<self.lati.count;i++)
        //for(int i=0;i<self.eventsAround.count;i++)
        {
            //CLLocationCoordinate2D coordidateCity;
            coordidate.latitude=
                [[NSString stringWithFormat:@"%@",[self.lati objectAtIndex:i]] doubleValue];
            //coordidateCity.latitude=[[NSString stringWithFormat:@"%@",[[self.eventsAround valueForKey:[NSString stringWithFormat:@"%d",i]] valueForKey:@"lat"]] doubleValue];
            coordidate.longitude=
                [[NSString stringWithFormat:@"%@",[self.longi objectAtIndex:i]] doubleValue];   
            //coordidateCity.longitude=[[NSString stringWithFormat:@"%@",[[self.eventsAround valueForKey:[NSString stringWithFormat:@"%d",i]] valueForKey:@"longi"]] doubleValue];
            
            SimpleLocation *annotationCity=
                [[[SimpleLocation alloc] initWithName] autorelease];
            //annotationCity.name=[NSString stringWithFormat:@"%@",[[self.eventsAround valueForKey:[NSString stringWithFormat:@"%d",i]] valueForKey:@"city"]];
            annotationCity.name=[   NSString stringWithFormat:@"%@", 
                                 [ self.cities objectAtIndex:i ] ];
                                   
            annotationCity.coordinate= coordidate; // coordidateCity;
            annotationCity.message=nil;
            //annotationCity.pp=[NSString stringWithFormat:@"%@",[[self.eventsAround valueForKey:[NSString stringWithFormat:@"%d",i]] valueForKey:@"flag"]];
            annotationCity.type=0;
            [self.mv addAnnotation:annotationCity];
            
        }
    }
    
    //[self setMapRegion];
#endif
    
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
            //UIImage *newFlag=[Utility imageWithImage:flag scaledToSize:CGSizeMake(12.0f/rate,12.0f)];
            //[annonationView setImage:newFlag];
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
#if 0
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
#endif
}


#pragma mark - table view delegates...

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ self.cities count ] - 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:@"citycell"];
    if(cell==nil)
    {
        cell =[[[UITableViewCell alloc] init] autorelease];
    }
    int row = [ indexPath row ];
    
    cell.textLabel.text = [ self.cities objectAtIndex:(row + 1) ];
    
    return cell;
}
        

#pragma mark - View lifecycle

- (void) initGeoData
{
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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //djcAppDelegate *app = (djcAppDelegate *)[ [ UIApplication sharedApplication ] delegate];
    //self.VIP=app.VIP;
    //app.search_view = self;
    
    
    //self.mode=SearchViewList;
    //self.modeList=1;
    
    [ self initGeoData ];
    
    [ self.tv setDelegate:self ];
    [ self.tv setDataSource:self ];    
    
    
    self.mv.delegate = self;
    [ self refreshMap ];
    
    /*
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
     */
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
