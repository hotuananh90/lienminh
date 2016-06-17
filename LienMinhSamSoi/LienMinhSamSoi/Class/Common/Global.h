//
//  Global.h
//  interface4
//
//  Created by ASang on 12/12/14.
//  Copyright (c) 2014 Sang Le. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface Global : NSObject

extern MPMoviePlayerController *gVideoController;
extern NSString *deviceTokenString;
extern NSMutableArray* gFavoriteArr;
extern NSMutableArray* gPush;
extern NSData *gDataIMG;
extern BOOL IS_FULL_SCREEN;
extern BOOL IS_PLAYING;
@end
