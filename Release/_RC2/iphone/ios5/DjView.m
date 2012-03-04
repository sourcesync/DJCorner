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
#import "LocalizedManager.h"

//#define GET_PIC_ASYNC

@implementation DjView

@synthesize tv=_tv;
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
@synthesize VIP=_VIP;
@synthesize scrolling=_scrolling;
@synthesize refresh=_refresh;
@synthesize get_mode=_get_mode;

#pragma - funcs...

- (void) newGetter
{
    if (self.getter!=nil)
    {
        [ self.getter finished ];
        self.getter = nil;
    }
    self.getter =  [ [ [ DJSGetter alloc ] init ] autorelease ];
    self.getter.delegate = self;
    NSString *search = self.search;
    self.getter.search = search;
    self.getter.all_djs = self.all_djs;
    self.get_mode = DJGetPaused;
}

- (void) updateViews
{
    [ self.tv reloadData ];
    self.tv.hidden = NO;
    self.activity.hidden = YES;
    
    if ( !self.scrolling )
    {
        [ self loadImagesForOnscreenRows ];
    }
}


#pragma resignfirstresponder

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.field_search resignFirstResponder];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        self.search = @"";
        self.refresh = YES;
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
    self.getter = nil;
    self.search = nil;
    [ super dealloc ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [ Utility AlertLowMemory ];
    
    //  Reduce getter footprint...
    [ self.getter cancel];
    [ self.getter removeCache ];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    djcAppDelegate *app=(djcAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.VIP=app.VIP;
    
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
    
    self.refresh = YES;
    
    //leve
    self.button_AllTop50.title=[LocalizedManager localizedString:@"all"];
    self.button_search.title=[LocalizedManager localizedString:@"search"];

}

-(void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];

    if ( self.get_mode != DJGetDone )
    {
        self.get_mode = DJGetPaused;
        [ self.getter cancel];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated ];
    
    djcAppDelegate *app=(djcAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.VIP=app.VIP;
    
    //[self.tv performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
    if (self.back_from) 
    {
        return;
    }
    else
    {
        if (self.refresh)
        {
            [ self.tv setHidden:YES];
        
            self.activity.hidden = NO;
            [ self.activity startAnimating ];
        }
        else
        {
            [ self.tv setHidden:NO];
        }
    }
    
    self.button_AllTop50.title=[LocalizedManager localizedString:@"all"];
    self.button_search.title=[LocalizedManager localizedString:@"search"];
    NSLog(@"%@",[LocalizedManager selectedLanguage]);
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
        if (self.refresh)
        {
            // Clear any previous search context...
            self.search = @"";
            self.field_search.text = @"";
            [ self newGetter ];
            
            self.get_mode = DJGetGetting;
            [ self.getter getNext ];
            
            self.refresh = NO;
        }
        else // possibly continue paused actions...
        {
            if ( self.getter && ( self.get_mode == DJGetPaused ) )
            {
                self.get_mode = DJGetGetting;
                [ self.getter getNext ];
            }
        }
    }
    
    self.scrolling = NO; // TODO: why do i need this when return to the tab?...
    
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
#ifdef DJS_ADS
            return count+count/(ADSPOSITION+1)*self.VIP;
#else
            return count;
#endif
        }
        else
        {
#ifdef DJS_ADS
            return count+1+(count+1)/(ADSPOSITION+1)*self.VIP;
#else
            return count + 1;
#endif
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
        cell.textLabel.text = [LocalizedManager localizedString:@"connection_problem"];
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
        cell.textLabel.text = @""; //@"Please Wait...";
        //cell.textLabel.text = [LocalizedManager localizedString:@"wait"];
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
        cell.textLabel.text = [LocalizedManager localizedString:@"no_djs_match"];
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
        
#ifdef DJS_ADS
        if((self.VIP==1)&&row>0&&((row+1)%(ADSPOSITION+1)==0))
        {
            UITableViewCell *ads=[tableView dequeueReusableCellWithIdentifier:[AdsCell reuseIdentifier]];
            if(ads==nil)
            {
                ads=[[[AdsCell alloc] init] autorelease];
            }
            
            AdsCell *cell=(AdsCell *)ads;
            //[cell autorelease];
            
            cell.lb_adsContent.text=@"ads in dj list";
            [cell.iv setImage:[UIImage imageNamed:@"redbull.png"]];
            [cell.iv sizeToFit];
            
            return cell;
        }
        else if ( row == ([ self.getter.djs count]+row/(ADSPOSITION+1)*self.VIP) )  // get more button...
#else
        if ( row == ([ self.getter.djs count] ) )
#endif
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
            cell.textLabel.text = [LocalizedManager localizedString:@"get_more_djs"];
            cell.textLabel.textColor = [ UIColor blackColor ];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryType = UITableViewCellAccessoryNone;
            return cell;
        }
        else
        {
            //  Get/create the cell...
            UITableViewCell *tcell=[tableView dequeueReusableCellWithIdentifier:[DjsCell reuseIdentifier]];
            if (tcell == nil) 
            {
                tcell = [[[ DjsCell alloc] init ] autorelease];
            }
            DjsCell *cell=(DjsCell *)tcell;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.textLabel.textColor = [ UIColor blackColor ];
            cell.content.textColor=[UIColor blackColor];
            cell.content.font=[UIFont boldSystemFontOfSize:17];
            cell.upcoming.text = @"";
                        
            //  Get dj info object...
#ifdef DJS_ADS
            DJ *dj = [ self.getter.djs objectAtIndex:(row-row/(ADSPOSITION+1)*self.VIP) ];
#else
            DJ *dj = [ self.getter.djs objectAtIndex:row ];
#endif
            //  Set dj text...
            NSString *str = [ NSString stringWithFormat:@"%@",dj.name];
            //cell.textLabel.text = str;
            cell.content.text=str;
            
            if (dj.upcoming) cell.upcoming.text = dj.upcoming;
            
            //  Get dj pic or use default?...
            cell.icon.image = nil; // Clear reused image just in case...
            if ( dj.pic_path )
            {
                //NSLog(@"%@", dj.pic_path);
                [ self loadImageForRow:cell:indexPath ];
            }
            else
            {
                UIImage *imgAll = [ UIImage imageNamed:@"Genericthumb2.png" ];
                cell.icon.image = imgAll;
            }
            
            return cell;   
        }
    }
}

