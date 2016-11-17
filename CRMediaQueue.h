//
//  CRMediaQueue.h
//  SimplePlayer
//
//  Created by c0ldra1n on 11/17/16.
//  Copyright © 2016 c0ldra1n. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MAX_PQCOUNT 20

typedef enum : NSUInteger {
    CRRepeatNone,
    CRRepeatAll,
    CRRepeatOne
} CRRepeatState;

@interface CRMediaQueue : NSObject {
    NSUInteger _queueCount;
}

@property CRRepeatState repeatState;

@property NSMutableArray *source;

@property NSMutableArray *history;

@property id nowplayingObject;

@property NSMutableArray *queue;

@property BOOL shuffle;

-(void)reloadQueue;

-(BOOL)playerShouldPlayNextTrack;
-(BOOL)playerShouldPlayPreviousTrack;
-(void)playerDidPlayNextTrack;
-(void)playerDidPlayPreviousTrack;

-(id)nextTrack;
-(id)previousTrack;

@end
