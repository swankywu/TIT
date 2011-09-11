//
//  Singer.m
//  TIT
//
//  Created by Swanky on 11-9-1.
//  Copyright 2011 iBrother. All rights reserved.
//

#import "Singer.h"


@implementation Singer

- (void)dealloc{
    [soundSource release];
    soundSource = nil;
    [super dealloc];
}

- (void)initAnimations{
#define kClassName @"Singer"
    
    [self loadPlistForAnimationWithName:@"idelAnim"
                           andClassName:kClassName
                 withGameCharacterState:GameCharacterStateIdle];
    [self loadPlistForAnimationWithName:@"singLowAnim"
                           andClassName:kClassName
                 withGameCharacterState:GameCharacterStateSingLow];
    [self loadPlistForAnimationWithName:@"singLowAnim"
                           andClassName:kClassName
                 withGameCharacterState:GameCharacterStateSingLow0];
    [self loadPlistForAnimationWithName:@"singLowAnim"
                           andClassName:kClassName
                 withGameCharacterState:GameCharacterStateSingLow1];
    [self loadPlistForAnimationWithName:@"singHighAnim"
                           andClassName:kClassName
                 withGameCharacterState:GameCharacterStateSingHigh];
    [self loadPlistForAnimationWithName:@"singStareAnim"
                           andClassName:kClassName
                 withGameCharacterState:GameCharacterStateSingStare];
}


- (id) init{
    if( self = [super init] ){
        soundSource = nil;
        //self.contentSize = CGSizeMake(86.0f, 144.0f);
        self.type = GameObjectTypeSinger;
        [self initAnimations];
        [self changeState:GameCharacterStateIdle];
    }
    return self;
}

#pragma mark - 

- (void)changeState:(GameCharacterState)newState{

    static int soundPlayId = -1;
    
    if( newState == self.state) return;
    if( self.state == GameCharacterStateSingHigh && [self numberOfRunningActions] > 0){
        if( newState == GameCharacterStateSingLow)
            return;
        
    }
    
    [self stopAllActions];
    [self setState:newState];

    
    id anim = [self.animDic objectForKey:[NSString stringWithFormat:@"%d", newState]];
    id action = [CCAnimate actionWithAnimation:anim restoreOriginalFrame:NO];

    if( !soundSource){
        soundSource = [[SimpleAudioEngine sharedEngine] soundSourceForFile:@"a2.aiff"];
        [soundSource setPitch:1.0f];
        [soundSource setPan:1.0f];
        [soundSource setGain:1.0f];
        [soundSource setLooping:YES];
        [soundSource retain];
    }
    
    if( newState == GameCharacterStateIdle || newState == GameCharacterStateSingLow ){
        if( soundPlayId > -1 ){
            [[SimpleAudioEngine sharedEngine] stopEffect:soundPlayId];
            soundPlayId = -1;
        }
        
        if( newState == GameCharacterStateIdle ){
            if( [soundSource isPlaying] )
                [soundSource stop];
        } else if(newState == GameCharacterStateSingLow){
            [soundSource play];
        }
        action = [CCRepeatForever actionWithAction:action];
    } else if(newState == GameCharacterStateSingHigh){
        soundPlayId = [[SimpleAudioEngine sharedEngine] playEffect:@"a3.aiff" pitch:1.0f pan:1.0f gain:1.0f];
    } else if( newState == GameCharacterStateSingLow0 ){
        soundPlayId = [[SimpleAudioEngine sharedEngine] playEffect:@"a0.aiff" pitch:1.0f pan:1.0f gain:1.0f];
         action = [CCRepeatForever actionWithAction:action];
    } else if( newState == GameCharacterStateSingLow1 ){
        soundPlayId = [[SimpleAudioEngine sharedEngine] playEffect:@"a1.aiff" pitch:1.0f pan:1.0f gain:1.0f];
         action = [CCRepeatForever actionWithAction:action];
    }     
    [self runAction:action];
}

- (void)updateStateWidthDeltaTime:(float)deltaTime
             andListOfGameObjects:(CCArray *)listOfGameObjects{
    
}

@end
