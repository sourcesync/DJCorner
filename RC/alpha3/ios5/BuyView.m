//
//  BuyView.m
//  alpha2
//
//  Created by George Williams on 11/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BuyView.h"
#import "djcAppDelegate.h"
#import "EventView.h"

@implementation BuyView

@synthesize web_view=_web_view;
@synthesize tb=_tb;
@synthesize event=_event;
@synthesize parent=_parent;

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
    self.event = nil;
    self.parent = nil;
    
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
    
    [ self.tb setFrame:CGRectMake(0, 0, 320,44) ];
    self.tb.hidden = NO;
    
    self.web_view.delegate = self;
    
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated ];
    
    
    [ self.tb setFrame:CGRectMake(0, 0, 320,44) ];
    self.tb.hidden = NO;
    
    djcAppDelegate *app = 
        ( djcAppDelegate *)[ [ UIApplication sharedApplication] delegate];
    
    NSString *cur_url = [ app getCurURL ];
    
    NSURL *url = [ NSURL URLWithString:cur_url ];
    
    NSURLRequest *req = [ NSURLRequest requestWithURL:url ];
    
    self.web_view.hidden = YES;
    self.web_view.scalesPageToFit = YES;
    [ self.web_view loadRequest:req ];
}

-(void) viewDidAppear:(BOOL)animated
{
    [ super viewDidAppear:animated];
        
    [ self.tb setFrame:CGRectMake(0, 0, 320,44) ];
    self.tb.hidden = NO;

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


#pragma mark - button callbacks...

-(IBAction) buttonBack: (id)sender
{
    if ( [self.parent isKindOfClass:[ EventView class] ] )
    {
        EventView *eview = (EventView *)self.parent;
        eview.back_from = YES;
    }
    [ self dismissModalViewControllerAnimated:YES ];
}

#pragma mark - uiwebview delegate...

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.web_view.hidden = NO;
}

@end
