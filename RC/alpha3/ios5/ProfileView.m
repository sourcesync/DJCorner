//
//  ProfileView.m
//  alpha2
//
//  Created by George Williams on 11/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProfileView.h"
#import "utility.h"
#import "djcAppDelegate.h"

@implementation ProfileView

@synthesize tv=_tv;
@synthesize api=_api;
@synthesize djs=_djs;
@synthesize activity=_activity;
@synthesize selectedDJ=_selectedDJ;
@synthesize selectedIndex=_selectedIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        //self.api = [ [ [ DJCAPI alloc ] init:self ] autorelease ];
        //self.api =  [ [ DJCAPI alloc ] init:self ];
    }
    return self;
}

- (void)dealloc
{
    self.api = nil;
    self.djs = nil;
    self.selectedDJ = nil;
    
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
    
    self.api =  [ [ [ DJCAPI alloc ] init:self ] autorelease ];
    
    self.tv.dataSource = self;
    self.tv.delegate = self;
    
    [ self.tv reloadData ];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    djcAppDelegate *app = ( djcAppDelegate *)
        [ [ UIApplication sharedApplication ] delegate ];
    
    if (! [ self.api get_followdjs:app.devtoken ] )
    {
        [ Utility AlertAPICallFailed ];
        self.tv.hidden = NO;
        self.activity.hidden = YES;
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated ];
    
    self.tv.hidden = YES;
    self.djs = nil;
    self.activity.hidden = NO;
}


#pragma mark - table view delegates...


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( self.djs == nil )
    {
        return 1;
    }
    else if ( [ self.djs count] == 0 )
    {
        return 1;
    }
    else
    {
        int count = [ self.djs count ];
        return count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             @"profile_cell"];
    if (cell == nil) 
    {
        cell = [[[ UITableViewCell alloc] init] autorelease];
    }
    
    if ( self.djs == nil )
    {
        cell.textLabel.text = @"Please Wait...";
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.font = [ UIFont boldSystemFontOfSize:17.0f ];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [ UIColor blackColor ];
        [ cell.imageView setImage:nil ];
    }
    else if ( [ self.djs count ] == 0 )
    {
        cell.textLabel.text = @"You are not following any DJs.";
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.font = [ UIFont boldSystemFontOfSize:17.0f ];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [ UIColor blackColor ];
        [ cell.imageView setImage:nil ];
    }
    else 
    {
        int row = [ indexPath row ];
        NSMutableDictionary *dct = [ self.djs objectAtIndex: row ];
        cell.textLabel.text = [ dct objectForKey:@"dj" ];
        cell.textLabel.textAlignment = UITextAlignmentLeft;
        cell.textLabel.font = [ UIFont systemFontOfSize:17.0f ];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.textLabel.textColor = [ UIColor blackColor ];
        UIImage *img = [ UIImage imageNamed:@"Genericthumb.png" ];
        [ cell.imageView setImage:img ];
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [ indexPath row ];
    
    self.selectedIndex = row;
    
    [ tableView deselectRowAtIndexPath:indexPath animated:YES ];
    
    if ( (self.djs != nil) && ( [ self.djs count ] >0 ) )
    {
        //UITableViewCell *cell = [ tableView cellForRowAtIndexPath:indexPath ];
        //NSString *dj = cell.textLabel.text;
        
        NSMutableDictionary *dct = [ self.djs objectAtIndex: row ];
        NSString *djid = [ dct objectForKey:@"djid" ];
        self.selectedDJ = djid;
     
        UIActionSheet *popupQuery = [[UIActionSheet alloc] 
                                 initWithTitle:@"DJs Corner" 
                                 delegate:self 
                                 cancelButtonTitle:@"Cancel"
                                 destructiveButtonTitle:nil
                                 otherButtonTitles:
                                 @"Go To DJ Page", @"Stop Following",
                                     nil];
        popupQuery.delegate= self;
        popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        //[popupQuery showInView:self.view];
        [popupQuery showInView:self.tabBarController.view];
        
        [popupQuery release];
        
    }
}

#pragma mark - DJCAPI...

-(void) apiLoadingFailed:(NSString *)errMsg
{
    [ Utility AlertAPICallFailedWithMessage:errMsg ];
}

-(void) got_followdjs:(NSDictionary *)data
{
    NSNumber *_st = [ data objectForKey:@"status" ];
    NSInteger st = [ _st integerValue ];
    if (st>0 )
    {
        self.djs = [ data objectForKey:@"results" ];
        
        self.tv.hidden = NO;
        self.activity.hidden = YES;
        [ self.tv reloadData ];
    }
    else
    {
        NSString *msg = [ data objectForKey:@"msg" ];
        [ Utility AlertMessage:msg ];
        
        self.tv.hidden = NO;
        self.activity.hidden = YES;
    }
}


-(void) stopped_followdj:(NSDictionary *)data
{
    NSNumber *_st = [ data objectForKey:@"status" ];
    NSInteger st = [ _st integerValue ];
    if (st>0 )
    {
        self.djs = [ data objectForKey:@"results" ];
        
        self.tv.hidden = NO;
        self.activity.hidden = YES;
        [ self.tv reloadData ];
    }
    else
    {
        NSString *msg = [ data objectForKey:@"msg" ];
        [ Utility AlertMessage:msg ];
        
        self.tv.hidden = NO;
        self.activity.hidden = YES;
    }
}


#pragma mark - uiaction sheet delegate...


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    if (buttonIndex==0 ) 
    {
        djcAppDelegate *app = ( djcAppDelegate *) 
            [ [ UIApplication sharedApplication ] delegate ];
        
        //DJ *dj = [ self.djs objectAtIndex:self.selectedIndex ];
        NSString *djid = self.selectedDJ;
        [ app showDJItemModal:self:nil:djid ];
        
        //if (! [ self.api stop_followdj:app.devtoken:self.selectedDJ ] )
        //{
        //    [ Utility AlertAPICallFailed ];
        // }
    }
    else if (buttonIndex==1 ) 
    {
        djcAppDelegate *app = ( djcAppDelegate *) 
        [ [ UIApplication sharedApplication ] delegate ];
        
        if (! [ self.api stop_followdj:app.devtoken:self.selectedDJ ] )
        {
            [ Utility AlertAPICallFailed ];
        }
    }
    else
    {
        //actionSheet.release
    }
}

@end
