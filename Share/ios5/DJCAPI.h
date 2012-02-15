//
//  DJCAPI.h
//  alpha1
//
//  Created by George Williams on 11/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONRPCService.h"
#import "UIImageForCell.h"

enum API_IDS
{
    GET_EVENTS = 0, 
    GET_EVENT,
    REGISTER_DEVICE,
    FOLLOW_DJS,
    GET_FOLLOW_DJS,
    STOP_FOLLOW_DJ,
    GET_DJS,
    GET_SCHEDULE,
    GET_DJ,
    GET_SIMILAR_DJS
};

@protocol DJCAPIServiceDelegate

@optional -(void) dataLoaded:(NSData*)data;
@required -(void) apiLoadingFailed:(NSString*) errMsg;
@optional -(void) got_events:(NSDictionary *)data; //0
@optional -(void) got_event:(NSDictionary *)data; //1
@optional -(void) device_registered:(NSDictionary *)data; //2
@optional -(void) followed_djs:(NSDictionary *)data; //3
@optional -(void) got_followdjs:(NSDictionary *)data; //4
@optional -(void) stopped_followdj:(NSDictionary *)data; //5
@optional -(void) got_djs:(NSDictionary *)data; //6
@optional -(void) got_schedule:(NSDictionary *)data; //7
@optional -(void) got_dj:(NSDictionary *)data; //8
@optional -(void) got_similar_djs:(NSDictionary *)data; //9

@optional -(void) got_pic:(UIImageForCell *)ufc;
@end

@interface DJCAPI : NSObject <JSONRPCServiceDelegate>

//  RETAIN...
@property (nonatomic, retain) id<DJCAPIServiceDelegate> delegate;
@property (nonatomic, retain) JSONRPCService* svc;
@property (nonatomic, retain) NSOperationQueue *queue;

//  ASSIGN...
@property (nonatomic, assign) BOOL finishOnMainThread;

//  PUBLIC FUNCS...
-(id)       init:(id<DJCAPIServiceDelegate>)del;
-(BOOL)     get_events:(NSDictionary *)location:(NSDictionary *)paging:(NSString *)city:(BOOL)all;
-(BOOL)     get_event:(NSDictionary *)location:(NSString *)eoid;
-(BOOL)     register_device:(NSString *)tokstr;
-(BOOL)     followdjs:(NSString *)deviceid:(NSMutableArray *)djs:(NSMutableArray *)djids;
-(BOOL)     get_followdjs:(NSString *)deviceid;
-(BOOL)     stop_followdj:(NSString *)deviceid:(NSString *)dj;
-(BOOL)     get_djs:(NSString *)searchrx:(BOOL)all_djs:(NSDictionary *)paging;
-(BOOL)     get_schedule:(NSString *)djid;
-(BOOL)     get_dj:(NSString *)djid;
-(BOOL)     get_similar_djs:(NSString *)djid;

- (void)    asyncDownloadImage: (NSString *)url_string: (NSNumber *)idx;
- (void)    asyncGetPic: (NSString *)name: (NSNumber *)idx;
- (void)    cancelRequest;
- (void)    cancelAsyncPicDownloads;

@end
