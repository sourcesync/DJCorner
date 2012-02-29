//
//  LanguageChange.h
//  djc
//
//  Created by Zix Engineer on 22/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LanguageChange : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, retain) NSMutableDictionary * languages;
@property(nonatomic, retain) NSString *languageSelected;
@property(nonatomic, retain) IBOutlet UITableView *tv;
@property(nonatomic, retain) IBOutlet UILabel *lb_langCurrent;
@property(nonatomic, retain) IBOutlet UIBarButtonItem * button_cancel;
@property(nonatomic, retain) IBOutlet UIBarButtonItem * button_done;
@property(nonatomic, retain) IBOutlet UILabel * lb_language;
@property(nonatomic, retain) IBOutlet UILabel * lb_your_lang;

-(IBAction)languageCancel:(id)sender;
-(IBAction)languageFinish:(id)sender;

@end
