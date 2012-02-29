//
//  SimilarDJView.h
//  alpha2
//
//  Created by George Williams on 12/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJCAPI.h"

@interface SimilarDJView : UIViewController
    < UITableViewDataSource, UITableViewDelegate, DJCAPIServiceDelegate>

//  IBOUTLET...
@property (nonatomic,retain) IBOutlet UITableView *tv;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *activity;
//leve
@property (nonatomic,retain) IBOutlet UIBarButtonItem *button_back;
@property (nonatomic,retain) IBOutlet UILabel *lb_similar;

//  RETAIN...
@property (nonatomic, retain) NSString *djid;
@property (nonatomic, retain) NSString *djname;
@property (nonatomic, retain) NSMutableArray *similar;
@property (nonatomic, retain) DJCAPI *api;
@property (nonatomic, retain) UIViewController *parent;

//  PUBLIC FUNCS...
-(id) init;

-(IBAction) buttonBackClicked:(id)sender;

@end