-(void)loadImageForRow: (DjsCell *)tcell: (NSIndexPath *)path
{
    int row = [ path row ];
    NSNumber *idx = [ NSNumber numberWithInt:row ];
    
    //  If type DJcell...
    if ( [ tcell isKindOfClass: [ DjsCell class ] ] )
    {
        DjsCell *djc = (DjsCell *)tcell;
        
        //  See if its in cache...
        UIImage *img = [ self.getter getCachePic:idx ];
        if (img)
        {
            DjsCell *djc = (DjsCell *)tcell;
            djc.icon.image = img;
            [djc.activity setHidden:YES];
            [djc.icon setHidden:NO];
        }
        //  Else launch async loading if not scrolling...
        else if (! self.scrolling )
        {
            int row = [ path row ];
            
            //NSLog(@"async get pic! %d", row);
            //  Get info for this cell...
#ifdef DJS_ADS
            DJ *dj = [ self.getter.djs objectAtIndex:(row-row/(ADSPOSITION+1)*self.VIP) ];
#else
            DJ *dj = [ self.getter.djs objectAtIndex:row ];
#endif
            
            //NSLog(@"after djinfo %@ %@", dj.pic_path, idx);
            
            if ( dj.pic_path )
            {
                //  Launch the getter...
                [ self.getter asyncGetPic:dj.pic_path:idx ];
                [djc.activity setHidden:NO];
                [djc.activity startAnimating];
                [djc.icon setHidden:YES ];
            }
        }
    }
}

