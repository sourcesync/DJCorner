//
//  EventCell.m
//  Sprawl
//
//  Created by George Williams on 8/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EventCell.h"


@implementation EventCell


@synthesize content=_content;
@synthesize name=_name;
//@synthesize pic=_pic;
@synthesize distance=_distance;
@synthesize msg=_msg;
@synthesize icon=_icon;
@synthesize activity=_activity;


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
            frame = CGRectMake(0, 0, 320, MATCHVIEWCELL_HEIGHT-21);
            self.content.frame = frame; 
            
            //  Configure accessory...
            self.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            
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
    [ _name release ];
    [ _msg release ];
    [ _distance release ];
    // TODO: release xib elements too?...
    [ super dealloc];
}


#pragma mark - class methods


// Reuse identifier of this custom cell.
+ (NSString *)nibName
{
    return @"EventCell";
}

// Reuse identifier of this custom cell.
+ (NSString *)reuseIdentifier
{
    return @"EventCell";
}

// Cell's default height.
+ (CGFloat)height
{
    return MATCHVIEWCELL_HEIGHT + EXTRA;
}



@end
