//
//  MainSearchView.m
//  alpha2
//
//  Created by George Williams on 12/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MainSearchView.h"
#import "djcAppDelegate.h"

@implementation MainSearchView 

@synthesize cell_search_by_city=_cell_search_by_city;
@synthesize cell_search_djs=_cell_search_djs;
@synthesize tv=_tv;
@synthesize field_search=_field_search;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)  
    {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tv.dataSource = self;
    self.tv.delegate = self;
    
    self.field_search.delegate = self;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tv.hidden = YES;
}


-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.tv.hidden = NO;
    [ self.tv reloadData ];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) dealloc
{
    [ super dealloc ];
}

#pragma mark - table view delegates...


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
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
        return self.cell_search_by_city;
    }
    else if ( section == 1 )
    {
        self.cell_search_djs.selectionStyle = UITableViewCellSelectionStyleNone;
        return self.cell_search_djs;
    }
    else
    {
        return nil;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [ tableView deselectRowAtIndexPath:indexPath animated:YES ];
    
    int section = [ indexPath section ];
    
    if ( section == 0 )
    {
        djcAppDelegate *app = 
            (djcAppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
        [ app showSearchByCity:self ];
    }
    else if ( section == 1 )
    {
        djcAppDelegate *app = 
            (djcAppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
        [ app showSearchDJS:self:nil ];
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    if (section==0)
    {
        return @"Search For Events:";
    }
    else
    {
        return @"Search For DJs:";
    }
}


#pragma mark - button callbacks...


-(IBAction) searchClicked:(id)sender
{
    NSString *search = self.field_search.text;
    
    djcAppDelegate *app = ( djcAppDelegate *)[[ UIApplication sharedApplication ] delegate ];
    [ app showSearchDJS:self:search ];
}

#pragma mark - field callback...

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField 
{
    [theTextField resignFirstResponder];
    return YES;
}


@end
