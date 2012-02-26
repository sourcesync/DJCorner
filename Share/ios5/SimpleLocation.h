//
//  SimpleAnnotation.h
//  Sprawl
//
//  Created by George Williams on 8/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SimpleLocation : NSObject <MKAnnotation> 
{
}


//  RETAIN...
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSString *pp;

//  ASSIGN...
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) int type;
@property (nonatomic, assign) BOOL contact;

- (id)initWithName;
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end 
