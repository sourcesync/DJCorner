//
//  DJCAPI.m
//  alpha1
//
//  Created by George Williams on 11/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DJCAPI.h"
#import "JSONRPCService.h"
#import "JSON.h"
//#import "ASIHTTPRequest.h"
//#import "ASIDownloadCache.h"

@implementation DJCAPI

@synthesize delegate=_delegate;
@synthesize svc=_svc;
@synthesize queue=_queue;
@synthesize finishOnMainThread=_finishOnMainThread;

static NSString *SERVER = @"localhost:7777";
//static NSString *SERVER = @"greendotblade5.cs.nyu.edu:7777";
 
-(id) init:(id<DJCAPIServiceDelegate>)del
{
    self = [ super init ];
    if (self) 
    {
        NSString *urlstr = [ NSString stringWithFormat:@"http://%@/api",SERVER ];
        NSURL *url = [ NSURL URLWithString:urlstr ];
        _svc = [[JSONRPCService alloc] initWithURL:url];
        _svc.delegate = self;
        _delegate = del;
        _queue = [NSOperationQueue new];
        _finishOnMainThread = YES;
    }
    return self;
}

-(void) dealloc
{
    
    self.svc = nil;
    self.delegate = nil;
    self.queue = nil;
    
    [ super dealloc];
}


-(BOOL) ExecMethod:
(NSString *)methodName 
         andParams:(NSArray *)parameters 
            withID:(NSString *)identificator
{
    [self.svc execMethod:methodName andParams:parameters withID:identificator];
    return YES;
}

-(BOOL) get_events:(NSDictionary *)location:(NSDictionary *)paging
{
    NSArray *args = [ NSArray arrayWithObjects:location,paging,nil];
    return [self ExecMethod:@"get_events" andParams:args withID:@"0" ];
}

-(BOOL)     get_event:(NSDictionary *)location:(NSString *)eoid
{
    NSArray *args = [ NSArray arrayWithObjects:location,eoid,nil];
    return [self ExecMethod:@"get_event" andParams:args withID:@"1" ];
}


#pragma mark - jsonservice delegate...


#pragma mark - jsonrpc service delegate


-(void) dataLoaded:(NSData*)data 
{
    if (self.delegate!=nil)
    {        
        //  Convert the data to text...
        NSString *txt = [[[NSString alloc] 
                          initWithData:data encoding:NSUTF8StringEncoding] autorelease];
        //arc NSString *txt = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        //  Convert jsonrpc response payload to ios dictinoary...
        NSDictionary* result = [txt JSONValue];
        
        //  Get the id of the rpc call...
        NSString* rpcid = (NSString *)[ result objectForKey:@"id" ];  
        
        //  Get the results of the call as dct...
        NSDictionary* arg = (NSDictionary *)[ result objectForKey:@"result" ];
        
        //
        //  The delegate callback to call is based on rpc id...
        //
        
        NSInteger method_id = [ rpcid integerValue ];
        switch (method_id)
        {
                
            case (GET_EVENTS):
            {
                [ self.delegate got_events:arg ];
                break;
            }
            case (GET_EVENT):
            {
                [ self.delegate got_event:arg ];
                break;
            }
            default:
            {
                //[ Utility AlertError:@"Invalid Method ID" ];
            }
        }
    }
}

-(void) loadingFailed:(NSString*) errMsg 
{
    if (self.delegate!=nil)
    {
        [self.delegate apiLoadingFailed:errMsg];
    }
}

#pragma mark - image stuff...


- (UIImage *)downloadImage: (NSString *)url_string
{
    NSURL *url = [ NSURL URLWithString:url_string ];
    UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
    return image;
}


#if 0  // OLD ASIHTTP VERSION

- (UIImage *)downloadImage: (NSString *)url_string
{
    //  Set default cache...
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    
    //  Create url object from string...
    NSURL *url = [NSURL URLWithString:url_string];
    
    //  Check in cache first...
    UIImage *downloadedImage = [[UIImage alloc] initWithContentsOfFile:[[ASIDownloadCache sharedCache] pathToCachedResponseDataForURL:url]];
    
    if ( downloadedImage == nil ) // Not in cache...
    {
        
        __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request setDownloadCache:[ASIDownloadCache sharedCache]];
        [request setCachePolicy:ASIAskServerIfModifiedCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
        [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
        [request setSecondsToCache:86400];
        [request setDelegate:self];
        [request setCompletionBlock:^{
            NSLog(@"Image download complete.");
            //[self makeAssignment];
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"%@", [error localizedDescription]);
            //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Image download failed."
            //                                                message:[error localizedDescription] 
            //                                               delegate:nil
            //                                      cancelButtonTitle:@"OK"
            //                                      otherButtonTitles:nil];
            //[alert show];
            //[alert release];
        }];
        
        //[ request startAsynchronous];
        [ request startSynchronous ];
        
        downloadedImage = [[UIImage alloc] initWithContentsOfFile:[[ASIDownloadCache sharedCache] pathToCachedResponseDataForURL:url]];
        
    }
    
    [ downloadedImage autorelease ];
    return downloadedImage;
    
}
#endif

- (void)call_got_pic:(UIImageForCell *)ufc
{
    if (self.delegate!=nil)
    {
        [self.delegate got_pic:ufc ];
    }
}

//  Func to get called as operation not in main ui thread...
- (void)downloadImageIdx: (NSString *)url_string: (NSNumber *)idx
{
    //  Get image from cache, or synchronous download (in invocation thread)...
    UIImage *img = [ self downloadImage:url_string ];
    
    UIImageForCell *data = [ [ [ UIImageForCell alloc ] init ] autorelease ]; //gw-analyze
    //arc UIImageForCell *data = [ [ UIImageForCell alloc ] init ]; //gw-analyze
    data.idx = idx; 
    data.img = img;
    
    [ self performSelectorOnMainThread:@selector(call_got_pic:)
                            withObject:data waitUntilDone:YES];
    
}
-(void) asyncDownloadImage: (NSString *)url_string: (NSNumber *)idx
{
    //NSLog(@"%@", url_string);
    
    /* Operation Queue init (autorelease) */
    //NSOperationQueue *queue = [NSOperationQueue new];
    
    SEL mySelector = @selector(downloadImageIdx::);
    NSMethodSignature *sig = [[self class] instanceMethodSignatureForSelector:mySelector];
    NSInvocation *nsi = [ NSInvocation invocationWithMethodSignature:sig ];
    [ nsi setTarget:self ];
    [ nsi setSelector:mySelector ];
    [ nsi setArgument:&url_string atIndex:2 ];
    [ nsi setArgument:&idx atIndex:3 ];
    
    NSInvocationOperation *operation = [ [ NSInvocationOperation alloc ] initWithInvocation:nsi ];
    
    /* Add the operation to the queue */
    [self.queue addOperation:operation];
    
    //[operation release];
}


-(void)asyncGetPic: (NSString *)strurl: (NSNumber *)idx;
{
    //NSString *strurl = [ [ NSString alloc ] initWithFormat:@"%@/%@", 
    //                    [ SprawlAPI get_image_download_url ], name];  
    //[ strurl autorelease ];
    
    [ self asyncDownloadImage:strurl:idx];
}

- (void) cancelRequest
{
    [ self.svc cancelRequest ];
}


- (void) cancelAsyncPicDownloads
{
    [ self.queue cancelAllOperations ];
}



@end
