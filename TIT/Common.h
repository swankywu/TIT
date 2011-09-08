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
    GameCharacterStateSingHigh,
    GameCharacterStateSingStare,
    
    GameCharacterStateTapStart,
    GameCharacterStateTapKeeping,
    GameCharacterStateTapMoving,
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


@protocol GameplayLayerDelegate
-(void)createObjectOfType:(GameObjectType)objectType
               atLocation:(CGPoint)spawnLocation
               withZValue:(int)ZValue;
-(void)createPhaserWithDirection:(PhaserDirection)phaserDirection
                     andPosition:(CGPoint)spawnPosition;
@end


