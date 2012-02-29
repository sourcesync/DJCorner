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
#import "Utility.h"
#import "djcAppDelegate.h"

//#import "ASIHTTPRequest.h"
//#import "ASIDownloadCache.h"

@implementation DJCAPI

@synthesize delegate=_delegate;
@synthesize svc=_svc;
@synthesize queue=_queue;
@synthesize finishOnMainThread=_finishOnMainThread;
//@synthesize Now;

static NSString *TEST_SERVER = @"localhost:7779";
//static NSString *PROD_SERVER = @"www.theuniverseofallthings.com:7779";
//static NSString *SERVER = @"ec2-23-20-62-113.compute-1.amazonaws.com:7779";


+ (NSString *) SERVER
{
    //djcAppDelegate *app = (djcAppDelegate  *)[ [ UIApplication sharedApplication ] delegate ];
    return TEST_SERVER;
}

-(id) init:(id<DJCAPIServiceDelegate>)del
{
    self = [ super init ];
    if (self) 
    {
        NSString *urlstr = [ NSString stringWithFormat:@"http://%@/api",[ DJCAPI SERVER] ];
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
    //NSLog(@"execMethod1");
    [self.svc execMethod:methodName andParams:parameters withID:identificator];
    //NSLog(@"execMethod2");
    return YES;
}


- (void) ExecMethodAsync: 
    (NSString *)methodName: 
    (NSMutableArray *)parms: 
    (NSString *)identifier:
    (BOOL)finishOnMainThread
{
    NSData *data = 
        [self.svc execMethodSync:methodName 
                      andParams:parms 
                      withID:identifier ];
    if ( data == nil )
    {
        [ self performSelectorOnMainThread:@selector(loadingFailed:) 
                                withObject:@"Networking Error"
                             waitUntilDone:YES];
    }
    else
    {
        if ( finishOnMainThread )
        {
            [ self performSelectorOnMainThread:@selector(dataLoaded:) 
                                    withObject:data waitUntilDone:YES];
        }
        else
        {
            [ self performSelector:@selector(dataLoaded:) withObject:data ];
        }
    }
    
}

-(BOOL) get_events:(NSDictionary *)location:(NSDictionary *)paging:
    (NSString *)city:(BOOL)all:(int)sort_criteria
{
    //self.Now=0;
    NSNumber *_all = [ NSNumber numberWithBool:all ];
    NSNumber *_sort_criteria = [ NSNumber numberWithInt:sort_criteria ];
    
    NSArray *args = [ NSArray arrayWithObjects:location,paging,city,_all,_sort_criteria,nil];
    return [self ExecMethod:@"get_events" andParams:args withID:@"0" ];
}

-(BOOL)     get_event:(NSDictionary *)location:(NSString *)eoid
{
    //self.Now=1;
    NSArray *args = [ NSArray arrayWithObjects:location,eoid,nil];
    return [self ExecMethod:@"get_event" andParams:args withID:@"1" ];
}

-(BOOL)     register_device:(NSString *)tokstr
{
    //self.Now=2;
    NSArray *args = [ NSArray arrayWithObjects:tokstr,nil];
    return [self ExecMethod:@"register_device" andParams:args withID:@"2" ];
}

-(BOOL)     followdjs:(NSString *)deviceid:(NSMutableArray *)djs:(NSMutableArray *)djids
{
    //self.Now=3;
    NSArray *args = [ NSArray arrayWithObjects:deviceid,djs,djids,nil];
    return [self ExecMethod:@"followdjs" andParams:args withID:@"3" ];
}


-(BOOL)     get_followdjs:(NSString *)deviceid
{
    //self.Now=4;
    NSArray *args = [ NSArray arrayWithObjects:deviceid,nil];
    return [self ExecMethod:@"get_followdjs" andParams:args withID:@"4" ];
}


-(BOOL)     stop_followdj:(NSString *)deviceid:(NSString *)dj
{
    //self.Now=5;

    NSLog(@"ssssss1111");
    NSLog(@"%@",deviceid);
      NSLog(@"%@",dj);
    NSArray *args = [ NSArray arrayWithObjects:deviceid,dj,nil];
    NSLog(@"ssssss2222");
    return [self ExecMethod:@"stop_followdj" andParams:args withID:@"5" ];
}

-(BOOL)     get_djs:(NSString *)searchrx:(BOOL)all:(NSDictionary *)paging
{
    //self.Now=6;
    NSNumber *_all = [ NSNumber numberWithBool:all];
    NSArray *args = [ NSArray arrayWithObjects:searchrx,_all,paging,nil];
    return [self ExecMethod:@"get_djs" andParams:args withID:@"6" ];
}

-(BOOL)     get_schedule:(NSString *)djid
{
    //self.Now=7;
    NSArray *args = [ NSArray arrayWithObjects:djid,nil];
    return [self ExecMethod:@"get_schedule" andParams:args withID:@"7" ];
}

-(BOOL)     get_dj:(NSString *)djid
{
    //self.Now=8;
    NSArray *args = [ NSArray arrayWithObjects:djid,nil];
    return [self ExecMethod:@"get_dj" andParams:args withID:@"8" ];
}


-(BOOL)     get_similar_djs:(NSString *)djid
{
    //self.Now=9;
    NSArray *args = [ NSArray arrayWithObjects:djid,nil];
    return [self ExecMethod:@"get_similar_djs" andParams:args withID:@"9" ];
}


-(BOOL)     get_cities
{
    //self.Now=10;;
    NSArray *args = nil; //[ NSArray arrayWithObjects:djid,nil];
    return [self ExecMethod:@"get_cities" andParams:args withID:@"10" ];
}

#pragma mark - jsonrpc service delegate

//
//  Func that gets called when JSONRPC succeeds...
//
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
        
        //NSLog(@"%@", result);
        
        //  Get the id of the rpc call...
        NSString* rpcid = (NSString *)[ result objectForKey:@"id" ];  
        
        //  Get the results of the call as dct...
        NSDictionary* arg = (NSDictionary *)[ result objectForKey:@"result" ];
        
        //
        //  The delegate callback to call is based on rpc id...
        //
        //NSInteger method_id =self.Now;
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
            case (REGISTER_DEVICE):
            {
                [ self.delegate device_registered:arg ];
                break;
            }
            case (FOLLOW_DJS):
            {
                [ self.delegate followed_djs: arg];
                break;
            }
            case (GET_FOLLOW_DJS):
            {
                [ self.delegate got_followdjs:arg ];
                break;
            }
            case (STOP_FOLLOW_DJ):
            {
                [ self.delegate stopped_followdj:arg ];
                break;
            }
            case (GET_DJS):
            {
                [ self.delegate got_djs:arg ];
                break;
            }
            case (GET_SCHEDULE):
            {
                [ self.delegate got_schedule :arg ];
                break;
            }
            case (GET_DJ):
            {
                [ self.delegate got_dj :arg ];
                break;
            }
            case (GET_SIMILAR_DJS):
            {
                [ self.delegate got_similar_djs :arg ];
                break;
            }
            case (GET_CITIES):
            {
                [ self.delegate got_cities :arg ];
                break;
            }
            default: 
            {
                //[ Utility AlertError:@"Invalid Method ID" ];
            }
        }
    }
}

