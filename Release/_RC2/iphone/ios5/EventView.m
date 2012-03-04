//
//  EventView.m
//  alpha2
//
//  Created by George Williams on 11/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EventView.h"
#import "Utility.h"
#import "djcAppDelegate.h"
#import "LocalizedManager.h"

@implementation EventView

@synthesize cell_title=_cell_title;
@synthesize cell_description=_cell_description;
@synthesize cell_date=_cell_date;
@synthesize cell_buy=_cell_buy;
@synthesize tv=_tv;
@synthesize pic=_pic;
@synthesize label_title=_label_title;
@synthesize label_description=_label_description;
@synthesize delegate=_delegate;
@synthesize button_back=_button_back;
@synthesize event=_event;
@synthesize api=_api;
@synthesize connectionProblem=_connectionProblem;
@synthesize eoid=_eoid;
@synthesize button_buy_now=_button_buy_now;
@synthesize activity=_activity;
@synthesize label_date=_label_date;
@synthesize button_save=_button_save;
@synthesize label_venue=_label_venue;
@synthesize cell_venue=_cell_venue;
@synthesize eventStore=_eventStore;
@synthesize defaultCalendar=_defaultCalendar;
@synthesize eventid=_eventid;
@synthesize button_follow=_button_follow;
@synthesize follow_view=_follow_view;
@synthesize get_eid=_get_eid;
@synthesize parent=_parent;
@synthesize back_from;
@synthesize gcount;
//leve
@synthesize bt_map;
@synthesize lb_web_ticket;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        self.api = [ [ [ DJCAPI alloc ] init:self ] autorelease ];
        //self.api = [ [ DJCAPI alloc ] init:self ];
    }
    return self;
}

-(id) init
{
    self = [ self initWithNibName:@"EventView" bundle:nil ];
    return self;
}

- (void)dealloc
{
    self.api = nil;
    self.eoid = nil;
    self.defaultCalendar = nil;
    self.eventStore = nil;
    self.event = nil;
    self.get_eid = nil;
    self.parent = nil;
    
    //leve
    [bt_map release];
    [lb_web_ticket release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [ self.tv setDelegate:self];
    [ self.tv setDataSource:self];
    //[ self.tv reloadData ];
    
    // Initialize an event store object with the init method. Initialize the array for events.
	self.eventStore = [ [[EKEventStore alloc] init] autorelease ]; //gw-analyze
	
	// Get the default calendar from store.
	self.defaultCalendar = [self.eventStore defaultCalendarForNewEvents];
    
    //leve
    self.button_back.title=[LocalizedManager localizedString:@"back"];
    [self.button_buy_now setTitle:[LocalizedManager localizedString:@"tickets"] forState:UIControlStateNormal];
    [self.bt_map setTitle:[LocalizedManager localizedString:@"map_it"] forState:UIControlStateNormal];
    [self.button_save setTitle:[LocalizedManager localizedString:@"save_date"] forState:UIControlStateNormal];
    self.lb_web_ticket.text=[LocalizedManager localizedString:@"web_site"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated ];
    
    if (self.back_from)
    {
        
    }
    else
    {
        [ self.tv setHidden:YES];
        [ self.activity startAnimating ];
    }
    
    //leve
    self.button_back.title=[LocalizedManager localizedString:@"back"];
    [self.button_buy_now setTitle:[LocalizedManager localizedString:@"tickets"] forState:UIControlStateNormal];
    [self.bt_map setTitle:[LocalizedManager localizedString:@"map_it"] forState:UIControlStateNormal];
    [self.button_save setTitle:[LocalizedManager localizedString:@"save_date"] forState:UIControlStateNormal];
    self.lb_web_ticket.text=[LocalizedManager localizedString:@"web_site"];
}

-(void)viewDidAppear:(BOOL)animated
{
    [ super viewDidAppear:animated];
    
    if (self.back_from)
    {
        self.back_from = NO;
    }
    else
    {
        if ( self.get_eid != nil )
        {
            NSMutableDictionary *loc = 
            [ [[NSMutableDictionary alloc] initWithCapacity:0 ] autorelease ];
            
            if ( ! [self.api get_event:loc :self.get_eid ] )
            {
                [ Utility AlertAPICallFailed ];
            }
             
        }
        else
        {
            self.tv.hidden = NO;
            [ self.activity stopAnimating ];
            [ self.tv reloadData ];
        }
    }
}

#pragma mark - table view delegates...


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.event==nil)
    {
        return 0;
    }
    else
    {
        return 5;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = [ indexPath section ];
    
    if ( section == 0 )
    {
        //  Set title...
        self.label_title.text = self.event.name;
        
        //  Set pic...
        NSURL *url = [ NSURL URLWithString:self.event.pic_path ];
        NSData *data = [ NSData dataWithContentsOfURL:url ];
        UIImage *img = [ UIImage imageWithData:data ];
        [ self.pic setImage:img ];
        
        self.cell_title.selectionStyle = UITableViewCellSelectionStyleNone;
        return self.cell_title;
    }
    else if ( section == 1 )
    {
        //  event performers...
        NSString *str = @"";
#if 1
        for ( int i=0;i< [ self.event.performers count ] ;i++)
        {
            if (i==0) str = [ self.event.performers objectAtIndex:0 ];
            else str = [ NSString stringWithFormat:@"%@,%@", str, 
                        [ self.event.performers objectAtIndex:i ] ];
        }
        self.label_description.text = str;
        self.label_description.font = [ UIFont boldSystemFontOfSize:17 ];
        self.cell_description.selectionStyle = UITableViewCellSelectionStyleBlue;
#endif
        return self.cell_description;
    }
    else if ( section == 2 )
    {
        self.label_date.text = self.event.datestr;
        self.label_date.font = [ UIFont systemFontOfSize:17 ];
        self.cell_date.selectionStyle = UITableViewCellSelectionStyleNone;
        return self.cell_date;
    }
    else if ( section == 3 )
    {
        self.label_venue.text = [ NSString stringWithFormat:@"%@, %@",
                                 self.event.venue, self.event.city ];
        self.label_venue.font = [ UIFont systemFontOfSize:17 ];
        self.cell_venue.selectionStyle = UITableViewCellSelectionStyleNone;
        return self.cell_venue;
    }
    else if ( section == 4 )
    { 
#if 0
        BuyCell *cell = (BuyCell *)[tableView dequeueReusableCellWithIdentifier:@"buy_cell"];
        if (cell == nil) 
        {
            cell = [[[ BuyCell alloc] init] autorelease];
        }
        return cell;
#endif
        //self.cell_buy.selectionStyle = UITableViewCellSeparatorStyleNone;
        //self.cell_buy.backgroundColor = [ UIColor blackColor ];
        //self.cell_buy.contentView.backgroundColor = [ UIColor blackColor ];
        return self.cell_buy;
    }
    else
    {
        return nil;
    }
}


- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = [ indexPath section ];
    
    if ( section == 0)
    {
        return 80.0f;
    }
    else if ( section == 1)
    {
        return 80.0f;
    }
    else
    {
        return 44.0f;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [ tableView deselectRowAtIndexPath:indexPath animated:YES ];
    
    int section = [ indexPath section ];
    
    if ( section == 1 )
    {
        if ( (self.event.performers ==nil ) || ( [ self.event.performers count] == 0 ) )
        {
            [ Utility AlertMessage:@"No one can be followed at this time." ];
            //[ narr release ];
        }
        else
        {   
            if ( [ self.event.performers count ] ==1 )
            {
                NSString *djid = [ self.event.pfids objectAtIndex:0 ];
                djcAppDelegate *app = ( djcAppDelegate *)
                    [ [ UIApplication sharedApplication ] delegate ];
                [ app showDJItemModal:self :nil :djid ];
            }
            else
            {
                self.follow_view = [ [ [ DJSelectView alloc ] init ] autorelease ]; //ANA
                self.follow_view.event = self.event;
                self.follow_view.parent = self;
                [ self presentModalViewController:self.follow_view animated:YES ];
            }
        }
    }
}

#pragma mark - api delegate stuff...


#pragma mark - djcapi...

-(void) apiLoadingFailed:(NSString *)errMsg
{
    [ Utility AlertAPICallFailedWithMessage:errMsg ];
    self.connectionProblem = YES;
    [ self updateView ];
}

-(void) got_event:(NSDictionary *)data
{
    NSInteger status = [ [ data objectForKey:@"status" ] integerValue ];
    if (status>0)
    {
        NSDictionary *results = [ data objectForKey:@"results" ];
        self.event = [ Event ParseFromAPIEvent:results ];
        self.get_eid = nil;
        [ self.tv setHidden:NO ];
        [ self.activity stopAnimating ];
        [ self updateView ]; 
    }
    else
    {
        [ Utility AlertAPICallFailedWithMessage:@"API Call Return Bad Status." ];
        self.connectionProblem = YES;
        self.event = nil;
        [ self.activity stopAnimating ];
    }
}

