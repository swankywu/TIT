//
//  GameManager.h
//  TIT
//
//  Created by swanky on 9/7/11.
//  Copyright 2011 iBrother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleAudioEngine.h"
#import "Common.h"

@interface GameManager : NSObject{
@private
    BOOL isMusicOn;
    BOOL isSoundEffectsOn;
    BOOL isGameOver;
    SceneType currentScene;
    
    // Added for audio
    BOOL hasAudioBeenInitialized;
    GameManagerSoundState managerSoundState;
    SimpleAudioEngine *soundEngine;
    NSMutableDictionary *listOfSoundEffectFiles;
    NSMutableDictionary *soundEffectsState;
    
    
    //avPlayer
    AVAudioPlayer *avPlayer;
}

@property BOOL isMusicOn;
@property BOOL isSoundEffectsOn;
@property BOOL isGameOver;
@property (readwrite) GameManagerSoundState managerSoundState;
@property (nonatomic, retain) NSMutableDictionary *listOfSoundEffectFiles;
@property (nonatomic, retain) NSMutableDictionary *soundEffectsState;
@property (nonatomic, retain) AVAudioPlayer *avPlayer;

+ (GameManager*)sharedGameManager;
+ (NSString*)resourceFullPath:(NSString*)resourceName ofType:(NSString*)ofType;
- (void) runSceneWithSceneType:(SceneType)sceneType;

- (void)setupAudioEngine;
- (ALuint)playSoundEffect:(NSString*)fineName;
- (void)stopSoundEffect:(ALuint)soundEffectID;
- (void)playBackgroundTrack:(NSString*)trackFileName;

- (AVAudioPlayer*)avPlay:(NSString*)resourceName ofType:(NSString*)ofType;

@end
