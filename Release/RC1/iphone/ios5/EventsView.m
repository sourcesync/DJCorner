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
#import "MapEventCell.h"
#import "LocalizedManager.h"

#define DEFAULT_LAT     40.730039
#define DEFAULT_LONG    -73.994358

@implementation EventsView

//  IBOUTLET...
@synthesize tv=_tv;
@synthesize mv=_mv;
@synthesize segmentDJ=_segmentDJ;
@synthesize tb=_tb;
@synthesize buttonMapList=_buttonMapList;
@synthesize activity=_activity;
@synthesize header=_header;
@synthesize back_from;
//leve
@synthesize buttonCity;
@synthesize lb_events;

//  RETAIN...
@synthesize location_manager=_location_manager;
@synthesize longPressGesture;
@synthesize me_annotation;
@synthesize cur_search=_cur_search;
@synthesize getter=_getter;

//  ASSIGN...
@synthesize all_djs;
@synthesize mode=_mode;
@synthesize got_first_location=_got_first_location;
@synthesize got_first_events=_got_first_events;
@synthesize my_last_location=_my_last_location;
@synthesize VIP=_VIP;
@synthesize scrolling=_scrolling;
@synthesize refresh=_refresh;
@synthesize sort_criteria=_sort_criteria;
@synthesize get_mode=_get_mode;

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
    self.longPressGesture = nil;
    self.me_annotation = nil;
    
    //leve
    [lb_events release];
    [buttonCity release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [ self.getter cancel];
    [ self.getter removeCache ];
}

#pragma mark - View lifecycle...

- (void) newGetter:(NSString *)cur_search
{
    if (self.getter!=nil)
    {
        [ self.getter finished ];
        self.getter = nil;
    }
    self.getter = [ [ [ EventsGetter alloc ] init ] autorelease ]; //ANA
    
    self.getter.sort_criteria = self.sort_criteria;
    self.getter.cur_city_search = cur_search;
    self.getter.delegate = self;
    self.getter.latitude = self.my_last_location.latitude;
    self.getter.longitude = self.my_last_location.longitude;
    self.getter.all_djs = self.all_djs;
    self.get_mode = EventGetPaused;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    djcAppDelegate *app = (djcAppDelegate *)[ [ UIApplication sharedApplication ] delegate];
    self.VIP=app.VIP;
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
    self.tv.rowHeight = [ EventCell height ];
    
    //leve
    self.buttonMapList.title=[LocalizedManager localizedString:@"map"];
    self.buttonCity.title=[LocalizedManager localizedString:@"city"];
    self.lb_events.text=[LocalizedManager localizedString:@"event"];
    
    //  map view init...
    
#if 0
    //  gesture init...
    longPressGesture = [ [[UILongPressGestureRecognizer alloc] 
                          initWithTarget:self 
                        action:@selector(handleLongPressGesture:)] autorelease ];
    [self.mv addGestureRecognizer:longPressGesture];
    //[longPressGesture release];
#endif
    
    //  start in list mode...
    [ self showList ];
    
    //  refresh views...
    [ self updateViews ];
    
    self.all_djs = NO;
    self.segmentDJ.selectedSegmentIndex=1;
    [ self.segmentDJ addTarget:self action:@selector(segmentDJClicked:) 
               forControlEvents:UIControlEventValueChanged ];
    
    self.refresh = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    djcAppDelegate *app=(djcAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.VIP=app.VIP;
    [self.tv 
        performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
    if ( self.back_from )
    {
        self.tv.hidden = NO;
    }
    else
    {
        if (self.refresh)
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
            NSString *txt = [LocalizedManager localizedString:@"event"];
            if (self.cur_search!=nil)
            {
                txt = [ NSString stringWithFormat:@"Events In %@", self.cur_search ];
            }
            [ self.header setText:txt ];
    
            [ self showList ];
        }
        else
        {
            [ self.tv setHidden:NO];
        }
    }
    
    //leve
    self.buttonMapList.title=[LocalizedManager localizedString:@"map"];
    self.buttonCity.title=[LocalizedManager localizedString:@"city"];
    self.lb_events.text=[LocalizedManager localizedString:@"event"];
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
        if (self.refresh)
        {
            if (!self.got_first_events)
            {
                //  Schedule a default refresh in the future,
                //  in case location manager fails...
                [self performSelector:@selector(refreshFirstTime:) 
                           withObject:self afterDelay:3 ];
            }
            else
            {
                if (self.mode == EventViewMapOnly ) [ self showMap ];
                else [ self showList ];
                self.activity.hidden = YES;
                [ self.activity stopAnimating ];
            }
            self.refresh = NO;
        }
        else // possibly continue paused actions...
        {
            if ( self.getter && ( self.get_mode == EventGetPaused ) )
            {
                self.get_mode = EventGetGetting;
                [ self.getter getNext ];
            }
        }
    }
    
    self.scrolling = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    
    self.tv.hidden = YES;
    
    if (self.get_mode != EventGetDone )
    {
        self.get_mode = EventGetPaused;
        [ self.getter cancel ];
    }
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
    self.get_mode = EventGetPaused;
    
    if (self.mode == EventViewMapOnly ) [ self showMap ];
    else [ self showList ];
    self.activity.hidden = YES;
    [ self.activity stopAnimating ];
    
    [ Utility AlertMessage:[LocalizedManager localizedString:@"api_called_fail"]];   
    [ self updateViews ];
}

