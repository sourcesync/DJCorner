//
//  SimpleAnnotation.m
//  Sprawl
//
//  Created by George Williams on 8/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "SimpleLocation.h"

@implementation SimpleLocation

// retained...
@synthesize name = _name;
@synthesize message = _message;
@synthesize coordinate = _coordinate;

// assigned...
@synthesize type=_type;
@synthesize pp=_pp;
@synthesize contact=_contact;

- (id)initWithName
{
    if ((self = [super init])) 
    {
    }
    return self;
}

- (NSString *)title 
{
    return _name;
}

- (NSString *)subtitle 
{ 
    return _message;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    
}

- (void)dealloc
{
    [_name release];
    [_message release];
    [_pp release];
       
    [super dealloc];
}

@end