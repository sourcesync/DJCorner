//
//  SimilarDJView.m
//  alpha2
//
//  Created by George Williams on 12/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SimilarDJView.h"
#import "Utility.h"
#import "djcAppDelegate.h"

@implementation SimilarDJView

@synthesize tv=_tv;
@synthesize djid=_djid;
@synthesize djname=_djname;
@synthesize similar=_similar;
@synthesize activity=_activity;
@synthesize api=_api;
@synthesize parent=_parent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        self.api = [ [ [ DJCAPI alloc ] init:self ] autorelease ];
    }
    return self;
}

-(id) init
{
    self = [ self initWithNibName:@"SimilarDJView" bundle:nil];
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void) dealloc
{
    self.djid = nil;
    self.djname = nil;
    self.api = nil;
    self.similar = nil;
    self.parent = nil;
    
    [ super dealloc];
}

-(void) viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated];
    
    self.tv.hidden = YES;
    self.activity.hidden = NO;
}

-(void) viewDidAppear:(BOOL)animated
{
    [ super viewDidAppear:animated ];
    
    if (![ self.api get_similar_djs:self.djid ] )
    {
        [ Utility AlertAPICallFailed ];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tv.delegate = self;
    self.tv.dataSource = self;
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

#pragma mark - table view...


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( self.similar == nil )
    {
        return 1;
    }
    else if ( [ self.similar count ] == 0 )
    {
        return 1;
    }
    else
    {
        return [ self.similar count ];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [ indexPath row ];
    
    [ self.tv deselectRowAtIndexPath:indexPath animated:YES ];
    
    NSDictionary *item = [ self.similar objectAtIndex:row ];
    NSString *djid = [ item objectForKey:@"id" ];
    
    djcAppDelegate *app = ( djcAppDelegate *)
    [[ UIApplication sharedApplication ] delegate ];
    [ app showDJItemModal:self :nil: djid ];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( self.similar == nil )
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
    else if ( [ self.similar count ] == 0 ) 
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 @"plain_cell"];
        if (cell == nil) 
        {
            cell = [[[ UITableViewCell alloc] init] autorelease];
        }
        cell.textLabel.text = @"No Similar DJs...";
        cell.textLabel.font = [ UIFont boldSystemFontOfSize:17 ];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.textColor = [ UIColor blackColor ];
        return cell;
    }
    else 
    {
        int row = [ indexPath row ];
        
        NSDictionary *item = [ self.similar objectAtIndex:row ];
        
        NSString *name = [ item objectForKey:@"name" ];
        //NSString *eventdate = [ item objectForKey:@"eventdate" ];
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 @"plain_cell"];
        if (cell == nil) 
        {
            cell = [[[ UITableViewCell alloc] init] autorelease];
        }
        cell.textLabel.text = [ NSString stringWithFormat:@"%@", name ];
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

-(void) got_similar_djs:(NSDictionary *)data
{
    NSNumber *_status = [ data objectForKey:@"status" ];
    NSInteger status = [ _status integerValue ];
    if ( status>0 )
    {
        self.tv.hidden = NO;
        self.activity.hidden = YES;
        NSMutableArray *similar = [ data objectForKey:@"results" ];
        self.similar = similar;
        [self.tv reloadData];
    }
    else
    {
        NSString *msg = [ data objectForKey:@"msg" ];
        [ Utility AlertMessage:msg ];
    }
}

-(void) apiLoadingFailed:(NSString *)errMsg
{
    [ Utility AlertAPICallFailedWithMessage:errMsg ];
}


@end
