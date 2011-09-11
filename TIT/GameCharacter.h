//
//  GameCharacter.h
//  TIT
//
//  Created by Swanky on 11-9-1.
//  Copyright 2011 iBrother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Common.h"
#import "GameObject.h"

@interface GameCharacter : GameObject {
@private
    NSMutableDictionary *animDic;
    GameCharacterState state;
}

@property (nonatomic, retain) NSMutableDictionary *animDic;
@property (readwrite) GameCharacterState state;


- (void)changeState:(GameCharacterState)newState;
- (void)changeStateByNumber:(NSNumber*)newState;
- (void)changeStateByAnimationName:(NSString*)animationName;

- (void)checkAndClampSpritePosition;
- (CCAnimation*)loadPlistForAnimationWithName:(NSString*)animationName
                                 andClassName:(NSString*)className
                       withGameCharacterState:(GameCharacterState)theState;


@end
