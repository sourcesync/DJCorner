//
//  FollowView.h
//  alpha2
//
//  Created by George Williams on 12/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "DJCAPI.h"

@protocol DJSelectViewDelegate
@optional -(void) DJSelectViewOK:(NSMutableArray *)djs;
@end

@interface DJSelectView : UIViewController
    < UITableViewDataSource, UITableViewDelegate, DJCAPIServiceDelegate >
{
    
}

//  IBOUTLET...
@property (nonatomic, retain) IBOutlet UITableView *tv;

//  RETAIN...
@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) DJCAPI *api;
@property (nonatomic, retain) UIViewController *parent;

//  ASSIGN...
@property (nonatomic, assign) id<DJSelectViewDelegate> delegate;

//  PUBLIC FUNC...
-(IBAction) cancelClicked:(id)sender;
-(IBAction) okClicked:(id)sender;

@end
