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
#import "ProfileView.h"


@implementation feedbackView

//@synthesize activity=_activity;
@synthesize api=_api;
@synthesize parent=_parent;
@synthesize tf=_tf;
//@synthesize button_Done=_button_Done;


#pragma resignfirstresponse...
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if([self.tf isFirstResponder])
    {
        [self.tf resignFirstResponder];
    }
    [self resignFirstResponder];
}


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
    djcAppDelegate *app=(djcAppDelegate *)[[UIApplication sharedApplication] delegate];
    app.feedback_view=self;
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
    
    
    NSString *recipients = @"mailto:feedback@djscorner.com?subject=Feedback from DJs Corner!";
    NSString *body = @"&body=";
    
    NSString *email = [NSString stringWithFormat:@"%@%@%@", recipients, body,self.tf.text];
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
    
    
    //////////////////////////////////////////
    UIAlertView *alert = [[UIAlertView alloc] 
        initWithTitle:@"Feedback" 
        message:@"Your comment has been submitted"  
        delegate:self 
        cancelButtonTitle:@"OK" 
        otherButtonTitles:nil, nil];
	[alert show];
	[alert release];
    [self.tf setText:@""];
    [self.tf resignFirstResponder];
    [ self dismissModalViewControllerAnimated:YES ];
}

-(IBAction)backClicked:(id)sender
{
    if([self.parent isKindOfClass:[ProfileView class]])
    {
        ProfileView *pView=(ProfileView *)self.parent;
        pView.back_from=YES;
    }
    [self dismissModalViewControllerAnimated:YES];
}



#pragma mark - button callbacks...


-(IBAction) buttonDoneClicked:(id)sender
{
    [self.tf resignFirstResponder];
    
    [ self dismissModalViewControllerAnimated:YES ];
}

#pragma mark - djcapi...

-(void) apiLoadingFailed:(NSString *)errMsg
{
    [ Utility AlertAPICallFailedWithMessage:errMsg ];
}


@end