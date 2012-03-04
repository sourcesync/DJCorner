//
//  EventView.h
//  alpha2
//
//  Created by George Williams on 11/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

#import "DJCAPI.h"
#import "Event.h"
#import "BuyCell.h"
#import "DJSelectView.h"

@protocol EventViewDelegate <NSObject>
-(void) eventViewDone;
@end

@interface EventView : UIViewController 
    <UITableViewDelegate, UITableViewDataSource,
    DJCAPIServiceDelegate, EKEventEditViewDelegate,
    DJSelectViewDelegate>
{
    
}

//  IBOUTLET...
@property (nonatomic,retain) IBOutlet UITableView *tv;
@property (nonatomic,retain) IBOutlet UITableViewCell *cell_title;
@property (nonatomic,retain) IBOutlet UITableViewCell *cell_description;
@property (nonatomic,retain) IBOutlet UITableViewCell *cell_date;
@property (nonatomic,retain) IBOutlet UITableViewCell *cell_buy;
@property (nonatomic,retain) IBOutlet UITableViewCell *cell_venue;
@property (nonatomic,retain) IBOutlet UIImageView *pic;
@property (nonatomic,retain) IBOutlet UILabel *label_title;
@property (nonatomic,retain) IBOutlet UILabel *label_description;
@property (nonatomic,retain) IBOutlet UILabel *label_date;
@property (nonatomic,retain) IBOutlet UIBarButtonItem *button_back;
@property (nonatomic,retain) IBOutlet UIButton *button_buy_now;
@property (nonatomic,retain) IBOutlet UIButton *button_save;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic,retain) IBOutlet UILabel *label_venue;
@property (nonatomic,retain) IBOutlet UIButton *button_follow;
@property (nonatomic,retain) IBOutlet DJSelectView *follow_view;

//leve
@property (nonatomic,retain) IBOutlet UIButton *bt_map;
@property (nonatomic,retain) IBOutlet UILabel *lb_web_ticket;

//  RETAIN...
@property (nonatomic, retain) DJCAPI *api;
@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) NSString *eoid;
@property (nonatomic, retain) EKEventStore *eventStore;
@property (nonatomic, retain) EKCalendar *defaultCalendar;
@property (nonatomic, retain) NSString *get_eid;
@property (nonatomic, retain) UIViewController *parent;
@property (nonatomic, retain) NSString *gcount;
//  ASSIGN...
@property (nonatomic, assign) BOOL connectionProblem;
@property (nonatomic, assign) id<EventViewDelegate> delegate;
@property (nonatomic, assign) NSInteger eventid;
@property (nonatomic, assign) BOOL back_from;

//  PUBLIC FUNCS...
-(void)     updateView;
-(id)       init;
-(IBAction) buttonSave:(id)sender;
-(IBAction) buyNow: (id)sender;
-(IBAction) backButton: (id)sender;
-(IBAction) mapButton: (id)sender;
-(void)     addEvent:(id)sender;
//-(IBAction) followDJ: (id)sender;

@end
