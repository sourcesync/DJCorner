//
//  BuyCell.h
//  alpha2
//
//  Created by George Williams on 11/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BuyCell : UITableViewCell 
{
    
}

@property (nonatomic, retain) IBOutlet UIView *content;

+ (NSString *)  nibName;
+ (NSString *)  reuseIdentifier;
+ (CGFloat)     height;

@end
