//
//  ProfileView.m
//  alpha2
//
//  Created by George Williams on 11/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProfileView.h"
#import "utility.h"
#import "djcAppDelegate.h"

//leve
#import "LocalizedManager.h"
#import "LanguageChange.h"

@implementation ProfileView

@synthesize tv=_tv;
@synthesize api=_api;
@synthesize djs=_djs;
@synthesize activity=_activity;
@synthesize selectedDJ=_selectedDJ;
@synthesize selectedIndex=_selectedIndex;
@synthesize back_from=_back_from;
//@synthesize lb_version=_lb_version;
@synthesize dele=_dele;
@synthesize flags=_flag;
@synthesize btn=_btn;

//leve
@synthesize lb_version;
@synthesize lb_account;
@synthesize lb_profile;
@synthesize lb_djs_following;
@synthesize bt_upgrade;
@synthesize bt_contact_feedback;
@synthesize bt_change_language;
@synthesize lb_lang_now;
@synthesize lb_langauge;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        //self.api = [ [ [ DJCAPI alloc ] init:self ] autorelease ];
        //self.api =  [ [ DJCAPI alloc ] init:self ];
    }
    self.back_from=NO;
    return self;
}

- (void)dealloc
{
   
    _btn=nil;
    dele=nil;
    [dele release];
    self.api = nil;
    self.djs = nil;
    self.selectedDJ = nil;
    
    //leve
    [lb_profile release];
    //[lb_account
    [lb_djs_following release];
    [lb_account release];
    [bt_upgrade release];
    [bt_contact_feedback release];
    [lb_version release];
    [bt_change_language release];
    [lb_langauge release];
    [lb_lang_now release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.flags=YES;
    self.api =  [ [ [ DJCAPI alloc ] init:self ] autorelease ];
    
    self.tv.dataSource = self;
    self.tv.delegate = self;
    
    [ self.tv reloadData ];
    
    //leve
    self.lb_account.text=[LocalizedManager localizedString:@"account_version"];
    self.lb_djs_following.text=[LocalizedManager localizedString:@"djs_u_following"];
    self.lb_profile.text=[LocalizedManager localizedString:@"user_profile"];
    self.lb_version.text=[LocalizedManager localizedString:@"free"];
    [self.btn setTitle:[LocalizedManager localizedString:@"stop_music"] forState:UIControlStateNormal];
    [self.bt_contact_feedback setTitle:[LocalizedManager localizedString:@"contact_feedback"] forState:UIControlStateNormal];
    [self.bt_upgrade setTitle:[LocalizedManager localizedString:@"upgrade"] forState:UIControlStateNormal];
    [self.bt_change_language setTitle:[LocalizedManager localizedString:@"lang_change"] forState:UIControlStateNormal];
    self.lb_langauge.text= [LocalizedManager localizedString:@"p_language"];
    self.lb_lang_now.text=[LocalizedManager localizedString:[LocalizedManager selectedLanguage]];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
    if(self.back_from)
    {
        self.back_from=NO;
    }
    else
    {
        [super viewDidAppear:animated];
        
        djcAppDelegate *app = ( djcAppDelegate *)
        [ [ UIApplication sharedApplication ] delegate ];
        if(app.VIP)
        {
            self.lb_version.text=[LocalizedManager localizedString:@"free"];
        }
        else
        {
            self.lb_version.text=@"1$";
        }
        
        if (! [ self.api get_followdjs:app.devtoken ] )
        {
            [ Utility AlertAPICallFailed ];
            self.tv.hidden = NO;
            self.activity.hidden = YES;
        }
    }
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) viewWillAppear:(BOOL)animated
{
    if(self.back_from)
    {
        self.back_from=NO;
    }
    else
    {
        [ super viewWillAppear:animated ];
        
        self.tv.hidden = YES;
        self.djs = nil;
        self.activity.hidden = NO;
    }
    
    //leve
    self.lb_account.text=[LocalizedManager localizedString:@"account_version"];
    self.lb_djs_following.text=[LocalizedManager localizedString:@"djs_u_following"];
    self.lb_profile.text=[LocalizedManager localizedString:@"user_profile"];
    self.lb_version.text=[LocalizedManager localizedString:@"free"];
    [self.btn setTitle:[LocalizedManager localizedString:@"stop_music"] forState:UIControlStateNormal];
    [self.bt_contact_feedback setTitle:[LocalizedManager localizedString:@"contact_feedback"] forState:UIControlStateNormal];
    [self.bt_upgrade setTitle:[LocalizedManager localizedString:@"upgrade"] forState:UIControlStateNormal];
    [self.bt_change_language setTitle:[LocalizedManager localizedString:@"lang_change"] forState:UIControlStateNormal];
    self.lb_langauge.text= [LocalizedManager localizedString:@"p_language"];
    self.lb_lang_now.text=[LocalizedManager localizedString:[LocalizedManager selectedLanguage]];
}


#pragma mark - table view delegates...


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( self.djs == nil )
    {
        return 1;
    }
    else if ( [ self.djs count] == 0 )
    {
        return 1;
    }
    else
    {
        int count = [ self.djs count ];
        return count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             @"profile_cell"];
    if (cell == nil) 
    {
        cell = [[[ UITableViewCell alloc] init] autorelease];
    }
    
    if ( self.djs == nil )
    {
        cell.textLabel.text = [LocalizedManager localizedString:@"wait"];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.font = [ UIFont boldSystemFontOfSize:17.0f ];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [ UIColor blackColor ];
        [ cell.imageView setImage:nil ];
    }
    else if ( [ self.djs count ] == 0 )
    {
        cell.textLabel.text = [LocalizedManager localizedString:@"you_are_not_following"];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.font = [ UIFont boldSystemFontOfSize:17.0f ];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [ UIColor blackColor ];
        [ cell.imageView setImage:nil ];
    }
    else 
    {
        int row = [ indexPath row ];
        NSMutableDictionary *dct = [ self.djs objectAtIndex: row ];
        cell.textLabel.text = [ dct objectForKey:@"dj" ];
        cell.textLabel.textAlignment = UITextAlignmentLeft;
        cell.textLabel.font = [ UIFont systemFontOfSize:17.0f ];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.textLabel.textColor = [ UIColor blackColor ];
        UIImage *img = [ UIImage imageNamed:@"Genericthumb.png" ];
        [ cell.imageView setImage:img ];
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [ indexPath row ];
    
    self.selectedIndex = row;
    
    [ tableView deselectRowAtIndexPath:indexPath animated:YES ];
    
    if ( (self.djs != nil) && ( [ self.djs count ] >0 ) )
    {
        //UITableViewCell *cell = [ tableView cellForRowAtIndexPath:indexPath ];
        //NSString *dj = cell.textLabel.text;
        
        NSMutableDictionary *dct = [ self.djs objectAtIndex: row ];
        NSString *djid = [ dct objectForKey:@"djid" ];
        self.selectedDJ = djid;
        
        UIActionSheet *popupQuery = [[UIActionSheet alloc] 
                                     initWithTitle:@"DJ's Corner" 
                                     delegate:self 
                                     cancelButtonTitle:[LocalizedManager localizedString:@"upgrade_cancel"]
                                     destructiveButtonTitle:nil
                                     otherButtonTitles:
                                     [LocalizedManager localizedString:@"go_dj_page"],[LocalizedManager localizedString:@"try_stop_following"],
                                     nil];
        popupQuery.delegate= self;
        popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        //[popupQuery showInView:self.view];
        [popupQuery showInView:self.tabBarController.view];
        
        [popupQuery release];
        
    }
}

#pragma mark - DJCAPI...

-(void) apiLoadingFailed:(NSString *)errMsg
{
    [ Utility AlertAPICallFailedWithMessage:errMsg ];
}

-(void) got_followdjs:(NSDictionary *)data
{
    NSNumber *_st = [ data objectForKey:@"status" ];
    NSInteger st = [ _st integerValue ];
    if (st>0 )
    {
        self.djs = [ data objectForKey:@"results" ];
        
        self.tv.hidden = NO;
        self.activity.hidden = YES;
        [ self.tv reloadData ];
    }
    else
    {
        NSString *msg = [ data objectForKey:@"msg" ];
        [ Utility AlertMessage:msg ];
        
        self.tv.hidden = NO;
        self.activity.hidden = YES;
    }
}


-(void) stopped_followdj:(NSDictionary *)data
{
    NSNumber *_st = [ data objectForKey:@"status" ];
    NSInteger st = [ _st integerValue ];
    if (st>0 )
    {
        self.djs = [ data objectForKey:@"results" ];
        
        self.tv.hidden = NO;
        self.activity.hidden = YES;
        [ self.tv reloadData ];
    }
    else
    {
        NSString *msg = [ data objectForKey:@"msg" ];
        [ Utility AlertMessage:msg ];
        
        self.tv.hidden = NO;
        self.activity.hidden = YES;
    }
}


#pragma mark - uiaction sheet delegate...


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    if (buttonIndex==0 ) 
    {
        djcAppDelegate *app = ( djcAppDelegate *) 
        [ [ UIApplication sharedApplication ] delegate ];
        
        //DJ *dj = [ self.djs objectAtIndex:self.selectedIndex ];
        NSString *djid = self.selectedDJ;
        [ app showDJItemModal:self:nil:djid ];
        
        //if (! [ self.api stop_followdj:app.devtoken:self.selectedDJ ] )
        //{
        //    [ Utility AlertAPICallFailed ];
        // }
    }
    else if (buttonIndex==1 ) 
    {
        djcAppDelegate *app = ( djcAppDelegate *) 
        [ [ UIApplication sharedApplication ] delegate ];
        
        if (! [ self.api stop_followdj:app.devtoken:self.selectedDJ ] )
        {
            [ Utility AlertAPICallFailed ];
        }
    }
    else
    {
        //actionSheet.release
    }
}


