//
//  DjView.h
//  alpha2
//
//  Created by George Williams on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VenuesTabView.h"
#import "DJCAPI.h"
#import "VenuesGetter.h"
#import "DjsCell.h"
#import "AdsCell.h"

//#define DJS_ADS

#ifdef VENUES_ADS
#define ADSPOSITION 4
#endif


enum VenuesGetMode
{
    VenuesGetGetting = 0,
    VenuesGetPaused,
    VenuesGetDone
};

@interface VenuesTabView : UIViewController
    <UITableViewDataSource, UITableViewDelegate, VenuesGetterDelegate, UITextFieldDelegate>


//  IBOUTLET...
@property (nonatomic, retain) IBOutlet UITableView *tv;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *button_back;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *button_refresh;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, retain) IBOutlet UITextField *field_search;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *button_search;
//@property (nonatomic, retain) IBOutlet UISegmentedControl *segment_dj;
//@property (nonatomic, retain) IBOutlet UIBarButtonItem *button_AllTop50;

//  RETAIN...
@property (nonatomic, retain) VenuesGetter *getter;
@property (nonatomic, retain) NSString *search;

//  ASSIGN...
@property (assign) BOOL back_from;
//@property (assign) BOOL all_djs;
//@property (assign) BOOL top50;
@property (assign) int VIP;
@property (assign) BOOL scrolling;
@property (assign) BOOL refresh;
@property (assign) enum VenuesGetMode get_mode;


//  PUBLIC FUNCS...
-(id) init;
-(IBAction) refreshClicked: (id)sender;
-(IBAction) backClicked: (id)sender;
-(IBAction) searchClicked:(id)sender;
//-(IBAction) allTop50Clicked:(id)sender;
-(void) loadImagesForOnscreenRows;
-(void) loadImageForRow: (DjsCell *)tcell: (NSIndexPath *)path;
@end