//
//  Func that gets called when JSONRPC fails...
//
-(void) loadingFailed:(NSString*) errMsg 
{
    if (self.delegate!=nil)
    {
        [self.delegate apiLoadingFailed:errMsg];
    }
}

#pragma mark - image stuff...

//
//  Func to download in image via url synchronously...
//
- (UIImage *)downloadImage: (NSString *)url_string
{
    //  See if its abs or relative url...
    NSURL *url = nil;
    if ( [ url_string hasPrefix:@"http" ] )
    {
        url = [ NSURL URLWithString:url_string ];
    }
    else
    {
        NSString *fpath = [ NSString stringWithFormat:@"http://%@/%@", 
                           [ DJCAPI SERVER], 
                           url_string ];
        url = [ NSURL URLWithString:fpath ];
    }
                           
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
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"%@", [error localizedDescription]);
            [ Utility AlertAPICallFailedWithMessage:[error localizedDescription] ];
        }];
        
        [ request startSynchronous ];
        
        downloadedImage = [[UIImage alloc] initWithContentsOfFile:[[ASIDownloadCache sharedCache] pathToCachedResponseDataForURL:url]];
        
    }
    
    [ downloadedImage autorelease ];
    return downloadedImage;
    
}
#endif

//
//  Func that gets called when an image is downloaded...
//
- (void)call_got_pic:(UIImageForCell *)ufc
{
    if (self.delegate!=nil)
    {
        [self.delegate got_pic:ufc ];
    }
}

//
//  Func to download an image synchronously in current thread, but invoke 
//  callback in main thread...
//
- (void)downloadImageIdx: (NSString *)url_string: (NSNumber *)idx
{
    //  Get image from cache, or synchronous download (in invocation thread)...
    UIImage *img = [ self downloadImage:url_string ];
    
    
    //  Stuff image into object for callback...
    UIImageForCell *data = [ [ [ UIImageForCell alloc ] init ] autorelease ]; 
    data.idx = idx; 
    data.img = img;
    if (img==nil)
    {
        data.status = 1;
    }
    
    //  Invoke delegate callback in main thread...
    [ self performSelectorOnMainThread:@selector(call_got_pic:)
                            withObject:data waitUntilDone:YES];
    
}

//
//  Func to download an image in a worker queue (also install a callback)...
//
-(void) asyncDownloadImage: (NSString *)url_string: (NSNumber *)idx
{
    //  Create an operation to be used by the queue...
    SEL mySelector = @selector(downloadImageIdx::);
    NSMethodSignature *sig = [[self class] instanceMethodSignatureForSelector:mySelector];
    NSInvocation *nsi = [ NSInvocation invocationWithMethodSignature:sig ];
    [ nsi setTarget:self ];
    [ nsi setSelector:mySelector ];
    [ nsi setArgument:&url_string atIndex:2 ];
    [ nsi setArgument:&idx atIndex:3 ];
    NSInvocationOperation *operation = [ [ NSInvocationOperation alloc ] initWithInvocation:nsi ];
    [ operation autorelease ];
    
    //  Add the operation to the queue...
    [self.queue addOperation:operation];
}

//
//  Func to asynchronously download an image (callback in mainthread)...
//
-(void)asyncGetPic: (NSString *)strurl: (NSNumber *)idx;
{
    [ self asyncDownloadImage:strurl:idx];
}

//
//  Cancel any active api requests...
//
- (void) cancelRequest
{
    [ self.svc cancelRequest ];
}

//  
//  Cancel any operations in the queue...
//
- (void) cancelAsyncPicDownloads
{
    [ self.queue cancelAllOperations ];
}



@end