-(void) got_events:(NSInteger)start:(NSInteger)end
{
    self.get_mode = EventGetPaused;
    
    if (!self.activity.hidden)
    {
        // stop activity indicator if running...
        self.activity.hidden = YES;
        [ self.activity stopAnimating ];
        
        if (self.mode == EventViewMapOnly ) [ self showMap ];
        else [ self showList ];
    }
    
    //  update the view...
    [ self updateViews ];
    
    self.got_first_events = YES;
    
    //  continue to get more...
    if (!self.getter.got_all)
    {
        self.get_mode = EventGetGetting;
        [ self.getter getNext ];
    }
    else
    {
        self.get_mode = EventGetDone;
    }
}

-(void) got_pic:(UIImageForCell *)img
{
    //  Update the image only if not scrolling...
    if ( !self.scrolling )
    {
        //  If image is valid update the related cell...
        if (img.status==0)
        {
            //  Get the row index...
            int row = [ img.idx integerValue ];
            
            //  Path for this row...
            NSIndexPath *path = [ NSIndexPath indexPathForRow:row inSection:0 ];
            
            //  Get the cell for this row...
            UITableViewCell *tcell = [ self.tv cellForRowAtIndexPath:path ];
            EventCell *cell = (EventCell *)tcell;
            
            //  Set image...
            cell.icon.hidden = NO;
            [ cell.icon setImage:img.img ];
            
            //  Turn off loading anim...
            [ cell.activity stopAnimating ];
            cell.activity.hidden = YES;
        }
    }
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
    self.mode = EventViewListOnly;
    
    [self newGetter:cur_search ];
    self.get_mode = EventGetGetting;
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
    
    if ( !self.scrolling )
    {
        [ self loadImagesForOnscreenRows ];
    }
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
    self.mv.frame = CGRectMake(0, 87, 320, 324);
    self.tv.hidden = YES;
    self.mode = EventViewMapOnly; 
    self.buttonMapList.title = [LocalizedManager localizedString:@"map"];
}

-(void) showList
{
    self.mv.hidden = YES;
    self.tv.hidden = NO;
    self.tv.frame = CGRectMake(0, 87, 320, 324);
    self.mode = EventViewListOnly;
    self.buttonMapList.title = @"list/map";
    //self.buttonMapList.title = [LocalizedManager localizedString:@"map"];
    [ self.tv reloadData ];

}

