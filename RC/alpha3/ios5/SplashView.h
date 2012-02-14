//
//  SplashView.h
//  alpha2
//
//  Created by George Williams on 11/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MPMoviePlayerController.h>
#import <AVFoundation/AVFoundation.h>



@interface SplashView : UIViewController<AVAudioPlayerDelegate> 
{
    MPMoviePlayerController *theMovie;
    
    AVAudioPlayer *player; 
}

//  IBOUTLET...
@property (nonatomic, retain) IBOutlet UIImageView *img;
@property (retain) AVAudioPlayer *player;
//  PUBLIC FUNCS...
-(void) splashDoneMainThread:(id)obj;
-(void) splashDone:(id)obj;
-(id) init;
-(void)playVideo;
-(void)video_play:(NSString*)filename;

@end

