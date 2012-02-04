//
//  feedbackView.m
//  djc
//
//  Created by Hok Leong Chan on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/*
#import "feedbackView.h"
#import "Utility.h"
#import "djcAppDelegate.h"

@implementation feedbackView

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
    self = [ self initWithNibName:@"feedbackView" bundle:nil];
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

    self.api = nil;
    self.parent = nil;
    [ super dealloc];
}

-(void) viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated];
    

    self.activity.hidden = NO;
}

-(void) viewDidAppear:(BOOL)animated
{
    [ super viewDidAppear:animated ];
    
   // if (![ self.api get_similar_djs:self.djid ] )
   // {
   //     [ Utility AlertAPICallFailed ];
  //  }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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


@end*/