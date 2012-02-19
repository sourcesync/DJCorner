//
//  FollowView.m
//  alpha2
//
//  Created by George Williams on 12/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DJSelectView.h"
#import "djcAppDelegate.h"
#import "Utility.h"

@implementation DJSelectView

@synthesize tv=_tv;
@synthesize event=_event;
@synthesize delegate=_delegate;
@synthesize api=_api;
@synthesize parent=_parent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        self.api = [ [ [ DJCAPI alloc ] init:self ] autorelease ];
        //self.api =  [ [ DJCAPI alloc ] init:self ];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

-(void) dealloc
{
    self.event = nil;
    self.api = nil;
    self.parent = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tv.delegate = self;
    self.tv.dataSource = self;
    [ self.tv reloadData ];
    
    
}

- (void)viewDidUnload
{    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - table view delegates...


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ self.event.performers count ];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [ indexPath row ];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                @"profile_cell"];
    if (cell == nil) 
    {
        cell = [[[ UITableViewCell alloc] init] autorelease];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [ self.event.performers objectAtIndex:row];
    cell.textLabel.textColor = [ UIColor blackColor ];
    
    return cell;
}


- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}


- (void)tableView:(UITableView *)tableView 
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [ self.tv deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = [ indexPath row ];
    
    NSString *djid = [ self.event.pfids objectAtIndex:row ];
    
    djcAppDelegate *app = ( djcAppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app showDJItemModal:self :nil :djid ];
    
#if 0
    UITableViewCell *cell = [ self.tv cellForRowAtIndexPath:indexPath ];
                             
    UITableViewCellAccessoryType type = cell.accessoryType;
    if ( type == UITableViewCellAccessoryCheckmark )
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
#endif
}

#pragma mark - button callbacks...

-(IBAction) cancelClicked:(id)sender
{
    if ( [self.parent isKindOfClass:[ EventView class] ] )
    {
        EventView *eview = (EventView *)self.parent;
        eview.back_from = YES;
    }
    
    [ self dismissModalViewControllerAnimated:YES ];
    
}

-(IBAction) okClicked:(id)sender;
{
    djcAppDelegate *app = (djcAppDelegate *)
        [ [ UIApplication sharedApplication ] delegate ];
    NSString *tokstr = app.devtoken;

    
    NSMutableArray *arr = [ [ NSMutableArray alloc ] initWithCapacity:0 ];
    NSMutableArray *arrids = [ [ NSMutableArray alloc ] initWithCapacity:0 ];
    for (int i=0;i< [self.event.performers count];i++)
    {
        NSIndexPath *path = [ NSIndexPath indexPathForRow:i inSection:0 ];
        UITableViewCell *cell = [ self.tv cellForRowAtIndexPath:path ];
        if ( cell.accessoryType == UITableViewCellAccessoryCheckmark )
        {
            [ arr addObject: [ self.event.performers objectAtIndex:i ] ];
            [ arrids addObject: [ self.event.pfids objectAtIndex:i ] ];
        }
    }
    
    if ( [ arr count] == 0 )
    {
        [ Utility AlertMessage:@"No DJs Selected" ];
        [ arr release ];
        [ arrids release ];
    }
    else
    {
        if ( ! [ self.api followdjs:tokstr:arr:arrids ] )
        {
            [ Utility AlertAPICallFailed ];
        }    
        [ arr release ];
        [ arrids release ];
    }
}

#pragma mark - djcapi

-(void) apiLoadingFailed:(NSString *)errMsg
{
    [ Utility AlertAPICallFailedWithMessage:errMsg ];
}


-(void) followed_djs:(NSDictionary *)data
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
    
    [ self dismissModalViewControllerAnimated:YES ];
}


@end
