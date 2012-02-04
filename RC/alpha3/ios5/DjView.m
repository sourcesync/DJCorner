//
//  DjView.m
//  alpha2
//
//  Created by George Williams on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DjView.h"
#import "Utility.h"
#import "DJ.h"
#import "djcAppDelegate.h"

@implementation DjView

@synthesize tv=_tv;
@synthesize djs=_djs;
@synthesize getter=_getter;
@synthesize activity=_activity;
@synthesize button_back=_button_back;
@synthesize button_refresh=_button_refresh;
@synthesize search=_search;
@synthesize back_from=_back_from;
@synthesize field_search=_field_search;
@synthesize button_search=_button_search;
@synthesize segment_dj=_segment_dj;
@synthesize all_djs=_all_djs;

#pragma - funcs...

- (void) newGetter
{
    if (self.getter!=nil)
    {
        [ self.getter finished ];
        self.getter = nil;
    }
    self.getter = [ [ [ DJSGetter alloc ] init ] autorelease ];
    self.getter.delegate = self;
    NSString *search = self.search;
    self.getter.search = search;
    self.getter.all_djs = self.all_djs;
}

- (void) updateViews
{
    [ self.tv reloadData ];
    self.tv.hidden = NO;
    self.activity.hidden = YES;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        self.search = @"";
    }
    return self;
}

-(id) init
{
    self = [ self initWithNibName:@"DjView" bundle:nil ];
    return self;
}

-(void) dealloc
{
    self.djs = nil;
    self.getter = nil;
    self.search = nil;
    
    [ super dealloc ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [ self.tv setDelegate:self];
    [ self.tv setDataSource:self];
    [ self.tv reloadData ];
    
    self.field_search.delegate = self;
    self.field_search.clearButtonMode = UITextFieldViewModeAlways;
    self.field_search.clearsOnBeginEditing = YES;
    self.field_search.returnKeyType = UIReturnKeySearch;
    
    self.all_djs = NO;
    self.segment_dj.selectedSegmentIndex=1;
    [ self.segment_dj addTarget:self action:@selector(segmentDJClicked:) 
               forControlEvents:UIControlEventValueChanged ];
    
    [ self newGetter ];

}

-(void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    
    [ self.getter cancel];
}

-(void)viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated ];
    
    if (self.back_from) 
    {
        return;
    }
    else
    {
        self.djs = nil;
        [ self.tv setHidden:YES];
        //[ self.activity startAnimating ];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [ super viewDidAppear:animated];
 
    if (self.back_from)
    {
        self.back_from = NO;
        return;
    }
    else
    {
        // Clear any previous search context...
        self.search = @"";
        self.field_search.text = @"";
        [ self newGetter ];
        [ self.getter getNext ];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - table view delegates...


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( self.getter.djs == nil )
    {
        return 1;
    }
    else if (self.getter.connectionProblem )
    {
        return 1;
    }
    else
    {
        NSInteger count = [ self.getter.djs count ] ;
        NSInteger end = self.getter.end;
        if ( count == 0 )
        {
            return 1;
        }
        else if ( end == (count-1) )
        {
            return count;
        }
        else
        {
            return count+1;
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if ( self.getter.connectionProblem )
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 @"noitem_cell"];
        if (cell == nil) 
        {
            cell = [[[ UITableViewCell alloc] init] autorelease];
        }
        [ cell.imageView setImage:nil ];
        cell.textLabel.text = @"Connection Problem...";
        cell.textLabel.font = [ UIFont boldSystemFontOfSize:17 ];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.textColor = [ UIColor blackColor ];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    }
    else if ( self.getter.djs == nil )
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 @"noitem_cell"];
        if (cell == nil) 
        {
            cell = [[[ UITableViewCell alloc] init] autorelease];
        }
        [ cell.imageView setImage:nil ];
        cell.textLabel.text = @"Please Wait...";
        cell.textLabel.font = [ UIFont boldSystemFontOfSize:17 ];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.textColor = [ UIColor blackColor ];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;

        return cell;   
    }
    else if ( [ self.getter.djs count ] == 0 )
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 @"noitem_cell"];
        if (cell == nil) 
        {
            cell = [[[ UITableViewCell alloc] init] autorelease];
        }
        [ cell.imageView setImage:nil ];
        cell.textLabel.text = @"No DJs Match...";
        cell.textLabel.font = [ UIFont boldSystemFontOfSize:17 ];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.textColor = [ UIColor blackColor ];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;     
    }
    else
    {
        NSInteger row = [ indexPath row ];
        
        if ( row == [ self.getter.djs count] )  // get more button...
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                     @"getmore_cell"];
            if (cell == nil) 
            {
                cell = [[[ UITableViewCell alloc] init] autorelease];
            }
            [ cell.imageView setImage:nil ];
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.textLabel.font = [ UIFont boldSystemFontOfSize:17 ];
            cell.textLabel.text = @"Get More DJs...";
            cell.textLabel.textColor = [ UIColor blackColor ];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryType = UITableViewCellAccessoryNone;
            return cell;
        }
        else
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                     @"djitem_cell"];
            if (cell == nil) 
            {
                cell = [[[ UITableViewCell alloc] init ]  autorelease];
            }
            UIImage *img = [ UIImage imageNamed:@"Genericthumb2.png" ];
            [ cell.imageView setImage:img ];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.textLabel.textColor = [ UIColor blackColor ];
            cell.textLabel.font = [ UIFont systemFontOfSize:17 ];
            //  Get dj object...
            DJ *dj = [ self.getter.djs objectAtIndex:row ];
            
            //  Set name...
            if ( self.all_djs )
            {
                cell.textLabel.text = dj.name;
            }
            else // also show rating...
            {
                NSString *str = [ NSString stringWithFormat:@"%@ - #%d",dj.name,dj.rating];
                cell.textLabel.text = str;
            }
            return cell;   
        }
    }
}

