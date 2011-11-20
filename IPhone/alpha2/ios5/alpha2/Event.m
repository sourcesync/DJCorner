//
//  Event.m
//  alpha1
//
//  Created by George Williams on 11/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Event.h"

@implementation Event

@synthesize name=_name;
@synthesize pic_path=_pic_path;
@synthesize latitude=_latitude;
@synthesize longitude=_longitude;
@synthesize venue=_venue;
@synthesize distance=_distance;
@synthesize buyurl=_buyurl;

-(void) dealloc
{
    self.name = nil;
    self.pic_path = nil;
    self.venue = nil;
    
    [ super dealloc ];
}


+(NSMutableArray *) ParseFromAPI: (NSMutableArray *)arr
{
    int count = [ arr count ];
    NSMutableArray *events = [ [ NSMutableArray alloc ] initWithCapacity:count ];
    [ events autorelease ];
    
    for ( int i=0;i<count;i++)
    {
        NSDictionary *item = [ arr objectAtIndex:i ];
        
        NSLog(@"%@",item);
        
        Event *ev = [ [ Event alloc ] init ];   
        [ev autorelease];
        ev.name =  [ item objectForKey:@"name" ];
        ev.pic_path = [ item objectForKey:@"imgpath" ];
        
        ev.venue = [ item objectForKey:@"venuename" ];
        
        NSNumber *num = [ item objectForKey:@"dist" ];
        ev.distance = [ num integerValue ];
        
        num = [ item objectForKey:@"latitude" ];
        ev.latitude = [ num doubleValue ];
        
        num = [ item objectForKey:@"longitude" ];
        ev.longitude = [ num doubleValue ];
        
        ev.buyurl = [ item objectForKey:@"buyurl" ];
        
        [ events addObject:ev ];
    }
    
    return events;
}

+(Event *) ParseFromAPI2: (NSDictionary *)item
{
    
    NSLog(@"%@",item);
        
    Event *ev = [ [ Event alloc ] init ];   
    [ev autorelease];
    ev.name =  [ item objectForKey:@"name" ];
    ev.pic_path = [ item objectForKey:@"imgpath" ];
        
    ev.venue = [ item objectForKey:@"venuename" ];
        
    NSNumber *num = [ item objectForKey:@"dist" ];
    ev.distance = [ num integerValue ];
        
    num = [ item objectForKey:@"latitude" ];
    ev.latitude = [ num doubleValue ];
        
    num = [ item objectForKey:@"longitude" ];
    ev.longitude = [ num doubleValue ];
        
    ev.buyurl = [ item objectForKey:@"buyurl" ];
        
    return ev;
}

@end
