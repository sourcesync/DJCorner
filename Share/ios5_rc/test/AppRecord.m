

#import "AppRecord.h"

@implementation AppRecord

@synthesize appName;
@synthesize appIcon;
@synthesize imageURLString;
@synthesize artist;
@synthesize appURLString;

- (void)dealloc
{
    [appName release];
    [appIcon release];
    [imageURLString release];
	[artist release];
    [appURLString release];
    
    [super dealloc];
}

@end

