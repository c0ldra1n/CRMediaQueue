//
//  CRMediaQueue.m
//  SimplePlayer
//
//  Created by c0ldra1n on 11/17/16.
//  Copyright © 2016 c0ldra1n. All rights reserved.
//

#import "CRMediaQueue.h"

void shuffle(int *array, size_t n) {
    srand((unsigned int)time(0));
    if (n > 1) {
        size_t i;
        for (i = 0; i < n - 1; i++) {
            size_t j = i + rand() / (RAND_MAX / (n - i) + 1);
            int t = array[j];
            array[j] = array[i];
            array[i] = t;
        }
    }
}

@implementation CRMediaQueue {
    int *shuffleData;
}

-(int)_shuffleBox:(int)index{
    
    if(shuffleData == NULL){
        shuffleData = malloc(sizeof(int)*_source.count);    //  Dynamic memory allocation
        
        for(int i = 0; i<_source.count; i++){
            shuffleData[i] = i;
        }
        
        shuffle(shuffleData, _source.count);
    }
    
    return shuffleData[index];
    
}

-(NSUInteger)arrayCount{
    return _queueCount % _source.count;
}

-(NSUInteger)shuffledArrayCount{
    return (NSUInteger)[self _shuffleBox:(int)(_queueCount % _source.count)];
}

-(void)reloadQueue{
    
    
    if (self.repeatState == CRRepeatNone) {
        
        if (!self.queue) {
            self.queue = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < self.source.count; i++) {
                [self.queue addObject:self.source[(!self.shuffle ? i : [self _shuffleBox:i])]];
            }
            
        }   //  once it is available, we don't do anything about it.
        
    }else if (self.repeatState == CRRepeatAll){
        
        if (!self.queue) {
            self.queue = [[NSMutableArray alloc] init];
        }
        
        if (self.queue.count < MAX_PQCOUNT) {
            
            for(int i = 0; i<MAX_PQCOUNT - self.queue.count; i++){
                [self.queue addObject:self.source[(!self.shuffle ? [self arrayCount] : [self shuffledArrayCount])]];
                _queueCount++;
            }
            
        }
    }else if (self.repeatState == CRRepeatOne){
        
        if (!self.queue) {
            self.queue = [[NSMutableArray alloc] init];
            self.nowplayingObject = self.source.firstObject;
        }
        
        if (self.queue.count < MAX_PQCOUNT) {
            for(int i = 0; i<MAX_PQCOUNT - self.queue.count; i++){
                [self.queue addObject:_nowplayingObject];
            }
        }
    }
    
    
    if (!self.history) {
        self.history = [[NSMutableArray alloc] init];   //  we do it here...
    }
    
    if (!self.nowplayingObject) {
        self.nowplayingObject = self.queue.firstObject;
        [self.queue removeObjectAtIndex:0];
    }
    
}

-(BOOL)playerShouldPlayNextTrack{
    if (self.repeatState == CRRepeatNone) {
        if (self.queue.count < 1) {
            return false;
        }
    }
    
    return true;
}

-(BOOL)playerShouldPlayPrevTrack{
    if (self.history.count < 1) {
        return false;
    }
    
    return true;
}

-(void)playerDidPlayNextTrack{
    [self.history addObject:self.nowplayingObject];
    self.nowplayingObject = self.queue.firstObject;
    [self.queue removeObjectAtIndex:0];
    [self reloadQueue];
}

-(void)playerDidPlayPreviousTrack{
    [self.queue insertObject:self.nowplayingObject atIndex:0];
    self.nowplayingObject = self.history.lastObject;
    [self.history removeLastObject];
}

-(id)nextTrack{
    return self.queue.firstObject;
}
-(id)prevTrack{
    return self.history.lastObject;
}
@end
