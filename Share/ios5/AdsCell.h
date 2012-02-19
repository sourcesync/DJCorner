//
//  AdsCell.h
//  djc
//
//  Created by Zix Engineer on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ADCELL_HEIGHT 90
//#define EXTRA 10

@interface AdsCell : UITableViewCell

//IBOUTLET...
@property(nonatomic, retain ) IBOutlet UIImageView *iv;
@property(nonatomic, retain ) IBOutlet UILabel *lb_adsContent;
@property(nonatomic, retain ) IBOutlet UIView *mainView;


- (id) init;

+ (NSString *)  nibName;
+ (NSString *)  reuseIdentifier;
+ (CGFloat)     height;
@end
