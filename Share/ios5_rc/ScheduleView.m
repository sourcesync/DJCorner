//
//  ScheduleView.m
//  alpha2
//
//  Created by George Williams on 12/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ScheduleView.h"
#import "Utility.h"
#import "djcAppDelegate.h"
#import "LocalizedManager.h"
 
@implementation ScheduleView 

@synthesize tv=_tv;
@synthesize djname=_djname;
@synthesize djid=_djid;
@synthesize schedule=_schedule;
@synthesize activity=_activity;
@synthesize api=_api;
@synthesize label_title=_label_title;
@synthesize parent=_parent;
@synthesize back_from=_back_from;
@synthesize button_back;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        self.api = [ [ [ DJCAPI alloc ] init:self ] autorelease ];
    }
    return self;
}

- (id) init
{
    return [ self initWithNibName:@"ScheduleView" bundle:nil];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void) viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated];
    
    if (self.back_from )
    {
        
    }
    else
    {
        self.schedule = nil;
        self.tv.hidden = YES;
        self.activity.hidden = NO;
    
        NSString *title = [ NSString stringWithFormat:@"%@ %@",[LocalizedManager localizedString:@"Schedule_for"], self.djname ];
        self.label_title.text = title;
    }
    self.button_back.title=[LocalizedManager localizedString:@"back"];
}


-(void) viewDidAppear:(BOOL)animated
{
    [ super viewDidAppear:animated];
    
    if (self.back_from)
    {
        self.back_from = NO;
    }
    else
    {
    if ( ! [ self.api get_schedule:self.djid ] )
    {
        [ Utility AlertAPICallFailed ];
    }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tv.delegate = self;
    self.tv.dataSource = self;
    self.button_back.title=[LocalizedManager localizedString:@"back"];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) dealloc
{
    self.djname = nil;
    self.djid = nil;
    self.schedule = nil;
    self.api = nil;
    self.parent = nil;
    
    [button_back release];
    
    
    [ super dealloc ];
}


#pragma mark - table view delegates...



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( self.schedule == nil )
    {
        return 1;
    }
    else if ( [ self.schedule count ] == 0 )
    {
        return 1;
    }
    else
    {
        return [ self.schedule count ];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [ indexPath row ];
    
    [ self.tv deselectRowAtIndexPath:indexPath animated:YES ];
    
    NSDictionary *item = [ self.schedule objectAtIndex:row ];
    
    NSString *eid = [ item objectForKey:@"eid" ];
    
    djcAppDelegate *app = ( djcAppDelegate *)
        [[ UIApplication sharedApplication ] delegate ];
    [ app showEventModal:self :nil :eid];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( self.schedule == nil )
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 @"plain_cell"];
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
    else if ( [ self.schedule count ] == 0 ) 
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 @"plain_cell"];
        if (cell == nil) 
        {
            cell = [[[ UITableViewCell alloc] init] autorelease];
        }
        cell.textLabel.text = [LocalizedManager localizedString:@"schedule_not_available"];
        cell.textLabel.font = [ UIFont boldSystemFontOfSize:17 ];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.textColor = [ UIColor blackColor ];
        return cell;
    }
    else 
    {
        int row = [ indexPath row ];
        
        NSDictionary *item = [ self.schedule objectAtIndex:row ];
        
        NSString *city = [ item objectForKey:@"city" ];
        NSString *eventdate = [ item objectForKey:@"eventdate" ];
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 @"plain_cell"];
        if (cell == nil) 
        {
            cell = [[[ UITableViewCell alloc] init] autorelease];
        }
        cell.textLabel.text = [ NSString stringWithFormat:@"%@ / %@", city, eventdate ];
        cell.textLabel.font = [ UIFont boldSystemFontOfSize:17 ];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.textColor = [ UIColor blackColor ];
        return cell;
    }
}

#pragma mark - button callbacks...


-(IBAction) buttonBackClicked:(id)sender
{
    if ( [self.parent isKindOfClass:[ DJItemView class] ] )
    {
        DJItemView *eview = (DJItemView *)self.parent;
        eview.back_from = YES;
    }
    [ self dismissModalViewControllerAnimated:YES ];
}

#pragma mark - djcapi...

-(void) apiLoadingFailed:(NSString *)errMsg
{
    [ Utility AlertAPICallFailedWithMessage:errMsg];
}

-(void) got_schedule:(NSDictionary *)data
{
    NSNumber *_status = [ data objectForKey:@"status" ];
    NSInteger status = [ _status integerValue ];
    if ( status>0 )
    {
        self.tv.hidden = NO;
        self.activity.hidden = YES;
        NSMutableArray *sched = [ data objectForKey:@"results" ];
        self.schedule = sched;
        [self.tv reloadData];
    }
    else
    {
        NSString *msg = [ data objectForKey:@"msg" ];
        [ Utility AlertMessage:msg ];
    }
}

@end
