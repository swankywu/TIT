//
//  CommonProtocols.h
//  TIT
//
//  Created by Swanky on 9/1/11.
//  Copyright 2011 iBrother. All rights reserved.
//

typedef enum {
    PhaserDirectionLeft,
    PhaserDirectionRight
} PhaserDirection;

typedef enum {
    GameCharacterStateIdle=1,
    GameCharacterStateSingLow,
    GameCharacterStateSingLow0,
    GameCharacterStateSingLow1,
    GameCharacterStateSingHigh,
    GameCharacterStateSingStare,
    
    GameCharacterStateTapStart,
    GameCharacterStateTapKeeping,
    GameCharacterStateTapMoving,
    GameCharacterStateTapFinishing,
    GameCharacterStateTapEnd,
    
//    GameCharacterStateWalking=100,
//    GameCharacterStateAttacking,
//    GameCharacterStateJumping,
//    GameCharacterStateBreathing,
//    GameCharacterStateTakingDamage,
//    GameCharacterStateDead,
//    GameCharacterStateTraveling,
//    GameCharacterStateRotating,
//    GameCharacterStateDrilling,
//    GameCharacterStateAfterJumping
} GameCharacterState; 

typedef enum {
    GameObjectTypeNone,
    GameObjectTypeSinger,
    GameObjectTypeChorusSinger,
    GameObjectTypeChorusConductor,
} GameObjectType;

typedef enum {
    SceneTypeUninitialized=0,
    SceneTypeSplash,
    SceneTypeMainMenuScene,

    SceneTypeAdventureMap=100,
    SceneTypeChorus,
} SceneType;


//CocosDenshion audio engine
#define AUDIO_MAX_WAITTIME 150
typedef enum {
    kAudioManagerUninitialized=0,
    kAudioManagerFailed=1,
    kAudioManagerInitializing=2,
    kAudioManagerInitialized=100,
    kAudioManagerLoading=200,
    kAudioManagerReady=300
} GameManagerSoundState;

#define SFX_NOTLOADED NO
#define SFX_LOADED YES
#define PLAYSOUNDEFFECT(...) \
[[GameManager sharedGameManager] playSoundEffect:@#__VA_ARGS__]
#define STOPSOUNDEFFECT(...) \
[[GameManager sharedGameManager] stopSoundEffect:__VA_ARGS__]



@protocol GameplayLayerDelegate
-(void)createObjectOfType:(GameObjectType)objectType
               atLocation:(CGPoint)spawnLocation
               withZValue:(int)ZValue;
-(void)createPhaserWithDirection:(PhaserDirection)phaserDirection
                     andPosition:(CGPoint)spawnPosition;
@end


