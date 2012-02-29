//
//  DJItemView.m
//  alpha2
//
//  Created by George Williams on 12/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DJItemView.h"
#import "djcAppDelegate.h"
#import "Utility.h"
#import "LocalizedManager.h"

@implementation DJItemView

@synthesize tv=_tv;
@synthesize dj=_dj;
@synthesize activity=_activity;
@synthesize label_title=_label_title;
@synthesize image_pic=_image_pic; 
@synthesize cell_title=_cell_title;
@synthesize cell_web_site=_cell_web_site;
@synthesize cell_follow=_cell_follow;
@synthesize cell_schedule=_cell_schedule;
@synthesize api=_api;
@synthesize getdj=_getdj;
@synthesize cell_similar=_cell_similar;
//@synthesize follow_btn=_follow_btn;
@synthesize selectedDj=_selectedDj;
@synthesize djs=_djs;

//leve
@synthesize button_back;
@synthesize bt_showFirst;
@synthesize bt_showSecond;
@synthesize bt_showThird;
@synthesize follow_btn;
@synthesize lb_web_site;
@synthesize lb_upcoming_events;
@synthesize lb_notification;
@synthesize lb_similiar;

//@synthesize button_follow=_button_follow;
@synthesize following=_following;
//jimmy
//@synthesize cell_feedback=_cell_feedback;
//end
@synthesize back_from=_back_from;
@synthesize parent=_parent;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
    }
    return self;
}

-(id)init
{
    self.following=NO;
    self.djs=nil;
    return [ self initWithNibName:@"DJItemView" bundle:nil ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tv.delegate = self;
    self.tv.dataSource = self;
    
    self.api = [ [ [ DJCAPI alloc ] init:self ] autorelease ];
    
    [self check_Followed:nil];
    
    //leve
    self.button_back.title=[LocalizedManager localizedString:@"back"];
    [self.bt_showSecond setTitle:[LocalizedManager localizedString:@"show"] forState:UIControlStateNormal];
    [self.bt_showThird setTitle:[LocalizedManager localizedString:@"show"] forState:UIControlStateNormal];
    [self.bt_showFirst setTitle:[LocalizedManager localizedString:@"show"] forState:UIControlStateNormal];
    [self.follow_btn setTitle:[LocalizedManager localizedString:@"follow_this_dj"] forState:UIControlStateNormal];
    self.lb_notification.text=[LocalizedManager localizedString:@"notification"];
    self.lb_upcoming_events.text=[LocalizedManager localizedString:@"upcoming_events"];
    self.lb_web_site.text=[LocalizedManager localizedString:@"dj_web_site"];
    self.lb_similiar.text=[LocalizedManager localizedString:@"similiar"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    if (self.back_from)
    {
        
    }
    else
    {
        [super viewWillAppear:animated];
        self.tv.hidden = YES;
        self.activity.hidden = NO;
    }
    
    //leve
    self.button_back.title=[LocalizedManager localizedString:@"back"];
    [self.bt_showSecond setTitle:[LocalizedManager localizedString:@"show"] forState:UIControlStateNormal];
    [self.bt_showThird setTitle:[LocalizedManager localizedString:@"show"] forState:UIControlStateNormal];
    [self.bt_showFirst setTitle:[LocalizedManager localizedString:@"show"] forState:UIControlStateNormal];
    [self.follow_btn setTitle:[LocalizedManager localizedString:@"follow_this_dj"] forState:UIControlStateNormal];
    self.lb_notification.text=[LocalizedManager localizedString:@"notification"];
    self.lb_upcoming_events.text=[LocalizedManager localizedString:@"upcoming_events"];
    self.lb_web_site.text=[LocalizedManager localizedString:@"dj_web_site"];
    self.lb_similiar.text=[LocalizedManager localizedString:@"similiar"];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.back_from)
    {
        self.back_from = NO;
    }
    else
    {
        if ( self.getdj != nil )
        {
            if ( ! [ self.api get_dj:self.getdj ] )
            {
                [ Utility AlertAPICallFailed ];
            }
        }
        else
        {
            self.tv.hidden = NO;
            self.activity.hidden = YES;
            [ self.tv reloadData ];
        }
        
    }
   for(NSMutableDictionary *adj in self.djs)
   {
       
       if([[NSString stringWithFormat:@"%@",self.dj.name] isEqualToString:[NSString stringWithFormat:@"%@",[adj valueForKey:@"dj"]]])
       {
           //NSLog(@"they are the same");
           self.following=YES;
           [self.follow_btn setTitle:[LocalizedManager localizedString:@"stop_follow_this_dj"] forState:UIControlStateNormal];
       }

   }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) dealloc
{
    self.dj = nil;
    self.api = nil;
    self.getdj = nil;
    self.selectedDj = nil;
    
    //leve
    [button_back release];
    [bt_showFirst release];
    [bt_showSecond release];
    [bt_showThird release];
    [lb_web_site release];
    [lb_upcoming_events release];
    [lb_notification release];
    [lb_similiar release];
    
    [ super dealloc ];
}

#pragma mark - uitableview delegate...


#pragma mark - table view delegates...


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ( self.dj == nil )
    {
        return 0;
    }
    else
    {
        return 4;
        //return 5;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = [ indexPath section ];
    
    if ( section == 0 )
    {
        NSString *name = self.dj.name;
        
        //  Set title...
        self.label_title.text = name;

        //  Set pic...
        //NSURL *url = [ NSURL URLWithString:self.event.pic_path ];
        //NSData *data = [ NSData dataWithContentsOfURL:url ];
        //UIImage *img = [ UIImage imageWithData:data ];
        //[ self.pic setImage:img ];
        
        UIImage *imgAll = [ UIImage imageNamed:@"Genericthumb2.png" ];
        //download image from db
        UIImage *img=
            [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.dj.pic_path]]];
        [ self.image_pic setImage:img ];
        if(img==nil)
        {
            [self.image_pic setImage:imgAll];
        }
        
        self.cell_title.selectionStyle = UITableViewCellSelectionStyleNone;
        return self.cell_title;
    }
    else if ( section == 1 )
    {
        self.cell_schedule.selectionStyle = UITableViewCellSelectionStyleNone;
        return self.cell_schedule;
    }
    else if ( section == 2 )
    {
        self.cell_follow.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return self.cell_follow;
    }
    else if ( section == 3 )
    {
        self.cell_similar.selectionStyle = UITableViewCellSelectionStyleNone;
        return self.cell_similar;
    }
    else if ( section == 4 )
    {
        //jimmy
       //self.cell_feedback.selectionStyle = UITableViewCellSelectionStyleNone;
       // return self.cell_feedback;

        return nil;
        //end 
    }
    else if ( section == 5 )
    { 
        return nil;
    }
    else
    {
        return nil;
    }
    
}


- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = [ indexPath section ];
    
    if ( section == 0)
    {
        return 88.0f;
    }
    else
    {
        return 44.0f;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [ tableView deselectRowAtIndexPath:indexPath animated:YES ];
    
    int section = [ indexPath section ];
    
    if ( section == 1 )
    {
    }
    
}


#pragma mark - button callbacks...


-(IBAction) showWebSiteClicked:(id)sender
{
}

-(IBAction) showScheduleClicked:(id)sender
{
    djcAppDelegate * app = ( djcAppDelegate *) [ [ UIApplication sharedApplication ] delegate ];
    [ app showDJSchedule:self:self.dj];
}

-(IBAction) backButtonClicked: (id)sender
{
    if ( [self.parent isKindOfClass:[ EventView class] ] )
    {
        EventView *eview = (EventView *)self.parent;
        eview.back_from = YES;
    }
    
    [ self dismissModalViewControllerAnimated:YES ];
}

-(IBAction) followButtonClicked:(id)sender
{
    djcAppDelegate *app = (djcAppDelegate *)
        [ [ UIApplication sharedApplication ] delegate ];
    NSString *tokstr = app.devtoken;
    
    NSMutableArray *arr = [ [ NSMutableArray alloc ] initWithCapacity:0];
    NSMutableArray *arrids = [ [ NSMutableArray alloc ] initWithCapacity:0];
    
    [ arr addObject:self.dj.name ];
    [ arrids addObject:self.dj.djid ];
    
      

    if(self.following==NO)
    {
        if ( ! [ self.api followdjs:tokstr:arr:arrids ] )
        {
            [ Utility AlertAPICallFailed ];
        } 
        else
        {
            [self.follow_btn setTitle:[LocalizedManager localizedString:@"stop_follow_this_dj"] forState:UIControlStateNormal];
            self.following=YES;
        }
        
        
    }
    else
    {
        //UITableViewCell *cell = [ tableView cellForRowAtIndexPath:indexPath ];
            //NSString *dj = cell.textLabel.text;
            
        UIActionSheet *popupQuery = [[UIActionSheet alloc] 
                                     initWithTitle:[LocalizedManager localizedString:@"djitemtitle"] 
                                     delegate:self 
                                     cancelButtonTitle:[LocalizedManager localizedString:@"djitemcancel"]
                                     destructiveButtonTitle:nil
                                     otherButtonTitles:
                                     [LocalizedManager localizedString:@"djitemstop"],
                                     nil];
        popupQuery.delegate= self;
        popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [popupQuery showInView:self.view];
            
        [popupQuery release];
            
        
        /*
        [self.follow_btn setTitle:@"Follow this DJ" forState:UIControlStateNormal];
        self.following=NO;
    
        
        NSString *djid = self.dj.djid;
        self.selectedDj = djid;
          [ [ UIApplication sharedApplication ] delegate ];
 
        
        if (! [ self.api stop_followdj:tokstr:self.selectedDj ] )
        {
           //[ Utility AlertAPICallFailed ];
        }
         */
        
        
    }


    [ arr release ];
    [ arrids release ];
}