-(void) got_pic:(UIImageForCell *)ufc
{
   
}

#pragma mark - public func...

-(void) updateView
{
    [ self.tv reloadData ];
}

#pragma mark - button callbacks...

-(IBAction) backButton: (id)sender
{
    if (self.parent && [ self.parent isKindOfClass:[ EventsView class ] ])
    {
        EventsView *eview = (EventsView *)self.parent;
        eview.back_from = YES;
    }
    else if (self.parent && [ self.parent isKindOfClass:[ ScheduleView class ] ])
    {
        ScheduleView *eview = (ScheduleView *)self.parent;
        eview.back_from = YES;
    }
    
    djcAppDelegate * app = ( djcAppDelegate *) [ [ UIApplication sharedApplication ] delegate ];
    [ app doneEventModal ];
    [ self dismissModalViewControllerAnimated:YES ];
}

-(IBAction) buyNow: (id)sender
{ 
    djcAppDelegate *app = 
        (djcAppDelegate *)[[ UIApplication sharedApplication] delegate ];
    
    //  Set the buy url...
    NSString *buyurl = self.event.buyurl;
    [ app buyEvent: buyurl ];
    
    //  Show the buy view...
    [ app showBuyModal:self:self.event ];
}


-(IBAction) buttonSave:(id)sender
{
    //[ Utility AlertMessage:@"Feature not implemented yet."];
    [ self addEvent:self ];
}


