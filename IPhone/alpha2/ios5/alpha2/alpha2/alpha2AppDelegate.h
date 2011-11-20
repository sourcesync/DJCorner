//
//  alpha2AppDelegate.h
//  alpha2
//
//  Created by George Williams on 11/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EventView.h"
#import "Event.h"


@interface alpha2AppDelegate : NSObject 
    <UIApplicationDelegate, UITabBarControllerDelegate,
    EventViewDelegate>
{

}

//  RETAIN...
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) NSString *cur_url;
@property (nonatomic, retain) EventView *event_view;

//  PUBLIC FUNCS...
-(void) buyEvent:(NSString *)url;
-(NSString *) getCurURL;
-(void) splashDone;
-(void) showEventModal:(UIViewController *)src:(Event *)evt;

@end
