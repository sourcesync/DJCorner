//
//  MapEventCell.h
//  djc
//
//  Created by George Williams on 2/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MAPEVENTCELL_HEIGHT 25 //65

@interface MapEventCell : UITableViewCell


@property (nonatomic,retain) IBOutlet UIView        *mainView;
@property (nonatomic,retain) IBOutlet UIImageView   *icon;
@property (nonatomic,retain) IBOutlet UILabel       *lbl;

//  PUBLIC FUNCS
- (id) init;

+ (NSString *)  nibName;
+ (NSString *)  reuseIdentifier;
+ (CGFloat)     height;



@end