-(IBAction) mapButton: (id)sender
{
    djcAppDelegate *app = (djcAppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    double lat = self.event.latitude;
    double lng = self.event.longitude;
    CLLocationCoordinate2D latlong = CLLocationCoordinate2DMake(lat,lng);
    NSString *str = [ NSString stringWithFormat:@"%@, %@",
                     self.event.venue, self.event.city ];
    [ app mapIt:self :str: latlong];
}



#pragma mark -
#pragma mark - Add a new event

// If event is nil, a new event is created and added to the specified event store. New events are 
// added to the default calendar. An exception is raised if set to an event that is not in the 
// specified event store.
- (void)addEvent:(id)sender
{
      gcount = @"0";
    EKEventStore *eventStore = [[[EKEventStore alloc] init] autorelease]; 
    NSArray *calendarsArray = [[NSArray alloc] init];
    calendarsArray = [[eventStore calendars] retain];
    
    
    for (EKCalendar *thisCalendar in calendarsArray) {
        
        EKCalendarType type = thisCalendar.type;
        
        
        if (type == EKCalendarTypeExchange) {
            gcount = @"1";
        }
        if (type == EKCalendarTypeCalDAV) {
            gcount = @"2";
        }
  
    }   

   
	// When add button is pushed, create an EKEventEditViewController to display the event.
	EKEventEditViewController *addController = 
    [[EKEventEditViewController alloc] initWithNibName:nil bundle:nil];
	
	// set the addController's event store to the current event store.
	addController.eventStore = self.eventStore;
    
    //  Get event info...
    //NSMutableDictionary *event = [ self.events objectAtIndex:self.eventid ];
    //NSString *name = [ event objectForKey:@"name"];
    //NSString *lc = [ event objectForKey:@"lc" ];
    //NSString *sd = [ event objectForKey:@"sd" ];
    //NSString *ed = [ event objectForKey:@"ed" ];
    NSString *name = self.event.name;
    NSString *lc = self.event.venue;
    NSString *sd = self.event.startdate;
    //NSLog(@"%@",sd);
    //NSString *ed = self.event.enddate;
    //NSLog(@"%@",ed);

    // create an event and prefill some fields...
    EKEvent *evt = [ EKEvent eventWithEventStore:self.eventStore ];
    [ evt setTitle:name ];
    [ evt setCalendar:self.defaultCalendar ];
    [ evt setLocation:lc ];
    EKRecurrenceRule *rule = 
    [ [ EKRecurrenceRule alloc ] 
     initRecurrenceWithFrequency:EKRecurrenceFrequencyMonthly interval:1 end:nil ];
    [ rule autorelease ];
    [ evt setRecurrenceRule: rule ];
    NSDateFormatter *fmt = [ [ NSDateFormatter alloc ] init ];
    [ fmt autorelease ];
    
    //NSString *sample = @"2011-12-31T21:00:00+00:00";
    //NSString *sample = @"2011-12-31T21";
    //[ fmt setDateFormat:@"yyyyMMdd h:mm a" ];
    //[ fmt setDateFormat:@"%Y-%m-%dT%H:%M:%S+00:00" ];
    //[ fmt setDateFormat:@"yyyy-MM-ddThh:mm:00+00:00" ];
    
    NSLocale *          enUSPOSIXLocale;
    enUSPOSIXLocale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease];
    [ fmt setLocale:enUSPOSIXLocale];
    [ fmt setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'+00:00'"];
    [ fmt setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    //NSDate *sdt = [fmt dateFromString:sample ];
    NSDate *sdt = [fmt dateFromString:sd ];
    [ evt setStartDate:sdt ];
    
    //NSDate *edt = [fmt dateFromString:ed ];
    NSDate *edt = [ sdt dateByAddingTimeInterval:10 ];
    [ evt setEndDate:edt ];
    
    //  Set this as the event to modify...
    addController.event = evt;
    
	// present EventsAddViewController as a modal view controller
	[self presentModalViewController:addController animated:YES];
	
	addController.editViewDelegate = self;
    [calendarsArray release];
	[addController release];
}


- (void)addEvent2:(id)sender
{
    
    EKEventStore *eventStore2 = [[[EKEventStore alloc] init] autorelease]; 
    NSArray *calendarsArray2 = [[NSArray alloc] init];
    calendarsArray2 = [[eventStore2 calendars] retain];
    
    
	// When add button is pushed, create an EKEventEditViewController to display the event.
	EKEventEditViewController *addController = 
    [[EKEventEditViewController alloc] initWithNibName:nil bundle:nil];
	
	// set the addController's event store to the current event store.
	addController.eventStore = self.eventStore;
    
    //  Get event info...
    NSString *name = self.event.name;
    NSString *lc = self.event.venue;
    NSString *sd = self.event.startdate;
    NSLog(@"%@",sd);
    NSString *ed = self.event.enddate;
    NSLog(@"%@",ed);
    
    // create an event and prefill some fields...
    EKEvent *evt = [ EKEvent eventWithEventStore:self.eventStore ];
    [ evt setTitle:name ];
    
    //jimmy add other calendar
    //[ evt setCalendar:self.defaultCalendar ];
    
    NSInteger i2= 0 ;
    NSInteger cindex2= 0 ;
    
    for (EKCalendar *thisCalendar2 in calendarsArray2) {
        
        EKCalendarType type = thisCalendar2.type;
        
       
        if (type == EKCalendarTypeExchange) {
            cindex2 = i2;
            gcount = @"0";
        }
        if (type == EKCalendarTypeCalDAV) {
            cindex2 = i2;
            gcount = @"0";
        }
        
        i2++;
    }   
    
    
    
    EKCalendar *calendar2 = [calendarsArray2 objectAtIndex:cindex2];
    [ evt setCalendar:calendar2 ];
    
    
    
    
    
    
    
    [ evt setLocation:lc ];
    EKRecurrenceRule *rule = 
    [ [ EKRecurrenceRule alloc ] 
     initRecurrenceWithFrequency:EKRecurrenceFrequencyMonthly interval:1 end:nil ];
    [ rule autorelease ];
    [ evt setRecurrenceRule: rule ];
    NSDateFormatter *fmt = [ [ NSDateFormatter alloc ] init ];
    [ fmt autorelease ];
    
    
    NSLocale *          enUSPOSIXLocale;
    enUSPOSIXLocale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease];
    [ fmt setLocale:enUSPOSIXLocale];
    [ fmt setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'+00:00'"];
    [ fmt setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    //NSDate *sdt = [fmt dateFromString:sample ];
    NSDate *sdt = [fmt dateFromString:sd ];
    [ evt setStartDate:sdt ];
    
    //NSDate *edt = [fmt dateFromString:ed ];
    NSDate *edt = [ sdt dateByAddingTimeInterval:10 ];
    [ evt setEndDate:edt ];
    
    //  Set this as the event to modify...
    addController.event = evt;
    
	// present EventsAddViewController as a modal view controller
	[self presentModalViewController:addController animated:YES];
	
	addController.editViewDelegate = self;
	[addController release];
    [calendarsArray2 release];
}


- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 0)
    {
        
        [self addEvent2:self];
        
        NSLog(@"ok");
    }
    else
    {
        NSLog(@"cancel");
    }
}


#pragma mark -
#pragma mark EKEventEditViewDelegate

// Overriding EKEventEditViewDelegate method to update event store according to user actions.
- (void)eventEditViewController:(EKEventEditViewController *)controller 
          didCompleteWithAction:(EKEventEditViewAction)action 
{
	
	NSError *error = nil;
	EKEvent *thisEvent = controller.event;
	
	switch (action) 
    {
		case EKEventEditViewActionCanceled:
			// Edit action canceled, do nothing. 
			break;
			
		case EKEventEditViewActionSaved:
			// When user hit "Done" button, save the newly created event to the event store, 
			// and reload table view.
			// If the new event is being added to the default calendar, then update its 
			// eventsList.
            
            
			if (self.defaultCalendar ==  thisEvent.calendar) 
            {
				//[self.eventsList addObject:thisEvent];
			}
            
            
            if (gcount == @"1"){
                UIAlertView *alert = [[UIAlertView alloc] 
                                      initWithTitle:@"Sync Calendar" 
                                      message:@"Sync with your Exchange calendar?"
                                      delegate:self 
                                      cancelButtonTitle:@"Yes" 
                                      otherButtonTitles:@"No", nil];
                
                [alert show];
                [alert release];
                gcount=@"0";
            }
            if (gcount == @"2"){
                UIAlertView *alert = [[UIAlertView alloc] 
                                      initWithTitle:@"Sync Calendar" 
                                      message:@"Sync with your CalDAV/Google calendar?"
                                      delegate:self 
                                      cancelButtonTitle:@"Yes" 
                                      otherButtonTitles:@"No", nil];
                
                [alert show];
                [alert release];
                gcount=@"0";
            }
            
            
			break;
            
			[controller.eventStore saveEvent:controller.event span:EKSpanThisEvent error:&error];
			//[self.tableView reloadData];
			break;
			
		case EKEventEditViewActionDeleted:
			// When deleting an event, remove the event from the event store, 
			// and reload table view.
			// If deleting an event from the currenly default calendar, then update its 
			// eventsList.
			if (self.defaultCalendar ==  thisEvent.calendar) 
            {
				//[self.eventsList removeObject:thisEvent];
			}
			[controller.eventStore removeEvent:thisEvent span:EKSpanThisEvent error:&error];
			//[self.tableView reloadData];
			break;
			
		default:
			break;
	}
	// Dismiss the modal view controller
	[controller dismissModalViewControllerAnimated:YES];
	
}


// Set the calendar edited by EKEventEditViewController to our chosen calendar - the default calendar.
- (EKCalendar *)eventEditViewControllerDefaultCalendarForNewEvents:(EKEventEditViewController *)controller 
{
	EKCalendar *calendarForEdit = self.defaultCalendar;
	return calendarForEdit;
}

#pragma mark - button callbacks...

#if 0
-(IBAction) followDJ: (id)sender
{
    //[ Utility AlertMessage:@"yo" ];
    djcAppDelegate *app = (djcAppDelegate *)
        [ [ UIApplication sharedApplication ] delegate ];
    NSString *tokstr = app.devtoken;
    
    if ( ! [ self.api followdjs:tokstr:nil ] )
    {
        [ Utility AlertAPICallFailed ];
    }
}
#endif

#pragma mark - djcapi...

-(void) followed_dj:(NSDictionary *)data
{
    NSNumber *_st = [ data objectForKey:@"status" ];
    NSInteger st = [ _st integerValue ];
    if (st<=0)
    {
        NSString *msg = [ data objectForKey:@"msg" ];
        [ Utility AlertMessage:msg ];
    }
    else
    {
        NSString *msg = [ data objectForKey:@"msg" ];
        [ Utility AlertMessage:msg ];
    }
}

#pragma mark - follow view delegate...

#if 0
-(void) FollowViewOK: (NSMutableArray *)djs
{
    //[ Utility AlertMessage:@"yo" ];
    djcAppDelegate *app = (djcAppDelegate *)
        [ [ UIApplication sharedApplication ] delegate ];
    NSString *tokstr = app.devtoken;
    
    if ( ! [ self.api followdjs:tokstr:djs ] )
    {
        [ Utility AlertAPICallFailed ];
    }
}
#endif


@end
