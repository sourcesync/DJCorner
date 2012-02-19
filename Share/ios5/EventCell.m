//
//  EventCell.m
//  Sprawl
//
//  Created by George Williams on 8/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EventCell.h"


@implementation EventCell


@synthesize mainView=_mainView;
@synthesize event=_event;
@synthesize distance=_distance;
@synthesize icon=_icon;
@synthesize activity=_activity;
@synthesize date=_date;
@synthesize performers=_performers;
@synthesize venue=_venue;

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
            [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
            
            NSAssert(self.mainView != nil, @"NIB file loaded but content property not set.");
            
            //  Configure size of frame...
            CGRect frame;
            frame = CGRectMake(0, 0, 320, EVENTCELL_HEIGHT ); //MATCHVIEWCELL_HEIGHT-21);
            self.frame = frame;
            
            
            self.mainView.frame = frame; 
            self.mainView.backgroundColor = [ UIColor whiteColor ];
            
            self.selectedBackgroundView.frame = frame;
            //  Configure accessory...
            //self.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            
            //UIImageView *imageView = [[[UIImageView alloc] initWithImage:
            //                           [UIImage imageNamed:@"DJscornerarrow"]] autorelease];
            //self.accessoryView = imageView;
            
#if 0
            //  Configure accessory...
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"DJscornerarrow.png"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(someAction:) forControlEvents:UIControlEventTouchUpInside];
            //button.tag = self.indexPath;
            self.accessoryView = button;
#endif
            
            [self addSubview:self.mainView];
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
    return @"EventCell";
}

// Reuse identifier of this custom cell.
+ (NSString *)reuseIdentifier
{
    return @"eventitem_cell";
}

// Cell's default height.
+ (CGFloat)height
{
    return EVENTCELL_HEIGHT; // + EXTRA;
}

@end
