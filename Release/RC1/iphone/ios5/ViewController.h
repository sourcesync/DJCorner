//
//  ViewController.h
//  DJSCornerIntro
//
//  Created by George Williams on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyMovieView.h"

enum play_state
{
    LOADING = 0,
    READY,
    PLAYING,
    FADING_OUT,
    STOPPED
};

@interface ViewController : UIViewController < MyMovieViewDelegate>
 

@property (strong,nonatomic) MyMovieView *fmv;
@property (assign) BOOL tapped;
@property (assign) int counter;
@property (assign) enum play_state state;
@property (assign) BOOL in_app;

@property (retain) AVAudioPlayer *player;

-(void)doVolumeFade;

-(void) playAudio;

-(void) stopAudio;

- (void) stopIntro;

- (void) playIntro;

-(void) gotoapp;

-(void) prepVideo;

@end
