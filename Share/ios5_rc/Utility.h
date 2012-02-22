//
//  Utility.h
//  Sprawl
//
//  Created by George Williams on 7/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Utility : NSObject 
{
}

+ (UIFont *) GetStandardFont: (CGFloat)sz;
+ (void) AlertLowMemory;
+ (void) AlertError: (NSString *)msg;
+ (void) AlertAPICallFailed;
+ (void) AlertAPICallFailedWithMessage: (NSString *)msg;
+ (void) AlertMessage: (NSString *)msg;
+ (void) AlertMessageNoInternet;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+ (UIImage *)downloadImage:(NSString *)url;
+ (UIImage *)downloadPic:(NSString *)url;
+ (UIImage *)getPic:(NSString *)url;
+ (void) emptyImageCache;
+ (NSString *)dateDiff:(NSDate *)origDate;

@end
