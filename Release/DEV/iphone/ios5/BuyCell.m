//
//  BuyCell.m
//  alpha2
//
//  Created by George Williams on 11/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BuyCell.h"

@implementation BuyCell

@synthesize content=_content; 

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
    }
    return self; 
}


- (id)init 
{
    UITableViewCellStyle style = UITableViewCellStyleDefault;
    NSString *identifier = NSStringFromClass([self class]);
    
    if ((self = [super initWithStyle:style reuseIdentifier:identifier])) 
    {
        NSString *nibName = [[self class] nibName];
        if (nibName) 
        {
            // load from nib...
            [[NSBundle mainBundle] loadNibNamed:nibName
                                          owner:self
                                        options:nil];
            NSAssert(self.content != nil, @"NIB file loaded but content property not set.");
            
            //  Configure size of frame...
            CGRect frame;
            frame = CGRectMake(0, 0, 320, 44);
            self.content.frame = frame; 
            
            //  Configure accessory...
            self.accessoryType = UITableViewCellAccessoryNone;
            
            [self addSubview:self.content];
        }
    }
    return self; 
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)dealloc
{
    // TODO: release xib elements too?...
    [ super dealloc];
}


#pragma mark - class methods


// Reuse identifier of this custom cell.
+ (NSString *)nibName
{
    return @"BuyCell";
}

// Reuse identifier of this custom cell.
+ (NSString *)reuseIdentifier
{
    return @"BuyCell";
}

// Cell's default height.
+ (CGFloat)height
{
    return 44.0f;
}

@end

