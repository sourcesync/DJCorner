//
//  EventView.m
//  alpha2
//
//  Created by George Williams on 11/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EventView.h"
#import "Utility.h"

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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
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
    [super dealloc];
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
    // Do any additional setup after loading the view from its nib.
    
    self.api = [ [ DJCAPI alloc ] init:self ];
    
    [ self.tv setDelegate:self];
    [ self.tv setDataSource:self];
    [ self.tv reloadData ];
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

#pragma mark - table view delegates...


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
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
        self.cell_description.selectionStyle = UITableViewCellSeparatorStyleNone;
        return self.cell_description;
    }
    else if ( section == 2 )
    {
        self.cell_date.selectionStyle = UITableViewCellSeparatorStyleNone;
        return self.cell_date;
    }
    else if ( section == 3 )
    {
        self.cell_buy.selectionStyle = UITableViewCellSeparatorStyleNone;
        self.cell_buy.backgroundColor = [ UIColor blackColor ];
        self.cell_buy.contentView.backgroundColor = [ UIColor blackColor ];
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
    else
    {
        return 44.0f;
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
        self.event = [ Event ParseFromAPI2:results ];
        [ self updateView ]; 
    }
    else
    {
        [ Utility AlertAPICallFailedWithMessage:@"API Call Return Bad Status." ];
        self.connectionProblem = YES;
        self.event = nil;
        [ self updateView ];
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
    [ self dismissModalViewControllerAnimated:YES ];
}


@end
