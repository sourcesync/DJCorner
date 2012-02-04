//
//  DJSearchView.h
//  alpha2
//
//  Created by George Williams on 12/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJSearchView : UIViewController
    < UITableViewDelegate, UITableViewDataSource>

//  IBOUTLET...
@property (nonatomic, retain) IBOutlet UITableView *tv;
@property (nonatomic, retain) IBOutlet UITableViewCell *cell_search;

//  RETAIN...
@property (nonatomic, retain) NSString *search;

//  PUBLIC FUNCS...
-(IBAction) buttonBackClicked:(id)sender;

@end
