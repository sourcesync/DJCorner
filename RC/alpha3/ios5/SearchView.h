//
//  SecondViewController.h
//  alpha2
//
//  Created by George Williams on 11/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SearchView : UIViewController 
    <UITableViewDelegate, UITableViewDataSource>
{
    
}


//  IBOUTLET...
@property (nonatomic, retain) IBOutlet UITableView *tv;

//  RETAIN...
@property (nonatomic, retain) NSMutableArray *cities;

//  PUBLIC FUNC...
-(IBAction) buttonBackClicked:(id)sender;

@end
