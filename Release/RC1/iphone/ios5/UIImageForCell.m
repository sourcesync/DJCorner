//
//  UIImageForCell.m
//  Sprawl
//
//  Created by George Williams on 9/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIImageForCell.h"


@implementation UIImageForCell

// RETAIN...
@synthesize img=_img;
@synthesize idx=_idx;

//  ASSIGN..
@synthesize status;

-(void) dealloc
{
    self.img = nil;
    self.idx = nil;
    
    [ super dealloc ];
}

@end
