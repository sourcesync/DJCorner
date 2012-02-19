//
//  MainSearchView.h
//  alpha2
//
//  Created by George Williams on 12/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainSearchView : UIViewController
    <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

//  IBOUTLET...
@property (nonatomic, retain) IBOutlet UITableViewCell *cell_search_by_city;
@property (nonatomic, retain) IBOutlet UITableViewCell *cell_search_djs;
@property (nonatomic, retain) IBOutlet UITableView *tv;
@property (nonatomic, retain) IBOutlet UITextField *field_search;

//  PUBLIC FUNCS...
-(IBAction) searchClicked:(id)sender;



@end
