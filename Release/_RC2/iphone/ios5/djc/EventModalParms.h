//
//  EventModalParms.h
//  djc
//
//  Created by George Williams on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Event.h"

@interface EventModalParms : NSObject

@property (nonatomic,retain) UIViewController *src;
@property (nonatomic,retain) NSObject *data;
@property (nonatomic,retain) NSString *oid;

@end