-(void)loadImagesForOnscreenRows
{
    //  Get all visible cell paths...
    NSArray *paths = [ self.tv indexPathsForVisibleRows ];
    for ( int i=0; i< [paths count];i++)
    {
        //  Get path for cell...
        NSIndexPath *path = [ paths objectAtIndex:i ];
        
        UITableViewCell *cell = [ self.tv cellForRowAtIndexPath:path ];
        
        if ( [ cell isKindOfClass:[ DjsCell class ] ] )
        {
            DjsCell *dcell = (DjsCell *)cell;
            
            [ self loadImageForRow:dcell:path ];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.tv.hidden)
    {
        self.scrolling = YES;
        //NSLog(@"scroll start");
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.scrolling = NO;
    //NSLog(@"scroll stop thread=%d", [ NSThread isMainThread]);
    
    [self loadImagesForOnscreenRows];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.scrolling = NO;
    //NSLog(@"decel stop=%d", [ NSThread isMainThread]);
    
   [self loadImagesForOnscreenRows];
}

/*
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if the keyboard appears,resign it
    [self.field_search resignFirstResponder];
    
    int row = [ indexPath row ];
    
#ifdef DJ_ADS
    if((self.VIP==1)&&row>0&&((row+1)%(ADSPOSITION+1)==0))
    {
        return;
    }
    else
#endif
    {
        [ tableView deselectRowAtIndexPath:indexPath animated:YES];
        
#ifdef DJS_ADS
        if ((self.VIP==1)&&(row ==( [self.getter.djs count]+self.getter.djs.count%(ADSPOSITION+1)*self.VIP)) )
#else
        if ( row ==( [self.getter.djs count] ) )
#endif
        {
            self.get_mode = DJGetGetting;
            [ self.getter getNext ];
        }
        else
        {
#ifdef DJS_ADS
            DJ *dj = [ self.getter.djs objectAtIndex:(row-row/(ADSPOSITION+1)*self.VIP) ];
#else
            DJ *dj = [ self.getter.djs objectAtIndex:row ];
#endif
            djcAppDelegate *app = 
            ( djcAppDelegate *)[ [ UIApplication sharedApplication] delegate];
            
            self.back_from = YES;
            [ app showDJItemModal:self:dj:nil ];
             
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
#ifdef DJS_ADS
    if((self.getter.djs==nil)||([self.getter.djs count]==0)||
       ([self.getter.djs count]==([indexPath row]-indexPath.row/(ADSPOSITION+1)*self.VIP)))
    {
        return 44;
    }
    else if((self.VIP==1)&&((indexPath.row+1)%(ADSPOSITION+1)==0)&&indexPath.row>0)
    {
        return [ AdsCell height ];
    }
    else
    {
        return [ DjsCell height ];
    }
#else
    if((self.getter.djs==nil)||([self.getter.djs count]==0))   
    {
        return 44;
    }
    else
    {
        return 75.0f;
    }
#endif
}

#pragma mark - djs getter delegate...

-(void) got_djs:(NSInteger)start :(NSInteger)end
{
    self.get_mode = DJGetPaused;
    
    //  Stop the activity indicator...
    if (!self.activity.hidden)
    {
        self.activity.hidden = YES;
        [ self.activity stopAnimating ];
        self.tv.hidden = NO;
    }
    
    //  Got more, so tell the view...
    [ self updateViews ];
    
    //  Keep getting until we got all...
    if ( !self.getter.got_all )
    {
        self.get_mode = DJGetGetting;
        [self.getter  getNext];
    }
    else
    {
        self.get_mode = DJGetDone;
    }
}

-(void) got_pic:(UIImageForCell *)img
{
    //  Update the image only if not scrolling...
    if ( !self.scrolling )
    {
        //  If image is valid update the related cell...
        if (img.status==0)
        {
            //  Get the row index...
            int row = [ img.idx integerValue ];
    
            //  Path for this row...
            NSIndexPath *path = [ NSIndexPath indexPathForRow:row inSection:0 ];
    
            //  Get the cell for this row...
            UITableViewCell *tcell = [ self.tv cellForRowAtIndexPath:path ];
            DjsCell *cell = (DjsCell *)tcell;
    
            //  Set image...
            cell.icon.hidden = NO;
            [ cell.icon setImage:img.img ];
    
            //  Turn off loading anim...
            [ cell.activity stopAnimating ];
            cell.activity.hidden = YES;
        }
    }
}

-(void) failed
{
    self.get_mode = DJGetPaused;
    
    [ Utility AlertAPICallFailed ];
}

#pragma mark - button callbacks...

-(IBAction) refreshClicked: (id)sender
{
    [ self newGetter ];
    
    self.activity.hidden = NO;
    [ self.tv reloadData ];
    self.tv.hidden = YES;
    
    self.get_mode = DJGetGetting;
    [ self.getter getNext ];
}


-(IBAction) backClicked: (id)sender
{
    [ self dismissModalViewControllerAnimated:YES ];
}


-(IBAction) searchClicked:(id)sender
{
    [self.field_search resignFirstResponder];
    
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
    [self.field_search resignFirstResponder];
    
    if(self.top50==YES)
    {
        self.top50=NO;
        self.all_djs=YES;
        self.button_AllTop50.title=[LocalizedManager localizedString:@"top50"];
    }
    else
    {
        self.top50=YES;
        self.all_djs=NO;
        self.button_AllTop50.title=[LocalizedManager localizedString:@"all"];
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