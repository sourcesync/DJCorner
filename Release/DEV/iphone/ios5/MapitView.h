//
//  MapitView.h
//  alpha2
//
//  Created by George Williams on 12/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"

@interface MapitView : UIViewController 
{
    
}

//  IBOUTLET...
@property (nonatomic, retain) IBOutlet UIImageView *mapv;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, retain) IBOutlet UILabel *header;

//  RETAIN...
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) UIViewController *parent;

//  ASSIGN...
@property (nonatomic, assign) CLLocationCoordinate2D latlong;

//  PUBLIC FUNCS...
-(IBAction) buttonBack: (id)sender;

@end
