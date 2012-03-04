//
//  Event.m
//  alpha1
//
//  Created by George Williams on 11/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Venue.h"

@implementation Venue

@synthesize name=_name;
@synthesize vid=_vid;
@synthesize pic_path=_pic_path;

@synthesize latitude=_latitude;
@synthesize longitude=_longitude;
//@synthesize venue=_venue;

@synthesize distance=_distance;
@synthesize website=_website;
@synthesize rating=_rating;
@synthesize upcoming=_upcoming;

-(void) dealloc
{
    self.name = nil;
    self.vid = nil;
    self.pic_path = nil;
    //self.venue = nil;
    self.website = nil;
    self.upcoming = nil;
    
    [ super dealloc ];
}


+(NSMutableArray *) ParseFromAPI: (NSMutableArray *)arr
{
    int count = [ arr count ];
    NSMutableArray *venues = [ [ NSMutableArray alloc ] initWithCapacity:count ];
    [ venues autorelease ];
    
    for ( int i=0;i<count;i++)
    {
        NSDictionary *item = [ arr objectAtIndex:i ];
        
        //NSLog(@"%@",item);
        
        //  Get event object...
        
        Venue *v = [ [ Venue alloc ] init ];   
        [v autorelease];
        
        //venue name...
        NSString *name = [ item objectForKey:@"name" ];
        v.name =  name;
        
        //venue name...
        v.vid =  [ item objectForKey:@"id" ];
        
        //venue pic_path 
        v.pic_path=[item objectForKey:@"pic"];
    
        //venue rating...
        NSNumber *_num =  [ item objectForKey:@"rating" ];
        if ( _num )
            v.rating = [ _num intValue ];
        else
            v.rating = -1;
        
        //  upcoming
        NSString *upcoming = [item objectForKey:@"upcoming"];
        v.upcoming = upcoming;
        
        [ venues addObject:v ];
    }
    
    return venues;
}

#if 0
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
    NSString *pf =  [ item objectForKey:@"pf" ];
    ev.performers = pf;
    
    return ev;
}
#endif

@end
