//
//  EventsGetter.h
//  alpha2
//
//  Created by George Williams on 11/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UIImageForCell.h"
#import "DJCAPI.h"

@protocol EventsGetterDelegate <NSObject>
-(void)got_events:(NSInteger)start:(NSInteger)end;
-(void)got_pic:(UIImageForCell *)img;
-(void)failed;
@end

@interface EventsGetter : NSObject 
    <DJCAPIServiceDelegate>
{

} 

//  RETAIN... 
@property (nonatomic, retain) NSMutableArray *events;
@property (nonatomic, retain) DJCAPI *api;
@property (nonatomic, retain) NSString *cur_city_search;
@property (nonatomic, retain) NSMutableDictionary *picdic;

//  ASSIGN...
@property (nonatomic, assign) id<EventsGetterDelegate> delegate;
@property (nonatomic, assign) NSInteger total_to_get;
@property (nonatomic, assign) BOOL first_time;
@property (nonatomic, assign) BOOL call_in_progress;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) BOOL connectionProblem;
@property (nonatomic, assign) BOOL all_djs;
@property (nonatomic, assign) BOOL got_all;


//  PUBLIC FUNCS...
-(id)   init;
-(void) getNext; 
-(void) cancel;
-(UIImage *) getCachePic:(NSNumber *)idx;
-(void) asyncGetPic:(NSString *)path:(NSNumber *)idx;
-(void) finished;
-(void) removeCache;

@end
 