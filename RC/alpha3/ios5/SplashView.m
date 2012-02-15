//
//  SplashView.m
//  alpha2
//
//  Created by George Williams on 11/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SplashView.h"
#import "djcAppDelegate.h"

@implementation SplashView


@synthesize img=_img;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
    }
    return self;
} 

//-(id)init
//{
//    self = [ self initWithNibName:@"SplashView" bundle:nil ];
//    return self;
//}

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
    
    self.img.backgroundColor = [ UIColor clearColor ];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
    
    
}


-(void)playMovieAtURL:(NSURL*)theURL
{
    theMovie= [[MPMoviePlayerController alloc] initWithContentURL:theURL];
    
    if (theMovie) {
        
        theMovie.scalingMode=MPMovieScalingModeAspectFill;
        theMovie.fullscreen=YES;
        //theMovie.userCanShowTransportControls=NO; 
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(myMovieFinishedCallback:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:theMovie];
        [[theMovie view] setFrame:CGRectMake(0, 0, 320, 460)]; 
        
        // Movie playback is asynchronous, so this method returns immediately. 
        [[self view] addSubview:[theMovie view]]; 
        [theMovie play];
    }
}

// When the movie is done,release the controller.
- (void)myMovieFinishedCallback:(NSNotification*)aNotification
{
    theMovie=[aNotification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:theMovie];
    NSLog(@"finished");  
    [theMovie release];
    [ self performSelectorOnMainThread:@selector(splashDone:)
                            withObject:self 
                         waitUntilDone:NO ];
} 
// play video
- (void)video_play:(NSString*)filename
{
    NSString* file = [[NSBundle mainBundle] pathForResource:filename ofType:@"mp4"];
    NSURL* url = [NSURL fileURLWithPath:file];
    NSLog(@"Playing URL: %@", url);
    [self playMovieAtURL:url];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    
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
    [self video_play:@"DGNYE Logo"];
    
}

-(void) splashDone:(id)obj
{
    
    djcAppDelegate *app = (djcAppDelegate *)
    [ [ UIApplication sharedApplication ] delegate ];
    [ app splashDone ];
    //[self playMisic:@"DGNYE Logo Final 1"];
    
}




@end
