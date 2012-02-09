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
#import "DjsCell.h"
#import "AdsCell.h"

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
@synthesize top50=_top50;
@synthesize button_AllTop50=_button_AllTop50;

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
    self.top50=YES;
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
            return count+count/(ADSPOSITION+1);
        }
        else
        {
            return count+1+(count+1)/(ADSPOSITION+1);
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
        
        if(row>0&&((row+1)%(ADSPOSITION+1)==0))
        {
            UITableViewCell *ads=[tableView dequeueReusableCellWithIdentifier:[AdsCell reuseIdentifier]];
            if(ads==nil)
            {
                ads=[[[AdsCell alloc] init] autorelease];
            }
            
            AdsCell *cell=(AdsCell *)ads;
            
            cell.lb_adsContent.text=@"ads in dj list";
            [cell.iv setImage:[UIImage imageNamed:@"redbull.png"]];
            [cell.iv sizeToFit];
            
            return cell;
        }
        
        else if ( row == ([ self.getter.djs count]+row/(ADSPOSITION+1)) )  // get more button...
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
            //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"djitem_cell"];
            UITableViewCell *tcell=[tableView dequeueReusableCellWithIdentifier:[DjsCell reuseIdentifier]];
            if (tcell == nil) 
            {
                tcell = [[[ DjsCell alloc] init ]  autorelease];
            }
            DjsCell *cell=(DjsCell *)tcell;
            UIImage *imgAll = [ UIImage imageNamed:@"Genericthumb2.png" ];
            //[ cell.imageView setImage:imgAll ];
            
 
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            //cell.textLabel.textColor = [ UIColor blackColor ];
            cell.content.textColor=[UIColor blackColor];
            cell.content.font=[UIFont systemFontOfSize:17];
            
            //cell.textLabel.font = [ UIFont systemFontOfSize:17 ];
            //  Get dj object...
            DJ *dj = [ self.getter.djs objectAtIndex:(row-row/(ADSPOSITION+1)) ];
            
            //NSData *data = [ NSData dataWithContentsOfURL:[NSURL URLWithString:dj.pic_path]];
            //UIImage *img=[UIImage imageWithData:data];
            
            //[cell.imageView setImage:img];
            
            //float sw=img.size.width/cell.imageView.image.size.width;
            //float sh=img.size.height/cell.imageView.image.size.height;
            //cell.imageView.transform=CGAffineTransformMakeScale(sw, sh);
            NSString *pic=dj.pic_path;
            
            if(pic!=nil)
            {
                NSNumber *num = [ NSNumber numberWithInteger:row];
                [self.getter asyncGetPic:pic :num];
                [cell.activity setHidden:NO];
                [ cell.activity startAnimating];
                [ cell.icon setHidden:YES ];
            }
            else
            {
                [cell.icon setImage:imgAll];
                [cell.icon setHidden:NO];
            }
            
            //  Set name...
            if ( self.all_djs )
            {
                //[cell.imageView setImage:[self.getter.djs g
                //cell.textLabel.text = dj.name;
                cell.content.text=dj.name;
            }
            else // also show rating...
            {
               // NSString *str = [ NSString stringWithFormat:@"%@ - #%d",dj.name,dj.rating];
                NSString *str = [ NSString stringWithFormat:@"%@",dj.name];
                //cell.textLabel.text = str;
                cell.content.text=str;
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
    
    if(row>0&&((row+1)%(ADSPOSITION+1)==0))
    {
        return;
    }
    else
    {
        [ tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        if (row ==( [self.getter.djs count]+self.getter.djs.count%(ADSPOSITION+1)) )
        {
            [ self.getter getNext ];
        }
        else
        {
            
            DJ *dj = [ self.getter.djs objectAtIndex:(row-row/(ADSPOSITION+1)) ];
            
            djcAppDelegate *app = 
            ( djcAppDelegate *)[ [ UIApplication sharedApplication] delegate];
            
            self.back_from = YES;
            [ app showDJItemModal:self:dj:nil ];
             
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if((self.getter.djs==nil)||([self.getter.djs count]==0)||
       ([self.getter.djs count]==([indexPath row]-indexPath.row/(ADSPOSITION+1))))
    {
        return 44;
    }
    else if(((indexPath.row+1)%(ADSPOSITION+1)==0)&&indexPath.row>0)
    {
        return 90.0f;
    }
    else
    {
        return 75.0f;
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
        [self.getter  getNext];
    }
}

-(void) got_pic:(UIImageForCell *)img
{
    int row = [ img.idx integerValue ];
    NSIndexPath *path = [ NSIndexPath indexPathForRow:row inSection:0 ];
    
    DjsCell *cell = (DjsCell *)[ self.tv cellForRowAtIndexPath:path ];
    [cell.activity setHidden:YES];
    [ cell.activity stopAnimating ];
    [ cell.icon setImage:img.img];
    [ cell.icon setHidden:NO ];}

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

#pragma mark -top50 or all

-(IBAction)allTop50Clicked:(id)sender
{
    if(self.top50==YES)
    {
        self.top50=NO;
        self.all_djs=YES;
        self.button_AllTop50.title=@"All";
    }
    else
    {
        self.top50=YES;
        self.all_djs=NO;
        self.button_AllTop50.title=@"Top50";
    }
    
    [self refreshClicked:nil];
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