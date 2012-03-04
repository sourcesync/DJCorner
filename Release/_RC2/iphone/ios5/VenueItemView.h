//
//  DJItemView.h
//  alpha2
//
//  Created by George Williams on 12/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Venue.h"
#import "DJCAPI.h"

@interface VenueItemView : UIViewController
    <UITableViewDataSource, UITableViewDelegate, DJCAPIServiceDelegate,UIActionSheetDelegate>

//  IBOUTLET...
@property (nonatomic, retain) IBOutlet UITableView *tv;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, retain) IBOutlet UILabel *label_title;
@property (nonatomic, retain) IBOutlet UIImageView *image_pic;
@property (nonatomic, retain) IBOutlet UITableViewCell *cell_title;
@property (nonatomic, retain) IBOutlet UITableViewCell *cell_schedule;
@property (nonatomic, retain) IBOutlet UITableViewCell *cell_follow;
@property (nonatomic, retain) IBOutlet UITableViewCell *cell_web_site;
@property (nonatomic, retain) IBOutlet UITableViewCell *cell_similar;
@property (nonatomic, retain) IBOutlet UIButton *follow_btn;

//leve
@property (nonatomic, retain) IBOutlet UIBarButtonItem *button_back;
@property (nonatomic, retain) IBOutlet UIButton *bt_showFirst;
@property (nonatomic, retain) IBOutlet UIButton *bt_showSecond;
@property (nonatomic, retain) IBOutlet UIButton *bt_showThird;
@property (nonatomic, retain) IBOutlet UILabel *lb_upcoming_events;
@property (nonatomic, retain) IBOutlet UILabel *lb_web_site;
@property (nonatomic, retain) IBOutlet UILabel *lb_notification;
@property (nonatomic, retain) IBOutlet UILabel *lb_similiar;

//@property (nonatomic, retain) IBOutlet UIButton *button_follow;
//jimmy
//@property (nonatomic, retain) IBOutlet UITableViewCell *cell_feedback;
//end


//  RETAIN...
@property (nonatomic, retain) Venue *venue;
@property (nonatomic, retain) DJCAPI *api;
@property (nonatomic, retain) NSString *getv;
@property (nonatomic, retain) UIViewController *parent;
@property (nonatomic, retain) NSMutableArray *venues;
//@property (nonatomic, retain) NSString *selectedDj;


//  ASSIGN...
@property (nonatomic, assign) BOOL back_from;

@property (nonatomic, assign) BOOL following;
//  PUBLIC FUNC...
-(id)init;
-(IBAction) showWebSiteClicked:(id)sender;
-(IBAction) showScheduleClicked:(id)sender;
-(IBAction) followButtonClicked:(id)sender;
-(IBAction) similarButtonClicked:(id)sender;
//jimmy 
-(IBAction) feedbackButtonClicked:(id)sender;
//end
-(IBAction) backButtonClicked:(id)sender;


-(void) check_Followed:(id)sender;
@end
