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

@protocol DJSGetterDelegate <NSObject>
-(void)got_djs:(NSInteger)start:(NSInteger)end;
-(void)got_pic:(UIImageForCell *)img;
-(void)failed;
@end

@interface DJSGetter : NSObject 
    <DJCAPIServiceDelegate>
{

} 


//  RETAIN... 
@property (nonatomic, retain) NSMutableArray *djs;
@property (nonatomic, retain) DJCAPI *api;
@property (nonatomic, retain) NSString *search;
@property (nonatomic, retain) NSMutableDictionary *picdic;

//  ASSIGN...
@property (nonatomic, assign) id<DJSGetterDelegate> delegate;
@property (nonatomic, assign) NSInteger total_to_get;
@property (nonatomic, assign) BOOL first_time;
@property (nonatomic, assign) BOOL call_in_progress;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) BOOL connectionProblem;
@property (assign) NSInteger end;
@property (assign) BOOL all_djs;
@property (assign) BOOL got_all;

//  PUBLIC FUNCS...
-(id)   init;
-(void) getNext; 
-(void) cancel;
-(void) asyncGetPic:(NSString *)pp:(NSNumber *)idx;
-(void) finished;
-(UIImage *) getCachePic:(NSNumber *)num;
-(void) removeCache;

@end
 