-(void) stopped_followdj:(NSDictionary *)data
{
    //NSNumber *_st = [ data objectForKey:@"status" ];
    //NSInteger st = [ _st integerValue ];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    if (buttonIndex==0 ) 
    {
        djcAppDelegate *app = (djcAppDelegate *)
        [ [ UIApplication sharedApplication ] delegate ];
        NSString *tokstr = app.devtoken;
        
        
        
        
        NSString *djid = self.dj.djid;
        self.selectedDj = djid;
        [ [ UIApplication sharedApplication ] delegate ];
        
        
        if (! [ self.api stop_followdj:tokstr:self.selectedDj ] )
        {
            //[ Utility AlertAPICallFailed ];
        }
        else
        {
            [self.follow_btn setTitle:[LocalizedManager localizedString:@"follow_this_dj"] forState:UIControlStateNormal];
            self.following=NO;
        }
    }
    else
    {
        //actionSheet.release
    }
}

-(IBAction) similarButtonClicked:(id)sender
{
    djcAppDelegate *app = (djcAppDelegate *)
    [ [ UIApplication sharedApplication ] delegate ];
    
    [ app showSimilarDJS:self :self.dj ];
    
    //NSString *tokstr = app.devtoken;
    //if ( ! [ self.api similardjs: self.dj.djid ] )
    //{
    //    [ Utility AlertAPICallFailed ];
    //} 
}

//jimmy 

-(IBAction) feedbackButtonClicked:(id)sender
{
    djcAppDelegate *app = (djcAppDelegate *)
    [ [ UIApplication sharedApplication ] delegate ];
    
    [ app showFeedback:self :self.dj ];
   
/*    
    NSString *recipients = @"mailto:cj2000s@gmail.com?subject=Feedback!";
    NSString *body = @"&body=";
    
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
 */
}

//end


#pragma mark - djcapi...

-(void) apiLoadingFailed:(NSString *)errMsg
{
    [ Utility AlertAPICallFailedWithMessage:errMsg ];
}

-(void) followed_djs:(NSDictionary *)data
{
    NSNumber *_st = [ data objectForKey:@"status" ];
    NSInteger st = [ _st integerValue ];
    if (st<=0)
    {
        NSString *msg = [ data objectForKey:@"msg" ];
        [ Utility AlertMessage:msg ];
    }
    else
    {
        NSString *msg = [ data objectForKey:@"msg" ];
        [ Utility AlertMessage:msg ];
    }
    
    //[ self dismissModalViewControllerAnimated:YES ];
}

-(void) got_dj:(NSDictionary *)data
{
    NSNumber *_st = [ data objectForKey:@"status" ];
    NSInteger st = [ _st integerValue ];
    if (st<=0)
    {
        NSString *msg = [ data objectForKey:@"msg" ];
        [ Utility AlertMessage:msg ];
    }
    else
    {
        NSMutableDictionary *dct = [ data objectForKey:@"results" ];
        
        DJ *dj = [ [ DJ alloc ] init ];
        [ dj autorelease ];
        dj.name = [ dct objectForKey:@"name" ];
        dj.djid = [ dct objectForKey:@"id" ];
        dj.pic_path=[dct objectForKey:@"pic"];
        self.dj = dj;
        self.getdj = nil;
        
        self.tv.hidden = NO;
        self.activity.hidden = YES;
        [ self.tv reloadData ];
    }
}

-(void) check_Followed:(id)sender
{
    djcAppDelegate *app = ( djcAppDelegate *)
    [ [ UIApplication sharedApplication ] delegate ];
    
    if (! [ self.api get_followdjs:app.devtoken ] )
    {
        [ Utility AlertAPICallFailed ];
    }

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


@end
