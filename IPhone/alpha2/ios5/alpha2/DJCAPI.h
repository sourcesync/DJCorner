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
    GET_EVENT
};

@protocol DJCAPIServiceDelegate

@optional -(void) dataLoaded:(NSData*)data;
@required -(void) apiLoadingFailed:(NSString*) errMsg;
@optional -(void) got_events:(NSDictionary *)data; //0
@optional -(void) got_event:(NSDictionary *)data; //0

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
-(BOOL)     get_events:(NSDictionary *)location:(NSDictionary *)paging;
-(BOOL)     get_event:(NSDictionary *)location:(NSString *)eoid;
- (void)    asyncDownloadImage: (NSString *)url_string: (NSNumber *)idx;
- (void)    asyncGetPic: (NSString *)name: (NSNumber *)idx;
- (void)    cancelRequest;
- (void)    cancelAsyncPicDownloads;

@end