-(void) showMapList
{
    self.mv.hidden = NO;
    self.tv.hidden = NO;
    self.mv.frame = CGRectMake(0, 87, 320, 170);
    self.tv.frame = CGRectMake(0, 257, 320, 154);
    self.mode = EventViewListMap;
    self.buttonMapList.title = @"map";
    self.sort_criteria = 1;
}
 
-(void) getMore
{
    self.get_mode = EventGetGetting;
    [ self.getter getNext ];
}

-(void)loadImageForRow: (EventCell *)tcell: (NSIndexPath *)path
{
    int row = [ path row ];
    NSNumber *idx = [ NSNumber numberWithInt:row ];
    
    //  If type DJcell...
    if ( [ tcell isKindOfClass: [ EventCell class ] ] )
    {
        EventCell *evc = (EventCell *)tcell;
        
        //  See if its in cache...
        UIImage *img = [ self.getter getCachePic:idx ];
        if (img)
        {
            evc.icon.image = img;
            [evc.activity setHidden:YES];
            [evc.icon setHidden:NO];
        }
        //  Else launch async loading if not scrolling...
        else if (! self.scrolling )
        {
            int row = [ path row ];
            
            //NSLog(@"async get pic! %d", row);
            //  Get info for this cell...
#ifdef EVENTS_ADS
            Event *ev = [ self.getter.events objectAtIndex:(row-row/(ADSPOSITION+1)*self.VIP) ];
#else
            Event *ev = [ self.getter.events objectAtIndex:row ];
#endif
            
            //NSLog(@"after evinfo %@ %@", ev.pic_path, idx);
            
            if (ev.pic_path )
            {
                //  Launch the getter...
                [ self.getter asyncGetPic:ev.pic_path:idx ];
                [evc.activity setHidden:NO];
                [evc.activity startAnimating];
                [evc.icon setHidden:YES ];
            }
        }
    }
}

