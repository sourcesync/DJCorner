//
//  EventModalParms.m
//  djc
//
//  Created by George Williams on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventModalParms.h"

@implementation EventModalParms

@synthesize src=_src;
@synthesize data=_data;
@synthesize oid=_oid;

-(void) dealloc
{
    self.src = nil;
    self.data = nil;
    self.oid = nil;
}

@end
