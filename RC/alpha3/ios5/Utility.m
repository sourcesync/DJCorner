//
//  Utility.m
//  Sprawl
//
//  Created by George Williams on 7/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Utility.h"

#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "DJCAPI.h"

@implementation Utility

static BOOL low_mem_warned = NO;


+ (UIFont *) GetStandardFont: (CGFloat)sz 
{
    UIFont *fnt =  [ UIFont fontWithName:@"SansSerifBookFLF" size:sz ];
    if (fnt==nil)
        [ Utility AlertMessage:@"Font not found"];
    return fnt;
}

+ (void) AlertLowMemory 
{
    //  TODO: Seems like there should something else done :)
    if (!low_mem_warned)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"DJ's Corner"
                          message: @"Low Memory"
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
        [alert show];
        [alert release]; 
        
        low_mem_warned = YES;
    }
}

+ (void) AlertError: (NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"DJ's Corner"
                          message: msg
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}


+ (void) AlertMessageNoInternet
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"DJ's Corner"
                          message: @"Cannot Connect To Server"
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}


+ (void) AlertMessage: (NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"DJ's Corner"
                          message: msg
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

+ (void) AlertAPICallFailed
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"DJ's Corner"
                          message: @"API Call Failed."
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}


+ (void) AlertAPICallFailedWithMessage: (NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"DJ's Corner"
                          message: msg
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}



+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize 
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    return newImage;
}

+ (void) emptyImageCache
{
    [[ASIDownloadCache sharedCache] clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
}

+ (UIImage *)downloadImage: (NSString *)url_string
{
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    
    NSURL *url = [NSURL URLWithString:url_string];
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Image download failed."
                                                        message:[error localizedDescription] 
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }];
    
    //[request startAsynchronous];
    [ request startSynchronous ];
    
    UIImage *downloadedImage = [[UIImage alloc] initWithContentsOfFile:[[ASIDownloadCache sharedCache] pathToCachedResponseDataForURL:url]];
    
    [ downloadedImage autorelease ];
    
    return downloadedImage;
}


+(UIImage *)downloadPic: (NSString *)strurl
{    
    UIImage *pic = [ Utility downloadImage:strurl ];
    
    if ( pic == nil ) 
    {
        // TODO: Should warn or something...
        NSString* defaultImage = [[NSBundle mainBundle] pathForResource:@"star_logo" ofType:@"png"];
        NSData *data = [NSData dataWithContentsOfFile:defaultImage ];
        pic = [ [ UIImage alloc ] initWithData:data ];
        
        [ pic autorelease ];
    }
    
    
    
    return pic;
}


+(UIImage *)getPic: (NSString *)name
{
#if 0
    NSString *strurl = [ [ NSString alloc ] initWithFormat:@"%@/%@", 
                        [ SprawlAPI get_image_download_url ], name];  
    [ strurl autorelease ];
    
    return [ Utility downloadPic:strurl ];
#endif
    
    return [ Utility downloadPic:name ];
}

+ (NSString *)dateDiff:(NSDate *)origDate //(NSString *)origDate 
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setFormatterBehavior:NSDateFormatterBehavior10_4];
    [df setDateFormat:@"EEE, dd MMM yy HH:mm:ss VVVV"];
    //NSDate *convertedDate = [df dateFromString:origDate];
    NSDate *convertedDate = origDate;
    [df release];
    NSDate *todayDate = [NSDate date];
    double ti = [convertedDate timeIntervalSinceDate:todayDate];
    ti = ti * -1;
    //if(ti < 1) {
    //    return @"now";
    //} else      
    if (ti < 60) {
        return @"less than a minute ago";
    } else if (ti < 3600) {
        int diff = round(ti / 60);
        return [NSString stringWithFormat:@"%d minutes ago", diff];
    } else if (ti < 86400) {
        int diff = round(ti / 60 / 60);
        return[NSString stringWithFormat:@"%d hours ago", diff];
    } else if (ti < 2629743) {
        int diff = round(ti / 60 / 60 / 24);
        return[NSString stringWithFormat:@"%d days ago", diff];
    } else {
        return @"never";
    }   
}


@end