/*
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [ indexPath row ];
    
    [ tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (row == [self.getter.djs count] )
    {
        [ self.getter getNext ];
    }
    else
    {
        DJ *dj = [ self.getter.djs objectAtIndex:row ];
        
        djcAppDelegate *app = 
            ( djcAppDelegate *)[ [ UIApplication sharedApplication] delegate];
        
        self.back_from = YES;
        [ app showDJItemModal:self:dj:nil ];
    }
}

#pragma mark - djs getter delegate...

-(void) got_djs:(NSInteger)start :(NSInteger)end
{
    if (!self.activity.hidden)
    {
        self.activity.hidden = YES;
        [ self.activity stopAnimating ];
        self.tv.hidden = NO;
    }
    
    [ self updateViews ];
    
    if ( !self.getter.got_all )
    {
        [self.getter getNext];
    }
}

-(void) got_pic:(UIImageForCell *)img
{
    
}

-(void) failed
{
    [ Utility AlertAPICallFailed ];
}

#pragma mark - button callbacks...

-(IBAction) refreshClicked: (id)sender
{
    self.tv.hidden = YES;
    self.activity.hidden = NO;
    [ self newGetter ];
    [ self.getter getNext ];
}


-(IBAction) backClicked: (id)sender
{
    [ self dismissModalViewControllerAnimated:YES ];
}


-(IBAction) searchClicked:(id)sender
{
    [ self.field_search resignFirstResponder];
    
    NSString *search = self.field_search.text;
    if ( search == nil ) search = @"";
    self.search = search;
    
    [ self refreshClicked:nil ];
}

#pragma mark - field callback...

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField 
{
    [theTextField resignFirstResponder];
    
    [ self searchClicked:nil ];
    
    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField*)textField
{
    return YES;
}

#pragma mark - segment dj...

-(IBAction)segmentDJClicked:(id)sender
{
    if (self.segment_dj.selectedSegmentIndex == 0 )
    {
        self.all_djs = YES;
    }
    else
    {
        self.all_djs = NO;
    }
    
    [ self refreshClicked:nil ];
}

@end