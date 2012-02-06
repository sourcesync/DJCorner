//
//  EventsGetter.m
//  alpha2
//
//  Created by George Williams on 11/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DJSGetter.h"
#import "DJ.h"
#import "SimpleLocation.h"
#import "DJCAPI.h"
#import "Utility.h"

#define GETTER_PAGE_SIZE 10

@implementation DJSGetter

@synthesize djs=_djs;
@synthesize delegate=_delegate;
@synthesize api=_api;
@synthesize total_to_get=_total_to_get;
@synthesize first_time=_first_time;
@synthesize call_in_progress=_call_in_progress;
@synthesize latitude=_latitude;
@synthesize longitude=_longitude;
@synthesize connectionProblem=_connectionProblem;
@synthesize search=_search;
@synthesize end=_end;
@synthesize all_djs=_all_djs;
@synthesize got_all;

-(id) init 
{
    self = [ super init ];
    self.api = [ [ [ DJCAPI alloc ] init:self ] autorelease];
    //self.api = [ [ DJCAPI alloc ] init:self ];
    self.djs = nil;
    self.total_to_get = 0;
    self.first_time = YES;
    self.call_in_progress = NO;
    self.connectionProblem = NO;
    self.search = @"";
    self.end = 0;
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
        NSInteger count = [ self.djs count];
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
       
        NSString *search = self.search;
        if ( search == nil ) search = @"";
        
        BOOL all_djs = self.all_djs;
        
        if ( ! [ self.api get_djs: search :all_djs: paging ] )        
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
    self.search = nil;
    self.djs = nil;
    
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

-(void) got_djs:(NSDictionary *)data
{
    self.call_in_progress = NO;
    
    NSInteger status = [ [ data objectForKey:@"status" ] integerValue ];
    if (status>0)
    {
        //  Get return paging info...
        NSMutableDictionary *paging = [ data objectForKey:@"paging" ];  
        NSNumber *_total = [ paging objectForKey:@"total" ];
        self.total_to_get = [ _total intValue ];
        NSNumber *_start = [ paging objectForKey:@"start" ];
        NSInteger start = [ _start integerValue ];
        NSNumber *_eend = [ paging objectForKey:@"end" ];
        NSInteger eend = [ _eend integerValue ];
        self.end = eend;
        
        //
        //  Copy new items into array...
        //
        NSMutableArray *results = [ data objectForKey:@"results" ];
        //NSLog(@"%@", results);
        
        NSMutableArray *djs = [ DJ ParseFromAPI:results ];
        if (self.djs == nil ) 
        {
            self.djs = 
                [ [ [ NSMutableArray alloc ] initWithCapacity:self.total_to_get ] autorelease];
        } 
        [ self.djs addObjectsFromArray:djs ];
        
        //  call delegate...
        if (self.delegate!=nil) [ self.delegate got_djs:start :eend ];
        
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
    if (self.delegate!=nil)
    {
        [self.delegate got_pic:ufc ];
    }
}


@end
