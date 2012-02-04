//
//  SecondViewController.m
//  alpha2
//
//  Created by George Williams on 11/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SearchView.h"
#import "Utility.h"
#import "djcAppDelegate.h"

@implementation SearchView

@synthesize tv=_tv;
@synthesize cities=_cities;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    djcAppDelegate *app = (djcAppDelegate *)[ [ UIApplication sharedApplication ] delegate];
    app.search_view = self;
    
    [ self.tv setDelegate:self ];
    [ self.tv setDataSource:self ];    
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
                   @"Hong Chong",
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
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //[ Utility AlertMessage:@"This is not yet implemented" ];
}

-(void) viewWillAppear:(BOOL)animated
{
    [ self.tv reloadData ];

}



- (void)dealloc
{
    self.cities = nil;
    [super dealloc];
}


#pragma mark - table view delegates...


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ self.cities count ] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             @"search_cell"];
    int row = [ indexPath row ];
    if (cell == nil) 
    {
        cell = [[[ UITableViewCell alloc] init] autorelease];
    }
    
    [ cell.textLabel setText: [ self.cities objectAtIndex:row ] ];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = [ UIColor blackColor ];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    djcAppDelegate *app = (djcAppDelegate *)[ [ UIApplication sharedApplication ] delegate];

    [ self.tv deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = [ indexPath row ];
    
    if ( row == 0 )
    {
        [ app doSearch:self:nil];
    }
    else
    {
        UITableViewCell *cell = [ self.tv cellForRowAtIndexPath:indexPath ];
        NSString *city = cell.textLabel.text;
        [ app doSearch:self:city];
    }
}
/*
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
}
 */

#pragma mark - button callbacks...


-(IBAction) buttonBackClicked:(id)sender
{
    [ self dismissModalViewControllerAnimated:YES ];
}


@end
