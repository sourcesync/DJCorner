//
//  ViewController.m
//  DJSCornerIntro
//
//  Created by George Williams on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "djcAppDelegate.h"

@implementation ViewController

@synthesize fmv=_fmv;
@synthesize tapped=_tapped;
@synthesize player=_player;
@synthesize counter=_counter;
@synthesize state=_state;
@synthesize in_app=_in_app;


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
    // Release any cached data, images, etc that aren't in use.
}



-(BOOL) tapDone
{
    if (self.tapped) return true;
    self.tapped = YES;
    
    [ self doVolumeFade ];
    
    self.fmv.hidden = YES;
    
    [ self gotoapp ];
    
    //self.view.backgroundColor = [ UIColor whiteColor ];
    [ [ UIApplication sharedApplication ] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [ [ UIApplication sharedApplication ] setStatusBarHidden:NO ];
    
    return true;
}


-(void)doVolumeFade
{  
    if (self.player.volume > 0.01) {
        self.player.volume = self.player.volume - 0.01;
        
        if (self.state != STOPPED )
        {
            [self performSelector:@selector(doVolumeFade) withObject:nil afterDelay:0.10];    
        }
    } else {
        // Stop and get the sound ready for playing again
        [self.player stop];
        self.player.currentTime = 0;
        [self.player prepareToPlay];
        self.player.volume = 0.5;
        self.state = STOPPED;
    }
}

-(void) gotoapp
{ 
    if (!self.in_app)
    {
        self.in_app = YES;
        djcAppDelegate *app = (djcAppDelegate *)
        [ [ UIApplication sharedApplication ] delegate ];
        [ app splashDone ];
    }
}

-(void) playAudio
{
    [self.player play ];
    [self.player setVolume:0.5];
}


-(void) stopAudio
{
    [self.player setVolume:0.0];
    [self.player stop ];
    self.player.currentTime = 0;
    [self.player prepareToPlay];
}


-(BOOL) prepAudio
{
    
	NSError *error;
	NSString *path = [[NSBundle mainBundle] pathForResource:@"introaudio" ofType:@"mp3"];
	if (![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        return NO; 
    }
	//Initialize the player
	self.player = [[AVAudioPlayer alloc] 
                   initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error];
	//self.player.delegate = self;
    self.player.numberOfLoops = -1;  
	if (!self.player)
	{
		NSLog(@"Error: %@", [error localizedDescription]);
		return NO;
	} 
	[self.player prepareToPlay];
    
    
    return YES;
}

- (void) fadeOut
{    
    if ( self.state ==  PLAYING )
    {
        self.state = FADING_OUT;
        
        [ self doVolumeFade ];
        
        self.fmv.hidden = YES;
        
        [ self gotoapp ];
        [ [ UIApplication sharedApplication ] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        [ [ UIApplication sharedApplication ] setStatusBarHidden:NO ];
    }
}


- (void) trackDone: (id)obj
{
    if ( self.state == PLAYING )
    {
        NSNumber *_num = (NSNumber *)obj;
        int counter = [ _num intValue ];
        [ _num release ];
        if (counter == self.counter)
        {
            [ self fadeOut ];
            
            [ self prepVideo ];
        }
    }
}

- (void) playIntro
{
    if ( ( self.state == READY ) || ( self.state == STOPPED ) )
    {
        self.state = PLAYING;
        
        //  READY OR STOPPED OR FADING OUT...
    
        self.view.backgroundColor = [ UIColor blackColor ];
        [ [ UIApplication sharedApplication ] setStatusBarHidden:YES ];
        self.tapped = NO;
    
        self.fmv.hidden = NO;
        [ self.fmv play ];
    
        [self.player setCurrentTime:0];
        [self playAudio ];
    
        self.counter += 1;
        NSNumber *_num = [ [ NSNumber alloc ] initWithInt:self.counter ];
        [ self performSelector:@selector(trackDone:) withObject:_num afterDelay:60*3 ];
    }
}

- (void) stopIntro
{
    if ( ( self.state == FADING_OUT) || ( self.state == PLAYING) )
    {
        self.state = STOPPED;
        
        [ self.fmv stop ];
    
        [ self stopAudio ];
        
        self.state = STOPPED;
    }
}

-(void) prepVideo
{
    self.fmv = [ [ [ MyMovieView alloc ] 
                  initWithFrame:
                  CGRectMake(0, 0, 320, 480):@"introvideo":2 ] autorelease ];
    //self.fmv.section = sct;
    self.fmv.del = self;
    [ self.view addSubview:self.fmv ];
    [ self.view bringSubviewToFront:self.fmv ];
    self.fmv.hidden = YES;
    
    //[ self.fmv load ];
}

-(void) prepIntro
{
    self.state = LOADING;
    
    [ self prepVideo ];
    
    [ self prepAudio ];
    
    self.state = READY;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [ self prepIntro ];
    
    
    self.view.backgroundColor = [ UIColor blackColor ];
    
    
    [ [ UIApplication sharedApplication ] setStatusBarHidden:YES ];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [ self playIntro ];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
    // Return YES for supported orientations
    //return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
