//
//  EventsGetter.m
//  alpha2
//
//  Created by George Williams on 11/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EventsGetter.h"
#import "Event.h"
#import "SimpleLocation.h"
#import "DJCAPI.h"
#import "Utility.h"

#define GETTER_PAGE_SIZE 6

@implementation EventsGetter


@synthesize events=_events;
@synthesize delegate=_delegate;
@synthesize api=_api;
@synthesize total_to_get=_total_to_get;
@synthesize first_time=_first_time;
@synthesize call_in_progress=_call_in_progress;
@synthesize latitude=_latitude;
@synthesize longitude=_longitude;
@synthesize connectionProblem=_connectionProblem;
@synthesize cur_city_search=_cur_city_search;
@synthesize all_djs=_all_djs;
@synthesize got_all=_got_all;

-(id) init 
{
    self = [ super init ];
    self.api = [ [ [ DJCAPI alloc ] init:self ] autorelease];
    //self.api = [ [ DJCAPI alloc ] init:self ];
    self.events = nil;
    self.total_to_get = 0;
    self.first_time = YES;
    self.call_in_progress = NO;
    self.connectionProblem = NO;
    self.all_djs = YES;
    self.got_all = NO;
    return self;
} 

-(NSMutableDictionary *) getPagingDct:(NSInteger)start:(NSInteger)end
{
    // paging info...
    NSMutableDictionary *paging = [[NSMutableDictionary alloc] initWithCapacity:2];
    [ paging autorelease ];
    [ paging setObject:[NSNumber numberWithInt:start] forKey:@"start"];
    [ paging setObject:[NSNumber numberWithInt:end] forKey:@"end"];
    return paging;
}

-(NSMutableDictionary *) getLocDct
{
    // location info...
    NSMutableDictionary *loc = [[NSMutableDictionary alloc] initWithCapacity:0];
    [ loc autorelease ];
    [ loc setObject:[NSNumber numberWithDouble:self.latitude] forKey:@"lat" ];
    [ loc setObject:[NSNumber numberWithDouble:self.longitude] forKey:@"lng" ];
    return loc;
}

-(void) asyncGetPic:path:num
{
    [ self.api asyncGetPic:path :num ];
}

-(void) getNext
{
    //
    //  Calc the api call params...
    //
    NSInteger start = -1;
    NSInteger end = -1;
    BOOL go = NO;
    if (self.first_time)
    {
        self.first_time = NO;
        start = 0;
        end = GETTER_PAGE_SIZE - 1;
        go = YES;
    }
    else
    {
        //  How many left...
        NSInteger count = [ self.events count];
        if ( ( self.total_to_get - count  ) > 0 )
        {
            start = count;
            end = count + GETTER_PAGE_SIZE;
            go = YES;
        }
        else
        {
            self.got_all = YES;
        }
    }
    
    //
    //  Make the api call...
    //
    if (go)
    { 
        self.call_in_progress = YES;
        NSMutableDictionary *paging = [ self getPagingDct:start:end ];
        NSMutableDictionary *loc = [ self getLocDct ];
        NSString *city = @""; 
        if (self.cur_city_search) 
        {
            city = self.cur_city_search;
        }
        BOOL all_djs = self.all_djs;
        
        if ( ! [ self.api get_events:loc :paging :city:all_djs ] )        
        {
            self.call_in_progress = NO;
            
            //  invoke delegate...
            if (self.delegate!=nil) [ self.delegate failed ];
            
            [ Utility AlertAPICallFailed ];
        }
    }
}

-(void) cancel
{
    self.connectionProblem = NO;
    [ self.api cancelRequest ];
    [ self.api cancelAsyncPicDownloads ];
    self.call_in_progress = NO;
    
    //  TODO: probably should wait until calls are flushed...
}

-(void) finished
{
    [ self cancel ];
    self.delegate = nil;
}

-(void) dealloc
{
    self.api.delegate = nil;
    self.api = nil;
    
    [ super dealloc ];
}

#pragma mark - djcapi...

-(void) apiLoadingFailed:(NSString *)errMsg
{
    self.connectionProblem = YES;
    self.call_in_progress = NO;
    
    //  invoke delegate...
    if (self.delegate!=nil) [ self.delegate failed ];
    
    [ Utility AlertAPICallFailedWithMessage:errMsg ];
}

-(void) got_events:(NSDictionary *)data
{
    self.call_in_progress = NO;
    
    //NSLog(@"%@", data);
    
    NSNumber *_status = [ data objectForKey:@"status" ];
    NSInteger status = [ _status integerValue ];
    if (status>0)
    {
        //  Get return paging info...
        NSMutableDictionary *paging = [ data objectForKey:@"paging" ];  
        NSNumber *_total = [ paging objectForKey:@"total" ];
        self.total_to_get = [ _total intValue ];
        NSNumber *_start = [ data objectForKey:@"start" ];
        NSInteger start = [ _start integerValue ];
        NSNumber *_end = [ data objectForKey:@"end" ];
        NSInteger end = [ _end integerValue ];
        
        //
        //  Copy new items into array...
        //
        NSMutableArray *results = [ data objectForKey:@"results" ];
        NSMutableArray *evts = [ Event ParseFromAPIEvents:results ];
        if (self.events == nil ) 
        {
            self.events = 
                [ [ [ NSMutableArray alloc ] initWithCapacity:self.total_to_get ] autorelease];
        } 
        [ self.events addObjectsFromArray:evts ];
        
        //  call delegate...
        if (self.delegate!=nil) [ self.delegate got_events:start :end ];
        
    }
    else
    {
        //  Invoke delegate...
        if (self.delegate!=nil) [ self.delegate failed ];
        
        [ Utility AlertAPICallFailedWithMessage:@"API Call Return Bad Status." ];
    }
}

-(void) got_pic:(UIImageForCell *)ufc
{
    //int row = [ ufc.idx integerValue ];
    if (self.delegate!=nil)
    {
        [self.delegate got_pic:ufc ];
    }
}


@end
