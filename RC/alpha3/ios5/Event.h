//
//  Event.h
//  alpha1
//
//  Created by George Williams on 11/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject
 
//  RETAIN...
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *pic_path;
@property (nonatomic, retain) NSString *venue;
@property (nonatomic, retain) NSString *buyurl;
@property (nonatomic, retain) NSString *datestr;
@property (nonatomic, retain) NSMutableArray *performers;
@property (nonatomic, retain) NSString *startdate;
@property (nonatomic, retain) NSString *enddate;
@property (nonatomic, retain) NSMutableArray *pfids;
@property (nonatomic, retain) NSString *city;

//  ASSIGN...
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) double distance;

//  PUBLIC FUNCS...
+(NSMutableArray *) ParseFromAPIEvents:(NSMutableArray *)arr;

+(Event *) ParseFromAPIEvent:(NSDictionary *)arr;

@end
