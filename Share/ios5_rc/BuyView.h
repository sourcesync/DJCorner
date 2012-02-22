//
//  BuyView.h
//  alpha2
//
//  Created by George Williams on 11/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Event.h"

@interface BuyView : UIViewController 
    <UIWebViewDelegate>
{
    
}

//  RETAIN...
@property (nonatomic,retain) Event *event;
@property (nonatomic,retain) UIViewController *parent;

//  IBOUTLET...
@property (nonatomic,retain) IBOutlet UIWebView *web_view;
@property (nonatomic,retain) IBOutlet UIToolbar *tb;

//  PUBLIC FUNC...
-(IBAction) buttonBack: (id)sender;

@end
