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
@synthesize performers=_performers;
@synthesize datestr=_datestr;
@synthesize startdate=_startdate;
@synthesize enddate=_enddate;
@synthesize pfids=_pfids;
@synthesize city=_city;

-(void) dealloc
{
    self.name = nil;
    self.pic_path = nil;
    self.venue = nil;
    self.buyurl = nil;
    self.datestr = nil;
    self.performers = nil;
    self.startdate = nil;
    self.enddate = nil;
    self.pfids = nil;
    self.city = nil;
    
    [ super dealloc ];
}


+(NSMutableArray *) ParseFromAPIEvents: (NSMutableArray *)arr
{
    int count = [ arr count ];
    NSMutableArray *events = [ [ NSMutableArray alloc ] initWithCapacity:count ];
    [ events autorelease ];
    
    for ( int i=0;i<count;i++)
    {
        NSDictionary *item = [ arr objectAtIndex:i ];
        
        //NSLog(@"%@",item);
        
        //  Get event object...
        Event *ev = [ [ Event alloc ] init ];   
        [ev autorelease];
        
        //  event name...
        ev.name =  [ item objectForKey:@"name" ];
        
        //  event date...
        NSString *edate = [ item objectForKey:@"eventdate"];
        ev.datestr = edate;
        
        //  start date...
        NSString *sdate = [ item objectForKey:@"startdate"];
        ev.startdate = sdate;
        
        //  end date...
        NSString *enddate = [ item objectForKey:@"enddate"];
        ev.enddate = enddate;
        
        //  event pic...
        ev.pic_path = [ item objectForKey:@"imgpath" ];
        
        //  event venue...
        ev.venue = [ item objectForKey:@"venuename" ];
        
        //  event distance...
        NSNumber *num = [ item objectForKey:@"dist" ];
        ev.distance = [ num integerValue ];
        
        //  event lat...
        num = [ item objectForKey:@"latitude" ];
        ev.latitude = [ num doubleValue ];
        
        //  event long...
        num = [ item objectForKey:@"longitude" ];
        ev.longitude = [ num doubleValue ];
        
        //  event buy url...
        ev.buyurl = [ item objectForKey:@"buyurl" ];
        
        //  event performers...
        NSMutableArray *pf =  [ item objectForKey:@"pf" ];
        ev.performers = pf;
        
        NSMutableArray *pfids = [ item objectForKey:@"pfids" ];
        ev.pfids = pfids;
        
        //  city...
        NSString *city = [ item objectForKey:@"city" ];
        ev.city = city;
        
        [ events addObject:ev ];
    }
    
    return events;
}

+(Event *) ParseFromAPIEvent: (NSDictionary *)item
{
    NSLog(@"%@",item);
        
    Event *ev = [ [ Event alloc ] init ];   
    [ev autorelease];
    
    //  event name...
    NSString *ename = [ item objectForKey:@"name" ];
    ev.name =  ename;
    
    //  event date...
    NSString *edate = [ item objectForKey:@"eventdate"];
    ev.datestr = edate;
    
    //  start date...
    NSString *sdate = [ item objectForKey:@"startdate"];
    ev.startdate = sdate;
    
    //  end date...
    NSString *enddate = [ item objectForKey:@"enddate"];
    ev.enddate = enddate;
    
    //  image path...
    ev.pic_path = [ item objectForKey:@"imgpath" ];
        
    //  venue...
    ev.venue = [ item objectForKey:@"venuename" ];
        
    //  distance...
    NSNumber *num = [ item objectForKey:@"dist" ];
    ev.distance = [ num integerValue ];
        
    //  latitude...
    num = [ item objectForKey:@"latitude" ];
    ev.latitude = [ num doubleValue ];
        
    //  longitude...
    num = [ item objectForKey:@"longitude" ];
    ev.longitude = [ num doubleValue ];
        
    //  buy url...
    ev.buyurl = [ item objectForKey:@"buyurl" ];
        
    //  event date str...
    ev.datestr = [ item objectForKey:@"eventdate" ];
    
    //  event performers...
    NSMutableArray *pf =  [ item objectForKey:@"pf" ];
    ev.performers = pf;
    
    NSMutableArray *pfids = [ item objectForKey:@"pfids" ];
    ev.pfids = pfids;
    
    return ev;
}

@end
