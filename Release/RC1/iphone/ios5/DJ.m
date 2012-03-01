//
//  Event.m
//  alpha1
//
//  Created by George Williams on 11/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DJ.h"

@implementation DJ

@synthesize name=_name;
@synthesize djid=_djid;
@synthesize pic_path=_pic_path;
@synthesize latitude=_latitude;
@synthesize longitude=_longitude;
@synthesize venue=_venue;
@synthesize distance=_distance;
@synthesize website=_website;
@synthesize rating=_rating;
@synthesize upcoming=_upcoming;

-(void) dealloc
{
    self.name = nil;
    self.djid = nil;
    self.pic_path = nil;
    self.venue = nil;
    self.website = nil;
    self.upcoming = nil;
    
    [ super dealloc ];
}


+(NSMutableArray *) ParseFromAPI: (NSMutableArray *)arr
{
    int count = [ arr count ];
    NSMutableArray *djs = [ [ NSMutableArray alloc ] initWithCapacity:count ];
    [ djs autorelease ];
    
    for ( int i=0;i<count;i++)
    {
        NSDictionary *item = [ arr objectAtIndex:i ];
        
        //NSLog(@"%@",item);
        
        //  Get event object...
        DJ *dj = [ [ DJ alloc ] init ];   
        [dj autorelease];
        
        //  dj name...
        dj.name =  [ item objectForKey:@"name" ];
        
        //  djid name...
        dj.djid =  [ item objectForKey:@"id" ];
        
        //jd pic_path 
        dj.pic_path=[item objectForKey:@"pic"];
        
        //  rating...
        NSNumber *_num =  [ item objectForKey:@"rating" ];
        if ( _num )
            dj.rating = [ _num intValue ];
        else
            dj.rating = -1;
        
        //  upcoming
        NSString *upcoming = [item objectForKey:@"upcoming"];
        dj.upcoming = upcoming;
#if 0
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
        NSString *pf =  [ item objectForKey:@"pf" ];
        ev.performers = pf;
#endif
        
        [ djs addObject:dj ];
    }
    
    return djs;
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
