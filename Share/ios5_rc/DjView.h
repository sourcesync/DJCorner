//
//  DjView.h
//  alpha2
//
//  Created by George Williams on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJCAPI.h"
#import "DJSGetter.h"
#import "DjsCell.h"
#import "AdsCell.h"
#import "IconDownloader.h"
//#import "Languagemanger.h"

#define ADSPOSITION 4
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

enum{
    
    cellNameTag=20,
    cellIntarvateTag,
    cellBtnTag,
    
}eLblName;

@interface DjView : UIViewController
<UITableViewDataSource, UITableViewDelegate, DJSGetterDelegate, UITextFieldDelegate,UIScrollViewDelegate, IconDownloaderDelegate>
{
    NSMutableDictionary *imageDownloadsInProgress; 
    
    
}


//  IBOUTLET...
@property (nonatomic, retain) IBOutlet UITableView *tv;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *button_back;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *button_refresh;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, retain) IBOutlet UITextField *field_search;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *button_search;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segment_dj;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *button_AllTop50;

@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;

//  RETAIN...
//@property (nonatomic, retain) NSMutableArray *djs;
@property (nonatomic, retain) DJSGetter *getter;
@property (nonatomic, retain) NSString *search;
@property (nonatomic, retain) NSMutableDictionary *pics;
@property (nonatomic, retain) NSString *pic;
@property (nonatomic, retain) NSMutableData *picTemp;
@property (nonatomic,retain) NSArray *visiblePath;


//  ASSIGN...
@property (assign) BOOL back_from;
@property (assign) BOOL all_djs;
@property (assign) BOOL top50;
@property (assign) int VIP;


//  PUBLIC FUNCS...
-(id) init;
-(IBAction) refreshClicked: (id)sender;
-(IBAction) backClicked: (id)sender;
-(IBAction) searchClicked:(id)sender;
-(IBAction) allTop50Clicked:(id)sender;
- (void)appImageDidLoad:(NSIndexPath *)indexPath;
@end
