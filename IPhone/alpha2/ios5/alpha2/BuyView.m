//
//  BuyView.m
//  alpha2
//
//  Created by George Williams on 11/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BuyView.h"
#import "alpha2AppDelegate.h"

@implementation BuyView

@synthesize web_view=_web_view;
@synthesize tb=_tb;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
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
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated ];
    
    alpha2AppDelegate *app = 
        ( alpha2AppDelegate *)[ [ UIApplication sharedApplication] delegate];
    
    NSString *cur_url = [ app getCurURL ];
    
    NSURL *url = [ NSURL URLWithString:cur_url ];
    
    NSURLRequest *req = [ NSURLRequest requestWithURL:url ];
    
    [ self.web_view loadRequest:req ];
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

@end
