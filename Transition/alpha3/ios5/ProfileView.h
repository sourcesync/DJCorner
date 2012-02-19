//
//  ProfileView.h
//  alpha2
//
//  Created by George Williams on 11/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJCAPI.h"
#import "djcAppDelegate.h"
typedef enum{
    
    StopMusicBtn=20,
    PlayMusicBtn=21,
    
}EnumPro;
@interface ProfileView : UIViewController 
< UITableViewDelegate, UITableViewDataSource, 
DJCAPIServiceDelegate, UIActionSheetDelegate,UIAlertViewDelegate>
{
    djcAppDelegate  *dele;
    
    
}

//  IBOUTLET...
@property (nonatomic, retain) IBOutlet UIButton *btn;
@property (nonatomic, retain) IBOutlet UITableView *tv;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, retain) IBOutlet UILabel *lb_version;
@property(nonatomic,retain) IBOutlet djcAppDelegate *dele;
//  ASSIGN...
@property (assign) NSInteger selectedIndex;

@property (nonatomic, assign) BOOL back_from;

//  RETAIN...
@property (nonatomic, retain) DJCAPI *api;
@property (nonatomic, retain) NSMutableArray *djs;
@property (nonatomic, retain) NSString *selectedDJ;

@property (assign) BOOL flags;



//FUN...
-(IBAction)upGradeClicked:(id)sender;
-(IBAction)contactFeedClicked:(id)sender;
-(IBAction)stopMusic:(id)sender;

@end