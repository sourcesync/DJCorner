//
//  EventView.h
//  alpha2
//
//  Created by George Williams on 11/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DJCAPI.h"
#import "Event.h"

@protocol EventViewDelegate <NSObject>
-(void) eventViewDone;
@end

@interface EventView : UIViewController 
    <UITableViewDelegate, UITableViewDataSource,
    DJCAPIServiceDelegate>
{
    
}

//  IBOUTLET...
@property (nonatomic,retain) IBOutlet UITableView *tv;
@property (nonatomic,retain) IBOutlet UITableViewCell *cell_title;
@property (nonatomic,retain) IBOutlet UITableViewCell *cell_description;
@property (nonatomic,retain) IBOutlet UITableViewCell *cell_date;
@property (nonatomic,retain) IBOutlet UITableViewCell *cell_buy;
@property (nonatomic,retain) IBOutlet UIImageView *pic;
@property (nonatomic,retain) IBOutlet UILabel *label_title;
@property (nonatomic,retain) IBOutlet UILabel *label_description;
@property (nonatomic,retain) IBOutlet UIBarButtonItem *button_back;

//  RETAIN...
@property (nonatomic, retain) DJCAPI *api;
@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) NSString *eoid;

//  ASSIGN...
@property (nonatomic, assign) BOOL connectionProblem;
@property (nonatomic, assign) id<EventViewDelegate> delegate;

//  PUBLIC FUNCS...
-(void) updateView;
-(id) init;

@end
