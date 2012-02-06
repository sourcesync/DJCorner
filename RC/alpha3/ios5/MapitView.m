//
//  MapitView.m
//  alpha2
//
//  Created by George Williams on 12/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapitView.h"
#import "Utility.h"
#import "EventView.h"

@implementation MapitView

@synthesize mapv=_mapv;
@synthesize location=_location;
@synthesize activity=_activity;
@synthesize latlong=_latlong;
@synthesize header=_header;
@synthesize parent=_parent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    self.location = nil;
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
    
    self.mapv.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewDidAppear:(BOOL)animated
{
    double lat = self.latlong.latitude;
    double lng = self.latlong.longitude;
    
    NSString *strurl = [ NSString stringWithFormat: 
                        @"http://maps.googleapis.com/maps/api/staticmap?zoom=16&size=512x512&maptype=roadmap&markers=color:blue%%7Clabel:S%%7C%f,%f&sensor=false", 
                        lat, lng                        ]; 
    //NSLog(strurl);
    NSURL *url = [ NSURL URLWithString:strurl ];
    NSData *data = [ NSData dataWithContentsOfURL:url ];
    
    //[data autorelease];
    if (data==nil)
    {
        [ Utility AlertMessage:@"Map not available" ];
        self.mapv.hidden = YES;
        self.activity.hidden = YES;
    }
    else
    {
        UIImage *img = [ UIImage imageWithData:data ];
        //[ img autorelease ];
        [ self.mapv setImage:img ];
        self.mapv.hidden = NO;
        self.activity.hidden = YES;
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    self.mapv.hidden = YES;
    self.activity.hidden = NO;
    
    self.header.text = self.location;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - button back...

-(IBAction) buttonBack: (id)sender
{
    if ( [self.parent isKindOfClass:[ EventView class] ] )
    {
        EventView *eview = (EventView *)self.parent;
        eview.back_from = YES;
    }
    
    [ self dismissModalViewControllerAnimated:YES ];
}

@end
