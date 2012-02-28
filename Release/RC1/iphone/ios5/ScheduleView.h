//
//  ScheduleView.h
//  alpha2
//
//  Created by George Williams on 12/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJCAPI.h"

@interface ScheduleView : UIViewController
    <UITableViewDelegate, UITableViewDataSource, DJCAPIServiceDelegate>
 
//  IBOUTLET...
@property (nonatomic, retain) IBOutlet UITableView *tv;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, retain) IBOutlet UILabel *label_title;
//@property (nonatomic, retain) IBOutlet 

//  RETAIN...
@property (nonatomic, retain) NSString *djname;
@property (nonatomic, retain) NSString *djid;
@property (nonatomic, retain) NSMutableArray *schedule;
@property (nonatomic, retain) DJCAPI *api;
@property (nonatomic, retain) UIViewController *parent;

//  ASSIGN...
@property (nonatomic, assign) BOOL back_from;

//  PUBLIC FUNCS...
-(IBAction) buttonBackClicked:(id)sender;

@end
