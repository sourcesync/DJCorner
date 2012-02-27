//
//  MyMoviePlayer.m
//  Tribeca
//
//  Created by George Williams on 9/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyMoviePlayer.h"
//#import "TribecaAppDelegate.h"


@implementation MyMoviePlayer

@synthesize movieURL;
@synthesize mp;
//@synthesize mv=_mv;
@synthesize delegate=_delegate;
@synthesize bCalledStop=_bCalledStop;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
    } 
    return self;
}

- (id)initWithPath:(NSString *)moviePath
{
    // Initialize and create movie URL
    //self = [super init];
    self = [ self initWithNibName:@"MyMoviePlayer" bundle:nil ];
    if (self)
    {
        self.movieURL = [NSURL fileURLWithPath:moviePath];    
        //[movieURL retain];
    }
    return self;
}

-(void) moviePlayBackDidFinish: (id)sender
{
    //if (self.bCalledStop)
    //    return;
    self.bCalledStop = YES;
    
    //  Call parent delegate...
    if (self.delegate!=nil)
    {
        [ self.delegate movieDone ];
    }
    
    //  Terminate the player...
    [ self.mp stop ];
    //[ self.mp release ];
    self.mp = nil;
    
    //  Resign responder (TODO: need this?)...
    //BOOL res = [ self resignFirstResponder ];
    //[ self dismissModalViewControllerAnimated:YES ];
    //res = [ self resignFirstResponder ];
    
    
#if 0
    self.mv = [ [ MenuViewController alloc ] 
               initWithNibName:@"MenuViewController" bundle:nil ];
    TribecaAppDelegate *app = (TribecaAppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app.window addSubview:self.mv.view];
    
#endif
    
}

- (void)orientationChanged:(NSNotification *)note
{

}

- (void) readyPlayer
{
    self.mp =  [ [[MPMoviePlayerController alloc] initWithContentURL:movieURL] autorelease ];
    
    
    [ self.view addSubview:self.mp.view ];
    
    // For 3.2 devices and above
    if ([self.mp respondsToSelector:@selector(loadState)]) 
    {
        // Set movie player layout
        [mp setControlStyle:MPMovieControlStyleFullscreen];
        [mp setFullscreen:YES];
        
        // May help to reduce latency
        [mp prepareToPlay];
        
        [mp play];
#if 0
        // Register that the load state changed (movie is ready)
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(moviePlayerLoadStateChanged:) 
                                                     name:MPMoviePlayerLoadStateDidChangeNotification 
                                                   object:nil];
#endif
    }  
    else
    {
#if 0
        // Register to receive a notification when the movie is in memory and ready to play.
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(moviePreloadDidFinish:) 
                                                     name:MPMoviePlayerContentPreloadDidFinishNotification 
                                                   object:nil];
#endif
    }
    
#if 1
    // Register to receive a notification when the movie has finished playing. 
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(moviePlayBackDidFinish:) 
                                                 name:MPMoviePlayerPlaybackDidFinishNotification 
                                               object:nil];
#endif
    
    // Override point for customization after application launch.
    UIDevice *device = [UIDevice currentDevice];					//Get the device object
	[device beginGeneratingDeviceOrientationNotifications];			//Tell it to start monitoring the accelerometer for orientation
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];	//Get the notification centre for the app
	[nc addObserver:self											//Add yourself as an observer
		   selector:@selector(orientationChanged:)
			   name:UIDeviceOrientationDidChangeNotification
			 object:device];
    
}

- (void)dealloc
{
    //[super dealloc];
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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
