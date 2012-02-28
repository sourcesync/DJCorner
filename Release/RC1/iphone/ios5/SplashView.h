//
//  SplashView.h
//  alpha2
//
//  Created by George Williams on 11/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MPMoviePlayerController.h>


@interface SplashView : UIViewController 
{
#ifdef INTRO
    MPMoviePlayerController *theMovie;
#endif
}

//  IBOUTLET...
@property (nonatomic, retain) IBOutlet UIImageView *img;

//  PUBLIC FUNCS...
-(void) splashDoneMainThread:(id)obj;
-(void) splashDone:(id)obj; 

#ifdef INTRO
-(void)video_play:(NSString*)filename;
#endif

@end

