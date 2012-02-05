//
//  feedbackView.m
//  djc
//
//  Created by Hok Leong Chan on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "feedbackView.h"
#import "Utility.h"
#import "djcAppDelegate.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>


@implementation feedbackView

//@synthesize activity=_activity;
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
    

   // self.activity.hidden = NO;
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


-(IBAction) submitClicked:(id)sender
{
    if ( [self.parent isKindOfClass:[ DJItemView class] ] )
    {
        //DJItemView *eview = (DJItemView *)self.parent;
        //eview.back_from = YES;
        
    }
    //////////////////////////////////////////
    
    
 //   NSString *recipients = @"mailto:cj2000s@gmail.com?subject=Hello from California!";
   // NSString *body = @"&body=It is raining in sunny California!";
    
   // NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    //email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
   // NSString* urlString = [NSString stringWithFormat:@"mailto:cj2000s@gmail.com"];
    
    NSURL *url = [[NSURL alloc] initWithString:
                  @"mailto:cj2000s@yahoo.com?subject=subject&body=Hi"];
    [[UIApplication sharedApplication] openURL:url];
   // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    
    
    //////////////////////////////////////////
    UIAlertView *alert = [[UIAlertView alloc] 
        initWithTitle:@"Feedback" 
        message:@"Your comment has been submitted"  
        delegate:self 
        cancelButtonTitle:@"No" 
        otherButtonTitles:@"Yes", nil];
	[alert show];
	[alert release];
    
    [ self dismissModalViewControllerAnimated:YES ];
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

-(void) apiLoadingFailed:(NSString *)errMsg
{
    [ Utility AlertAPICallFailedWithMessage:errMsg ];
}


@end