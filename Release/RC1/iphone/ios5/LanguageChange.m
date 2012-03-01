//
//  LanguageChange.m
//  djc
//
//  Created by Zix Engineer on 22/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LanguageChange.h"
#import "LocalizedManager.h"
#import "djcAppDelegate.h"

@implementation LanguageChange

@synthesize languages;
@synthesize tv;
@synthesize lb_langCurrent;
@synthesize languageSelected;
@synthesize button_done;
@synthesize button_cancel;
@synthesize lb_language;
@synthesize lb_your_lang;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
         
    }
    return self;
}
 

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    self.tv.delegate=self;
    self.tv.dataSource=self;
    
    NSArray* langArray=[[NSArray alloc] initWithObjects:@"en",@"es",@"zh-Hans", nil];
    NSArray* langAllArray=[[NSArray alloc] initWithObjects:@"English",@"Spanish",@"中文", nil];
    self.languages=[[NSMutableDictionary alloc] init];
    for(int i=0;i<langArray.count;i++)
    {
        NSMutableDictionary *temp=[[NSMutableDictionary alloc] init];
        [temp setObject:[langArray objectAtIndex:i] forKey:@"shortLang"];
        [temp setObject:[langAllArray objectAtIndex:i] forKey:@"language"];
        [self.languages setObject:temp forKey:[NSString stringWithFormat:@"%d",i]];

    }
    
    lb_langCurrent.text=[LocalizedManager localizedString:[LocalizedManager selectedLanguage]];
    [super viewDidLoad];
    
    self.lb_language.text=[LocalizedManager localizedString:@"ll_language"];
    self.lb_your_lang.text=[LocalizedManager localizedString:@"ll_your_lang"];
    self.button_done.title=[LocalizedManager localizedString:@"ll_done"];
    self.button_cancel.title=[LocalizedManager localizedString:@"ll_cancel"];
    // Do any additional setup after loading the view from its nib.
    [self.tv selectRowAtIndexPath:[NSIndexPath indexPathForRow:[self getSelectedRow:langArray selected:[LocalizedManager selectedLanguage]] inSection:0] animated:NO scrollPosition:0];
    
    [langAllArray release];
    [langArray release];
}

-(NSInteger)getSelectedRow:(NSArray *)arrayLang selected:(NSString *)selectedLang
{
    if(arrayLang!=nil)
    {
        for(int i=0;i<arrayLang.count;i++)
        {
            if([[NSString stringWithFormat:@"%@",[arrayLang objectAtIndex:i]] isEqualToString:selectedLang])
            {
                return i;
            }
        }
    }
    return 0;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.lb_language.text=[LocalizedManager localizedString:@"ll_language"];
    self.lb_your_lang.text=[LocalizedManager localizedString:@"ll_your_lang"];
    self.button_done.title=[LocalizedManager localizedString:@"ll_done"];
    self.button_cancel.title=[LocalizedManager localizedString:@"ll_cancel"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark- uitableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1; 
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self.languages count]==0)
    {
        return 1;
    }
    return [self.languages count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"language_cell"];
    
    if([self.languages count]==0)
    {
        if(cell==nil)
        {
            cell=[[[UITableViewCell alloc] init] autorelease];
        }
        
        cell.textLabel.text = @"English";
        cell.textLabel.font = [ UIFont boldSystemFontOfSize:17 ];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.textColor = [ UIColor blackColor ];
        return cell;
    }
    else
    {
        if(cell==nil)
        {
            cell=[[[UITableViewCell alloc] init] autorelease];
        }
        //NSLog(@"%@",self.languages);
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[[self.languages valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]] valueForKey:@"language"]];
        //NSLog(@"%@",cell.textLabel.text);
        cell.textLabel.font = [ UIFont boldSystemFontOfSize:17 ];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.textColor = [ UIColor blackColor ];
        return cell;
        
    }
   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSString *selectedLanguage;
    if([self.languages count]==0)
    {
        //return @"en";
        //selectedLanguage=@"en";
        self.languageSelected=@"en";
    }
    else
    {
        //selectedLanguage=[NSString stringWithFormat:@"%@",[[self.languages valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]] valueForKey:@"shortLang"]];
        self.languageSelected=[NSString stringWithFormat:@"%@",[[self.languages valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]] valueForKey:@"shortLang"]];
        //NSLog(@"%@",self.languageSelected);
    }
}

#pragma mark- click
-(IBAction)languageCancel:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)languageFinish:(id)sender
{
    [LocalizedManager setSelectedLanguage:self.languageSelected];
    
    djcAppDelegate *app=(djcAppDelegate *) [[UIApplication sharedApplication] delegate];
    [app localization];
    //[[UIApplication sharedApplication] performSelector:@selector(terminateWithSuccess)]; 
    [self dismissModalViewControllerAnimated:YES];
    //NSLog(@"%@",[LocalizedManager selectedLanguage]);
}

-(void)dealloc
{
    [languages release];
    [tv release];
    [lb_langCurrent release];
    [languageSelected release];
    [lb_language release];
    [lb_your_lang release];
    [button_cancel release];
    [button_done release];
    [super dealloc];
}

@end