-(void)loadImagesForOnscreenRows
{
    //  Get all visible cell paths...
    NSArray *paths = [ self.tv indexPathsForVisibleRows ];
    for ( int i=0; i< [paths count];i++)
    {
        //  Get path for cell...
        NSIndexPath *path = [ paths objectAtIndex:i ];
        
        UITableViewCell *cell = [ self.tv cellForRowAtIndexPath:path ];
        
        if ( [ cell isKindOfClass:[ EventCell class ] ] )
        {
            EventCell *ecell = (EventCell *)cell;
            
            [ self loadImageForRow:ecell:path ];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ( !self.tv.hidden )
    {
        self.scrolling = YES;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.scrolling = NO;
    
    if ( self.mode == EventViewListOnly )
    {
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.scrolling = NO;
    
    if ( self.mode == EventViewListOnly )
    {
        [self loadImagesForOnscreenRows];
    }
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
        
        if ( self.mode == EventViewListMap )
        {
            return count;
        }
        else
        {
#ifdef EVENTS_ADS
            return count+count/(ADSPOSITION+1)*self.VIP;
#else
            return count;
#endif
        }
    }
}


- (UITableViewCell *) cellForRowAtIndexPath_ListOnly:(UITableView *)tableView:(NSIndexPath *)indexPath
{
    if ( self.getter.connectionProblem )
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 @"noitem_cell"];
        if (cell == nil) 
        {
            cell = [[[ UITableViewCell alloc] init] autorelease];
        }
        cell.textLabel.text = [LocalizedManager localizedString:@"connection_problem"];
        cell.textLabel.font = [ UIFont boldSystemFontOfSize:17 ];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.textColor = [ UIColor blackColor ];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        cell.textLabel.text = @""; //@"Please Wait...";
        //cell.textLabel.text = [LocalizedManager localizedString:@"wait"];
        cell.textLabel.font = [ UIFont boldSystemFontOfSize:17 ];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.textColor = [ UIColor blackColor ];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        cell.textLabel.text = [LocalizedManager localizedString:@"no_event"];
        cell.textLabel.font = [ UIFont boldSystemFontOfSize:17 ];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.textColor = [ UIColor blackColor ];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;     
    }
    else
    {
        NSInteger row = ([ indexPath row ]);
        
#ifdef EVENTS_ADS
        //add ads....
        if((self.VIP==1)&&(row>0)&&((row+1)%(ADSPOSITION+1)==0))
        {
            UITableViewCell *ads=[tableView dequeueReusableCellWithIdentifier:[AdsCell reuseIdentifier]];
            
            if(ads==nil)
            {
                ads=[[[AdsCell alloc] init]autorelease ];
            }
            
            AdsCell *cell=(AdsCell *)ads;
            cell.lb_adsContent.text=@"hello,ads";
            [cell.iv setImage:[UIImage imageNamed:@"redbull.png"]];
            [cell.iv sizeToFit];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if ( row ==( [ self.getter.events count] +row/(ADSPOSITION+1)*self.VIP))  // get more button...
#else
        if ( row ==( [ self.getter.events count] ) ) // getting more button...
#endif
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                     @"getmore_cell"];
            if (cell == nil) 
            {
                cell = [[[ UITableViewCell alloc] init] autorelease];
            }
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.textLabel.font = [ UIFont boldSystemFontOfSize:17 ];
            cell.textLabel.text = [LocalizedManager localizedString:@"get_more_event"];
            cell.textLabel.textColor = [ UIColor blackColor ];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.textLabel.textColor = [ UIColor blackColor ];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            //cell.content.textColor=[UIColor blackColor];
            //cell.content.font=[UIFont systemFontOfSize:17];
            
            int row = [ indexPath row ];
#ifdef EVENTS_ADS
            Event *event = [ self.getter.events objectAtIndex:(row-row/(ADSPOSITION+1)*self.VIP) ];
#else
            Event *event = [ self.getter.events objectAtIndex:row ];
#endif
         
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
            
            //  Get dj pic or use default?...
            cell.icon.image = nil; // clear reused image just in case...
            if ( event.pic_path )
            {
                //NSLog(@"%@", event.pic_path);
                [ self loadImageForRow:cell:indexPath ];
            }
            else
            {
                UIImage *imgAll = [ UIImage imageNamed:@"Genericthumb2.png" ];
                cell.icon.image = imgAll;
            }

        
            return cell;   
        }
    }
}


