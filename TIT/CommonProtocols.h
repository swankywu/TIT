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
    CharacterStateSpawning,
    CharacterStateIdle,
    CharacterStateCrouching,
    CharacterStateStandingUp,
    CharacterStateWalking,
    CharacterStateAttacking,
    CharacterStateJumping,
    CharacterStateBreathing,
    CharacterStateTakingDamage,
    CharacterStateDead,
    CharacterStateTraveling,
    CharacterStateRotating,
    CharacterStateDrilling,
    CharacterStateAfterJumping
} CharacterState; 
typedef enum {
    kObjectTypeNone,
    kPowerUpTypeHealth,
    kPowerUpTypeMallet,
    kEnemyTypeRadarDish,
    kEnemyTypeSpaceCargoShip,
    kEnemyTypeAlienRobot,
    kEnemyTypePhaser,
    kVikingType,
    kSkullType,
    kRockType,
    kMeteorType,
    kFrozenVikingType,
    kIceType,
    kLongBlockType,
    kCartType,
    kSpikesType,
    kDiggerType,
    kGroundType
} GameObjectType;

@protocol GameplayLayerDelegate
-(void)createObjectOfType:(GameObjectType)objectType
               withHealth:(int)initialHealth
               atLocation:(CGPoint)spawnLocation
               withZValue:(int)ZValue;
-(void)createPhaserWithDirection:(PhaserDirection)phaserDirection
                     andPosition:(CGPoint)spawnPosition;
@end