//
//  SplashView.m
//  alpha2
//
//  Created by George Williams on 11/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SplashView.h"
#import "alpha2AppDelegate.h"

@implementation SplashView


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
    }
    return self;
} 

-(id)init
{
    self = [ self initWithNibName:@"SplashView" bundle:nil ];
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
    
    [self performSelector:@selector(splashDoneMainThread:) withObject:self afterDelay:3 ];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
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

#pragma mark - public funcs...

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event  
{
    [ self splashDoneMainThread:self ];
    
}     
     
-(void) splashDoneMainThread:(id)obj
{
    [ self performSelectorOnMainThread:@selector(splashDone:)
                         withObject:self 
                         waitUntilDone:NO ];
}
     
-(void) splashDone:(id)obj
{
    alpha2AppDelegate *app = (alpha2AppDelegate *)
        [ [ UIApplication sharedApplication ] delegate ];
    [ app splashDone ];
}

     
     

@end