-(UITableViewCell *) cellForRowAtIndexPath_MapList:(UITableView *)tableView:(NSIndexPath *)indexPath
{
    UITableViewCell *cl = [tableView dequeueReusableCellWithIdentifier:
                           [ MapEventCell reuseIdentifier ]];
    if (cl == nil) 
    {
        cl = [[[ MapEventCell alloc] init] autorelease];
    }
    
    MapEventCell *cell = (MapEventCell *)cl;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.textLabel.textColor = [ UIColor blackColor ];
    
    int row = [ indexPath row ];
    
    Event *event = [ self.getter.events objectAtIndex:row ];

    UIImage *img = [ UIImage imageNamed:@"ad" ];
    cell.icon.image = img;
    cell.icon.contentMode = UIViewContentModeScaleAspectFit;
    cell.lbl.text = event.name;
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.mode == EventViewListOnly )
    {
        return [ self cellForRowAtIndexPath_ListOnly:self.tv:indexPath ];
    }
    else if (self.mode == EventViewListMap )
    {
        return [ self cellForRowAtIndexPath_MapList:self.tv:indexPath ];
    }
    else
    {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( self.mode == EventViewListMap )
    {
        return 44.0;
    }
    else
    {
#ifdef EVENTS_ADS
        if ( (self.getter.events ==nil)||([self.getter.events count]==0)||
        ([self.getter.events count]==([indexPath row]-indexPath.row/(ADSPOSITION+1)*self.VIP)))
        {
            return 44;
        }
        else if((self.VIP==1)&&indexPath.row>0&&((indexPath.row+1)%(ADSPOSITION+1)==0))
        {
            return 90.0f;
        }
        else
        {
            return 75.0f;
        }
#else
        if ( (self.getter.events ==nil)||([self.getter.events count]==0)||
        ([self.getter.events count]==([indexPath row])) )
        {
            return 44;
        }
        else
        {
            return [ EventCell height ];
        }
#endif
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
    
    //[ Utility AlertMessage:@"yo" ];
    //return;
    
#ifdef EVENTS_ADS
    if((self.VIP==1)&&row>0&&((row+1)%(ADSPOSITION+1)==0))
    {
        return;
    }
    else if (row == ([self.getter.events count]+self.getter.events.count/(ADSPOSITION+1)*self.VIP) )
#else
       if (row == ([self.getter.events count]))
#endif
    {
        [ self getMore ];
    }
    else
    {
#ifdef EVENTS_ADS
        Event *ev = [ self.getter.events objectAtIndex:(row-row/(ADSPOSITION+1)*self.VIP) ];
#else
        Event *ev = [ self.getter.events objectAtIndex:row ];
#endif
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

#pragma mark - gesture delegate stuff...


-(void)handleLongPressGesture:(UIGestureRecognizer*)sender 
{
    
    // This is important if you only want to receive one tap and hold event
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        //[self.mv removeGestureRecognizer:sender];
    }
    else
    {
#if 1
        // Here we get the CGPoint for the touch and convert it to latitude and longitude coordinates to display on the map
        CGPoint point = [sender locationInView:self.mv];
        CLLocationCoordinate2D locCoord = 
        [self.mv convertPoint:point toCoordinateFromView:self.mv];
        // Then all you have to do is create the annotation and add it to the map
        // YourAnnotation *dropPin = [[YourAnnotation alloc] init];
        if (self.me_annotation)
        {
            self.me_annotation.coordinate = locCoord;
        }
        
        //dropPin.latitude = [NSNumber numberWithDouble:locCoord.latitude];
        //dropPin.longitude = [NSNumber numberWithDouble:locCoord.longitude];
        //[self.mv addAnnotation:dropPin];
        //[dropPin release];
#endif
        
    }
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
    if ( self.me_annotation == nil )
    {
        self.me_annotation = [ [ [ SimpleLocation alloc ] initWithName ] autorelease ];
    }
    
    self.me_annotation.name = [ NSString stringWithString:[LocalizedManager localizedString:@"your_location"] ];
    self.me_annotation.message = nil;
    self.me_annotation.coordinate = coordinate;
    self.me_annotation.pp = nil;
    self.me_annotation.type=0;
    [ self.mv addAnnotation:self.me_annotation];
    
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

#if 0
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    //[ self.mv deselectAnnotation:view.annotation animated:NO ];
}
#endif

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
        //annotationView.draggable = YES;
        
        
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
    [ Utility AlertMessage:@"This feature is not yet implemented." ];
    
#if 0
    [ self.getter cancel ];
    
    djcAppDelegate *app = 
        ( djcAppDelegate *)[ [ UIApplication sharedApplication] delegate];
    
    
    [ app showSearchLocationBased:self ];
#endif
}


-(IBAction)buttonMapListClicked:(id)sender
{
    [ Utility AlertMessage:@"This feature is not yet implemented." ];
#if 0
    if (self.mode == EventViewListOnly )
    {
        [ self showMapList ];
    }
    else if ( self.mode == EventViewMapOnly )
    {
        [ self showList ];
    }
    else
    {
        [ self showMap ];
    }
#endif
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[LocalizedManager localizedString:@"location_prompt"] 
                                                    message:[LocalizedManager localizedString:@"turn_on_location_serve"]
                                                   delegate:nil 
                                          cancelButtonTitle:[LocalizedManager localizedString:@"cancel"] 
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}


@end
