//
//  DjsCell.h
//  djc
//
//  Created by Zix Engineer on 4/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DJCELL_HEIGHT 75
//#define EXTRA 10

@interface DjsCell : UITableViewCell

@property(nonatomic, retain) IBOutlet UIImageView *icon;
@property(nonatomic, retain) IBOutlet UIActivityIndicatorView *activity;
@property(nonatomic, retain) IBOutlet UILabel *content;
@property(nonatomic, retain) IBOutlet UIView *mainView;

- (id) init;

+ (NSString *)  nibName;
+ (NSString *)  reuseIdentifier;
+ (CGFloat)     height;

@end
