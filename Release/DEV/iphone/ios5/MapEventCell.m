//
//  MapEventCell.m
//  djc
//
//  Created by George Williams on 2/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapEventCell.h"

@implementation MapEventCell

@synthesize mainView=_mainView;
@synthesize icon=_icon;
@synthesize lbl=_lbl;

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
            frame = CGRectMake(0, 0, 320, MAPEVENTCELL_HEIGHT ); //MATCHVIEWCELL_HEIGHT-21);
            self.frame = frame;
            
            
            self.mainView.frame = frame; 
            self.mainView.backgroundColor = [ UIColor whiteColor ];
            
            self.selectedBackgroundView.frame = frame;
            
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
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
    return @"MapEventCell";
}

// Reuse identifier of this custom cell.
+ (NSString *)reuseIdentifier
{
    return @"mapeventitem_cell";
}

// Cell's default height.
+ (CGFloat)height
{
    return MAPEVENTCELL_HEIGHT; // + EXTRA;
}

@end
