//
//  DJSearchView.m
//  alpha2
//
//  Created by George Williams on 12/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DJSearchView.h"

@implementation DJSearchView

@synthesize tv=_tv;
@synthesize cell_search=_cell_search;
@synthesize search=_search;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tv.delegate = self;
    self.tv.dataSource = self;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tv reloadData ];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) dealloc
{
    self.search = nil;
    [ super dealloc ];
}

#pragma mark - table view delegate...



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //int section = [ indexPath section ];
    
    return self.cell_search;
/*
    if ( section == 0 )
    {        
        return self.cell_search_by_city;
    }
    else if ( section == 1 )
    {
        return self.cell_search_djs;
    }
    else
    {
        return nil;
    }
 */
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    return @"Please enter part or all of a DJ name:";
#if 0
    if (section==0)
    {
        return @"Please enter part or all of a DJ name:";
    }
    else
    {
        return @"";
    }
#endif
}

#if 0
- (UITableViewCell *)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = [ indexPath section ];
    
    if ( section == 0 )
    {
        return @"";
    }
    
}
#endif

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [ tableView deselectRowAtIndexPath:indexPath animated:YES ];
    
    int section = [ indexPath section ];
    
    if ( section == 0 )
    {
        //djcAppDelegate *app = (djcAppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
        //[ app showSearchByCity:self ];
    }
    else if ( section == 1 )
    {
        //djcAppDelegate *app = (djcAppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
        //[ app showSearchDJS:self ];
    }
}

#pragma mark - button callback...

-(IBAction) buttonBackClicked:(id)sender
{
    [ self dismissModalViewControllerAnimated:YES ];
}


@end