#pragma mark - uialert delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        //NSLog(@"this is one");
        djcAppDelegate *app=(djcAppDelegate *)[[UIApplication sharedApplication] delegate];
        app.VIP=0;
        if(app.VIP==0)
        {
            self.lb_version.text=@"1$";
        }
    }
}
#pragma mark - buttons clicked
-(IBAction)upGradeClicked:(id)sender
{
    [ Utility AlertMessage:@"Feature not yet implemented" ];
    
#if 0
    djcAppDelegate *app = 
    ( djcAppDelegate *)[ [ UIApplication sharedApplication] delegate];
    
    if(app.VIP==0)
    {
        return;
    }
    //[app purchaseManagerStart];
    
    UIAlertView *upgrade=[[UIAlertView alloc] 
                          initWithTitle:[LocalizedManager localizedString:@"upgrade"] 
                          message:[LocalizedManager localizedString:@"upgrade_msg"] 
                          delegate:self cancelButtonTitle:[LocalizedManager localizedString:@"upgrade_cancel"] otherButtonTitles:[LocalizedManager localizedString:@"upgrade_ok"], nil];
    [upgrade show];
    [upgrade release];
#endif
    
}

-(IBAction)contactFeedClicked:(id)sender
{
    djcAppDelegate *app=(djcAppDelegate *)[[UIApplication sharedApplication] delegate];
    [app showFeedback:self :nil];
}

#ifdef INTRO
-(IBAction)stopMusic:(id)sender{
    
    
    djcAppDelegate *app=(djcAppDelegate *)[[UIApplication sharedApplication] delegate]; 
    if(self.flags==YES)
    { 
        [self.btn setTitle:[LocalizedManager localizedString:@"play_music"] forState:UIControlStateNormal];
        [[app player] pause];
        self.flags=NO;
    }
    else
    {
        self.flags=YES;
        [self.btn setTitle:[LocalizedManager localizedString:@"stop_music"] forState:UIControlStateNormal];
        [[app player] play];
        
    }
}
#endif

-(IBAction)localization:(id)sender
{
    LanguageChange *lang=[[[LanguageChange alloc] init] autorelease];
    [self presentModalViewController:lang animated:YES];
}

@end
