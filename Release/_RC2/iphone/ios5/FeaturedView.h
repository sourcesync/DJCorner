//
//  FeaturedView.h
//  alpha2
//
//  Created by George Williams on 12/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeaturedView : UIViewController
    <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView *tv;

@end
