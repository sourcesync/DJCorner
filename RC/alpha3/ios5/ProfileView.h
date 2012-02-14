//
//  ProfileView.h
//  alpha2
//
//  Created by George Williams on 11/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJCAPI.h"

@interface ProfileView : UIViewController 
    < UITableViewDelegate, UITableViewDataSource, 
        DJCAPIServiceDelegate, UIActionSheetDelegate,UIAlertViewDelegate>
{
    
}

//  IBOUTLET...
@property (nonatomic, retain) IBOutlet UITableView *tv;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, retain) IBOutlet UILabel *lb_version;

//  ASSIGN...
@property (assign) NSInteger selectedIndex;

@property (nonatomic, assign) BOOL back_from;

//  RETAIN...
@property (nonatomic, retain) DJCAPI *api;
@property (nonatomic, retain) NSMutableArray *djs;
@property (nonatomic, retain) NSString *selectedDJ;




//FUN...
-(IBAction)upGradeClicked:(id)sender;
-(IBAction)contactFeedClicked:(id)sender;

@end
