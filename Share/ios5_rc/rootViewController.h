//
//  rootViewController.h
//  djc
//
//  Created by Zix Mac Engineer on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconDownloader.h"

@interface rootViewController : UITableViewController <UIScrollViewDelegate, IconDownloaderDelegate>
{
	NSArray *array;   // the main data model for our UITableView
    NSMutableDictionary *imageDownloadsInProgress;  // the set of IconDownloader objects for each app
}

@property (nonatomic, retain) NSArray *array;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;

-(void)appImageDidLoad:(NSIndexPath *)indexPath;
 
@end
