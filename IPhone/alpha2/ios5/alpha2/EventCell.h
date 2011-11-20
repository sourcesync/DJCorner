//
//  EventCell.h
//  Sprawl
//
//  Created by George Williams on 8/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MATCHVIEWCELL_HEIGHT 65
#define EXTRA 10

@interface EventCell : UITableViewCell 
{
    
}
 

@property (nonatomic,retain) IBOutlet UIView        *content;
@property (nonatomic,retain) IBOutlet UILabel       *name;
//@property (nonatomic,retain) IBOutlet UIImageView   *pic;
@property (nonatomic,retain) IBOutlet UILabel       *distance;
@property (nonatomic,retain) IBOutlet UILabel       *msg;
@property (nonatomic,retain) IBOutlet UIImageView   *icon;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *activity;

+ (NSString *)  nibName;
+ (NSString *)  reuseIdentifier;
+ (CGFloat)     height;


@end
