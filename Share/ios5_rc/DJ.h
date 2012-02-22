//
//  Event.h
//  alpha1
//
//  Created by George Williams on 11/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DJ : NSObject
 
 
//  RETAIN...
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *djid;
@property (nonatomic, retain) NSString *pic_path;
@property (nonatomic, retain) NSString *venue;
@property (nonatomic, retain) NSString *website;

//  ASSIGN...
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) double distance;
@property (nonatomic, assign) int rating;
//
//@property (nonatomic,retain) DJ *dj;
@property (nonatomic,retain) UIImage *appIcon;
 


//  PUBLIC FUNCS...
+(NSMutableArray *) ParseFromAPI:(NSMutableArray *)arr;


@end
