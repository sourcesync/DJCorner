//
//  MyMoviePlayer.h
//  Tribeca
//
//  Created by George Williams on 9/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
//#import "MenuViewController.h"

@protocol MyMoviePlayerDelegate <NSObject>
- (void)movieDone;

@end

@interface MyMoviePlayer : UIViewController 
{
    
}

@property (nonatomic, retain) MPMoviePlayerController *mp;
@property (nonatomic, retain) NSURL  *movieURL;
//@property (nonatomic, retain) MenuViewController *mv;
@property (nonatomic, assign) id<MyMoviePlayerDelegate> delegate;
@property (nonatomic, assign) BOOL bCalledStop;

- (id)initWithPath:(NSString *)moviePath;
- (void)readyPlayer;

@end
