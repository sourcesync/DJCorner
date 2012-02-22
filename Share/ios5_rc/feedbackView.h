//
//  feedbackView.h
//  djc
//
//  Created by Hok Leong Chan on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "DJCAPI.h"

@interface feedbackView : UIViewController
< DJCAPIServiceDelegate>

//  IBOUTLET...
//@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, retain) IBOutlet UITextView *tf;
//@property (nonatomic, retain) IBOutlet UIBarButtonItem *button_Done;

//leve
@property (nonatomic, retain) IBOutlet UIBarButtonItem *button_back;
@property (nonatomic, retain) IBOutlet UILabel *lb_feedback;
@property (nonatomic, retain) IBOutlet UIButton *bt_submit;

//  RETAIN...
@property (nonatomic, retain) DJCAPI *api;
@property (nonatomic, retain) UIViewController *parent;

//  PUBLIC FUNCS...
-(id) init;

//-(IBAction) buttonDoneClicked:(id)sender;
-(IBAction) submitClicked:(id)sender;
-(IBAction) backClicked:(id)sender;

@end

