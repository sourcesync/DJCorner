//
//  BuyView.h
//  alpha2
//
//  Created by George Williams on 11/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BuyView : UIViewController 
    <UIWebViewDelegate>
{
    
}

@property (nonatomic,retain) IBOutlet UIWebView *web_view;
@property (nonatomic,retain) IBOutlet UIToolbar *tb;

@end
