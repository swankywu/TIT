//
//  GameManager.m
//  TIT
//
//  Created by swanky on 9/7/11.
//  Copyright 2011 iBrother. All rights reserved.
//
#import <Foundation/NSException.h>
#import "cocos2d.h"
#import "GameManager.h"
#import "GameScene.h"
#import "SplashScene.h"
#import "ChorusScene.h"



@implementation GameManager
static GameManager *_singletonSharedGameManager = nil;
@synthesize isMusicOn;
@synthesize isSoundEffectsOn;
@synthesize isGameOver;
@synthesize managerSoundState;
@synthesize listOfSoundEffectFiles;
@synthesize soundEffectsState;
@synthesize avPlayer;


- (void)dealloc{
    self.listOfSoundEffectFiles = nil;
    self.soundEffectsState = nil;
    self.avPlayer = nil;
    [super dealloc];
}

+(GameManager*)sharedGameManager {
    @synchronized([GameManager class])
    {
        if(!_singletonSharedGameManager)
            [[self alloc] init];
        return _singletonSharedGameManager;
        return nil;

    }
}

+ (NSString*)resourceFullPath:(NSString*)resourceName ofType:(NSString*)ofType{
    NSString *fullFileName = [NSString stringWithFormat:@"%@.%@",resourceName, ofType];
    NSString *fullPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory ,NSUserDomainMask, YES) objectAtIndex:0];
    fullPath = [rootPath stringByAppendingPathComponent:fullFileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
        fullPath = [[NSBundle mainBundle] pathForResource:resourceName ofType:ofType];
    }
    return fullPath;
}

+(id)alloc {
    @synchronized ([GameManager class])
    {
//        NSAssert(_singletonSharedGameManager == nil,
//                 @"Attempted to allocate a second instance of the Game
//                 Manager singleton");
        _singletonSharedGameManager = [super alloc];
        return _singletonSharedGameManager;
    }
    return nil;
}




- (id)init
{
    self = [super init];
    if (self) {
        isMusicOn = YES;
        isSoundEffectsOn = YES;
        isGameOver = NO;
        currentScene = SceneTypeUninitialized;
        
        hasAudioBeenInitialized = NO;
        soundEngine = nil;
        managerSoundState = kAudioManagerUninitialized;
        [self setupAudioEngine];
    }
    
    return self;
}


- (void)runSceneWithSceneType:(SceneType)sceneType{
    id sceneToRun = nil;
    if (sceneType == SceneTypeChorus) {
        sceneToRun = [ChorusScene node];
    }else if(sceneType == SceneTypeSplash){
        sceneToRun = [SplashScene node];
    }
    
    if ([[CCDirector sharedDirector] runningScene] == nil) {
        [[CCDirector sharedDirector] runWithScene:sceneToRun];
    } else {
        [[CCDirector sharedDirector] replaceScene:sceneToRun];
    }
}

-(void)initAudioAsync {
    // Initializes the audio engine asynchronously
    managerSoundState = kAudioManagerInitializing;
    // Indicate that we are trying to start up the Audio Manager
    [CDSoundEngine setMixerSampleRate:CD_SAMPLE_RATE_MID];
    //Init audio manager asynchronously as it can take a few seconds
    //The FXPlusMusicIfNoOtherAudio mode will check if the user is
    // playing music and disable background music playback if
    // that is the case.
    [CDAudioManager initAsynchronously:kAMM_FxPlusMusicIfNoOtherAudio];
    //Wait for the audio manager to initialize
    while ([CDAudioManager sharedManagerState] != kAMStateInitialised)
    {
        [NSThread sleepForTimeInterval:0.1];
    }
    //At this point the CocosDenshion should be initialized
    // Grab the CDAudioManager and check the state
    CDAudioManager *audioManager = [CDAudioManager sharedManager];
    if (audioManager.soundEngine == nil ||
        audioManager.soundEngine.functioning == NO) {
        CCLOG(@"GameManager->CocosDenshion failed to init, no audio will play.");
        managerSoundState = kAudioManagerFailed;
    } else {
        [audioManager setResignBehavior:kAMRBStopPlay autoHandle:YES];
        soundEngine = [SimpleAudioEngine sharedEngine];
        managerSoundState = kAudioManagerReady;
        CCLOG(@"GameManager->CocosDenshion is Ready");
    }
}


-(void)setupAudioEngine {
    if (hasAudioBeenInitialized == YES) {
        return;
    } else {
        hasAudioBeenInitialized = YES;
        NSOperationQueue *queue = [[NSOperationQueue new] autorelease];
        NSInvocationOperation *asyncSetupOperation =
        [[NSInvocationOperation alloc] initWithTarget:self
                                             selector:@selector(initAudioAsync)
                                               object:nil];
        [queue addOperation:asyncSetupOperation];
        [asyncSetupOperation autorelease];
    }
}

- (void)playBackgroundTrack:(NSString*)trackFileName {
    // Wait to make sure soundEngine is initialized
    if ((managerSoundState != kAudioManagerReady) &&
        (managerSoundState != kAudioManagerFailed)) {
        int waitCycles = 0;
        while (waitCycles < AUDIO_MAX_WAITTIME) {
            [NSThread sleepForTimeInterval:0.1f];
            if ((managerSoundState == kAudioManagerReady) ||
                (managerSoundState == kAudioManagerFailed)) {
                break; }
            waitCycles = waitCycles + 1;
        }
    }
    if (managerSoundState == kAudioManagerReady) {
        if ([soundEngine isBackgroundMusicPlaying]) {
            [soundEngine stopBackgroundMusic];
        }
        [soundEngine preloadBackgroundMusic:trackFileName];
        [soundEngine playBackgroundMusic:trackFileName loop:YES];
    }
}
-(void)stopSoundEffect:(ALuint)soundEffectID {
    if (managerSoundState == kAudioManagerReady) {
        [soundEngine stopEffect:soundEffectID];
    }
}

- (ALuint)playSoundEffect:(NSString*)fileName {
    ALuint soundID = 0;
    if (managerSoundState == kAudioManagerReady) {
        soundID = [soundEngine playEffect:fileName];
    } else {
        CCLOG(@"GameManager->Sound Manager is not ready, cannot play %@",
              fileName);
    }
    return soundID;
}

#pragma mark - avplayer

- (AVAudioPlayer*)avPlay:(NSString*)resourceName ofType:(NSString*)ofType{
    NSString *fullPath = [GameManager resourceFullPath:resourceName ofType:ofType];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:fullPath];
    
    AVAudioPlayer* pl = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    pl.volume = 1.0f;
    [pl play];
    self.avPlayer = pl;
    [pl release];
    [url release];
    return pl;
}


@end
